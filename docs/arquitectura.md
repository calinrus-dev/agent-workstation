# Qué se sincroniza

| Capa | Fuente compartida | Destino |
| --- | --- | --- |
| Instrucciones | `guidance.md` | `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md` |
| Skills personales | `skills/` | Directorios globales de cada cliente |
| Modelo Codex | `defaults.env` | Claves superiores de `~/.codex/config.toml` en Linux |
| Context7 | Instalador Linux | Codex, Claude Code y Antigravity, con su esquema correspondiente |
| RTK | Binario instalado por equipo | Hooks de Codex y Claude Code; en Antigravity, regla por proyecto |

No se sincronizan archivos de autenticación, permisos, historiales, cachés, bases de datos, rutas de ejecutables ni configuración generada por plugins. Las copias anteriores se conservan localmente fuera del repositorio.

## Criterios para ahorrar contexto

1. Mantener las instrucciones globales cortas y estables. Los detalles de un repositorio viven en su `AGENTS.md`, `CLAUDE.md` o `GEMINI.md`.
2. Añadir skills solo para flujos que se reutilizan. El contenido completo se lee cuando hace falta; demasiadas descripciones globales también ocupan contexto.
3. Dejar los MCP globales en lo esencial. Cada servidor expone herramientas y puede añadir carga al contexto; los MCP propios de un proyecto van en ese proyecto.
4. Usar RTK en comandos compatibles y recuperar la salida íntegra cuando sea necesaria para depurar o verificar. El porcentaje de ahorro anunciado por una herramienta no garantiza ahorro de cuota.
5. Ajustar el razonamiento al trabajo. Aquí se conserva `high` para Codex porque es la preferencia actual; `xhigh` se reserva para problemas que lo justifiquen. La disponibilidad de `gpt-6.1-sol` en Codex se comprueba en cada instalación.

## Fuentes

- [Modelo GPT-6.1 Sol](https://developers.openai.com/api/docs/models/gpt-6.1-sol) y [MCP de documentación OpenAI](https://developers.openai.com/learn/docs-mcp)
- [MCP de Claude Code](https://code.claude.com/docs/en/mcp)
- [Reglas](https://antigravity.google/docs/rules/), [skills](https://antigravity.google/docs/skills) y [MCP](https://antigravity.google/docs/mcp) de Antigravity
- [Rust Token Killer](https://github.com/TokenFleet-AI/rtk)
