# Configuración de trabajo entre Windows y CachyOS

Repositorio personal para Codex, Claude Code y Google Antigravity. Contiene instrucciones, preferencias y dos skills propias. **No contiene sesiones, claves ni cachés**.

La idea es sencilla: este repositorio guarda las reglas y las preferencias compartidas; cada aplicación mantiene en cada equipo su sesión, los permisos y los ajustes que dependen del sistema. Hay un instalador repetible por sistema y una comprobación automática de sintaxis y arranque aislado.

## En CachyOS

Instala primero Git, Codex, Claude Code y Antigravity según sus canales oficiales. Para RTK instala el binario de [Rust Token Killer](https://github.com/TokenFleet-AI/rtk) desde su proyecto oficial; comprueba que `rtk gain` funciona. Graphify, Gitleaks y `gh` son herramientas opcionales que las instrucciones usan cuando están disponibles.

```bash
git clone https://github.com/calinrus-dev/agent-workstation.git ~/src/agent-workstation
cd ~/src/agent-workstation
bash install-linux.sh
```

El instalador guarda copias previas en `~/.local/share/agent-workstation-backups/`, coloca las instrucciones en los tres clientes, instala las skills compartidas, ajusta el modelo preferido de Codex y añade Context7 donde puede hacerlo sin credenciales. Si faltan herramientas, muestra lo pendiente. Reinicia los clientes después. No instala binarios ni inicia sesión por ti.

Para actualizar en cualquiera de los sistemas: `git pull` en este repositorio y vuelve a ejecutar el instalador correspondiente. Edita los archivos **aquí**, haz commit y push, y aplica el mismo cambio en el otro sistema.

## En Windows

La configuración Windows existente fue la fuente inicial. Para aplicar futuras revisiones del repositorio:

```powershell
git pull
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-windows.ps1
```

El instalador Windows sincroniza las instrucciones y skills compartidas. Deja intactos `config.toml`, los hooks y los MCP específicos de la app que ya funcionan en esa máquina. Las instrucciones anteriores se guardan bajo `%LOCALAPPDATA%\agent-workstation-backups`.

## Límites entre sistemas

- `gpt-6.1-sol` es la preferencia de **Codex**. Si tu instalación de Codex todavía no lo ofrece, cambia `CODEX_MODEL` en `defaults.env` a `gpt-6-sol` temporalmente y vuelve a aplicar el instalador. Claude y Antigravity usan sus propios selectores de modelo.
- Codex en Windows incluye un servidor `node_repl`, rutas de plugins, notificaciones y confianza por proyecto generados por la app. No se copian a Linux.
- Los tokens, claves SSH, OAuth, `auth.json`, `.claude.json`, historiales, bases de datos y permisos por proyecto se configuran por equipo. Inicia sesión por separado.
- Context7 es el único MCP remoto común del paquete. El servidor Dart de Antigravity en Windows se configura en Linux cuando tengas Dart instalado y quieras usarlo.
- RTK integra hooks globales en Codex y Claude Code. Para Antigravity, su integración oficial es **por proyecto**: ejecuta `rtk init --agent antigravity` en cada proyecto donde la quieras. RTK reduce el ruido de salida; la mejora real depende de los comandos usados.
- Mantén el `AGENTS.md` de cada repositorio con sus reglas específicas. Este paquete solo establece instrucciones globales.

Consulta [cómo está dividido el sistema](docs/arquitectura.md) antes de añadir otro MCP, hook o skill global.

## Comprobación rápida en CachyOS

```bash
codex mcp list
claude mcp list
rtk --version
rtk gain
```

Si un cliente no está instalado aún, el script lo indicará sin intentar descargarlo automáticamente.

## English quick start

This public repository syncs portable guidance and local skills across Codex, Claude Code, and Google Antigravity. Clone it on Linux and run `bash install-linux.sh`; on Windows run `powershell -NoProfile -ExecutionPolicy Bypass -File .\install-windows.ps1`. Backups are created before existing guidance is replaced. Authentication, project trust, sessions, app generated paths, and machine specific MCP servers stay local. See the Spanish sections above for details.

Released under the [MIT License](LICENSE).
