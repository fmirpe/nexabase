#!/bin/bash
# NexaBase MCP Setup Script para Clientes (Linux/macOS)
# Uso: ./setup-client-mcp.sh

# Colores
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}🚀 Configuración de NexaBase MCP para Clientes${NC}"
echo -e "${CYAN}==============================================${NC}"
echo -e ""
echo -e "${WHITE}   NexaBase - Backend as a Service${NC}"
echo -e "${GRAY}   URL: https://api.nexabase.online${NC}"
echo -e "${GRAY}   Dashboard: https://dashboard.nexabase.online${NC}"
echo -e "${GRAY}   Soporte: soporte@nexabase.online${NC}"
echo -e ""

# Paso 1: Pedir API Key
echo -e "${YELLOW}📝 Paso 1: Ingresa tu API Key de NexaBase${NC}"
echo -e "${GRAY}   (Lo obtienes en https://dashboard.nexabase.online/apikeys)${NC}"
echo -e "${GRAY}   ⚠️  Comienza con 'nxb_...'${NC}"
read -p "   API Key: " apiKey

if [ -z "$apiKey" ]; then
    echo -e "${RED}❌ Error: API Key es requerido${NC}"
    exit 1
fi

# Validar formato
if [[ ! $apiKey =~ ^nxb_ ]]; then
    echo -e "${YELLOW}⚠️  Advertencia: La API Key debería comenzar con 'nxb_'${NC}"
    read -p "   ¿Continuar de todos modos? (s/n): " continue
    if [ "$continue" != "s" ] && [ "$continue" != "S" ]; then
        exit 1
    }
fi

# Paso 2: Pedir URL de instancia
echo -e ""
echo -e "${YELLOW}🌐 Paso 2: URL de tu instancia NexaBase${NC}"
echo -e "${GRAY}   (Por defecto: https://api.nexabase.online)${NC}"
read -p "   URL [https://api.nexabase.online]: " instanceUrl

if [ -z "$instanceUrl" ]; then
    instanceUrl="https://api.nexabase.online"
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
      "url": "$instanceUrl/mcp/sse",
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

# Función para configurar Antigravity
configure_antigravity() {
    echo -e ""
    echo -e "${GREEN}🦅 Configurando Antigravity...${NC}"

    antigravityDir="$projectRoot/.antigravity"
    if [ ! -d "$antigravityDir" ]; then
        mkdir -p "$antigravityDir"
    fi

    cat > "$antigravityDir/mcp-config.json" << EOF
{
  "version": "1.0",
  "mcpServers": {
    "nexabase": {
      "enabled": true,
      "type": "sse",
      "url": "$instanceUrl/mcp/sse",
      "headers": {
        "X-API-Key": "$apiKey"
      }
    }
  }
}
EOF
    echo -e "${GREEN}   ✅ Archivo creado: .antigravity/mcp-config.json${NC}"
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
  "servers": [
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
  "servers": [
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

cat > "MCP_CONFIGURADO.md" << EOF
# ✅ MCP Configurado - NexaBase

## Configuración Completada

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
echo -e "${GREEN}   ✅ Instancia: $instanceUrl${NC}"
echo -e "${GREEN}   ✅ Editores configurados: $(if [ "$editorChoice" = "5" ]; then echo "Todos"; else echo "$editorChoice"; fi)${NC}"
echo -e "${GREEN}   ✅ Archivos creados${NC}"
echo -e ""
echo -e "${WHITE}🚀 Siguientes pasos:${NC}"
echo -e "${YELLOW}   1. Reinicia tu editor${NC}"
echo -e "${YELLOW}   2. Abre el chat de IA${NC}"
echo -e "${YELLOW}   3. Escribe: 'Lista las colecciones de NexaBase'${NC}"
echo -e ""
echo -e "${GRAY}📚 Documentación: docs/CLIENTE_GUIA_CONEXION_MCP.md${NC}"
echo -e "${GRAY}💬 Soporte: soporte@nexabase.online${NC}"
echo -e ""
