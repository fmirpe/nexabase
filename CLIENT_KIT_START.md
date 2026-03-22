# 🚀 Kit de Inicio Rápido - NexaBase MCP

## ¡Bienvenido a NexaBase!

<img src="https://api.nexabase.online/logo.png" alt="NexaBase Logo" width="200"/>

Este kit te ayudará a conectar tu editor de código con NexaBase en menos de 5 minutos.

---

## 📦 ¿Qué Incluye Este Kit?

- ✅ Scripts de configuración automática
- ✅ Plantillas para todos los editores
- ✅ Guía paso a paso
- ✅ Ejemplos de código
- ✅ FAQ y troubleshooting

---

## ⚡ Configuración en 3 Pasos

### **Paso 1: Obtén tu Token**

Ingresa a tu dashboard de NexaBase:

```
https://dashboard.nexabase.online/apikeys
```

Click en **"Generar Nuevo Token"** y copia el token.

---

### **Paso 2: Ejecuta el Script de Configuración**

Descarga y ejecuta:

#### **Windows (PowerShell)**
```powershell
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/fmirpe/nexabase/main/setup-client-mcp.ps1' -OutFile 'setup-mcp.ps1'"
.\setup-mcp.ps1
```

#### **macOS/Linux (Bash)**
```bash
curl -o setup-client-mcp.sh https://raw.githubusercontent.com/fmirpe/nexabase/main/setup-client-mcp.sh
chmod +x setup-client-mcp.sh
./setup-client-mcp.sh
```

El script te preguntará:
1. Tu token de acceso
2. Tu editor (Trae, Antigravity, Cursor, VS Code)
3. La URL de tu instancia NexaBase (usa: https://api.nexabase.online)

¡Y configurará todo automáticamente!

---

### **Paso 3: Reinicia tu Editor**

- **Trae:** `Ctrl + Shift + P` → `Developer: Reload Window`
- **Antigravity:** `Ctrl + Shift + P` → `Antigravity: Reload Configuration`
- **Cursor:** `Ctrl + Shift + P` → `Cursor: Reload Window`

---

## 🧪 ¡Prueba tu Conexión!

Abre el chat de IA en tu editor y escribe:

```
Lista las colecciones de NexaBase
```

Si ves una lista de colecciones, **¡está funcionando!** 🎉

---

## 📚 Guías por Editor

### **Trae IDE**
Ver `EDITORES/TRAET.md`

### **Antigravity**
Ver `EDITORES/ANTIGRAVITY.md`

### **Cursor**
Ver `EDITORES/CURSOR.md`

### **VS Code**
Ver `EDITORES/VSCODE.md`

---

## 🎯 Ejemplos Listos para Usar

### **Ejemplo 1: Crear Colección**

Pide a la IA:

```
Crea una colección "clientes" con:
- nombre (string)
- email (string, único)
- telefono (string)
- direccion (texto)
```

---

### **Ejemplo 2: Insertar Datos**

```
Inserta 5 clientes de ejemplo en la colección "clientes"
```

---

### **Ejemplo 3: Consultar**

```
Muestra todos los clientes con email de Gmail
```

---

### **Ejemplo 4: Workflow**

```
Crea un workflow que envíe email cuando se cree un cliente nuevo
```

---

## 🔧 Problemas Comunes

### **"Connection refused"**

**Solución:** Verifica la conexión a NexaBase

```bash
curl https://api.nexabase.online/health
```

---

### **"401 Unauthorized"**

**Solución:** Tu token expiró o es inválido

1. Genera nuevo token en el dashboard
2. Ejecuta nuevamente el script de configuración

---

### **"Tool not found"**

**Solución:** MCP no está cargado

1. Reinicia completamente tu editor
2. Verifica que `.trae/mcp.json` o `.antigravity/mcp-config.json` exista

---

## 📞 ¿Necesitas Ayuda?

### **Recursos**

- **Dashboard:** https://dashboard.nexabase.online
- **API Keys:** https://dashboard.nexabase.online/apikeys
- **Documentación:** https://api.nexabase.online/docs
- **Status:** https://status.nexabase.online

### **Contacto**

- **Email:** soporte@nexabase.online
- **Discord:** https://discord.gg/nexabase
- **GitHub:** https://github.com/nexabase

---

## ✅ Checklist

- [ ] Token generado
- [ ] Script ejecutado
- [ ] Editor reiniciado
- [ ] Prueba exitosa
- [ ] Primer prompt ejecutado

---

## 🎁 Bonus: Snippets de Código

### **Node.js - Cliente MCP**

```javascript
// mcp-client.js
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { SSEClientTransport } from '@modelcontextprotocol/sdk/client/sse.js';

const client = new Client({ name: 'mi-app', version: '1.0.0' });

const transport = new SSEClientTransport(
  new URL('https://api.nexabase.online/mcp/sse'),
  { headers: { Authorization: 'Bearer TU_TOKEN' } }
);

await client.connect(transport);

// Listar herramientas
const tools = await client.listTools();
console.log(`Herramientas: ${tools.tools.length}`);

// Ejecutar herramienta
const result = await client.callTool({
  name: 'list_collections',
  arguments: {}
});

console.log(result.content[0].text);
```

---

### **Python - Cliente MCP**

```python
# mcp_client.py
import asyncio
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def main():
    server_params = StdioServerParameters(
        command="bun",
        args=["run", "src/main.ts"],
        cwd="/path/to/nexabase",
        env={"DATABASE_URL": "..."}
    )
    
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            
            tools = await session.list_tools()
            print(f"Herramientas: {len(tools.tools)}")
            
            result = await session.call_tool("list_collections", {})
            print(result)

asyncio.run(main())
```

---

## 📖 Más Información

- **Guía Completa:** `docs/CLIENTE_GUIA_CONEXION_MCP.md`
- **API Reference:** `/api-docs` en api.nexabase.online
- **Ejemplos:** `examples/` en este kit

---

**¡Feliz Desarrollo con NexaBase!** 🚀

<img src="https://api.nexabase.online/logo.png" alt="NexaBase Logo" width="100"/>

---

*¿Tienes preguntas? Abre un ticket en el dashboard o envía un email a soporte@nexabase.online*
