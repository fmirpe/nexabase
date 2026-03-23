#!/bin/bash
# NexaBase MCP Setup Script para Clientes (Linux/macOS)
# Uso: ./setup-client-mcp.sh [--local]
#
# Opciones:
#   ./setup-client-mcp.sh          # Producción (default)
#   ./setup-client-mcp.sh --local  # Localhost para testing

# Colores
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Parsear argumentos
if [ "$1" = "--local" ]; then
    defaultInstanceUrl="http://localhost:3000"
    echo -e "${CYAN}🚀 Configuración de NexaBase MCP - LOCAL${NC}"
else
    defaultInstanceUrl="https://api.nexabase.online"
    echo -e "${CYAN}🚀 Configuración de NexaBase MCP - PRODUCCIÓN${NC}"
fi

echo -e "${CYAN}==============================================${NC}"
echo -e ""
echo -e "${WHITE}   NexaBase - Backend as a Service${NC}"
echo -e "${GRAY}   URL: $defaultInstanceUrl${NC}"
echo -e "${GRAY}   Dashboard: $defaultInstanceUrl/dashboard${NC}"
echo -e "${GRAY}   Soporte: soporte@nexabase.online${NC}"
echo -e ""

# Paso 1: Pedir API Key
echo -e "${YELLOW}📝 Paso 1: Ingresa tu API Key de NexaBase${NC}"
echo -e "${GRAY}   (Por defecto: usa la API Key del script)${NC}"
echo -e "${GRAY}   ⚠️  Comienza con 'nxb_...'${NC}"
read -p "   API Key [nxb_abbf5bd09203a2390d84d742a201b599c10738b2cfde2c78680ac14dff80a8c1]: " apiKey

if [ -z "$apiKey" ]; then
    apiKey="nxb_abbf5bd09203a2390d84d742a201b599c10738b2cfde2c78680ac14dff80a8c1"
fi

# Validar formato
if [[ ! $apiKey =~ ^nxb_ ]]; then
    echo -e "${YELLOW}⚠️  Advertencia: La API Key debería comenzar con 'nxb_'${NC}"
    read -p "   ¿Continuar de todos modos? (s/n): " continue
    if [ "$continue" != "s" ] && [ "$continue" != "S" ]; then
        exit 1
    fi
fi

# Paso 2: Pedir URL de instancia
echo -e ""
echo -e "${YELLOW}🌐 Paso 2: URL de tu instancia NexaBase${NC}"
echo -e "${GRAY}   (Por defecto: $defaultInstanceUrl)${NC}"
read -p "   URL [$defaultInstanceUrl]: " instanceUrl

if [ -z "$instanceUrl" ]; then
    instanceUrl="$defaultInstanceUrl"
fi

# Limpiar URL (quitar trailing slash)
instanceUrl="${instanceUrl%/}"

# Paso 3: Elegir editor
echo -e ""
echo -e "${YELLOW}🛠️  Paso 3: ¿Qué editor usas?${NC}"
echo -e "${WHITE}   1. Trae IDE${NC}"
echo -e "${WHITE}   2. Antigravity${NC}"
echo -e "${WHITE}   3. Cursor IDE${NC}"
echo -e "${WHITE}   4. VS Code${NC}"
echo -e "${WHITE}   5. Todos${NC}"
read -p "   Elige una opción (1-5): " editorChoice

# Obtener directorio del proyecto
projectRoot=$(pwd)

# Función para configurar Trae
configure_trae() {
    echo -e ""
    echo -e "${GREEN}🚀 Configurando Trae IDE...${NC}"

    traeDir="$projectRoot/.trae"
    if [ ! -d "$traeDir" ]; then
        mkdir -p "$traeDir"
    fi

    cat > "$traeDir/mcp.json" << EOF
{
  "mcpServers": [
    {
      "name": "NexaBase MCP",
      "type": "sse",
      "url": "$instanceUrl/api/mcp/sse",
      "headers": {
        "X-API-Key": "$apiKey"
      },
      "enabled": true
    }
  ]
}
EOF
    echo -e "${GREEN}   ✅ Archivo creado: .trae/mcp.json${NC}"
}

# Función para configurar Antigravity (ubicación global)
configure_antigravity() {
    echo -e ""
    echo -e "${GREEN}🦅 Configurando Antigravity (global)...${NC}"

    antigravityGlobalDir="$HOME/.gemini/antigravity"
    if [ ! -d "$antigravityGlobalDir" ]; then
        mkdir -p "$antigravityGlobalDir"
    fi

    antigravityGlobalPath="$antigravityGlobalDir/mcp_config.json"

    # Leer configuración existente y agregar NexaBase
    if [ -f "$antigravityGlobalPath" ]; then
        # Usar jq si está disponible, sino usar python
        if command -v jq &> /dev/null; then
            jq --arg url "$instanceUrl/mcp/sse" --arg key "$apiKey" '.mcpServers.nexabase = {"serverURL": $url, "headers": {"X-API-Key": $key}}' "$antigravityGlobalPath" > "$antigravityGlobalPath.tmp" && mv "$antigravityGlobalPath.tmp" "$antigravityGlobalPath"
        elif command -v python3 &> /dev/null; then
            python3 << PYEOF
import json
with open('$antigravityGlobalPath', 'r') as f:
    config = json.load(f)
config.setdefault('mcpServers', {})['nexabase'] = {
    'serverURL': '$instanceUrl/mcp/sse',
    'headers': {
        'X-API-Key': '$apiKey'
    }
}
with open('$antigravityGlobalPath', 'w') as f:
    json.dump(config, f, indent=2)
PYEOF
        else
            # Fallback: sobrescribir (puede perder otros MCPs)
            cat > "$antigravityGlobalPath" << EOF
{
  "mcpServers": {
    "nexabase": {
      "serverURL": "$instanceUrl/mcp/sse",
      "headers": {
        "X-API-Key": "$apiKey"
      }
    }
  }
}
EOF
        fi
        echo -e "${GREEN}   📁 Archivo actualizado: $antigravityGlobalPath${NC}"
    else
        # Crear nuevo archivo con formato estándar
        cat > "$antigravityGlobalPath" << EOF
{
  "mcpServers": {
    "nexabase": {
      "serverURL": "$instanceUrl/mcp/sse",
      "headers": {
        "X-API-Key": "$apiKey"
      }
    }
  }
}
EOF
        echo -e "${GREEN}   📁 Archivo creado: $antigravityGlobalPath${NC}"
    fi

    echo -e "${GREEN}✅ Antigravity configurado (global)${NC}"
}

# Función para configurar Cursor
configure_cursor() {
    echo -e ""
    echo -e "${GREEN}📟 Configurando Cursor IDE...${NC}"

    cursorDir="$projectRoot/.cursor"
    if [ ! -d "$cursorDir" ]; then
        mkdir -p "$cursorDir"
    fi

    cat > "$cursorDir/mcp.json" << EOF
{
  "mcpServers": [
    {
      "name": "NexaBase MCP",
      "type": "sse",
      "url": "$instanceUrl/mcp/sse",
      "headers": {
        "X-API-Key": "$apiKey"
      }
    }
  ]
}
EOF
    echo -e "${GREEN}   ✅ Archivo creado: .cursor/mcp.json${NC}"
}

# Función para configurar VS Code
configure_vscode() {
    echo -e ""
    echo -e "${GREEN}📝 Configurando VS Code...${NC}"

    vscodeDir="$projectRoot/.vscode"
    if [ ! -d "$vscodeDir" ]; then
        mkdir -p "$vscodeDir"
    fi

    cat > "$vscodeDir/mcp.json" << EOF
{
  "mcpServers": [
    {
      "name": "NexaBase MCP",
      "type": "sse",
      "url": "$instanceUrl/mcp/sse",
      "headers": {
        "X-API-Key": "$apiKey"
      }
    }
  ]
}
EOF
    echo -e "${GREEN}   ✅ Archivo creado: .vscode/mcp.json${NC}"
}

# Ejecutar configuración según elección
case $editorChoice in
    "1")
        configure_trae
        ;;
    "2")
        configure_antigravity
        ;;
    "3")
        configure_cursor
        ;;
    "4")
        configure_vscode
        ;;
    "5")
        configure_trae
        configure_antigravity
        configure_cursor
        configure_vscode
        ;;
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac

# Crear README
echo -e ""
echo -e "${YELLOW}📖 Creando README...${NC}"

currentDate=$(date +"%Y-%m-%d %H:%M:%S")
environmentName=$([ "$1" = "--local" ] && echo "LOCAL" || echo "PRODUCCIÓN")

cat > "MCP_CONFIGURADO.md" << EOF
# ✅ MCP Configurado - NexaBase

## Configuración Completada

- **Ambiente:** $environmentName
- **Instancia:** $instanceUrl
- **Editores:** $(if [ "$editorChoice" = "5" ]; then echo "Todos"; else echo "$editorChoice"; fi)
- **Fecha:** $currentDate
- **Soporte:** soporte@nexabase.online

## Siguientes Pasos

1. **Reinicia tu editor**
2. **Prueba la conexión:**
   - Abre el chat de IA
   - Escribe: "Lista las colecciones de NexaBase"
3. **¡Comienza a desarrollar!**

## Herramientas Disponibles: 39

- Colecciones: 9
- Workflows: 7
- Hooks: 4
- Funciones: 5
- Storage: 4
- Vector Store: 3
- Usuarios: 5
- Adicionales: 2

## ¿Problemas?

- **Email:** soporte@nexabase.online
- **Dashboard:** $instanceUrl/dashboard
- **Documentación:** $instanceUrl/docs
EOF

echo -e "${GREEN}   ✅ Archivo creado: MCP_CONFIGURADO.md${NC}"

# Guardar API Key (opcional)
echo -e ""
echo -e "${YELLOW}🔒 ¿Guardar API Key en archivo para futuras configuraciones?${NC}"
echo -e "${YELLOW}   ⚠️  ¡No compartas este archivo!${NC}"
read -p "   (s/n): " saveToken

if [ "$saveToken" = "s" ] || [ "$saveToken" = "S" ]; then
    echo "$apiKey" > "nexabase-apikey.txt"
    chmod 600 "nexabase-apikey.txt"
    echo -e "${GREEN}   ✅ API Key guardado en: nexabase-apikey.txt${NC}"
    echo -e "${YELLOW}   ⚠️  ¡No compartas este archivo!${NC}"
fi

# Resumen final
echo -e ""
echo -e "${CYAN}🎉 ¡Configuración Completada!${NC}"
echo -e "${CYAN}==============================================${NC}"
echo -e ""
echo -e "${WHITE}📋 Resumen:${NC}"
echo -e "${GREEN}   ✅ Ambiente: $environmentName${NC}"
echo -e "${GREEN}   ✅ Instancia: $instanceUrl${NC}"
echo -e "${GREEN}   ✅ Editores configurados: $(if [ "$editorChoice" = "5" ]; then echo "Todos"; else echo "$editorChoice"; fi)${NC}"
echo -e "${GREEN}   ✅ Archivos creados${NC}"
echo -e ""
echo -e "${WHITE}🚀 Siguientes pasos:${NC}"
if [ "$1" = "--local" ]; then
    echo -e "${YELLOW}   1. Asegúrate de que el backend esté corriendo: bun run start:dev${NC}"
fi
echo -e "${YELLOW}   2. Reinicia tu editor${NC}"
echo -e "${YELLOW}   3. Abre el chat de IA${NC}"
echo -e "${YELLOW}   4. Escribe: 'Lista las colecciones de NexaBase'${NC}"
echo -e ""
echo -e "${GRAY}📚 Documentación: docs/CLIENTE_GUIA_CONEXION_MCP.md${NC}"
echo -e "${GRAY}💬 Soporte: soporte@nexabase.online${NC}"
echo -e ""
