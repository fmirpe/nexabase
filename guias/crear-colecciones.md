# Crear Colecciones

Las **colecciones** son el corazón de NexaBase. Permiten crear tablas dinámicas con schemas personalizables sin necesidad de migraciones.

## ¿Qué es una Colección?

Una colección es una **tabla dinámica** en PostgreSQL con:
- Schema personalizado (campos, tipos, validaciones)
- Reglas de autenticación
- Índices automáticos
- Metadata y estadísticas

## Tipos de Datos Disponibles

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `string` | Texto corto (VARCHAR 255) | `"Hola"` |
| `text` | Texto largo (TEXT) | `"Lorem ipsum..."` |
| `number` | Números (INTEGER/DECIMAL) | `42`, `3.14` |
| `boolean` | Verdadero/Falso | `true`, `false` |
| `date` | Fechas (TIMESTAMP) | `"2024-01-01"` |
| `json` | Objetos JSON (JSONB) | `{"key": "value"}` |
| `email` | Emails validados | `"user@example.com"` |
| `url` | URLs validadas | `"https://example.com"` |

## Crear tu Primera Colección

### Ejemplo: Colección "Productos"

```bash
curl -X POST http://localhost:3000/api/admin/collections \
  -H "Authorization: Bearer TU_JWT_TOKEN" \
  -H "X-Tenant-ID: TU_TENANT_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "productos",
    "description": "Catálogo de productos",
    "schema": {
      "fields": {
        "nombre": {
          "type": "string",
          "required": true,
          "maxLength": 100
        },
        "descripcion": {
          "type": "text"
        },
        "precio": {
          "type": "number",
          "required": true,
          "min": 0
        },
        "stock": {
          "type": "number",
          "default": 0
        },
        "activo": {
          "type": "boolean",
          "default": true
        },
        "categoria": {
          "type": "string"
        },
        "imagen_url": {
          "type": "url"
        }
      },
      "timestamps": true,
      "indexes": ["categoria", "activo"]
    }
  }'
```

### Respuesta Exitosa

```json
{
  "id": "collection-uuid",
  "name": "productos",
  "description": "Catálogo de productos",
  "schema": { ... },
  "is_active": true,
  "record_count": 0,
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

## Schema Avanzado

### Validaciones

```json
{
  "fields": {
    "email": {
      "type": "email",
      "required": true,
      "unique": true
    },
    "edad": {
      "type": "number",
      "min": 18,
      "max": 100
    },
    "nombre": {
      "type": "string",
      "required": true,
      "minLength": 2,
      "maxLength": 50
    },
    "website": {
      "type": "url"
    },
    "metadata": {
      "type": "json",
      "default": {}
    }
  }
}
```

### Valores por Defecto

```json
{
  "fields": {
    "estado": {
      "type": "string",
      "default": "pendiente"
    },
    "activo": {
      "type": "boolean",
      "default": true
    },
    "contador": {
      "type": "number",
      "default": 0
    },
    "creado": {
      "type": "date",
      "default": "now()"
    }
  }
}
```

### Índices

```json
{
  "fields": { ... },
  "indexes": [
    "campo_simple",
    ["campo1", "campo2"],
    {"fields": ["precio"], "order": "DESC"}
  ]
}
```

## Colecciones con Timestamps

```json
{
  "fields": {
    "nombre": { "type": "string" }
  },
  "timestamps": true
}
```

**Automáticamente agrega:**
- `created_at` - Fecha de creación
- `updated_at` - Fecha de última actualización

## Listar Colecciones

```bash
curl -X GET http://localhost:3000/api/admin/collections \
  -H "Authorization: Bearer TU_TOKEN"
```

**Respuesta:**

```json
[
  {
    "id": "uuid-1",
    "name": "productos",
    "record_count": 150,
    "created_at": "2024-01-01T00:00:00Z"
  },
  {
    "id": "uuid-2",
    "name": "clientes",
    "record_count": 500,
    "created_at": "2024-01-02T00:00:00Z"
  }
]
```

## Obtener Schema de una Colección

```bash
curl -X GET http://localhost:3000/api/admin/collections/productos/schema \
  -H "Authorization: Bearer TU_TOKEN"
```

## Actualizar Colección

```bash
curl -X PUT http://localhost:3000/api/admin/collections/productos \
  -H "Authorization: Bearer TU_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "schema": {
      "fields": {
        "nombre": { "type": "string", "required": true },
        "precio": { "type": "number" },
        "nuevo_campo": { "type": "string", "default": "valor" }
      }
    }
  }'
```

## Eliminar Colección

```bash
curl -X DELETE http://localhost:3000/api/admin/collections/productos \
  -H "Authorization: Bearer TU_TOKEN"
```

⚠️ **Advertencia:** Esto elimina la tabla y todos los datos permanentemente.

## Ejemplos de Colecciones Comunes

### Clientes

```json
{
  "name": "clientes",
  "schema": {
    "fields": {
      "nombre": { "type": "string", "required": true },
      "email": { "type": "email", "required": true, "unique": true },
      "telefono": { "type": "string" },
      "direccion": { "type": "text" },
      "fecha_nacimiento": { "type": "date" },
      "activo": { "type": "boolean", "default": true }
    },
    "timestamps": true
  }
}
```

### Pedidos

```json
{
  "name": "pedidos",
  "schema": {
    "fields": {
      "numero_pedido": { "type": "string", "required": true, "unique": true },
      "cliente_id": { "type": "string", "required": true },
      "total": { "type": "number", "required": true },
      "estado": { "type": "string", "default": "pendiente" },
      "fecha_envio": { "type": "date" },
      "direccion_envio": { "type": "text" }
    },
    "timestamps": true
  }
}
```

### Artículos de Blog

```json
{
  "name": "articulos",
  "schema": {
    "fields": {
      "titulo": { "type": "string", "required": true },
      "slug": { "type": "string", "required": true, "unique": true },
      "contenido": { "type": "text", "required": true },
      "autor_id": { "type": "string" },
      "categoria": { "type": "string" },
      "tags": { "type": "json" },
      "publicado": { "type": "boolean", "default": false },
      "fecha_publicacion": { "type": "date" },
      "imagen_portada": { "type": "url" }
    },
    "timestamps": true
  }
}
```

## Mejores Prácticas

### Nombres

✅ **Haz:**
- Usa minúsculas: `productos`, `clientes`
- Usa plural: `productos` (no `producto`)
- Snake case: `detalles_pedido`

❌ **No hagas:**
- Mayúsculas: `Productos`
- Singular: `producto`
- Espacios: `productos del hogar`

### Campos

✅ **Haz:**
- Usa `required: true` para campos obligatorios
- Agrega índices en campos de búsqueda frecuente
- Usa tipos específicos (`email`, `url`) para validación automática

❌ **No hagas:**
- Campos sin tipo definido
- Demasiados índices (ralentiza writes)
- Nombres de campos en mayúsculas

### Rendimiento

- **Índices:** Agrega índices en campos usados en WHERE, ORDER BY, JOIN
- **Límites:** Colecciones con >1M de registros pueden necesitar optimización
- **JSON:** Usa campos JSON para datos opcionales o variables

## Límites por Plan

| Plan | Colecciones | Campos por colección | Registros |
|------|-------------|---------------------|-----------|
| Free | 5 | 20 | 1,000 |
| Starter | 20 | 50 | 10,000 |
| Professional | 100 | 100 | 100,000 |
| Enterprise | Ilimitado | Ilimitado | Ilimitado |

## Solución de Problemas

### Error: "Collection already exists"

La colección ya existe. Usa otro nombre o elimina la existente primero.

### Error: "Invalid schema"

Verifica que:
- Todos los campos tengan `type` definido
- Los tipos sean válidos
- Las validaciones sean correctas

### Error: "Tenant not found"

Asegúrate de incluir el header `X-Tenant-ID` o que tu API Key esté asociada a un tenant.

---

**Recursos Relacionados:**

- [CRUD de Registros](./crud-registros.md)
- [Relaciones](./relaciones.md)
- [Validaciones](./validaciones.md)
- [Índices](./indices.md)
