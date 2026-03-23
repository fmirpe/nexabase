# ⚙️ Configuración de NexaBase

Guía completa de configuración para todos los entornos.

## Archivo .env

Copia `.env.example` a `.env` y configura las variables:

```bash
# =============================================================================
# SERVIDOR
# =============================================================================

# Entorno: development, production, test
NODE_ENV=development

# Puerto del servidor
PORT=3000

# URL pública de la API
API_URL=http://localhost:3000

# =============================================================================
# BASE DE DATOS (PostgreSQL)
# =============================================================================

DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=nexabase

# Pool de conexiones
DATABASE_POOL_MIN=2
DATABASE_POOL_MAX=20

# SSL (true en producción)
DATABASE_SSL=false

# Query logging
DATABASE_LOGGING=false
DATABASE_SLOW_QUERY_THRESHOLD=1000

# =============================================================================
# JWT (Autenticación)
# =============================================================================

# ¡CAMBIAR EN PRODUCCIÓN! Mínimo 32 caracteres
JWT_SECRET=cambia-este-secreto-en-produccion-min-32-caracteres-aqui

# Duración de tokens
JWT_EXPIRES_IN=24h
REFRESH_TOKEN_EXPIRES_IN=7d

# =============================================================================
# REDIS (Caché y Colas)
# =============================================================================

REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# TTL de caché (ms)
CACHE_TTL=60000

# =============================================================================
# STORAGE (MinIO / S3)
# =============================================================================

# Provider: minio, s3, local
STORAGE_PROVIDER=minio

# MinIO
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_BUCKET=nexabase
MINIO_USE_SSL=false

# S3 (alternativa a MinIO)
# AWS_ACCESS_KEY_ID=
# AWS_SECRET_ACCESS_KEY=
# AWS_REGION=us-east-1
# AWS_S3_BUCKET=

# Storage local
STORAGE_PATH=./uploads

# =============================================================================
# EMAIL
# =============================================================================

# Provider: smtp, mailgun-api, mailgun-smtp
EMAIL_PROVIDER=smtp

# SMTP
SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=587
SMTP_USER=user
SMTP_PASSWORD=password
SMTP_SECURE=false

# Mailgun
MAILGUN_API_KEY=
MAILGUN_DOMAIN=

# Email desde
DEFAULT_FROM_EMAIL=noreply@nexabase.online
DEFAULT_FROM_NAME=NexaBase

# =============================================================================
# OAUTH (Google, GitHub)
# =============================================================================

# Google
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# GitHub
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
GITHUB_CALLBACK_URL=http://localhost:3000/auth/github/callback

# =============================================================================
# RATE LIMITING
# =============================================================================

# Habilitar rate limiting
RATE_LIMIT_ENABLED=true

# Límites por defecto
RATE_LIMIT_TTL=60000
RATE_LIMIT_MAX=100

# Límites específicos
RATE_LIMIT_API_SHORT_TTL=60000
RATE_LIMIT_API_SHORT_MAX=100
RATE_LIMIT_API_HOURLY_TTL=3600000
RATE_LIMIT_API_HOURLY_MAX=1000
RATE_LIMIT_API_DAILY_TTL=86400000
RATE_LIMIT_API_DAILY_MAX=50000

# =============================================================================
# MCP (Model Context Protocol)
# =============================================================================

# Token para autenticación MCP
MCP_TOKEN=

# URL del servidor MCP
MCP_SERVER_URL=https://api.nexabase.online/api/mcp/sse

# =============================================================================
# MONITORING
# =============================================================================

# OpenTelemetry
OTEL_ENABLED=false
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318

# Sentry (opcional)
SENTRY_DSN=
SENTR_ENVIRONMENT=development

# =============================================================================
# ACTIVITY LOGS
# =============================================================================

# Modo: all, errors_only, none
ACTIVITY_LOGS_MODE=all

# =============================================================================
# BACKUPS
# =============================================================================

# Habilitar backups automáticos
BACKUP_ENABLED=false
BACKUP_SCHEDULE=0 2 * * *
BACKUP_RETENTION_DAYS=7
BACKUP_PATH=./backups

# =============================================================================
# DOKPLOY (Deploy automático)
# =============================================================================

DOKPLOY_API_URL=
DOKPLOY_API_KEY=
DOKPLOY_SERVER_ID=

# =============================================================================
# VARIOS
# =============================================================================

# Habilitar Swagger
SWAGGER_ENABLED=true

# Habilitar CORS
CORS_ENABLED=true
CORS_ORIGIN=*

# Timezone
TZ=UTC
```

---

## Configuración por Entorno

### Development

```bash
NODE_ENV=development
PORT=3000
DATABASE_LOGGING=true
ACTIVITY_LOGS_MODE=none
RATE_LIMIT_ENABLED=false
```

### Production

```bash
NODE_ENV=production
PORT=3000
DATABASE_SSL=true
DATABASE_POOL_MAX=100
DATABASE_SLOW_QUERY_THRESHOLD=1000
ACTIVITY_LOGS_MODE=errors_only
RATE_LIMIT_ENABLED=true
CORS_ORIGIN=https://tudominio.com
```

### Test

```bash
NODE_ENV=test
PORT=3001
DATABASE_NAME=nexabase_test
DATABASE_LOGGING=false
ACTIVITY_LOGS_MODE=none
```

---

## Configuración de Docker

### docker-compose.yml

```yaml
version: '3.8'

services:
  # PostgreSQL
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: nexabase
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # MinIO
  minio:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - minio_data:/data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  # NexaBase Backend
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_HOST=postgres
      - DATABASE_PORT=5432
      - DATABASE_USER=postgres
      - DATABASE_PASSWORD=postgres
      - DATABASE_NAME=nexabase
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - MINIO_ENDPOINT=minio:9000
      - MINIO_ACCESS_KEY=minioadmin
      - MINIO_SECRET_KEY=minioadmin
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      minio:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules

volumes:
  postgres_data:
  redis_data:
  minio_data:
```

---

## Configuración de Producción

### Variables Críticas

```bash
# ¡OBLIGATORIO CAMBIAR!
JWT_SECRET=genera-un-secreto-unico-con-openssl-rand-base64-32
DATABASE_PASSWORD=cambia-la-password-por-defecto
MINIO_SECRET_KEY=cambia-la-secret-key-por-defecto

# SSL
DATABASE_SSL=true
MINIO_USE_SSL=true

# CORS
CORS_ORIGIN=https://tudominio.com

# Rate limiting
RATE_LIMIT_ENABLED=true
```

### Generar JWT_SECRET

```bash
# OpenSSL
openssl rand -base64 32

# Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

### PostgreSQL en Producción

```bash
# Conexión con SSL
DATABASE_URL=postgresql://user:password@host:5432/nexabase?ssl=true

# Pool más grande
DATABASE_POOL_MIN=10
DATABASE_POOL_MAX=100

# Réplicas de lectura (opcional)
DATABASE_REPLICA_HOST=replica.nexabase.online
DATABASE_REPLICA_PORT=5432
```

### Redis en Producción

```bash
# Con password
REDIS_PASSWORD=tu-password-seguro
REDIS_URL=redis://:password@host:6379

# Cluster (opcional)
REDIS_CLUSTER_NODES=host1:6379,host2:6379,host3:6379
```

---

## Configuración de MinIO/S3

### Crear Bucket con MinIO CLI

```bash
# Instalar mc (MinIO Client)
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc

# Configurar alias
mc alias set myminio http://localhost:9000 minioadmin minioadmin

# Crear bucket
mc mb myminio/nexabase

# Setear política pública (opcional)
mc policy set public myminio/nexabase/public
```

### Configurar S3 de AWS

```bash
# En .env
STORAGE_PROVIDER=s3
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION=us-east-1
AWS_S3_BUCKET=nexabase-files
```

---

## Configuración de Email

### Mailgun

```bash
EMAIL_PROVIDER=mailgun-api
MAILGUN_API_KEY=key-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
MAILGUN_DOMAIN=mg.tudominio.com
```

### SMTP Genérico

```bash
EMAIL_PROVIDER=smtp
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=tu@gmail.com
SMTP_PASSWORD=tu-password
SMTP_SECURE=false
```

---

## Configuración de OAuth

### Google OAuth

1. Ir a [Google Cloud Console](https://console.cloud.google.com/)
2. Crear proyecto
3. Habilitar Google+ API
4. Crear credenciales OAuth 2.0
5. Configurar redirect URI: `https://tudominio.com/auth/google/callback`
6. Copiar Client ID y Client Secret

### GitHub OAuth

1. Ir a [GitHub Settings](https://github.com/settings/developers)
2. New OAuth App
3. Application name: NexaBase
4. Homepage URL: https://tudominio.com
5. Authorization callback URL: https://tudominio.com/auth/github/callback
6. Copiar Client ID y Client Secret

---

## Verificar Configuración

### Health Check

```bash
curl http://localhost:3000/api/monitoring/health
```

**Respuesta esperada:**

```json
{
  "status": "ok",
  "services": {
    "database": "up",
    "redis": "up",
    "storage": "up",
    "email": "up"
  }
}
```

### Test de Conexiones

```bash
# Database
curl http://localhost:3000/api/monitoring/health/database

# Redis
curl http://localhost:3000/api/monitoring/health/redis

# Storage
curl http://localhost:3000/api/monitoring/health/storage
```

---

## Troubleshooting

### Error: "JWT_SECRET must be at least 32 characters"

**Solución:**
```bash
# Generar secreto seguro
openssl rand -base64 32
# Copiar el resultado a .env
JWT_SECRET=el-valor-generado
```

### Error: "Database connection failed"

**Verificar:**
1. PostgreSQL está corriendo
2. Credenciales en .env son correctas
3. Base de datos existe
4. Firewall permite conexión

```bash
# Test manual
psql -h localhost -U postgres -d nexabase
```

### Error: "Redis connection failed"

**Verificar:**
1. Redis está corriendo
2. Puerto 6379 accesible
3. Password correcto (si usa)

```bash
# Test manual
redis-cli ping
# Debe retornar: PONG
```

### Error: "MinIO connection failed"

**Verificar:**
1. MinIO está corriendo
2. Credenciales correctas
3. Bucket existe

```bash
# Test con mc
mc alias set myminio http://localhost:9000 minioadmin minioadmin
mc ls myminio
```

---

## Recursos Adicionales

- [Documentación de PostgreSQL](https://www.postgresql.org/docs/)
- [Documentación de Redis](https://redis.io/docs/)
- [Documentación de MinIO](https://min.io/docs/minio/linux/index.html)
- [Documentación de NestJS](https://docs.nestjs.com/)

---

**¿Problemas con la configuración?** [Abrir issue →](https://github.com/nexabase/nexabase/issues)
