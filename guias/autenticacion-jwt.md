# Autenticación JWT

NexaBase utiliza **JSON Web Tokens (JWT)** para autenticación segura de usuarios.

## ¿Cómo funciona JWT en NexaBase?

```
┌─────────────┐
│   Usuario   │
└──────┬──────┘
       │ 1. POST /api/v1/login (email, password)
       ▼
┌─────────────────┐
│  NexaBase API   │
│  - Valida creds │
│  - Genera JWT   │
└──────┬──────────┘
       │ 2. Retorna { access_token, refresh_token }
       ▼
┌─────────────┐
│   Usuario   │
│  Guarda     │
│  tokens     │
└──────┬──────┘
       │ 3. Usa access_token en requests
       │ Authorization: Bearer <token>
       ▼
┌─────────────────┐
│  NexaBase API   │
│  - Valida JWT   │
│  - Procesa req  │
└─────────────────┘
```

## Tokens

### Access Token

- **Duración:** 24 horas
- **Propósito:** Autenticar requests a la API
- **Contenido:**
  ```json
  {
    "sub": "user-uuid",
    "email": "usuario@ejemplo.com",
    "role": "admin",
    "tenantId": "tenant-uuid",
    "iat": 1234567890,
    "exp": 1234567890
  }
  ```

### Refresh Token

- **Duración:** 7 días
- **Propósito:** Obtener nuevos access tokens
- **Uso:** POST /api/v1/refresh

## Inicio Rápido

### 1. Login

```bash
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@nexabase.com",
    "password": "tu-password"
  }'
```

**Respuesta exitosa:**

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 86400,
  "token_type": "Bearer",
  "user": {
    "id": "user-uuid",
    "email": "admin@nexabase.com",
    "first_name": "Admin",
    "last_name": "User",
    "role": "admin",
    "tenantId": "tenant-uuid",
    "status": "active"
  },
  "organization": {
    "id": "tenant-uuid",
    "name": "Mi Organización",
    "slug": "mi-org"
  }
}
```

### 2. Usar Token en Requests

```bash
curl -X GET http://localhost:3000/api/users \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 3. Refrescar Token

```bash
curl -X POST http://localhost:3000/api/v1/refresh \
  -H "Authorization: Bearer TU_REFRESH_TOKEN"
```

## Autenticación con API Key

Para acceso programático, usa API Keys:

```bash
curl -X GET http://localhost:3000/api/users \
  -H "X-API-Key: nxb_tu_api_key_aqui"
```

**Ventajas de API Keys:**
- No expiran (a menos que las revoques)
- Ideales para scripts y automatización
- Permisos configurables
- Rate limiting personalizado

## Autenticación Dual (JWT + API Key)

Algunos endpoints requieren ambas:

```bash
curl -X POST http://localhost:3000/api/admin/collections \
  -H "Authorization: Bearer TU_JWT_TOKEN" \
  -H "X-API-Key: nxb_tu_api_key"
```

## Manejo de Errores

### 401 Unauthorized

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "error": "Unauthorized"
}
```

**Causas:**
- Token expirado
- Token inválido
- Token faltante

**Solución:**
1. Verifica que el token no expiró
2. Usa refresh token para obtener nuevo access token
3. Asegúrate de incluir el header `Authorization: Bearer <token>`

### 403 Forbidden

```json
{
  "statusCode": 403,
  "message": "Forbidden",
  "error": "Forbidden"
}
```

**Causas:**
- Usuario no tiene permisos
- Rol insuficiente

**Solución:**
- Verifica que el usuario tenga el rol necesario

## Seguridad

### Mejores Prácticas

1. **Nunca compartas tu token**
2. **Usa HTTPS** siempre en producción
3. **Almacena tokens de forma segura** (no en localStorage si es posible)
4. **Rota refresh tokens** periódicamente
5. **Revoca tokens** cuando el usuario cierre sesión

### Configuración JWT

En tu `.env`:

```bash
# Secreto para firmar JWT (mínimo 32 caracteres)
JWT_SECRET=tu-secreto-muy-seguro-min-32-caracteres-cambia-en-produccion

# Duración del access token
JWT_EXPIRES_IN=24h

# Duración del refresh token
REFRESH_TOKEN_EXPIRES_IN=7d
```

## Ejemplos por Lenguaje

### JavaScript/Node.js

```javascript
const axios = require('axios');

// Login
const response = await axios.post('http://localhost:3000/api/v1/login', {
  email: 'admin@nexabase.com',
  password: 'tu-password'
});

const { access_token, refresh_token } = response.data;

// Usar token
const users = await axios.get('http://localhost:3000/api/users', {
  headers: {
    'Authorization': `Bearer ${access_token}`
  }
});

// Refrescar token
const newToken = await axios.post('http://localhost:3000/api/v1/refresh', null, {
  headers: {
    'Authorization': `Bearer ${refresh_token}`
  }
});
```

### Python

```python
import requests

# Login
response = requests.post('http://localhost:3000/api/v1/login', json={
    'email': 'admin@nexabase.com',
    'password': 'tu-password'
})

data = response.json()
access_token = data['access_token']
refresh_token = data['refresh_token']

# Usar token
headers = {'Authorization': f'Bearer {access_token}'}
users = requests.get('http://localhost:3000/api/users', headers=headers)

# Refrescar token
headers = {'Authorization': f'Bearer {refresh_token}'}
new_token = requests.post('http://localhost:3000/api/v1/refresh', headers=headers)
```

### cURL

```bash
# Login
TOKEN=$(curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@nexabase.com","password":"tu-password"}' \
  | jq -r '.access_token')

# Usar token
curl -X GET http://localhost:3000/api/users \
  -H "Authorization: Bearer $TOKEN"
```

## Roles y Permisos

### Roles Disponibles

| Rol | Descripción | Permisos |
|-----|-------------|----------|
| **SUPER_ADMIN** | Administrador del sistema | Todos |
| **ADMIN** | Admin de tenant | CRUD completo en su tenant |
| **DEVELOPER** | Desarrollador | Lectura y escritura limitada |
| **USER** | Usuario básico | Lectura principalmente |

### Verificar Rol del Usuario

```bash
curl -X GET http://localhost:3000/api/v1/me \
  -H "Authorization: Bearer TU_TOKEN"
```

## Autenticación Opcional

Algunos endpoints permiten acceso público pero retornan datos adicionales si estás autenticado:

```bash
# Sin autenticación
curl -X GET http://localhost:3000/api/collections/productos

# Con autenticación (puede retornar datos personalizados)
curl -X GET http://localhost:3000/api/collections/productos \
  -H "Authorization: Bearer TU_TOKEN"
```

## Logout

```bash
curl -X POST http://localhost:3000/api/v1/logout \
  -H "Authorization: Bearer TU_TOKEN"
```

**Nota:** El logout invalida el refresh token en el servidor.

## Cambio de Contraseña

### Solicitar Reset

```bash
curl -X POST http://localhost:3000/api/v1/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@nexabase.com"}'
```

### Resetear Contraseña

```bash
curl -X POST http://localhost:3000/api/v1/reset-password \
  -H "Content-Type: application/json" \
  -d '{
    "token": "TOKEN_DEL_EMAIL",
    "password": "NuevaContraseña123!"
  }'
```

## Verificación de Email

Cuando un usuario se registra, recibe un email con token de verificación:

```bash
curl -X GET http://localhost:3000/api/v1/verify-email?token=TOKEN_DEL_EMAIL
```

---

**Recursos Relacionados:**

- [API Keys](./api-keys.md)
- [OAuth](./oauth.md)
- [2FA](./2fa.md)
- [Roles y Permisos](./roles.md)
