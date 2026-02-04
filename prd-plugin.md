<aside>
⚡ **PROPOSED SOLUTION**

# Requerimiento: Ambiente de Desarrollo con Claude Code para Manzana Verde

> Fecha: 30 de Enero 2026
> 
> 
> **Para:** Tech Lead
> 
> **De:** Equipo de Producto
> 
> **Prioridad:** Alta
> 

---

## 1. Objetivo

Crear un ambiente estandarizado de desarrollo con **Claude Code** que permita a **cualquier persona de MV** (técnica o no técnica) desarrollar funcionalidades de forma segura, consistente y alineada con nuestros estándares, sin romper lo que ya existe.

**Meta:** Democratizar el desarrollo. Que alguien de Ops, Marketing o Producto pueda crear herramientas útiles sin depender 100% del equipo de desarrollo.

---

## 2. Componentes del Requerimiento

### 2.1 Plugin de Claude Code para MV

Crear un plugin/configuración que se instale en Claude Code y contenga:

### A) Hooks de Control de Calidad (Automatización)

Tareas manuales que hoy hacemos (o no hacemos) y deben ser automáticas:

| Hook | Cuándo se ejecuta | Qué hace |
| --- | --- | --- |
| **Pre-commit** | Antes de guardar cambios | Lint, formateo, detectar secrets expuestos |
| **Pre-push** | Antes de subir código | Correr tests, validar tipos TypeScript |
| **Quality Gate** | Antes de merge | Verificar cobertura mínima, build exitoso |

**Resultado:** Nadie puede subir código roto o que no cumpla estándares.

### B) Agentes IA Especializados

Cada agente tiene un rol específico y conoce las reglas de MV:

| Agente | Rol | Capacidades Clave |
| --- | --- | --- |
| **QA Agent** | Asegurar calidad | Genera tests automáticamente, valida cobertura, identifica edge cases |
| **Doc Agent** | Proveer contexto | Se conecta a Notion, busca documentación relevante, sugiere actualizaciones |
| **Backend Agent** | Desarrollo backend | Conoce nuestras APIs, puede hacer queries seguros a BD staging, sigue nuestros patrones |
| **Frontend Agent** | Desarrollo frontend | Conoce nuestro Design System, componentes, patrones de UI |
| **Mobile Agent** | Desarrollo app móvil | Conoce React Native/Expo, patrones iOS/Android, deep linking |

### C) Skills (Conocimiento Reutilizable)

Paquetes de conocimiento que los agentes consumen:

- **mv-api-consumer:** Cómo consumir nuestras APIs correctamente
- **mv-db-queries:** Cómo hacer queries seguros (solo staging)
- **mv-design-system:** Colores, tipografía, componentes
- **mv-testing:** Cómo escribir tests en nuestro stack
- **mv-deployment:** Cómo deployar a staging

---

### 2.2 Documentación en Notion

Crear/organizar en Notion las siguientes bases de datos que el Doc Agent pueda consultar:

| Base de Datos | Contenido |
| --- | --- |
| **APIs Documentation** | Todos los endpoints, request/response schemas, autenticación |
| **Design System** | Tokens de diseño, componentes, links a Figma |
| **Architecture Decisions (ADRs)** | Decisiones técnicas importantes y su contexto |
| **Project Specs** | Especificaciones de cada proyecto/feature |
| **Integraciones** | WhatsApp, Google Maps, pagos, etc. |

**Importante:** El Doc Agent necesita acceso vía Notion API para buscar esta info automáticamente.

---

### 2.3 Documento CLAUDE.md

Un archivo que se carga automáticamente en cada sesión de Claude Code con:

- **Contexto de MV:** Qué hacemos, países, modelo de negocio
- **Stack tecnológico:** Versiones exactas que usamos
- **Repositorios:** Lista de repos y qué hace cada uno
- **Reglas críticas:** Cosas que NUNCA se deben hacer (ej: queries a prod, exponer secrets)
- **Patrones obligatorios:** Estructura de respuestas API, manejo de errores, etc.
- **Contactos:** A quién preguntar por cada área

---

### 2.4 Ambiente de Staging

Configurar acceso seguro a:

| Recurso | Permisos | Notas |
| --- | --- | --- |
| **Repos de GitHub** | Push a branches, no a main directo | Lista de repos autorizados |
| **Base de Datos Staging** | Solo lectura (SELECT con LIMIT) | Nunca producción |
| **APIs de Staging** | Full access | URL diferente a prod |
| **Vercel/Preview** | Deploy automático | Cada PR genera preview |

**Repos iniciales a incluir:**

- mv-landing-pedidos (landing WhatsApp)
- mv-web-app (app web principal)
- mv-mobile-app (app móvil)
- mv-admin-panel (panel admin)

---

### 2.5 Instructivo de Uso

Documentación clara de:

1. **Cómo instalar/configurar** Claude Code con el plugin de MV
2. **Cómo empezar un desarrollo** (desde cero vs modificar existente)
3. **Cómo probar en staging** (deploy, verificar, rollback)
4. **Cómo pedir review** y mergear a producción
5. **Qué hacer si algo falla** (troubleshooting común)
6. **Ejemplos prácticos** de tareas comunes

---

## 3. Cosas que Deberías Incluir (Sugerencias Adicionales)

Estas son cosas que no mencionaste pero considero importantes:

### 3.1 Seguridad

| Item | Por qué |
| --- | --- |
| **Secrets Manager** | Las API keys no deben estar en código, usar variables de entorno centralizadas |
| **Audit Log** | Registrar quién hizo qué cambio, cuándo, en qué repo |
| **Permisos por Rol** | No todos deberían poder tocar todos los repos |
| **Scan de vulnerabilidades** | Detectar dependencias con CVEs conocidos |

### 3.2 Governance

| Item | Por qué |
| --- | --- |
| **Templates de PR** | Estructura estándar para describir cambios |
| **Checklist obligatorio** | Antes de mergear: tests pasan, docs actualizados, etc. |
| **Code owners** | Definir quién debe aprobar cambios en cada área |
| **Rollback automatizado** | Si algo falla en staging, volver atrás fácil |

### 3.3 Onboarding

| Item | Por qué |
| --- | --- |
| **Proyecto sandbox** | Un repo de práctica para que nuevos usuarios experimenten sin miedo |
| **Video tutoriales** | Complementar docs escritos con videos cortos |
| **Sesión de onboarding** | Una sesión grupal cuando se lance |
| **Canal de Slack/soporte** | Donde preguntar dudas del sistema |

### 3.5 Casos de Uso Prioritarios a Definir

Definir los primeros 3-5 casos de uso que queremos habilitar:

1. **Ops:** Crear reportes/dashboards con datos de BD
2. **Marketing:** Landing pages para campañas
3. **Producto:** Prototipos funcionales de nuevas features
4. **Soporte:** Herramientas internas de consulta
5. **Ventas:** Calculadoras, simuladores de planes

---

## 4. Entregables Esperados

| # | Entregable | Descripción |
| --- | --- | --- |
| 1 | **Plugin Claude Code MV** | Código del plugin con hooks, agentes y skills |
| 2 | **Notion estructurado** | Bases de datos documentadas y conectables via API |
| 3 | **CLAUDE.md** | Documento de contexto global |
| 4 | **Ambiente staging** | Configurado y con accesos |
| 5 | **Instructivo** | Documentación de uso paso a paso |
| 6 | **Sesión de lanzamiento** | Capacitación al equipo |

---

## 5. Criterios de Éxito

El proyecto está completo cuando:

- [ ]  Una persona no técnica puede crear una landing page funcional siguiendo el instructivo
- [ ]  El código generado pasa todos los hooks de calidad automáticamente
- [ ]  El Doc Agent puede responder preguntas sobre nuestras APIs consultando Notion
- [ ]  Un desarrollo puede deployarse a staging sin intervención del equipo de dev
- [ ]  Hay al menos 3 personas de áreas no técnicas usando el sistema activamente
</aside>
