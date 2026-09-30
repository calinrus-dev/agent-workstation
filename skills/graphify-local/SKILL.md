---
name: graphify-local
description: Explorar dependencias e impacto entre módulos con Graphify local, o preparar el mapa de un repositorio nuevo. Úsalo para navegación transversal de código; para un cambio pequeño en un archivo conocido basta una lectura directa.
---

# Graphify local

Graphify se instala por equipo. Antes de usarlo, comprueba `graphify --version`
y que el ejecutable está en PATH. En Windows puedes localizarlo con
`Get-Command graphify`; en Linux, con `command -v graphify`.

## Integraciones existentes

Sigue primero AGENTS.md y los comandos del proyecto. Si el repositorio ya
integra Graphify mediante scripts propios, conserva sus comprobaciones de
vigencia y su entorno fijado. No sustituyas esa integración.

## Otros repositorios

- Para una exploración transversal, reutiliza un grafo vigente. Si no existe,
  prepara `.graphifyignore` respetando el contenido existente: excluye dependencias,
  builds, graphify-out, binarios, registros, documentos históricos, archivos .env,
  claves y certificados. El código del producto debe seguir incluido.
- Guarda `graphify-out/` fuera del control de versiones; en Git puedes añadir
  `/graphify-out/` a `.git/info/exclude` conservando sus otras líneas.
- Construye desde la raíz con `graphify extract . --code-only --max-workers 4`.
  Si necesitas comunidades, usa `graphify cluster-only . --no-label --no-viz`.
  Esas opciones mantienen la indexación de código local, sin llamadas a un LLM.
  No actives extracción semántica, etiquetado con IA, watch ni publicación por rutina.
- Consulta `graphify query "símbolo o relación" --budget 1800`, `explain`,
  `affected` o `path`. No cargues el JSON entero. Si la salida se trunca, acota la
  consulta; amplía el presupuesto solo si falta evidencia necesaria.
- Abre las funciones y pruebas localizadas. El grafo puede omitir relaciones
  dinámicas; distingue relaciones extraídas de inferidas y verifica en el código.
- Comprueba cambios relevantes posteriores al índice antes de confiar en él.
  Si no puedes establecer su vigencia, reconstruye con el comando local anterior
  o usa rg y lectura directa. Tras modificar código indexado, actualízalo cuando
  sea necesario para la siguiente consulta; respeta siempre los checks del repo.

En carpetas vacías, documentación sin código o cambios pequeños, usa búsqueda
acotada. No necesitas generar un grafo para cumplir esta skill.
