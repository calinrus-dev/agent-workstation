# Proyectos entre Windows y CachyOS

`clone-projects-linux.sh` enumera los repositorios no archivados de la cuenta autenticada con GitHub CLI y los clona en una carpeta por repositorio. Si existe la rama `sync/cachyos-2026-09-30`, la abre automáticamente. La carpeta de configuración `agent-workstation` se omite porque ya se ha clonado para ejecutar el script.

El script no sobreescribe carpetas existentes ni descarga cambios en ellas. Si un proyecto nuevo aparece más adelante en GitHub, vuelve a ejecutarlo; los ya clonados se saltan. Para elegir otro lote de ramas de sincronización, define `SYNC_BRANCH` antes de ejecutarlo.

## Rutina diaria

En el proyecto donde vayas a trabajar:

```bash
git status --short
git pull --ff-only
# Edita y ejecuta las verificaciones del proyecto.
git add -p
git diff --cached
git commit -m "Describe el cambio"
git push
```

Termina con el `push` antes de arrancar el otro sistema. Allí empieza con `git pull --ff-only`. Los cambios sin commit, los archivos ignorados, la caché, las credenciales y los builds locales no viajan con Git. Configura secretos y dependencias por máquina usando los ejemplos y la documentación de cada proyecto.

Las ramas `sync/cachyos-2026-09-30` son copias privadas del estado de trabajo que había en Windows al preparar la migración. No equivalen a una entrega probada ni se fusionan automáticamente con `main`. Algunos proyectos solo pueden compilarse o probarse por completo en Windows; en Linux puedes trabajar en el código compartido y ejecutar las verificaciones que admita cada stack.
