$ErrorActionPreference = "Stop"

$namespace = "secureops"
$pod = "secureops-postgres-0"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$filename = "secureops-$timestamp.backup"

$backupDir = Join-Path $PSScriptRoot "..\backups"
$backupDir = [System.IO.Path]::GetFullPath($backupDir)

New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

$destination = Join-Path $backupDir $filename
$remoteFile = "/tmp/$filename"

try {
    Write-Host "1. Generando respaldo PostgreSQL..."

    kubectl exec -n $namespace $pod -- `
        pg_dump -U secureops -d secureops `
        --format=custom --file=$remoteFile

    if ($LASTEXITCODE -ne 0) {
        throw "Error al generar el respaldo."
    }

    Write-Host "2. Copiando respaldo a Windows..."

    Push-Location $backupDir
    try {
        kubectl cp "${namespace}/${pod}:${remoteFile}" "./$filename"
    }
    finally {
        Pop-Location
    }

    if ($LASTEXITCODE -ne 0) {
        throw "Error al copiar el respaldo."
    }

    Write-Host "3. Verificando archivo..."

    $file = Get-Item $destination

    if ($file.Length -eq 0) {
        throw "El archivo de respaldo esta vacio."
    }

    Write-Host ""
    Write-Host "BACKUP COMPLETADO" -ForegroundColor Green
    Write-Host "Archivo: $destination"
    Write-Host "Tamaño: $($file.Length) bytes"
}
finally {
    kubectl exec -n $namespace $pod -- rm -f $remoteFile
}
