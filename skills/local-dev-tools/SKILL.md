---
name: local-dev-tools
description: Usar las herramientas locales de GitHub, busqueda estructural y deteccion de secretos al preparar un commit, trabajar con PR o buscar patrones de codigo que una busqueda textual no resuelve bien.
---

# Herramientas locales

Instala ast-grep, gh y Gitleaks en cada sistema cuando los necesites. Comprueba
los ejecutables con `Get-Command` en PowerShell o `command -v` en Linux.

## Buscar por estructura

Para formas sintacticas (llamadas, componentes, imports), consulta la ayuda de
`ast-grep run`. Ejemplo PowerShell: `ast-grep run --lang ts --pattern 'console.log($$$ARGS)' src`.
Usa comillas simples para que PowerShell no expanda los metavariables.
Acota carpetas y lenguaje; para texto literal usa rg. No apliques reescrituras masivas
sin revisar sus coincidencias. Verifica los cambios con las herramientas del proyecto.

## Preparar cambios de Git

- Inspecciona el diff propio y conserva cambios ajenos. No hagas commit, push o
  publicaciones solo porque la herramienta este instalada: sigue la peticion concreta.
- Al preparar un commit, si hay contenido staged, ejecuta
  `gitleaks git --pre-commit --staged --redact --no-banner` desde la raiz.
  El codigo 1 indica hallazgos; otros errores no equivalen a un escaneo limpio.
  No imprimas secretos ni desactives reglas para conseguir una salida verde.
- Respeta hooks y verificaciones locales. No anadas hooks Git globales que los sustituyan.
- Usa `gh auth status` cuando necesites GitHub; si falta una sesion, solicita al usuario
  autenticarse con `gh auth login`. Nunca copies credenciales de otras aplicaciones.
- Para PR y CI, consulta solo el diff, checks y logs relevantes. No lances sondeos o
  revisiones con IA de forma recurrente sin que la tarea lo requiera.

Los alias de shell como `cproj`, `groot` o `agide` son ajustes locales del perfil;
no los presupongas en otra máquina.
