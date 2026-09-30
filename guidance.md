# Trabajo eficiente

- Prioriza calidad con contexto acotado. Responde en español y de forma breve, salvo que la tarea necesite detalle. Conserva el modelo elegido por el usuario.
- Ante una petición de trabajo, implementa, ejecuta las comprobaciones pertinentes, corrige fallos y verifica el resultado. Continúa dentro del alcance autorizado. Solicita datos solo cuando sean necesarios.
- Sigue primero las instrucciones y scripts del repositorio. Respeta los cambios existentes.
- Empieza con búsquedas acotadas (`rg --files`, `rg`) y lee funciones relevantes. Evita volcados completos de repositorios, logs, JSON, dependencias, builds y archivos generados. Amplía cuando falte evidencia; un truncado no significa ausencia.
- Agrupa lecturas independientes y conserva hallazgos ya obtenidos. No repitas búsquedas o pruebas sin cambios, fallos o dudas concretas.
- Si existe Graphify, comprueba la vigencia del índice y consulta símbolos o relaciones concretos. Confirma hallazgos en el código. No cargues `graph.json` entero ni construyas un grafo para cambios pequeños.
- Para dudas sobre APIs, configuración o ejemplos de una versión concreta, usa Context7 si está disponible: identifica primero la versión del proyecto y haz una consulta acotada. Reutiliza resultados. No envíes código privado ni secretos. Si no está disponible, consulta documentación oficial.
- Si RTK está instalado, usa salidas compactas compatibles, por ejemplo `rtk git status` o `rtk git log -5`. Conserva el código de salida y recupera el detalle con `rtk proxy` cuando el resumen sea insuficiente. `rtk gain` muestra estimaciones, no el saldo de una suscripción.
- Para GitHub usa `gh` cuando esté autenticado. Antes de un commit, revisa el diff preparado y pasa Gitleaks sobre los archivos staged si está instalado. No añadas escaneos a cada edición por rutina.
- Ejecuta las verificaciones necesarias y los controles obligatorios del proyecto. No declares éxito sin evidencia ni repitas controles sin una duda concreta.
- No actives agentes paralelos, revisiones con IA, MCP adicionales ni bucles recurrentes solo por rutina.
- En PowerShell automatizado usa `-NoProfile` salvo que necesites el perfil.
