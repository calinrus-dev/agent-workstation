#!/usr/bin/env bash
set -euo pipefail

command -v git >/dev/null || { echo 'Instala Git primero.' >&2; exit 1; }
command -v gh >/dev/null || { echo 'Instala GitHub CLI (gh) primero.' >&2; exit 1; }
gh auth status --hostname github.com >/dev/null 2>&1 || {
  echo 'Inicia sesión en GitHub: gh auth login' >&2
  exit 1
}

owner="${GH_OWNER:-$(gh api user --jq .login)}"
root="${PROJECTS_ROOT:-$HOME/Projects/GitHub}"
sync_branch="${SYNC_BRANCH:-sync/cachyos-2026-09-30}"
mkdir -p "$root"

if git lfs version >/dev/null 2>&1; then
  git lfs install >/dev/null
else
  echo 'Git LFS no está instalado. Instálalo antes de clonar proyectos con modelos o binarios LFS.' >&2
  exit 1
fi

mapfile -t repositories < <(
  gh repo list "$owner" --no-archived --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner'
)
if (( ${#repositories[@]} == 0 )); then
  echo "No se encontraron repositorios para $owner." >&2
  exit 1
fi

cloned=0
skipped=0
failed=0
for repository in "${repositories[@]}"; do
  name="${repository##*/}"
  if [[ "$name" == agent-workstation ]]; then continue; fi
  target="$root/$name"
  if [[ -e "$target" ]]; then
    echo "EXISTE $target — no se modifica"
    ((skipped += 1))
    continue
  fi

  echo "CLONANDO $repository"
  if ! gh repo clone "$repository" "$target"; then
    echo "ERROR al clonar $repository" >&2
    ((failed += 1))
    continue
  fi
  ((cloned += 1))

  if git -C "$target" show-ref --verify --quiet "refs/remotes/origin/$sync_branch"; then
    if git -C "$target" switch --track -c "$sync_branch" "origin/$sync_branch"; then
      echo "RAMA $repository → $sync_branch"
    else
      echo "ERROR al activar $sync_branch en $repository" >&2
      ((failed += 1))
    fi
  fi
done

echo "Clonados: $cloned; existentes: $skipped; fallos: $failed. Destino: $root"
(( failed == 0 ))
