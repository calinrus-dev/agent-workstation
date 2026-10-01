#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=defaults.env
source "$repo_dir/defaults.env"
client_home="${AGENT_WORKSTATION_HOME:-$HOME}"
backup_dir="$client_home/.local/share/agent-workstation-backups/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup_dir"

install_guidance() {
  local target="$1"
  local source_file="${2:-guidance.md}"
  mkdir -p "$(dirname "$target")"
  if [[ -e "$target" ]]; then
    local rel="${target#"$client_home"/}"
    mkdir -p "$backup_dir/$(dirname "$rel")"
    cp -p "$target" "$backup_dir/$rel"
  fi
  install -m 644 "$repo_dir/$source_file" "$target"
}

install_guidance "$client_home/.codex/AGENTS.md"
install_guidance "$client_home/.claude/CLAUDE.md"
install_guidance "$client_home/.gemini/GEMINI.md"
for client_dir in "$client_home/.codex" "$client_home/.claude" "$client_home/.gemini"; do
  install_guidance "$client_dir/SOCIAL.md" SOCIAL.md
done

for skill in graphify-local local-dev-tools; do
  mkdir -p "$client_home/.agents/skills/$skill"
  cp -a "$repo_dir/skills/$skill/." "$client_home/.agents/skills/$skill/"
  for dir in "$client_home/.codex/skills" "$client_home/.claude/skills" "$client_home/.gemini/config/skills"; do
    mkdir -p "$dir"
    if [[ ! -e "$dir/$skill" && ! -L "$dir/$skill" ]]; then
      ln -s "$client_home/.agents/skills/$skill" "$dir/$skill"
    fi
  done
done

config="$client_home/.codex/config.toml"
mkdir -p "$(dirname "$config")"
if [[ -e "$config" ]]; then cp -p "$config" "$backup_dir/codex-config.toml"; else : > "$config"; fi

set_root_toml() {
  local key="$1" value="$2" temp
  temp="$(mktemp "${config}.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { root=1; done=0 }
    /^\[/ && root { if (!done) { print key " = " value; done=1 }; root=0 }
    root && $0 ~ "^[[:space:]]*" key "[[:space:]]*=" { print key " = " value; done=1; next }
    { print }
    END { if (root && !done) print key " = " value }
  ' "$config" > "$temp"
  chmod 600 "$temp"
  mv "$temp" "$config"
}
set_root_toml model "\"$CODEX_MODEL\""
set_root_toml model_reasoning_effort "\"$CODEX_REASONING_EFFORT\""
set_root_toml tool_output_token_limit "$CODEX_TOOL_OUTPUT_TOKEN_LIMIT"

if ! grep -Eq '^\[mcp_servers\.context7\]' "$config"; then
  cat >> "$config" <<'TOML'

[mcp_servers.context7]
url = "https://mcp.context7.com/mcp"
startup_timeout_sec = 30
tool_timeout_sec = 60
enabled_tools = ["resolve-library-id", "query-docs"]
TOML
fi

ag_mcp="$client_home/.gemini/config/mcp_config.json"
mkdir -p "$(dirname "$ag_mcp")"
if [[ -e "$ag_mcp" ]]; then cp -p "$ag_mcp" "$backup_dir/antigravity-mcp_config.json"; fi
if command -v python3 >/dev/null 2>&1; then
  python3 - "$ag_mcp" <<'PY'
import json, os, pathlib, sys, tempfile
p = pathlib.Path(sys.argv[1])
try:
    data = json.loads(p.read_text(encoding="utf-8")) if p.exists() else {}
    servers = data.setdefault("mcpServers", {})
    servers.setdefault("context7", {"serverUrl": "https://mcp.context7.com/mcp"})
    fd, name = tempfile.mkstemp(dir=p.parent, prefix=".mcp_config.")
    with os.fdopen(fd, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)
        file.write("\n")
    os.chmod(name, 0o600)
    os.replace(name, p)
except (OSError, ValueError, TypeError) as error:
    print(f"Antigravity MCP sin cambios: {error}")
PY
else
  echo "Instala Python 3 para añadir Context7 a Antigravity, o hazlo desde el panel MCP."
fi

if [[ "${AGENT_WORKSTATION_SKIP_INTEGRATIONS:-0}" != 1 ]]; then
  if command -v claude >/dev/null 2>&1; then
    if ! claude mcp get context7 >/dev/null 2>&1; then
      claude mcp add --transport http context7 --scope user https://mcp.context7.com/mcp || echo "Añade Context7 desde Claude Code manualmente."
    fi
  else
    echo "Claude Code aún no está en PATH; al instalarlo ejecuta: claude mcp add --transport http context7 --scope user https://mcp.context7.com/mcp"
  fi

  if command -v rtk >/dev/null 2>&1; then
    rtk init -g --codex --auto-patch || echo "Revisa la inicialización de RTK para Codex."
    rtk init -g --auto-patch || echo "Revisa la inicialización de RTK para Claude Code."
  else
    echo "RTK aún no está en PATH; instala Rust Token Killer y ejecuta: rtk init -g --codex; rtk init -g"
  fi
fi

echo "Configuración aplicada. Copias anteriores: $backup_dir"
echo "Verifica: codex mcp list; claude mcp list; rtk gain"
