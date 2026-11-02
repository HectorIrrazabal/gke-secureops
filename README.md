# GKE SecureOps

Secure, Scalable and Automated Kubernetes Platform
— GKE-Ready Architecture

## Objetivo

Proyecto de portafolio Cloud Engineer enfocado en
Kubernetes, seguridad, automatización y arquitectura GKE.

## Estado actual

Fase 0: entorno Kubernetes local preparado.

## Infraestructura implementada

- Windows 11 + Docker Desktop + WSL2
- kind v0.33.0
- Kubernetes v1.37.0
- Clúster local: gke-secureops
- Un nodo control-plane
- CNI: kindnet
- kubectl v1.34.1

## Comprobaciones realizadas

- Nodo Kubernetes Ready
- API Server saludable
- Pods del sistema Running
- Componentes del control plane saludables

## Comandos de verificación

kubectl config current-context
kubectl get nodes -o wide
kubectl get pods -A
kubectl get --raw='/readyz?verbose'

## Seguridad

NetworkPolicy API disponible.
Aplicación real de políticas pendiente de pruebas.

## Google Cloud

La implementación actual funciona localmente.
La arquitectura GKE se diseñará con Terraform
sin desplegar recursos facturables.

## Costos

Infraestructura cloud utilizada: USD 0.

## Próximas fases

1. Microservicios y contenedores
2. Deployments y Services
3. Gateway API
4. HPA y estrategias de despliegue
5. Seguridad y NetworkPolicies
6. CI/CD
7. Terraform para GKE
8. Observabilidad y troubleshooting
