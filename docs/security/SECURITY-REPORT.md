# Analisis de seguridad - GKE SecureOps

Fecha: 2026-11-02
Herramienta: Trivy 0.76.1

## Resultados

| Imagen | HIGH | CRITICAL |
|---|---:|---:|
| Backend Debian 12 | 41 | 2 |
| Backend Debian 13 | 50 | 0 |
| Backend multistage | 50 | 0 |
| Frontend Alpine | 0 | 0 |

## Acciones realizadas

- Migracion de Debian 12 a Debian 13.
- Construccion de Dockerfile multietapa.
- Ejecucion como usuario no root, UID 10001.
- Verificacion funcional de los endpoints HTTP.
- Generacion de SBOM CycloneDX.
- Investigacion de dependencias internas de pip.

## Hallazgos pendientes

- 45 hallazgos HIGH de paquetes Debian.
- 5 hallazgos HIGH de componentes Python.
- El runtime todavia contiene pip de la imagen base.
- No se han demostrado explotabilidad ni falsos positivos.

## Proximas mitigaciones

- Evaluar imagen runtime minima.
- Reducir paquetes y herramientas innecesarias.
- Aplicar controles de seguridad Kubernetes.
- Automatizar escaneos y documentar excepciones.

## Limitaciones

Los hallazgos pendientes no se consideran corregidos.
Los resultados corresponden a imagenes locales Docker.
No existe despliegue en GKE ni recursos cloud creados.
