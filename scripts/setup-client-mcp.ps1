# NexaBase MCP Setup Script para Clientes
# Uso: .\setup-client-mcp.ps1
# Soporte: soporte@nexabase.online

Write-Host "🚀 Configuración de NexaBase MCP para Clientes" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   NexaBase - Backend as a Service" -ForegroundColor White
Write-Host "   URL: https://api.nexabase.online" -ForegroundColor Gray
Write-Host "   Dashboard: https://dashboard.nexabase.online" -ForegroundColor Gray
Write-Host "   Soporte: soporte@nexabase.online" -ForegroundColor Gray
Write-Host ""

# Paso 1: Pedir API Key
Write-Host "📝 Paso 1: Ingresa tu API Key de NexaBase" -ForegroundColor Yellow
Write-Host "   (Lo obtienes en https://dashboard.nexabase.online/apikeys)" -ForegroundColor Gray
Write-Host "   ⚠️  Comienza con 'nxb_...'" -ForegroundColor Gray
$apiKey = Read-Host "   API Key"

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "❌ Error: API Key es requerido" -ForegroundColor Red
    exit 1
}

# Validar formato
if (-not $apiKey.StartsWith("nxb_")) {
    Write-Host "⚠️  Advertencia: La API Key debería comenzar con 'nxb_'" -ForegroundColor Yellow
    $continue = Read-Host "   ¿Continuar de todos modos? (s/n)"
    if ($continue -ne "s" -and $continue -ne "S") {
        exit 1
    }
}

# Paso 2: Pedir URL de instancia
Write-Host ""
Write-Host "🌐 Paso 2: URL de tu instancia NexaBase" -ForegroundColor Yellow
Write-Host "   (Por defecto: https://api.nexabase.online)" -ForegroundColor Gray
$instanceUrl = Read-Host "   URL [https://api.nexabase.online]"

if ([string]::IsNullOrWhiteSpace($instanceUrl)) {
    $instanceUrl = "https://api.nexabase.online"
}

# Limpiar URL (quitar trailing slash)
$instanceUrl = $instanceUrl.TrimEnd('/')

# Paso 3: Elegir editor
Write-Host ""
Write-Host "🛠️  Paso 3: ¿Qué editor usas?" -ForegroundColor Yellow
Write-Host "   1. Trae IDE" -ForegroundColor White
Write-Host "   2. Antigravity" -ForegroundColor White
Write-Host "   3. Cursor IDE" -ForegroundColor White
Write-Host "   4. VS Code" -ForegroundColor White
Write-Host "   5. Todos" -ForegroundColor White

$editorChoice = Read-Host "   Elige una opción (1-5)"

# Crear directorios
$projectRoot = Get-Location

# Función para configurar Trae
function Configure-Trae {
    Write-Host ""
    Write-Host "🚀 Configurando Trae IDE..." -ForegroundColor Green

    $traeDir = Join-Path $projectRoot ".trae"
    if (!(Test-Path $traeDir)) {
        New-Item -ItemType Directory -Path $traeDir | Out-Null
    }

    $config = @{
        mcpServers = @(
            @{
                name = "NexaBase MCP"
                type = "sse"
                url = "$instanceUrl/mcp/sse"
                headers = @{
                    "X-API-Key" = $apiKey
                }
                enabled = $true
            }
        )
    }

    $config | ConvertTo-Json -Depth 10 | Out-File (Join-Path $traeDir "mcp.json") -Encoding UTF8
    Write-Host "   ✅ Archivo creado: .trae/mcp.json" -ForegroundColor Green
}

# Función para configurar Antigravity (ubicación global)
function Configure-Antigravity {
    Write-Host ""
    Write-Host "🦅 Configurando Antigravity (global)..." -ForegroundColor Green

    $antigravityGlobalDir = Join-Path $env:USERPROFILE ".gemini\antigravity"
    if (!(Test-Path $antigravityGlobalDir)) {
        New-Item -ItemType Directory -Path $antigravityGlobalDir | Out-Null
    }

    $antigravityGlobalPath = Join-Path $antigravityGlobalDir "mcp_config.json"

    # Leer configuración existente si hay
    $existingConfig = @{ mcpServers = @{} }
    if (Test-Path $antigravityGlobalPath) {
        try {
            $existingConfig = Get-Content $antigravityGlobalPath -Raw | ConvertFrom-Json
            if (-not $existingConfig.mcpServers) {
                $existingConfig.mcpServers = @{}
            }
        } catch {
            Write-Host "   ⚠️  No se pudo leer configuración existente, se creará nueva" -ForegroundColor Yellow
        }
    }

    # Agregar NexaBase manteniendo otros MCPs
    # Antigravity requiere "serverURL" (no "url")
    $existingConfig.mcpServers.nexabase = @{
        serverURL = "$instanceUrl/mcp/sse"
        headers = @{
            "X-API-Key" = $apiKey
        }
    }

    # Escribir JSON con formato correcto (sin BOM)
    $jsonContent = $existingConfig | ConvertTo-Json -Depth 10
    
    # Usar [System.IO.File]::WriteAllText para evitar BOM
    [System.IO.File]::WriteAllText($antigravityGlobalPath, $jsonContent, [System.Text.UTF8Encoding]::new($false))
    
    Write-Host "   📁 Archivo actualizado: $antigravityGlobalPath" -ForegroundColor Green
    Write-Host "✅ Antigravity configurado (global)" -ForegroundColor Green
}

# Función para configurar Cursor
function Configure-Cursor {
    Write-Host ""
    Write-Host "📟 Configurando Cursor IDE..." -ForegroundColor Green

    $cursorDir = Join-Path $projectRoot ".cursor"
    if (!(Test-Path $cursorDir)) {
        New-Item -ItemType Directory -Path $cursorDir | Out-Null
    }

    $config = @{
        servers = @(
            @{
                name = "NexaBase MCP"
                type = "sse"
                url = "$instanceUrl/mcp/sse"
                headers = @{
                    "X-API-Key" = $apiKey
                }
            }
        )
    }

    $config | ConvertTo-Json -Depth 10 | Out-File (Join-Path $cursorDir "mcp.json") -Encoding UTF8
    Write-Host "   ✅ Archivo creado: .cursor/mcp.json" -ForegroundColor Green
}

# Función para configurar VS Code
function Configure-VSCode {
    Write-Host ""
    Write-Host "📝 Configurando VS Code..." -ForegroundColor Green

    $vscodeDir = Join-Path $projectRoot ".vscode"
    if (!(Test-Path $vscodeDir)) {
        New-Item -ItemType Directory -Path $vscodeDir | Out-Null
    }

    $config = @{
        servers = @(
            @{
                name = "NexaBase MCP"
                type = "sse"
                url = "$instanceUrl/mcp/sse"
                headers = @{
                    "X-API-Key" = $apiKey
                }
            }
        )
    }

    $config | ConvertTo-Json -Depth 10 | Out-File (Join-Path $vscodeDir "mcp.json") -Encoding UTF8
    Write-Host "   ✅ Archivo creado: .vscode/mcp.json" -ForegroundColor Green
}

# Ejecutar configuración según elección
switch ($editorChoice) {
    "1" { Configure-Trae }
    "2" { Configure-Antigravity }
    "3" { Configure-Cursor }
    "4" { Configure-VSCode }
    "5" {
        Configure-Trae
        Configure-Antigravity
        Configure-Cursor
        Configure-VSCode
    }
    default {
        Write-Host "❌ Opción inválida" -ForegroundColor Red
        exit 1
    }
}

# Crear README
Write-Host ""
Write-Host "📖 Creando README..." -ForegroundColor Yellow

$readme = @"
# ✅ MCP Configurado - NexaBase

<img src="https://api.nexabase.online/logo.png" alt="NexaBase Logo" width="150"/>

## Configuración Completada

- **Instancia:** $instanceUrl
- **Editores:** $(if ($editorChoice -eq "5") { "Todos" } else { $editorChoice })
- **Fecha:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
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
"@

$readme | Out-File "MCP_CONFIGURADO.md" -Encoding UTF8
Write-Host "   ✅ Archivo creado: MCP_CONFIGURADO.md" -ForegroundColor Green

# Guardar API Key (opcional)
Write-Host ""
Write-Host "🔒 ¿Guardar API Key en archivo para futuras configuraciones?" -ForegroundColor Yellow
Write-Host "   ⚠️  ¡No compartas este archivo!" -ForegroundColor Yellow
$saveToken = Read-Host "   (s/n)"

if ($saveToken -eq "s" -or $saveToken -eq "S") {
    $apiKey | Out-File "nexabase-apikey.txt" -Encoding UTF8
    Write-Host "   ✅ API Key guardado en: nexabase-apikey.txt" -ForegroundColor Green
    Write-Host "   ⚠️  ¡No compartas este archivo!" -ForegroundColor Yellow
}

# Resumen final
Write-Host ""
Write-Host "🎉 ¡Configuración Completada!" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Resumen:" -ForegroundColor White
Write-Host "   ✅ Instancia: $instanceUrl" -ForegroundColor Green
Write-Host "   ✅ Editores configurados: $(if ($editorChoice -eq "5") { "Todos" } else { $editorChoice })" -ForegroundColor Green
Write-Host "   ✅ Archivos creados" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Siguientes pasos:" -ForegroundColor White
Write-Host "   1. Reinicia tu editor" -ForegroundColor Yellow
Write-Host "   2. Abre el chat de IA" -ForegroundColor Yellow
Write-Host "   3. Escribe: 'Lista las colecciones de NexaBase'" -ForegroundColor Yellow
Write-Host ""
Write-Host "📚 Documentación: docs/CLIENTE_GUIA_CONEXION_MCP.md" -ForegroundColor Gray
Write-Host "💬 Soporte: soporte@nexabase.online" -ForegroundColor Gray
Write-Host ""
