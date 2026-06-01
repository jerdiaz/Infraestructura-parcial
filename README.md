# Infraestructura-parcial — Snyk Vulnerability Scanning Demo

Proyecto de demostración para el tutorial de escaneo de vulnerabilidades en Dockerfiles
usando Snyk y GitHub Actions (CodeQL SARIF).

## Qué hace este repositorio

- Contiene un `Dockerfile` con las mejores prácticas de seguridad aplicadas
- Integra Snyk Container via GitHub Actions para escaneo automático de vulnerabilidades
- Publica los resultados en la pestaña **Security → Code Scanning** de GitHub

## Vulnerabilidades corregidas

| Problema original | Solución aplicada |
|---|---|
| `node:14` (EOL, cientos de CVEs) | `node:20-alpine` |
| Proceso corriendo como `root` | `USER node` |
| `npm install` (no determinista) | `npm ci --only=production` |
| Sin `.dockerignore` | Agregado para excluir archivos sensibles |
