# 📦 Ejemplos de Uso de NexaBase MCP

En esta carpeta encontrarás ejemplos prácticos de cómo usar las herramientas MCP en diferentes escenarios.

---

## 🎯 Ejemplos Disponibles

### **1. Gestión de Colecciones**

#### **Crear Colección de Usuarios**
```javascript
// Prompt para IA:
"Crea una colección 'usuarios' con:
- email (string, único, requerido)
- nombre (string, requerido)
- rol (string: admin, user, moderator)
- activo (boolean, default: true)
- creado_en (date)"
```

#### **Insertar Múltiples Registros**
```javascript
// Prompt para IA:
"Inserta 10 usuarios de ejemplo en la colección 'usuarios'"
```

#### **Consultar con Filtros**
```javascript
// Prompt para IA:
"Muestra usuarios activos con rol de admin"
```

---

### **2. Workflows**

#### **Crear Workflow de Email**
```javascript
// Prompt para IA:
"Crea un workflow 'welcome-email' que:
1. Se active cuando se crea un usuario
2. Envíe un email de bienvenida
3. Registre la acción en activity_logs"
```

#### **Ejecutar Workflow Manualmente**
```javascript
// Prompt para IA:
"Ejecuta el workflow 'welcome-email' con los datos:
{
  email: 'nuevo@usuario.com',
  nombre: 'Juan Pérez'
}"
```

---

### **3. Funciones Serverless**

#### **Crear Función de Cálculo**
```javascript
// Prompt para IA:
"Crea una función 'calcular-impuestos' que:
- Reciba un monto
- Calcule el 21% de IVA
- Retorne el total con impuestos"
```

#### **Invocar Función**
```javascript
// Prompt para IA:
"Invoca la función 'calcular-impuestos' con monto: 1000"
```

---

### **4. Búsqueda Semántica**

#### **Crear Documentos Vectoriales**
```javascript
// Prompt para IA:
"Crea documentos vectoriales para:
1. 'Autenticación con JWT es un método seguro'
2. 'OAuth permite login con redes sociales'
3. 'API Keys son tokens de acceso'"
```

#### **Buscar por Similitud**
```javascript
// Prompt para IA:
"Busca documentos sobre 'login seguro con tokens'"
```

---

### **5. Storage**

#### **Subir Archivo**
```javascript
// Prompt para IA:
"Sube este archivo JSON al storage en la carpeta 'backups'"
```

#### **Obtener URL**
```javascript
// Prompt para IA:
"Dame la URL del archivo 'backup-2024.json'"
```

---

### **6. Hooks**

#### **Crear Hook de Validación**
```javascript
// Prompt para IA:
"Crea un hook 'validate-email' que:
- Se active antes de crear usuario
- Valide que el email tenga formato correcto
- Lance error si es inválido"
```

---

## 📊 Casos de Uso Reales

### **Caso 1: E-commerce**

```javascript
// Prompt completo:
"Crea un sistema de e-commerce con:

1. Colecciones:
   - productos (nombre, precio, stock, categoria)
   - ordenes (usuario_id, total, estado, fecha)
   - detalles_orden (orden_id, producto_id, cantidad, precio)

2. Workflows:
   - Enviar email de confirmación de orden
   - Actualizar stock después de compra
   - Notificar orden > $1000

3. Funciones:
   - Calcular total con impuestos
   - Generar reporte de ventas diarias"
```

### **Caso 2: Sistema de Reservas**

```javascript
// Prompt completo:
"Crea un sistema de reservas con:

1. Colecciones:
   - recursos (nombre, tipo, capacidad)
   - reservas (recurso_id, usuario_id, fecha_inicio, fecha_fin)
   - usuarios (nombre, email, telefono)

2. Hooks:
   - Validar que no haya reservas superpuestas
   - Enviar recordatorio 24hs antes

3. Búsqueda semántica:
   - Indexar descripciones de recursos"
```

### **Caso 3: Blog con CMS**

```javascript
// Prompt completo:
"Crea un CMS para blog con:

1. Colecciones:
   - posts (titulo, contenido, autor, estado)
   - categorias (nombre, slug)
   - comentarios (post_id, usuario, contenido)

2. Storage:
   - Subir imágenes de posts
   - Generar URLs temporales

3. Workflows:
   - Publicar post programado
   - Notificar nuevos comentarios"
```

---

## 🚀 Snippets de Código

### **Node.js - Cliente MCP Personalizado**

```javascript
// examples/nodejs/mcp-client.js
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { SSEClientTransport } from '@modelcontextprotocol/sdk/client/sse.js';

const TOKEN = 'TU_API_KEY';
const URL = 'https://api.nexabase.online/mcp/sse';

async function main() {
  const transport = new SSEClientTransport(
    new URL(URL),
    { headers: { Authorization: `Bearer ${TOKEN}` } }
  );

  const client = new Client({ name: 'mi-app', version: '1.0.0' }, {});
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
  await client.close();
}

main();
```

### **Python - Cliente MCP**

```python
# examples/python/mcp_client.py
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
            
            # Listar herramientas
            tools = await session.list_tools()
            print(f"Herramientas: {len(tools.tools)}")
            
            # Ejecutar herramienta
            result = await session.call_tool("list_collections", {})
            print(result)

asyncio.run(main())
```

---

## 📞 ¿Necesitas Más Ejemplos?

- **Email:** soporte@nexabase.online
- **GitHub:** https://github.com/fmirpe/nexabase
- **Discord:** https://discord.gg/nexabase

---

<div align="center">

**¿Tienes un caso de uso interesante? ¡Compártelo!** 🚀

</div>
