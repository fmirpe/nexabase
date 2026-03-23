# 🚀 Inicio Rápido de NexaBase

> Guía paso a paso para empezar a usar NexaBase en menos de 10 minutos

## Requisitos Previos

- Node.js 18+ o Bun
- Docker y Docker Compose (opcional pero recomendado)
- PostgreSQL 15+
- Redis 6+

---

## 1. Instalación Local (5 minutos)

### Opción A: Con Docker (Recomendado)

```bash
# 1. Clonar repositorio
git clone https://github.com/nexabase/nexabase.git
cd nexabase/nexabase-backend-v1

# 2. Copiar variables de entorno
cp .env.example .env

# 3. Iniciar servicios con Docker
docker-compose up -d
```

**Servicios incluidos:**
- PostgreSQL (puerto 5432)
- Redis (puerto 6379)
- MinIO (puerto 9000) - Storage compatible con S3

### Opción B: Manual

```bash
# 1. Instalar dependencias
npm install

# 2. Configurar .env
# Editar nexabase-backend-v1/.env con tus credenciales

# 3. Ejecutar migraciones
npm run migration:run

# 4. Iniciar servidor
npm run start:dev
```

---

## 2. Verificar Instalación

El servidor debería estar corriendo en `http://localhost:3000`

### Verificar Health Check

```bash
curl http://localhost:3000/api/monitoring/health
```

**Respuesta exitosa:**
```json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "services": {
    "database": "up",
    "redis": "up",
    "storage": "up"
  }
}
```

### Acceder a Documentación Swagger

Abre tu navegador en:
- **API Interna:** http://localhost:3000/api/docs
- **API Pública:** http://localhost:3000/docs

---

## 3. Primer Usuario Admin (2 minutos)

### Registrarse

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@miempresa.com",
    "password": "Admin123!",
    "first_name": "Admin",
    "last_name": "User"
  }'
```

**Respuesta:**
```json
{
  "id": "user-uuid",
  "email": "admin@miempresa.com",
  "first_name": "Admin",
  "last_name": "User",
  "role": "admin",
  "status": "active"
}
```

### Iniciar Sesión

```bash
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@miempresa.com",
    "password": "Admin123!"
  }'
```

**Guarda el `access_token` de la respuesta.**

---

## 4. Crear Primera Colección (2 minutos)

### Colección "Tareas"

```bash
# Reemplaza TU_TOKEN con el token del login
export TOKEN="tu_access_token_aqui"

curl -X POST http://localhost:3000/api/admin/collections \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "tareas",
    "description": "Lista de tareas",
    "schema": {
      "fields": {
        "titulo": {
          "type": "string",
          "required": true,
          "maxLength": 100
        },
        "descripcion": {
          "type": "text"
        },
        "completada": {
          "type": "boolean",
          "default": false
        },
        "prioridad": {
          "type": "string",
          "default": "media"
        },
        "fecha_vencimiento": {
          "type": "date"
        }
      },
      "timestamps": true
    }
  }'
```

---

## 5. CRUD de Registros (3 minutos)

### Crear Tarea

```bash
curl -X POST http://localhost:3000/api/collections/tareas \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Aprender NexaBase",
    "descripcion": "Completar el tutorial de inicio rápido",
    "prioridad": "alta"
  }'
```

### Listar Tareas

```bash
curl -X GET http://localhost:3000/api/collections/tareas \
  -H "Authorization: Bearer $TOKEN"
```

**Respuesta:**
```json
{
  "data": [
    {
      "id": "tarea-uuid",
      "titulo": "Aprender NexaBase",
      "descripcion": "Completar el tutorial de inicio rápido",
      "completada": false,
      "prioridad": "alta",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ],
  "meta": {
    "total": 1,
    "page": 1,
    "limit": 10,
    "totalPages": 1
  }
}
```

### Actualizar Tarea

```bash
# Reemplaza TAREA_ID con el ID retornado
curl -X PUT http://localhost:3000/api/collections/tareas/TAREA_ID \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "completada": true
  }'
```

### Eliminar Tarea

```bash
curl -X DELETE http://localhost:3000/api/collections/tareas/TAREA_ID \
  -H "Authorization: Bearer $TOKEN"
```

---

## 6. Crear API Key (1 minuto)

Para acceso programático:

```bash
curl -X POST http://localhost:3000/api/v1/keys \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Mi Primera API Key",
    "description": "Para scripts de automatización",
    "permissions": ["read", "write"]
  }'
```

**Guarda la API Key retornada** (empieza con `nxb_`).

### Usar API Key

```bash
curl -X GET http://localhost:3000/api/collections/tareas \
  -H "X-API-Key: nxb_tu_api_key_aqui"
```

---

## 7. Siguientes Pasos

### Explora la Documentación

- **[Autenticación](./guias/autenticacion-jwt.md)** - JWT, API Keys, OAuth
- **[Colecciones](./guias/crear-colecciones.md)** - Schemas, validaciones, relaciones
- **[Workflows](./guias/workflows.md)** - Automatización de procesos
- **[Funciones Serverless](./guias/funciones.md)** - Ejecuta código sin servidores

### Características Avanzadas

```bash
# 1. Crear Workflow
POST /api/workflows

# 2. Subir Archivos
POST /api/storage/upload

# 3. Ejecutar Función Serverless
POST /api/functions/:id/invoke

# 4. Búsqueda Vectorial (IA)
POST /api/vector-store/search

# 5. Conectar con MCP (IA)
# Ver CONFIGURACION_MCP.md
```

### Dashboard y Monitoreo

- **Actividad:** GET `/api/activity-logs`
- **Métricas:** GET `/api/analytics/usage`
- **Health:** GET `/api/monitoring/health`

---

## Comandos Útiles

### Desarrollo

```bash
# Iniciar en modo desarrollo (watch)
npm run start:dev

# Build para producción
npm run build

# Ejecutar tests
npm run test

# Linting
npm run lint
```

### Base de Datos

```bash
# Ejecutar migraciones
npm run migration:run

# Revertir última migración
npm run migration:revert

# Sincronizar schema (dev only)
npm run schema:sync
```

### Docker

```bash
# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down

# Reiniciar base de datos
docker-compose down -v && docker-compose up -d
```

---

## Variables de Entorno Esenciales

```bash
# Servidor
NODE_ENV=development
PORT=3000

# Base de Datos
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=nexabase

# JWT (¡CAMBIAR EN PRODUCCIÓN!)
JWT_SECRET=cambia-este-secreto-en-produccion-min-32-caracteres

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Storage (MinIO)
STORAGE_PROVIDER=minio
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
```

---

## Solución de Problemas

### Error: "Connection refused"

**Causa:** PostgreSQL o Redis no están corriendo.

**Solución:**
```bash
docker-compose ps
docker-compose up -d postgres redis
```

### Error: "JWT_SECRET must be at least 32 characters"

**Causa:** El secreto JWT es muy corto.

**Solución:**
```bash
# En .env
JWT_SECRET=un-secreto-muy-largo-de-al-menos-32-caracteres-aqui
```

### Error: "Tenant not found"

**Causa:** Falta el header `X-Tenant-ID` o la API Key no está asociada a un tenant.

**Solución:**
1. Obtén tu tenant ID: GET `/api/organizations/current`
2. Incluye el header: `X-Tenant-ID: tu-tenant-id`

### Error: "Collection already exists"

**Causa:** Ya existe una colección con ese nombre.

**Solución:**
- Usa otro nombre
- O elimina la existente: DELETE `/api/admin/collections/:name`

---

## Recursos Adicionales

- **Documentación Completa:** [README.md](../README.md)
- **Guías Detalladas:** [guias/README.md](./guias/README.md)
- **Referencia de API:** [referencia-api/README.md](../referencia-api/README.md)
- **Ejemplos:** https://github.com/nexabase/nexabase-examples
- **Comunidad:** https://discord.gg/nexabase

---

## ¿Necesitas Ayuda?

- **Issues:** https://github.com/nexabase/nexabase/issues
- **Discord:** https://discord.gg/nexabase
- **Email:** soporte@nexabase.online

---

**¡Felicidades! 🎉** Ya tienes NexaBase corriendo localmente. ¡Hora de construir algo increíble!
