# 🚀 NexaBase MCP Client Kit

> **Conecta tu editor de código con NexaBase y desarrolla más rápido con IA**

[![NexaBase](https://img.shields.io/badge/NexaBase-MCP-blue?style=for-the-badge)](https://nexabase.online)
[![MCP](https://img.shields.io/badge/MCP-Protocol-green?style=for-the-badge)](https://modelcontextprotocol.io)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

---

## 📋 ¿Qué es NexaBase MCP?

NexaBase MCP (Model Context Protocol) te permite conectar tu editor de código favorito directamente a la plataforma NexaBase, dándote acceso a **39 herramientas** que automatizan el desarrollo:

- ✅ **Colecciones:** CRUD completo de bases de datos
- ✅ **Workflows:** Automatización de procesos
- ✅ **Hooks:** Eventos de base de datos
- ✅ **Funciones Serverless:** Código en la nube
- ✅ **Storage:** Gestión de archivos
- ✅ **Vector Store:** Búsqueda semántica con IA
- ✅ **Usuarios:** Gestión de equipos

---

## ⚡ Inicio Rápido (5 Minutos)

### **Paso 1: Obtén tu Token de Acceso JWT**

1. Ve a [Dashboard NexaBase](https://dashboard.nexabase.online/apikeys)
2. Inicia sesión
3. Click en **"Generar Nueva API Key"**
4. Copia tu token JWT (comienza con `eyJhbGciOiJIUzI1NiIs...`)

> **Nota:** Aunque el dashboard muestra "API Key", en realidad se trata de un **JWT Token** que expira en 24 horas. Ver `MCP_TOKEN_VS_APIKEY_CLARIFICATION.md` para más detalles.

### **Paso 2: Descarga el Script**

#### **Windows (PowerShell)**
```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/fmirpe/nexabase/main/scripts/setup-client-mcp.ps1' -OutFile 'setup-mcp.ps1'
.\setup-mcp.ps1
```

#### **macOS / Linux**
```bash
curl -o setup-client-mcp.sh https://raw.githubusercontent.com/fmirpe/nexabase/main/scripts/setup-client-mcp.sh
chmod +x setup-client-mcp.sh
./setup-client-mcp.sh
```

### **Paso 3: Sigue las Instrucciones**

El script te preguntará:
1. Tu **API Key** (del Paso 1)
2. Tu **editor** (Trae, Antigravity, Cursor, VS Code)
3. La **URL de instancia** (por defecto: `https://api.nexabase.online`)

### **Paso 4: ¡Listo!**

Reinicia tu editor y comienza a usar las 39 herramientas MCP.

---

## 🛠️ Editores Soportados

| Editor | Estado | Configuración |
|--------|--------|---------------|
| 🚀 **Trae IDE** | ✅ Soportado | `.trae/mcp.json` |
| 🦅 **Antigravity** | ✅ Soportado | `.antigravity/mcp-config.json` |
| 📟 **Cursor** | ✅ Soportado | `.cursor/mcp.json` |
| 📝 **VS Code** | ✅ Soportado | `.vscode/mcp.json` |

---

## 📦 ¿Qué Incluye Este Kit?

### **Scripts**
- `setup-client-mcp.ps1` - Configuración automática para Windows
- `setup-client-mcp.sh` - Configuración automática para macOS/Linux

### **Documentación**
- `CLIENT_KIT_START.md` - Guía de inicio rápido
- `docs/CLIENTE_GUIA_CONEXION_MCP.md` - Guía completa de conexión
- `docs/CONFIG_TRAE_ANTIGRAVITY_MCP.md` - Configuración por editor

### **Utilidades** (Próximamente)
- Scripts de migración
- Herramientas de backup
- Generadores de código
- Plantillas de proyectos

---

## 🎯 Ejemplos de Uso

### **Crear una Colección**

En el chat de IA de tu editor:

```
Crea una colección "productos" con:
- nombre (string, requerido)
- precio (number)
- stock (number)
- categoria (string)
```

### **Insertar Datos**

```
Inserta 5 productos de ejemplo en la colección "productos"
```

### **Consultar con Filtros**

```
Muestra productos con precio mayor a 100 y stock disponible
```

### **Crear Workflow**

```
Crea un workflow que envíe email cuando el stock sea menor a 10
```

### **Búsqueda Semántica**

```
Busca documentos sobre "autenticación de usuarios"
```

---

## 📚 Documentación Completa

| Guía | Descripción |
|------|-------------|
| [Inicio Rápido](CLIENT_KIT_START.md) | Configuración en 3 pasos |
| [Guía de Conexión](docs/CLIENTE_GUIA_CONEXION_MCP.md) | Detalle por editor |
| [Troubleshooting](docs/CLIENTE_GUIA_CONEXION_MCP.md#troubleshooting) | Problemas comunes |
| [Ejemplos](docs/CLIENTE_GUIA_CONEXION_MCP.md#ejemplos-de-uso) | Casos de uso reales |

---

## 🔧 Comandos Útiles

### **Ver Herramientas Disponibles**

Después de configurar, en tu editor:

```
Lista las herramientas MCP disponibles
```

### **Probar Conexión**

```
Lista las colecciones de NexaBase
```

### **Ver Estado del Tenant**

```
Muestra información del tenant actual
```

---

## 🆘 Soporte

### **Recursos**

- 📖 **Documentación:** https://api.nexabase.online/docs
- 🎯 **Dashboard:** https://dashboard.nexabase.online
- 💬 **Discord:** https://discord.gg/nexabase
- 🐙 **GitHub:** https://github.com/fmirpe/nexabase

### **Contacto**

- **Email:** soporte@nexabase.online
- **Horario:** Lunes a Viernes, 9:00 - 18:00 UTC-3

---

## ❓ FAQ

### **¿Necesito instalar algo adicional?**

Solo Node.js 18+ y tu editor favorito. El script configura todo automáticamente.

### **¿Mi Token de Acceso JWT expira?**

Sí, los JWT tokens expiran en **24 horas**. Puedes generar uno nuevo en el dashboard cuando lo necesites. El token es un JWT (JSON Web Token) que comienza con `eyJhbGciOiJIUzI1NiIs...`.

### **¿Funciona en producción?**

Sí, configura la URL de tu instancia de producción cuando el script te pregunte.

### **¿Puedo usar múltiples editores?**

¡Sí! Ejecuta el script varias veces seleccionando diferentes editores.

### **¿Qué pasa si tengo un error?**

1. Revisa los logs de tu editor (Output → MCP)
2. Verifica que tu API Key sea válida
3. Reinicia completamente tu editor
4. Contacta soporte: soporte@nexabase.online

---

## 🚀 Próximas Caracteruras

- [ ] Scripts de migración automática
- [ ] Generador de código desde schemas
- [ ] Plantillas de proyectos pre-configurados
- [ ] Herramientas de backup y restore
- [ ] CLI oficial de NexaBase
- [ ] Integración con más editores

---

## 📄 Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).

---

## 🙏 Agradecimientos

- [Model Context Protocol](https://modelcontextprotocol.io) - Protocolo MCP
- [NexaBase](https://nexabase.online) - Plataforma Backend as a Service
- [Trae IDE](https://trae.ai) - Editor con IA
- [Cursor](https://cursor.sh) - Editor con IA

---

<div align="center">

**Hecho con ❤️ por el equipo de NexaBase**

[🌐 Sitio Web](https://nexabase.online) | [📧 Contacto](mailto:soporte@nexabase.online) | [💬 Discord](https://discord.gg/nexabase)

</div>
