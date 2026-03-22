# 🤝 Contribuyendo a NexaBase MCP Client Kit

¡Gracias por tu interés en contribuir! Esta guía te ayudará a participar en el proyecto.

---

## 📋 ¿Cómo Puedo Contribuir?

### **1. Reportando Bugs** 🐛

Encuentra un error? Abre un issue con:

- Descripción clara del problema
- Pasos para reproducir
- Comportamiento esperado vs. real
- Capturas de pantalla (si aplica)
- Versión de tu editor y sistema operativo

### **2. Sugiriendo Mejoras** 💡

¿Tienes una idea? Abre un issue con:

- Descripción de la mejora
- Por qué sería útil
- Casos de uso
- Ejemplos (si aplica)

### **3. Agregando Ejemplos** 📝

¿Usas MCP en tu proyecto? Comparte tu experiencia:

- Crea un archivo en `examples/`
- Explica el caso de uso
- Incluye código de ejemplo
- Agrega instrucciones de uso

### **4. Creando Utilidades** 🛠️

¿Desarrollaste un script útil?

- Crea una carpeta en `utils/`
- Documenta qué hace
- Incluye instrucciones de uso
- Agrega tests (si aplica)

### **5. Mejorando Documentación** 📚

¿Encontraste algo confuso?

- Corrige errores ortográficos
- Mejora explicaciones confusas
- Agrega ejemplos faltantes
- Traduce a otros idiomas

---

## 🚀 Primeros Pasos

### **1. Fork del Repositorio**

```bash
# Haz click en "Fork" en GitHub
# O usa la CLI:
gh repo fork fmirpe/nexabase
```

### **2. Clona tu Fork**

```bash
git clone https://github.com/TU-USUARIO/nexabase.git
cd nexabase
```

### **3. Crea una Rama**

```bash
git checkout -b feature/mi-contribucion
```

### **4. Realiza tus Cambios**

```bash
# Edita los archivos
# Agrega tests si corresponde
```

### **5. Commit**

```bash
git add .
git commit -m "feat: agrega mi contribución"
```

**Formato de commits:**
- `feat:` nueva funcionalidad
- `fix:` corrección de bugs
- `docs:` cambios en documentación
- `style:` formato, sin cambios de lógica
- `refactor:` refactorización
- `test:` tests
- `chore:` mantenimiento

### **6. Push**

```bash
git push origin feature/mi-contribucion
```

### **7. Pull Request**

Ve a GitHub y abre un Pull Request:
- Describe tus cambios
- Referencia issues relacionados
- Agrega screenshots si corresponde

---

## 📐 Estándares de Código

### **Scripts (PowerShell/Bash)**

- Usa nombres descriptivos
- Comenta secciones complejas
- Maneja errores
- Usa colores para mejor UX

**Ejemplo Bash:**
```bash
#!/bin/bash
# Descripción del script
# Uso: ./script.sh [opciones]

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}✅ Éxito${NC}"
```

### **Documentación**

- Usa Markdown
- Sé claro y conciso
- Incluye ejemplos
- Agrega enlaces relevantes

---

## 🧪 Testing

Antes de enviar tu PR:

1. **Prueba tus cambios**
   - Ejecuta los scripts en diferentes sistemas
   - Verifica que la configuración funcione

2. **Verifica compatibilidad**
   - Windows (PowerShell)
   - macOS (Bash)
   - Linux (Bash)

3. **Actualiza documentación**
   - Si cambias funcionalidad, actualiza docs
   - Agrega ejemplos si corresponde

---

## 📝 Checklist para PR

Antes de enviar tu Pull Request:

- [ ] El código funciona correctamente
- [ ] Los tests pasan (si aplica)
- [ ] La documentación está actualizada
- [ ] Los commits siguen el formato
- [ ] No hay información sensible (tokens, passwords)
- [ ] El código está comentado (si es complejo)

---

## 🎯 Áreas que Necesitan Ayuda

### **Prioridad Alta** 🔴

- [ ] Tests automatizados para scripts
- [ ] Soporte para más editores (Sublime, Atom)
- [ ] Traducciones (Inglés, Portugués)

### **Prioridad Media** 🟡

- [ ] Más ejemplos de casos de uso
- [ ] Videos tutoriales
- [ ] Integración con CI/CD

### **Prioridad Baja** 🟢

- [ ] Mejoras de UI en scripts
- [ ] Animaciones en documentación
- [ ] Merchandising

---

## 🏆 Reconocimientos

Los contribuidores serán reconocidos en:

- `CONTRIBUTORS.md` - Lista de contribuidores
- README.md - Badge de contribuidor
- Releases - Mención en notas de versión

---

## 📞 Contacto

¿Tienes dudas?

- **Discord:** https://discord.gg/nexabase
- **Email:** soporte@nexabase.online
- **Issues:** https://github.com/fmirpe/nexabase/issues

---

## 🙏 Gracias

¡Gracias por contribuir a hacer de NexaBase una mejor plataforma para todos!

<div align="center">

**Hecho con ❤️ por la comunidad de NexaBase**

[Ver Contribuidores](CONTRIBUTORS.md)

</div>
