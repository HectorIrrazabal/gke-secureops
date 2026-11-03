$ErrorActionPreference = "Stop"

$namespace = "secureops"
$pod = "secureops-postgres-0"
$backupDir = [System.IO.Path]::GetFullPath(
    (Join-Path $PSScriptRoot "..\backups")
)

$backup = Get-ChildItem $backupDir -Filter "*.backup" -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $backup -or $backup.Length -eq 0) {
    throw "No se encontro un respaldo valido."
}

$context = kubectl config current-context
if ($context -ne "kind-gke-secureops") {
    throw "Contexto Kubernetes incorrecto: $context"
}

$restoreDb = "secureops_restore_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$remoteFile = "/tmp/restore-$($backup.Name)"

Write-Host "Backup seleccionado: $($backup.Name)"
Write-Host "Base de restauracion: $restoreDb"

try {
    Write-Host "1. Copiando backup al Pod..."

    Push-Location $backupDir
    try {
        kubectl cp "./$($backup.Name)" "${namespace}/${pod}:${remoteFile}"
        $copyExitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }

    if ($copyExitCode -ne 0) {
        throw "Error al copiar el backup."
    }

    Write-Host "2. Validando archivo PostgreSQL..."

    kubectl exec -n $namespace $pod -- `
        pg_restore --list $remoteFile | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "El archivo de backup no es valido."
    }

    Write-Host "3. Creando base de recuperacion..."

    kubectl exec -n $namespace $pod -- `
        psql -v ON_ERROR_STOP=1 -U secureops -d postgres `
        -c "CREATE DATABASE $restoreDb;"

    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo crear la base de restauracion."
    }

    Write-Host "4. Restaurando tablas y registros..."

    kubectl exec -n $namespace $pod -- `
        pg_restore -U secureops -d $restoreDb `
        --exit-on-error --single-transaction `
        --no-owner --no-acl $remoteFile

    if ($LASTEXITCODE -ne 0) {
        throw "Error al restaurar PostgreSQL."
    }

    Write-Host "5. Verificando pedidos recuperados..."

    kubectl exec -n $namespace $pod -- `
        psql -U secureops -d $restoreDb `
        -c "SELECT COUNT(*) AS pedidos_recuperados FROM orders;"

    if ($LASTEXITCODE -ne 0) {
        throw "Error al verificar los pedidos."
    }

    Write-Host ""
    Write-Host "RESTAURACION COMPLETADA" -ForegroundColor Green
    Write-Host "Base original: secureops"
    Write-Host "Base restaurada: $restoreDb"
}
finally {
    kubectl exec -n $namespace $pod -- `
        rm -f $remoteFile
}
