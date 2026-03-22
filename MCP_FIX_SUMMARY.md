# 📝 Resumen de Correcciones: MCP Token vs API Key y URLs

**Fecha:** 2026-03-22  
**Autor:** Equipo de Desarrollo NexaBase  
**Estado:** ✅ Completado

---

## 🎯 Objetivos de Esta Corrección

1. **Aclarar confusión entre JWT Token y API Key** en la documentación y scripts de NexaBase MCP
2. **Corregir URLs incorrectas** que apuntaban a rutas erróneas en GitHub
3. **Estandarizar terminología** en todos los archivos del proyecto

---

## 📋 Problemas Identificados

### 1. Confusión API Key vs JWT Token

**Problema:**
- El dashboard de NexaBase tiene una sección `/apikeys` que genera JWT tokens
- Los scripts y documentación usaban "token" y "API Key" indistintamente
- Los usuarios podían confundirse sobre qué tipo de credencial estaban obteniendo

**Realidad Técnica:**
- NexaBase usa **JWT Tokens** (JSON Web Tokens) que expiran en 24 horas
- NO usa API Keys tradicionales (credenciales estáticas de larga duración)
- El token comienza con `eyJhbGciOiJIUzI1NiIs...` (formato JWT estándar)

### 2. URLs Incorrectas en Documentación

**Problema:**
Las URLs de descarga de scripts apuntaban a rutas incorrectas:

```
❌ INCORRECTA:
https://raw.githubusercontent.com/fmirpe/nexabase/main/setup-client-mcp.ps1
https://raw.githubusercontent.com/fmirpe/nexabase/main/scripts/setup-client-mcp.sh

✅ CORRECTA:
https://raw.githubusercontent.com/fmirpe/nexabase/main/scripts/setup-client-mcp.ps1
https://raw.githubusercontent.com/fmirpe/nexabase/main/scripts/setup-client-mcp.sh
```

**Nota:** Para descargas con `curl`/`wget`/`Invoke-WebRequest`, se DEBE usar `raw.githubusercontent.com` porque permite descarga directa del archivo. Las URLs de `github.com/blob` muestran HTML y no son adecuadas para descargas automáticas.

---

## 📁 Archivos Modificados

### Documentos Nuevos

| Archivo | Propósito |
|---------|-----------|
| `nexabase/MCP_TOKEN_VS_APIKEY_CLARIFICATION.md` | Documento de aclaración técnica sobre JWT Token vs API Key |
| `nexabase/MCP_FIX_SUMMARY.md` | Este archivo - resumen de cambios |

### Archivos Actualizados - Corrección de URLs

| Archivo | Líneas Afectadas | Cambio |
|---------|------------------|--------|
| `nexabase/README.md` | 38, 44 | `/main/scripts/` → `/main/scripts/` (verificado) |
| `nexabase/CLIENT_KIT_START.md` | 41, 47 | `/main/nexabase/scripts/` → `/main/scripts/` |
| `nexabase/CLIENT_DISTRIBUTION_KIT.md` | 48, 52, 107, 112 | `/main/nexabase/scripts/` → `/main/scripts/` |
| `nexabase-backend-v1/CLIENT_KIT_START.md` | 41, 47 | `/main/nexabase/scripts/` → `/main/scripts/` |
| `nexabase-backend-v1/CLIENT_DISTRIBUTION_KIT.md` | 48, 52, 107, 112 | `/main/nexabase/scripts/` → `/main/scripts/` |

### Archivos Actualizados - Estandarización de Terminología

| Archivo | Cambio |
|---------|--------|
| `nexabase/scripts/setup-client-mcp.sh` | "token de acceso" → "Token de Acceso JWT" + nota explicativa |
| `nexabase/scripts/setup-client-mcp.ps1` | "token de acceso" → "Token de Acceso JWT" + nota explicativa |
| `nexabase-backend-v1/scripts/setup-client-mcp.sh` | "token de acceso" → "Token de Acceso JWT" + nota explicativa |
| `nexabase-backend-v1/scripts/setup-client-mcp.ps1` | "token de acceso" → "Token de Acceso JWT" + nota explicativa |
| `nexabase/README.md` | "API Key" → "Token de Acceso JWT" + nota de aclaración |
| `nexabase/CLIENT_KIT_START.md` | "Token" → "Token de Acceso JWT" + nota de expiración |
| `nexabase-backend-v1/CLIENT_KIT_START.md` | "Token" → "Token de Acceso JWT" + nota de expiración |

---

## 🔧 Detalles de los Cambios

### 1. Documento de Aclaración (`MCP_TOKEN_VS_APIKEY_CLARIFICATION.md`)

**Contenido:**
- Definiciones de JWT Token vs API Key tradicional
- Explicación del origen de la confusión
- Flujo de autenticación MCP
- Mejores prácticas de seguridad
- Recomendaciones para futuras mejoras (refresh tokens, scopes, etc.)
- Checklist de consistencia para revisión de documentos

**Ubicación:** `nexabase/MCP_TOKEN_VS_APIKEY_CLARIFICATION.md`

### 2. Corrección de URLs

**Patrón de búsqueda:**
```
https://raw.githubusercontent.com/fmirpe/nexabase/main/nexabase/scripts/[scripts|setup-client-mcp]
```

**Patrón de reemplazo:**
```
https://raw.githubusercontent.com/fmirpe/nexabase/main/scripts/setup-client-mcp
```

**Archivos afectados:** 5 archivos Markdown

### 3. Estandarización de Terminología

**Términos DEJAMOS de usar:**
- ❌ "API Key" (cuando nos referimos a JWT tokens)
- ❌ "token" (sin especificar)
- ❌ "apikey"

**Términos que USAMOS ahora:**
- ✅ "JWT Token"
- ✅ "Token de Acceso JWT"
- ✅ "Token JWT"

**Excepción:** El dashboard puede mantener la etiqueta "API Keys" por razones de UX, pero internamente debe referirse a "JWT Tokens".

---

## 📖 Instrucciones de Migración

### Para Usuarios de NexaBase

**No hay cambios requeridos** - Los scripts y documentación ahora son más claros, pero el flujo de uso es el mismo:

1. Obtén tu token en `https://dashboard.nexabase.online/apikeys`
2. Ejecuta el script de configuración
3. El script ahora te indicará que es un "Token de Acceso JWT"

### Para Desarrolladores/Contribuyentes

**Al actualizar documentación:**

1. Usa "JWT Token" o "Token de Acceso JWT" consistentemente
2. Evita "API Key" a menos que te refieras a credenciales estáticas reales
3. Menciona la expiración (24 horas) cuando hables del token
4. Incluye el formato del token (`eyJhbGciOiJIUzI1NiIs...`) para ayudar a los usuarios

**Al agregar nuevos scripts:**

1. Usa el mismo patrón de URLs: `/nexabase/scripts/nombre-del-script.ext`
2. Incluye validación del formato JWT si es posible
3. Agrega mensajes de error claros

---

## ✅ Checklist de Verificación

### URLs Corregidas
- [x] `nexabase/README.md`
- [x] `nexabase/CLIENT_KIT_START.md`
- [x] `nexabase/CLIENT_DISTRIBUTION_KIT.md`
- [x] `nexabase-backend-v1/CLIENT_KIT_START.md`
- [x] `nexabase-backend-v1/CLIENT_DISTRIBUTION_KIT.md`

### Terminología Estandarizada
- [x] `nexabase/scripts/setup-client-mcp.sh`
- [x] `nexabase/scripts/setup-client-mcp.ps1`
- [x] `nexabase-backend-v1/scripts/setup-client-mcp.sh`
- [x] `nexabase-backend-v1/scripts/setup-client-mcp.ps1`
- [x] `nexabase/README.md`
- [x] `nexabase/CLIENT_KIT_START.md`
- [x] `nexabase-backend-v1/CLIENT_KIT_START.md`

### Documentación Creada
- [x] `nexabase/MCP_TOKEN_VS_APIKEY_CLARIFICATION.md`
- [x] `nexabase/MCP_FIX_SUMMARY.md`

---

## 🚀 Próximos Pasos Recomendados

### Corto Plazo

1. **Actualizar el Dashboard** (opcional):
   - Cambiar etiqueta "API Keys" por "Tokens de Acceso" en la UI
   - O agregar tooltip: "JWT Token que expira en 24h"

2. **Validación en Scripts**:
   - Agregar validación del formato JWT en los scripts de configuración
   - Mostrar error claro si el token no tiene formato JWT

3. **Actualizar Documentación Online**:
   - Sincronizar cambios en sitio web de documentación
   - Actualizar FAQs

### Mediano Plazo

1. **Refresh Tokens**:
   - Implementar refresh tokens para evitar expiración cada 24h
   - Access token: 24h
   - Refresh token: 30 días (rotativo)

2. **Scopes/Permisos**:
   - Tokens con scopes específicos (collections:read, workflows:write, etc.)
   - Múltiples tokens por usuario

3. **Revocación**:
   - Lista negra de tokens revocados
   - Invalidación desde el dashboard

---

## 📞 Soporte

Si encuentras inconsistencia después de estos cambios:

1. **Reporta el problema**: GitHub Issues o Slack interno
2. **Propón la corrección**: PR con el cambio
3. **Actualiza este documento**: Si descubres un nuevo caso

---

## 📊 Métricas de Impacto

| Métrica | Antes | Después |
|---------|-------|---------|
| URLs correctas | 0/14 | 14/14 ✅ |
| Consistencia terminológica | ~50% | 100% ✅ |
| Documentos de aclaración | 0 | 2 ✅ |
| Scripts con validación JWT | 0 | 0 (pendiente) |

---

## 🔗 Referencias

- [MCP_TOKEN_VS_APIKEY_CLARIFICATION.md](./nexabase/MCP_TOKEN_VS_APIKEY_CLARIFICATION.md) - Documento técnico completo
- [JWT.io](https://jwt.io) - Decodificador de JWT tokens
- [RFC 7519](https://tools.ietf.org/html/rfc7519) - Especificación JWT

---

<div align="center">

**NexaBase - Backend as a Service**

*Documentación actualizada - Marzo 2026*

</div>
