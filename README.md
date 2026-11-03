# ☁️ GKE SecureOps

**Cloud Engineering · Kubernetes · DevSecOps · Infrastructure as Code**

Proyecto de portafolio que implementa una **aplicación de gestión de pedidos** y demuestra cómo desplegarla, protegerla, monitorearla y recuperar sus datos en Kubernetes. Además, incluye una arquitectura objetivo de **Google Kubernetes Engine (GKE)** definida con Terraform.

![Dashboard de GKE SecureOps con pedidos e indicadores conectados a PostgreSQL](docs/images/dashboard.png)

## 🎯 ¿Qué problema resuelve?

Permite **crear, consultar, actualizar y eliminar pedidos** mediante un dashboard web. El frontend **Nginx** se comunica con una API **FastAPI**, que almacena los pedidos en **PostgreSQL**. El objetivo técnico es operar esta aplicación con prácticas de escalabilidad, seguridad y automatización, no solo ejecutarla.

```text
Navegador → Nginx → FastAPI (HPA: 2–5 réplicas) → PostgreSQL → PVC
                        │
                 Prometheus + Grafana
```

## 🛠️ Tecnologías, habilidades y decisiones técnicas

| Área / habilidad | ¿Qué implementé? | ¿Por qué? |
| --- | --- | --- |
| **Contenedores y Kubernetes** | Docker, Kind, Deployments y Services | Empaquetar componentes, administrar Pods y facilitar la comunicación interna entre servicios. |
| **Escalabilidad y disponibilidad** | HPA (2–5 réplicas), health checks, recursos y Rolling Updates | Ajustar la capacidad según demanda y reducir interrupciones durante actualizaciones. |
| **Persistencia de datos** | PostgreSQL, StatefulSet y PVC | Conservar pedidos aunque se reinicien o recreen los Pods. |
| **Seguridad de Kubernetes** | ServiceAccounts, RBAC, Secrets y SecurityContexts restrictivos | Separar identidades, limitar permisos y reducir privilegios de los contenedores. |
| **Segmentación de red** | NetworkPolicies para frontend y backend | Declarar qué comunicaciones están permitidas; su aplicación efectiva por el CNI aún requiere validación. |
| **Observabilidad** | Prometheus, Grafana y alertas | Inspeccionar CPU, memoria, réplicas y comportamiento de la aplicación. |
| **Integración continua y seguridad** | GitHub Actions, Pytest con PostgreSQL temporal y Trivy | Detectar errores funcionales y revisar vulnerabilidades/configuraciones en el repositorio. La entrega automática (CD) está pendiente. |
| **Backup & Recovery** | Scripts PowerShell, `pg_dump` y `pg_restore` | Recuperar información ante incidentes; se validó una restauración de **7 pedidos** en una base independiente. |
| **Infraestructura Cloud (IaC)** | Terraform para VPC, subredes, GKE privado e IAM | Definir una arquitectura de Google Cloud versionable y reproducible, sin aprovisionarla todavía. |

## ☁️ ¿Qué está desplegado realmente?

- **Kubernetes operativo:** la aplicación se ejecuta localmente en **Kind**, con frontend, backend y PostgreSQL.
- **GKE en Google Cloud:** existe un **diseño en Terraform**, pero **el clúster no ha sido creado ni desplegado en GCP**. No se atribuye experiencia de operación de GKE en producción a este proyecto.
- **Acceso público:** el dashboard no tiene una URL pública de demostración; se accede desde el equipo que ejecuta Kind.

## 📸 Evidencia técnica

<details>
<summary><strong>Ver Kubernetes, PostgreSQL, Grafana y GitHub Actions</strong></summary>

**Kubernetes y HPA:** Pods en ejecución y configuración del autoescalamiento.

![Pods de Kubernetes y Horizontal Pod Autoscaler](docs/images/kubernetes-hpa.png)

**PostgreSQL:** datos de pedidos consultados mediante SQL.

![Consulta SQL de pedidos en PostgreSQL](docs/images/postgresql.png)

**Grafana:** métricas de réplicas, CPU y memoria.

![Dashboard de observabilidad en Grafana](docs/images/grafana.png)

**GitHub Actions:** workflows de pruebas y validación. Las pruebas de integración con PostgreSQL se ejecutaron correctamente.

![Workflows de GitHub Actions](docs/images/github-actions.png)

</details>

## 🚀 Cómo abrir el dashboard local

Con **Docker Desktop**, **Kind** y la aplicación **ya desplegada** en el clúster:

```powershell
kubectl get pods -n secureops
kubectl port-forward -n secureops service/secureops-frontend 8081:8080
```

Abrir **http://localhost:8081** en el mismo equipo.

> Esta sección permite acceder a una instalación existente; **no instala el proyecto desde cero**. Una instalación nueva requiere construir/cargar las imágenes, aplicar los manifiestos y configurar el Secret de PostgreSQL.

## 📁 Dónde encontrar cada componente

- [`apps/`](apps/) — frontend Nginx y backend FastAPI.
- [`k8s/`](k8s/) — recursos Kubernetes y configuraciones de seguridad.
- [`database/`](database/) — esquema SQL y datos iniciales.
- [`infra/terraform/`](infra/terraform/) — arquitectura objetivo para Google Cloud.
- [`.github/workflows/`](.github/workflows/) — pruebas, validaciones y análisis automatizados.
- [`scripts/`](scripts/) — respaldo y restauración de PostgreSQL.

**Enfoque del proyecto:** demostrar habilidades de **Cloud Engineer / DevSecOps** mediante una aplicación operativa en Kubernetes y un diseño de infraestructura GCP claramente diferenciado de lo desplegado.
