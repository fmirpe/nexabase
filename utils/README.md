# 🛠️ Utilidades y Scripts de NexaBase

En esta carpeta encontrarás scripts y utilidades adicionales para trabajar con NexaBase.

---

## 📦 Scripts Disponibles

### **1. Setup MCP** ⭐

Configuración automática de MCP para tu editor.

| Script | Sistema | Descripción |
|--------|---------|-------------|
| `setup-client-mcp.ps1` | Windows | Configuración con PowerShell |
| `setup-client-mcp.sh` | macOS/Linux | Configuración con Bash |

**Uso:**
```bash
# Windows
.\setup-client-mcp.ps1

# macOS/Linux
./setup-client-mcp.sh
```

---

### **2. Generar Token** (Próximamente)

Genera tokens de prueba para desarrollo.

```bash
# Próximamente
bun run generate-token.ts
```

---

### **3. Backup de Colecciones** (Próximamente)

Exporta colecciones completas a JSON.

```bash
# Próximamente
bun run backup-collection.ts --collection=usuarios --output=./backup.json
```

---

### **4. Migración de Datos** (Próximamente)

Importa datos desde CSV/JSON a colecciones.

```bash
# Próximamente
bun run migrate-data.ts --input=./datos.csv --collection=productos
```

---

### **5. Limpieza de Datos** (Próximamente)

Elimina registros duplicados o huérfanos.

```bash
# Próximamente
bun run cleanup-data.ts --collection=logs --older-than=30d
```

---

## 🔧 Utilidades de Desarrollo

### **Health Check** (Próximamente)

Verifica el estado de tu instancia NexaBase.

```bash
# Próximamente
bun run health-check.ts --url=https://api.nexabase.online
```

**Output:**
```
✅ API: OK
✅ Database: OK
✅ MCP: OK
✅ Storage: OK
```

---

### **Seed de Datos** (Próximamente)

Genera datos de prueba para desarrollo.

```bash
# Próximamente
bun run seed-data.ts --collections=usuarios,productos --count=100
```

---

## 📝 Scripts Personalizados

### **Crear tu Propio Script**

1. Clona el repositorio
2. Crea una carpeta con el nombre de tu script
3. Agrega un `README.md` explicando qué hace
4. Envía un pull request

**Estructura:**
```
utils/
  └── mi-script/
      ├── index.ts
      ├── README.md
      └── package.json
```

---

## 🚀 Contribuir

¿Creaste una utilidad útil? ¡Compártela!

1. Fork del repositorio
2. Crea tu rama (`git checkout -b feature/mi-utilidad`)
3. Commit de cambios (`git commit -m 'Add mi-utilidad'`)
4. Push a la rama (`git push origin feature/mi-utilidad`)
5. Abre un Pull Request

---

## 📞 Soporte

- **Email:** soporte@nexabase.online
- **GitHub:** https://github.com/fmirpe/nexabase
- **Discord:** https://discord.gg/nexabase

---

<div align="center">

**¿Tienes una idea para una utilidad?** [¡Ábrela en Issues!](https://github.com/fmirpe/nexabase/issues)

</div>
