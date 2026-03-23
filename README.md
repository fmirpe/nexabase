# 📘 Documentación de NexaBase

> **Backend as a Service** enterprise-grade con multi-tenancy, automatización y APIs dinámicas

![Versión](https://img.shields.io/badge/versión-1.3.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![NestJS](https://img.shields.io/badge/NestJS-10.4.20-red)
![TypeScript](https://img.shields.io/badge/TypeScript-5.9.2-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-blue)

---

## 📖 Tabla de Contenidos

- [Introducción](#introducción)
- [Características Principales](#características-principales)
- [Arquitectura](#arquitectura)
- [Inicio Rápido](#inicio-rápido)
- [Guías por Tema](#guías-por-tema)
- [Referencia de API](#referencia-de-api)
- [Módulos del Sistema](#módulos-del-sistema)
- [Despliegue](#despliegue)
- [Contribuir](#contribuir)

---

## Introducción

**NexaBase** es una plataforma completa de **Backend as a Service (BaaS)** que permite a desarrolladores y empresas construir aplicaciones escalables sin preocuparse por la infraestructura backend.

### ¿Qué puedes hacer con NexaBase?

✅ **Crear APIs REST automáticamente** a partir de schemas dinámicos  
✅ **Gestionar múltiples organizaciones** con aislamiento completo de datos  
✅ **Automatizar procesos** con workflows visuales  
✅ **Ejecutar código serverless** sin gestionar servidores  
✅ **Almacenar archivos** en la nube con MinIO/S3  
✅ **Buscar con IA** usando embeddings vectoriales  
✅ **Recibir datos en tiempo real** con WebSockets  
✅ **Integrar con IA** mediante MCP (Model Context Protocol)  

### Casos de Uso

| Caso | Descripción |
|------|-------------|
| **SaaS Multi-Tenant** | Crea un SaaS con aislamiento de datos por cliente |
| **Prototipado Rápido** | Genera un backend completo en minutos |
| **Aplicaciones Enterprise** | Escala a miles de usuarios con seguridad |
| **Automatización** | Orquesta procesos complejos con workflows |
| **Integración de IA** | Conecta tu aplicación con asistentes de IA |

---

## Características Principales

### 🔐 Autenticación y Autorización Completa

- **JWT** con refresh tokens rotativos
- **API Keys** con hash SHA-256 y permisos granulares
- **OAuth2** (Google, GitHub)
- **2FA/TOTP** opcional
- **Roles jerárquicos:** SUPER_ADMIN, ADMIN, DEVELOPER, USER
- **Row Level Security** en PostgreSQL

### 🏢 Multi-Tenancy Enterprise

- **Aislamiento total** de datos por tenant
- **Subdominios personalizados** por organización
- **Límites configurables** por plan (Free, Starter, Pro, Enterprise)
- **Contexto automático** desde headers, subdominio o API Key

### 📊 Colecciones Dinámicas

- **Schemas personalizables** sin migraciones
- **Tipos soportados:** string, text, number, boolean, date, json, email, url
- **Relaciones:** belongs_to, has_many, many_to_many
- **Índices compuestos** automáticos
- **Validaciones** configurables

### ⚡ Automatización

- **Workflows visuales** con triggers y acciones
- **Hooks de código** en eventos del sistema
- **Funciones serverless** en Node.js/TypeScript
- **Programación cron** para tareas recurrentes

### 🗄️ Almacenamiento

- **Archivos** con MinIO o S3
- **Límite de 50MB** por archivo
- **Metadatos** personalizables
- **URLs públicas/privadas**

### 🧠 Búsqueda Vectorial (IA)

- **pgvector** para embeddings
- **Búsqueda por similitud** coseno
- **Integración con OpenAI**
- **Metadatos JSONB**

### 🔄 Tiempo Real

- **WebSockets** con Socket.IO
- **Pub/Sub nativo** de PostgreSQL
- **Rooms por tenant** y colección
- **Reconexión automática**

### 🤖 MCP Server

- **39+ herramientas** para IA
- **Transporte SSE** y HTTP Streamable
- **Integración completa** con todos los módulos

### 📈 Monitoreo y Analytics

- **Métricas de API** (P50, P95, P99)
- **Tracking de uso** por tenant
- **Logs de auditoría** completos
- **Alertas configurables**

### 📚 Documentación Automática

- **Swagger/OpenAPI** generado automáticamente
- **3 niveles:** Internal, Public, SDK
- **Try it out** habilitado

---

## Arquitectura

### Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| **Runtime** | Node.js 18+ / Bun |
| **Framework** | NestJS 10.4.20 |
| **Lenguaje** | TypeScript 5.9.2 |
| **Base de Datos** | PostgreSQL 15+ |
| **ORM** | TypeORM 0.3.26 |
| **Vector Search** | pgvector 0.2.1 |
| **Cache** | Redis 6+ |
| **Colas** | Bull 4.16.5 |
| **WebSockets** | Socket.IO 4.8.1 |
| **Auth** | Passport.js + JWT |
| **Storage** | MinIO 8.0.6 |
| **Email** | Nodemailer + Mailgun |
| **MCP** | @modelcontextprotocol/sdk 1.27.1 |
| **Monitoreo** | OpenTelemetry 0.213.0 |
| **Logging** | Winston 3.18.3 |

### Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                         CLIENTES                            │
│  (Web App, Mobile, Scripts, MCP, Webhooks)                  │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS / WSS
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    LOAD BALANCER                            │
│                    (Nginx / Traefik)                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              NEXABASE BACKEND (NestJS)                      │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  API Gateway + Middlewares                           │   │
│  │  - Auth (JWT, API Key)                               │   │
│  │  - Rate Limiting                                     │   │
│  │  - Tenant Resolution                                 │   │
│  │  - Analytics                                         │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Módulos de Negocio                                  │   │
│  │  - Collections  - Users     - Workflows              │   │
│  │  - Hooks        - Functions - Storage                │   │
│  │  - Vector Store - Email     - MCP                    │   │
│  │  - ... (30+ módulos)                                 │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Servicios de Infraestructura                        │   │
│  │  - Cache (Redis)                                     │   │
│  │  - Colas (Bull)                                      │   │
│  │  - WebSockets (Socket.IO)                            │   │
│  │  - Logging (Winston)                                 │   │
│  │  - Métricas (OpenTelemetry)                          │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────┬──────────────────────┬─────────────────────────┘
             │                      │
             ▼                      ▼
┌─────────────────────┐  ┌─────────────────────┐
│   PostgreSQL 15+    │  │      Redis 6+       │
│  - Datos            │  │  - Caché            │
│  - pgvector         │  │  - Pub/Sub          │
│  - RLS              │  │  - Rate Limiting    │
└─────────────────────┘  └─────────────────────┘
             │
             ▼
┌─────────────────────┐
│      MinIO / S3     │
│  - Archivos         │
│  - Backups          │
└─────────────────────┘
```

### Estructura de Directorios

```
nexabase-backend-v1/
├── src/
│   ├── auth/                 # Autenticación y autorización
│   ├── tenants/              # Multi-tenancy
│   ├── collections/          # Colecciones dinámicas
│   ├── users/                # Gestión de usuarios
│   ├── workflows/            # Automatización de procesos
│   ├── hooks/                # Hooks personalizables
│   ├── functions/            # Funciones serverless
│   ├── storage/              # Almacenamiento de archivos
│   ├── vector-store/         # Búsqueda vectorial
│   ├── email/                # Servicio de correos
│   ├── mcp/                  # Servidor MCP
│   ├── api-keys/             # API Keys
│   ├── plans/                # Planes y suscripciones
│   ├── rate-limiting/        # Limitación de tasa
│   ├── analytics/            # Analytics de uso
│   ├── webhooks/             # Sistema de webhooks
│   ├── backup/               # Backups programados
│   ├── monitoring/           # Monitoreo y alertas
│   ├── realtime/             # WebSockets
│   ├── oauth/                # OAuth (Google, GitHub)
│   ├── notifications/        # Notificaciones
│   ├── activity-logs/        # Logging de actividades
│   ├── dashboard/            # Dashboard
│   ├── developer-portal/     # Portal para desarrolladores
│   ├── sdk/                  # Generación de SDKs
│   ├── introspection/        # Introspección del sistema
│   ├── documentation/        # Documentación automática
│   ├── admin/                # Panel de administración
│   ├── middleware/           # Middlewares personalizados
│   ├── config/               # Configuración del sistema
│   ├── utils/                # Utilidades
│   ├── app.module.ts         # Módulo principal
│   ├── main.ts               # Punto de entrada
│   └── tracing.ts            # OpenTelemetry
├── package.json
├── .env.example
├── docker-compose.yml
└── init.sql
```

---

## Inicio Rápido

### 1. Instalación Local

```bash
# Clonar repositorio
git clone https://github.com/nexabase/nexabase.git
cd nexabase/nexabase-backend-v1

# Instalar dependencias
npm install

# Copiar variables de entorno
cp .env.example .env

# Configurar .env (mínimo necesario)
DATABASE_HOST=localhost
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=nexabase
JWT_SECRET=tu-secreto-muy-seguro-min-32-caracteres
REDIS_HOST=localhost

# Iniciar servicios (Docker)
docker-compose up -d postgres redis minio

# Ejecutar migraciones
npm run migration:run

# Iniciar servidor
npm run start:dev
```

### 2. Primeros Pasos

#### Crear Usuario Admin

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@nexabase.com",
    "password": "Admin123!",
    "first_name": "Admin",
    "last_name": "User"
  }'
```

#### Login y Obtener Token

```bash
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@nexabase.com",
    "password": "Admin123!"
  }'
```

#### Crear Primera Colección

```bash
curl -X POST http://localhost:3000/api/admin/collections \
  -H "Authorization: Bearer TU_JWT_TOKEN" \
  -H "X-Tenant-ID: TU_TENANT_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "productos",
    "schema": {
      "fields": {
        "nombre": { "type": "string", "required": true },
        "precio": { "type": "number", "required": true },
        "descripcion": { "type": "text" },
        "activo": { "type": "boolean", "default": true }
      },
      "timestamps": true
    }
  }'
```

#### Insertar Datos

```bash
curl -X POST http://localhost:3000/api/collections/productos \
  -H "Authorization: Bearer TU_JWT_TOKEN" \
  -H "X-Tenant-ID: TU_TENANT_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Producto 1",
    "precio": 99.99,
    "descripcion": "Descripción del producto"
  }'
```

### 3. Acceder a Documentación

- **Swagger Interno:** http://localhost:3000/api/docs
- **Swagger Público:** http://localhost:3000/docs

---

## Guías por Tema

### 🔐 Autenticación

- [Guía de Autenticación JWT](./guias/autenticacion-jwt.md)
- [Uso de API Keys](./guias/api-keys.md)
- [Configurar OAuth (Google, GitHub)](./guias/oauth.md)
- [Autenticación 2FA/TOTP](./guias/2fa.md)

### 🏢 Multi-Tenancy

- [Introducción a Multi-Tenancy](./guias/multi-tenancy.md)
- [Configurar Subdominios](./guias/subdominios.md)
- [Row Level Security (RLS)](./guias/rls.md)
- [Planes y Límites](./guias/planes.md)

### 📊 Colecciones

- [Crear Colecciones](./guias/crear-colecciones.md)
- [Schemas y Tipos](./guias/schemas.md)
- [Relaciones entre Colecciones](./guias/relaciones.md)
- [Validaciones](./guias/validaciones.md)
- [Índices](./guias/indices.md)

### ⚡ Automatización

- [Workflows: Introducción](./guias/workflows.md)
- [Triggers y Acciones](./guias/workflows-triggers.md)
- [Hooks Personalizados](./guias/hooks.md)
- [Funciones Serverless](./guias/funciones.md)

### 🗄️ Storage

- [Subir Archivos](./guias/storage.md)
- [Configurar MinIO](./guias/minio.md)
- [URLs Públicas y Privadas](./guias/storage-urls.md)

### 🧠 IA y Vector Store

- [Búsqueda Vectorial](./guias/vector-store.md)
- [Integración con OpenAI](./guias/openai.md)
- [Embeddings](./guias/embeddings.md)

### 🔄 Tiempo Real

- [WebSockets](./guias/websockets.md)
- [Suscribirse a Colecciones](./guias/realtime-collections.md)

### 🤖 MCP

- [Configurar MCP en Editores](./CONFIGURACION_MCP.md)
- [Herramientas Disponibles](./guias/mcp-tools.md)
- [Uso con Cursor/VS Code](./guias/mcp-editores.md)

### 📈 Monitoreo

- [Analytics de Uso](./guias/analytics.md)
- [Métricas de Rendimiento](./guias/metricas.md)
- [Alertas](./guias/alertas.md)
- [Logs de Auditoría](./guias/audit-logs.md)

### 📚 Documentación

- [Generar Documentación](./guias/documentacion.md)
- [Swagger Personalizado](./guias/swagger.md)

### 🚀 Despliegue

- [Docker](./guias/docker.md)
- [Producción](./guias/produccion.md)
- [Dokploy](./guias/dokploy.md)
- [Escalabilidad](./guias/escalabilidad.md)

---

## Referencia de API

### Endpoints Principales

#### Autenticación

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/v1/login` | Login con email/password |
| POST | `/api/v1/refresh` | Refrescar token JWT |
| POST | `/api/v1/logout` | Cerrar sesión |
| GET | `/api/v1/me` | Obtener perfil actual |
| PATCH | `/api/v1/change-password` | Cambiar contraseña |

#### Colecciones

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/admin/collections` | Listar colecciones |
| POST | `/api/admin/collections` | Crear colección |
| GET | `/api/admin/collections/:name` | Obtener colección |
| PUT | `/api/admin/collections/:name` | Actualizar colección |
| DELETE | `/api/admin/collections/:name` | Eliminar colección |
| GET | `/api/collections/:name` | Listar registros |
| POST | `/api/collections/:name` | Crear registro |
| GET | `/api/collections/:name/:id` | Obtener registro |
| PUT | `/api/collections/:name/:id` | Actualizar registro |
| DELETE | `/api/collections/:name/:id` | Eliminar registro |

#### Usuarios

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/users` | Listar usuarios |
| POST | `/api/users` | Crear usuario |
| GET | `/api/users/:id` | Obtener usuario |
| PUT | `/api/users/:id` | Actualizar usuario |
| DELETE | `/api/users/:id` | Eliminar usuario |

#### Workflows

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/workflows` | Listar workflows |
| POST | `/api/workflows` | Crear workflow |
| GET | `/api/workflows/:id` | Obtener workflow |
| POST | `/api/workflows/:id/execute` | Ejecutar workflow |

#### Storage

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/storage/upload` | Subir archivo |
| GET | `/api/storage/files` | Listar archivos |
| GET | `/api/storage/files/:id/download` | Descargar archivo |
| DELETE | `/api/storage/files/:id` | Eliminar archivo |

[Ver documentación completa de API →](./referencia-api/README.md)

---

## Módulos del Sistema

NexaBase incluye **30+ módulos** completamente funcionales:

| Módulo | Descripción | Docs |
|--------|-------------|------|
| **Auth** | Autenticación y autorización | [Ver](./modulos/auth.md) |
| **Tenants** | Multi-tenancy y organizaciones | [Ver](./modulos/tenants.md) |
| **Collections** | Colecciones dinámicas | [Ver](./modulos/collections.md) |
| **Users** | Gestión de usuarios | [Ver](./modulos/users.md) |
| **Workflows** | Automatización de procesos | [Ver](./modulos/workflows.md) |
| **Hooks** | Hooks personalizables | [Ver](./modulos/hooks.md) |
| **Functions** | Funciones serverless | [Ver](./modulos/functions.md) |
| **Storage** | Almacenamiento de archivos | [Ver](./modulos/storage.md) |
| **Vector Store** | Búsqueda vectorial | [Ver](./modulos/vector-store.md) |
| **Email** | Envío de correos | [Ver](./modulos/email.md) |
| **MCP** | Model Context Protocol | [Ver](./modulos/mcp.md) |
| **API Keys** | Gestión de API Keys | [Ver](./modulos/api-keys.md) |
| **Plans** | Planes y suscripciones | [Ver](./modulos/plans.md) |
| **Rate Limiting** | Control de tasa | [Ver](./modulos/rate-limiting.md) |
| **Analytics** | Analytics de uso | [Ver](./modulos/analytics.md) |
| **Webhooks** | Sistema de webhooks | [Ver](./modulos/webhooks.md) |
| **Backup** | Backups programados | [Ver](./modulos/backup.md) |
| **Monitoring** | Monitoreo y alertas | [Ver](./modulos/monitoring.md) |
| **Realtime** | WebSockets | [Ver](./modulos/realtime.md) |
| **OAuth** | OAuth (Google, GitHub) | [Ver](./modulos/oauth.md) |
| **Notifications** | Notificaciones | [Ver](./modulos/notifications.md) |
| **Activity Logs** | Logging de actividades | [Ver](./modulos/activity-logs.md) |
| **Dashboard** | Dashboard principal | [Ver](./modulos/dashboard.md) |
| **Developer Portal** | Portal para desarrolladores | [Ver](./modulos/developer-portal.md) |
| **SDK** | Generación de SDKs | [Ver](./modulos/sdk.md) |
| **Introspection** | Introspección del sistema | [Ver](./modulos/introspection.md) |
| **Documentation** | Documentación automática | [Ver](./modulos/documentation.md) |
| **Admin** | Panel de administración | [Ver](./modulos/admin.md) |
| **Testing** | Herramientas de testing | [Ver](./modulos/testing.md) |
| **Configuration** | Configuración de la app | [Ver](./modulos/configuration.md) |

---

## Despliegue

### Opciones de Despliegue

1. **Docker (Recomendado)**
   ```bash
   docker-compose up -d
   ```

2. **Dokploy**
   - Ver [Guía de Dokploy](./guias/dokploy.md)

3. **Manual (Node.js)**
   ```bash
   npm run build
   npm run start:prod
   ```

4. **Kubernetes**
   - Ver [Guía de Kubernetes](./guias/kubernetes.md)

### Requisitos de Producción

| Recurso | Mínimo | Recomendado |
|---------|--------|-------------|
| **CPU** | 2 cores | 4+ cores |
| **RAM** | 2 GB | 8+ GB |
| **Storage** | 10 GB | 100+ GB |
| **PostgreSQL** | 15+ | 16+ con réplicas |
| **Redis** | 6+ | Cluster |

### Variables de Producción

```bash
NODE_ENV=production
DATABASE_SSL=true
DATABASE_POOL_MAX=100
DATABASE_SLOW_QUERY_THRESHOLD=1000
ACTIVITY_LOGS_MODE=errors_only
```

[Ver guía completa de despliegue →](./guias/produccion.md)

---

## Contribuir

### Cómo Contribuir

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'Añadir nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

### Desarrollo Local

```bash
# Instalar dependencias
npm install

# Modo desarrollo (watch)
npm run start:dev

# Tests
npm run test

# Linting
npm run lint

# Build
npm run build
```

### Código de Conducta

- Sé respetuoso con otros contribuidores
- Documenta tus cambios
- Escribe tests para nuevas características
- Sigue los estándares de código del proyecto

---

## Soporte

- **Documentación:** https://docs.nexabase.online
- **Issues:** https://github.com/nexabase/nexabase/issues
- **Email:** soporte@nexabase.online
- **Discord:** https://discord.gg/nexabase

---

## License

MIT License - ver [LICENSE](./LICENSE) para más detalles.

---

**Hecho con ❤️ por el equipo de NexaBase**
