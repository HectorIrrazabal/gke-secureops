# ☁️ GKE SecureOps — Kubernetes & Cloud Engineering

**Proyecto de portafolio | Cloud Engineer Junior · Kubernetes · DevOps · Google Cloud (IaC)**

Plataforma de gestión de pedidos desplegada sobre **Kubernetes local (Kind)**, diseñada para demostrar habilidades prácticas de **orquestación, redes, seguridad, escalabilidad, observabilidad y automatización**. Incluye una **arquitectura objetivo de GKE privado en Google Cloud**, definida con Terraform y aún no desplegada.

> **Lo que demuestra:** no solo desarrollé una aplicación; también configuré cómo ejecutarla, escalarla, protegerla, monitorearla, probarla y recuperar sus datos.

![Dashboard de pedidos conectado a PostgreSQL](docs/images/dashboard.png)

## 🎯 Caso de uso y arquitectura

El sistema permite **crear, consultar, actualizar y eliminar pedidos** desde una interfaz web. Nginx entrega el frontend, FastAPI expone la API REST y PostgreSQL conserva los datos. El foco del proyecto es la **operación de esta carga de trabajo en Kubernetes**.

```text
Usuario → Nginx (frontend) → FastAPI (backend, HPA 2–5 Pods)
                                 │
                                 ▼
                          PostgreSQL (StatefulSet)
                                 │
                                 ▼
                          Volumen persistente (PVC)

                 Prometheus + Grafana → Métricas y observabilidad
```

## 🛠️ Habilidades Cloud / DevOps aplicadas y por qué

| Área | Tecnologías y prácticas | ¿Qué problema resuelven? |
| --- | --- | --- |
| **Orquestación de contenedores** | Docker, Kubernetes, Kind, Deployments y Services | Ejecutar y comunicar componentes de forma declarativa, sin depender de IPs de Pods. |
| **Escalabilidad y disponibilidad** | HPA (2–5 réplicas), health checks, recursos de CPU/RAM y Rolling Updates | Ajustar capacidad, detectar fallos y reducir interrupciones durante actualizaciones. |
| **Persistencia y datos** | PostgreSQL, StatefulSet y PVC | Mantener los pedidos aunque se reinicie un Pod. |
| **IAM y seguridad de Kubernetes** | ServiceAccounts, RBAC, Secrets y SecurityContexts | Separar identidades, limitar permisos y evitar credenciales dentro del código. |
| **Networking y segmentación** | Services y NetworkPolicies para frontend/backend | Definir el tráfico permitido entre componentes; falta validar el cumplimiento efectivo por el CNI. |
| **Observabilidad** | Prometheus, Grafana y reglas de alerta | Consultar métricas de CPU, memoria y réplicas para diagnosticar el sistema. |
| **Integración continua (CI)** | GitHub Actions, Pytest y PostgreSQL temporal | Detectar errores en cada push, incluyendo operaciones CRUD sobre una base SQL real de prueba. |
| **Seguridad en pipelines** | Trivy y validación de manifiestos | Revisar vulnerabilidades y configuraciones inseguras antes de desplegar. |
| **Continuidad operativa** | PowerShell, `pg_dump` y `pg_restore` | Crear respaldos y comprobar la recuperación de datos: **7 pedidos restaurados** en una base separada. |
| **Infrastructure as Code / GCP** | Terraform para VPC, subredes, GKE privado e IAM | Definir una infraestructura Cloud reproducible y versionada **sin generar recursos facturables todavía**. |

## ✅ Evidencia de resultados

- **Aplicación funcional:** frontend, API REST CRUD y PostgreSQL corriendo en Kubernetes local.
- **Autoescalamiento:** HPA del backend configurado entre **2 y 5 réplicas**.
- **Pruebas automatizadas:** workflow **FastAPI + PostgreSQL Tests** completado exitosamente en GitHub Actions.
- **Recuperación:** respaldo y restauración probados con **7 pedidos**, sin modificar la base original.
- **Observabilidad:** métricas inspeccionables desde Grafana.

<details>
<summary><strong>Ver capturas técnicas de Kubernetes, SQL, Grafana y CI</strong></summary>

**Kubernetes y HPA**

![Pods y HPA de Kubernetes](docs/images/kubernetes-hpa.png)

**Datos en PostgreSQL**

![Consulta SQL de pedidos](docs/images/postgresql.png)

**Observabilidad en Grafana**

![Panel de métricas en Grafana](docs/images/grafana.png)

**Automatización en GitHub Actions**

![Flujos de GitHub Actions](docs/images/github-actions.png)

</details>

## ☁️ Kubernetes local vs. Google Cloud

| Entorno | Estado real |
| --- | --- |
| **Kubernetes en Kind** | **Desplegado y operativo localmente** con frontend, backend y PostgreSQL. |
| **Google Kubernetes Engine (GKE)** | **Arquitectura definida en Terraform**: VPC, red privada, clúster, nodos e IAM. **No desplegado en GCP**. |
| **CI en GitHub Actions** | **Ejecutado con éxito**, usando una instancia temporal de PostgreSQL para pruebas. |

> El proyecto no tiene una demo web pública ni constituye experiencia de operación en GKE de producción. Su objetivo es acreditar implementación práctica de Kubernetes y diseño de infraestructura Cloud.

## 🚀 Probar el dashboard localmente

Con **Docker Desktop, Kind y los componentes ya desplegados**:

```powershell
kubectl get pods -n secureops
kubectl port-forward -n secureops service/secureops-frontend 8081:8080
```

Abrir **http://localhost:8081** en el mismo computador. Estos comandos **no instalan el proyecto desde cero**: una nueva instalación requiere construir/cargar las imágenes, aplicar los manifiestos y configurar el Secret de PostgreSQL.

## 📁 Código e infraestructura

- [`apps/`](apps/) — frontend Nginx y API FastAPI.
- [`k8s/`](k8s/) — manifiestos de Kubernetes, HPA y seguridad.
- [`database/`](database/) — esquema de PostgreSQL y datos iniciales.
- [`infra/terraform/`](infra/terraform/) — infraestructura objetivo de GKE en Google Cloud.
- [`.github/workflows/`](.github/workflows/) — CI, pruebas y análisis automatizados.
- [`scripts/`](scripts/) — scripts de respaldo y restauración.

**Áreas profesionales representadas:** Cloud Engineering Junior, Kubernetes, infraestructura como código, DevOps y seguridad Cloud.
