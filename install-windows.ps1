$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$homeDir = if ($env:AGENT_WORKSTATION_HOME) { $env:AGENT_WORKSTATION_HOME } else { $HOME }
$backupBase = if ($env:AGENT_WORKSTATION_HOME) { Join-Path $homeDir 'backups' } else { Join-Path $env:LOCALAPPDATA 'agent-workstation-backups' }
$backup = Join-Path $backupBase (Get-Date -Format 'yyyyMMdd-HHmmss-fff')
New-Item -ItemType Directory -Force -Path $backup | Out-Null

$targets = @(
  @{ Path = (Join-Path $homeDir '.codex\AGENTS.md'); Name = 'AGENTS.md' },
  @{ Path = (Join-Path $homeDir '.claude\CLAUDE.md'); Name = 'CLAUDE.md' },
  @{ Path = (Join-Path $homeDir '.gemini\GEMINI.md'); Name = 'GEMINI.md' }
)
foreach ($entry in $targets) {
  $parent = Split-Path -Parent $entry.Path
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  if (Test-Path -LiteralPath $entry.Path) {
    Copy-Item -LiteralPath $entry.Path -Destination (Join-Path $backup $entry.Name)
  }
  Copy-Item -LiteralPath (Join-Path $repo 'guidance.md') -Destination $entry.Path -Force
}

foreach ($name in @('graphify-local', 'local-dev-tools')) {
  $source = Join-Path $repo "skills\$name"
  $targets = @(
    (Join-Path $homeDir ".agents\skills\$name"),
    (Join-Path $homeDir ".codex\skills\$name"),
    (Join-Path $homeDir ".claude\skills\$name"),
    (Join-Path $homeDir ".gemini\config\skills\$name")
  )
  foreach ($target in $targets) {
    $item = Get-Item -LiteralPath $target -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType) { continue }
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item -Path (Join-Path $source '*') -Destination $target -Recurse -Force
  }
}

Write-Output "Instrucciones y skills aplicadas. Copias anteriores: $backup"
Write-Output 'Codex config.toml, hooks, MCP y credenciales de Windows no se han modificado.'
