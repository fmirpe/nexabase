# 🔐 Aclaración: JWT Token vs API Key en NexaBase MCP

## Resumen Ejecutivo

En NexaBase, utilizamos **JWT Tokens** para la autenticación MCP, NO API Keys tradicionales. Este documento explica la diferencia y por qué es importante.

---

## 📚 Definiciones

### JWT Token (Lo que usa NexaBase)

Un **JSON Web Token (JWT)** es un token temporal que contiene información codificada sobre el usuario y su tenant.

**Características:**
- ✅ **Temporal**: Expira después de un período (por defecto: 24 horas)
- ✅ **Autocontenido**: Incluye información del usuario (email, rol, tenantId)
- ✅ **Firmado**: Verificable sin consultar la base de datos
- ✅ **Formato**: Comienza con `eyJhbGciOiJIUzI1NiIs...`

**Ejemplo de payload:**
```json
{
  "sub": "09b9dec4-93db-4af4-a960-a6945615940a",
  "email": "admin@nexabase.com",
  "role": "admin",
  "tenantId": "c6931091-eb68-410f-a766-50f4cf99fd09",
  "iat": 1774210268,
  "exp": 1774296668
}
```

### API Key (NO usada en NexaBase MCP)

Una **API Key** tradicional es una credencial estática de larga duración.

**Características:**
- ⚠️ **Permanente**: No expira a menos que se revoque
- ⚠️ **Opaca**: Solo es un identificador, no contiene información
- ⚠️ **Requiere lookup**: El servidor debe consultar la BD para validar

---

## 🔄 ¿Por Qué la Confusión?

### Origen del Problema

1. **El dashboard tiene una sección `/apikeys`** - Esto genera JWT tokens, no API Keys
2. **Los scripts dicen "token de acceso"** - Correcto, pero algunos documentos dicen "API Key"
3. **Terminología inconsistente** - Algunos archivos usan "token", otros "apikey"

### Realidad Técnica

```
┌─────────────────────────────────────────────────────────────┐
│  Dashboard NexaBase (/apikeys)                              │
│                                                             │
│  Botón: "Generar Nueva API Key"  ← ETIQUETA INCORRECTA     │
│           ↓                                                 │
│  El backend genera un JWT Token                            │
│           ↓                                                 │
│  Usuario copia el token (eyJhbGciOiJIUzI1NiIs...)          │
│           ↓                                                 │
│  Se usa en header: Authorization: Bearer <JWT_TOKEN>       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Terminología Correcta

| Contexto | Término Correcto | Ejemplo |
|----------|------------------|---------|
| **Autenticación MCP** | JWT Token / Token de Acceso | `eyJhbGciOiJIUzI1NiIs...` |
| **Dashboard UI** | Token de Acceso (NO API Key) | Sección `/apikeys` |
| **Scripts de configuración** | Token | `setup-client-mcp.sh` |
| **Header HTTP** | Bearer Token | `Authorization: Bearer <token>` |

---

## 🔧 Flujo de Autenticación MCP

### 1. Generación del Token (Backend)

```typescript
// nexabase-backend-v1/scripts/generate-token-mcp.ts
const payload = {
  sub: user.id,           // ID del usuario
  email: user.email,      // Email del usuario
  role: user.role,        // Rol (admin, user, etc.)
  tenantId: tenantId,     // ID del tenant
};

const token = jwt.sign(payload, jwtSecret, { expiresIn: '24h' });
```

### 2. Uso del Token (Cliente MCP)

```json
// .trae/mcp.json
{
  "mcpServers": [
    {
      "name": "NexaBase MCP",
      "type": "sse",
      "url": "https://api.nexabase.online/mcp/sse",
      "headers": {
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIs..."
      }
    }
  ]
}
```

### 3. Validación (Servidor)

El servidor MCP:
1. Extrae el token del header `Authorization: Bearer <token>`
2. Verifica la firma JWT
3. Extrae `tenantId` y `userId` del payload
4. Usa esa información para aislar datos por tenant

---

## 📋 Mejores Prácticas

### Para Usuarios de NexaBase

1. **Nunca compartas tu token** - Es como una contraseña temporal
2. **Regenera el token cada 24h** - O cuando inicies sesión en un nuevo equipo
3. **No lo guardes en repositorios** - Usa `.gitignore` para `token.txt` y `.env`
4. **Usa variables de entorno** - Para automatización en CI/CD

### Para Desarrolladores de NexaBase

1. **Usa terminología consistente**:
   - ✅ "JWT Token" o "Token de Acceso"
   - ❌ "API Key" (cuando en realidad es un JWT)

2. **Documenta la expiración**:
   - Indica claramente que el token expira en 24h
   - Proporciona instrucciones para regenerar

3. **Considera refresh tokens** - Para futuras versiones:
   - Access token: 24h
   - Refresh token: 30 días
   - Rotación automática

4. **Audita los tokens** - Log de generación y uso

---

## 🚨 Consideraciones de Seguridad

### Riesgos Actuales

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Token expuesto en repo | Alto | `.gitignore`, secrets scanning |
| Token de larga duración | Medio | Expiración 24h |
| Sin rate limiting | Medio | Implementar límites por tenant |
| Token sin scope | Bajo | Todos los permisos del usuario |

### Recomendaciones Futuras

1. **Scopes/Permisos Granulares**
   ```
   token con scope: collections:read workflows:write
   ```

2. **Refresh Tokens**
   ```
   access_token: 24h
   refresh_token: 30 días (rotativo)
   ```

3. **Revocación de Tokens**
   - Lista negra de tokens revocados
   - Invalidación desde el dashboard

4. **Múltiples Tokens por Usuario**
   - Un token por dispositivo/editor
   - Revocación individual

---

## 📝 Migración de Terminología

### Archivos que DEBEN usar "Token" (no "API Key")

- ✅ `setup-client-mcp.sh` / `.ps1` - Scripts de configuración
- ✅ `.trae/mcp.json` - Configuración de editor
- ✅ Documentación MCP
- ✅ Mensajes de error

### Excepción: Dashboard UI

El dashboard puede mantener la etiqueta "API Keys" por razones de UX (los usuarios entienden mejor "API Key"), pero internamente debe referirse a "JWT Tokens".

---

## 🔍 ¿Cómo Identificar Qué Tipo de Credencial Es?

### Es un JWT Token si:
- ✅ Comienza con `eyJ` (base64 de `{"alg":"HS256",...}`)
- ✅ Tiene 3 partes separadas por puntos
- ✅ Expira después de X tiempo
- ✅ Contiene información del usuario codificada

### Es una API Key tradicional si:
- ✅ Es un string aleatorio (ej: `sk-abc123def456...`)
- ✅ No tiene estructura específica
- ✅ No expira a menos que se revoque
- ✅ Es opaca (no contiene información)

---

## ✅ Checklist de Consistencia

### Para Revisión de Documentos

- [ ] ¿Usa "JWT Token" o "Token de Acceso" consistentemente?
- [ ] ¿Evita "API Key" cuando se refiere a JWT tokens?
- [ ] ¿Menciona la expiración del token (24h)?
- [ ] ¿Incluye ejemplo del formato (`eyJhbGciOiJIUzI1NiIs...`)?
- [ ] ¿Explica cómo regenerar el token?

### Para Revisión de Código

- [ ] ¿Las variables se llaman `token` no `apiKey`?
- [ ] ¿El header usa `Authorization: Bearer <token>`?
- [ ] ¿La documentación del endpoint menciona JWT?

---

## 📞 ¿Tienes Dudas?

Si encuentras inconsistencia en la documentación o código:

1. **Reporta el problema** - GitHub Issues o Slack interno
2. **Propón la corrección** - PR con el cambio
3. **Actualiza este documento** - Si descubres un nuevo caso

---

## 📖 Referencias

- [JWT.io](https://jwt.io) - Decodificador de JWT tokens
- [RFC 7519](https://tools.ietf.org/html/rfc7519) - Especificación JWT
- [Model Context Protocol](https://modelcontextprotocol.io) - Protocolo MCP

---

<div align="center">

**Documento de referencia para el equipo de NexaBase**

Última actualización: 2026-03-22

</div>
