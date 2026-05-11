# easy-build-skills — one-line installer (Windows PowerShell)
# Usage:
#   iwr -useb https://raw.githubusercontent.com/Fantasymax/easy-build-skills/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$RepoUrl    = "https://github.com/Fantasymax/easy-build-skills.git"
$SkillName  = "user-research-for-ai-config"
$SkillsDir  = Join-Path $env:USERPROFILE ".claude\skills"
$TmpDir     = Join-Path $env:TEMP ("easy-build-skills-" + [guid]::NewGuid().ToString("N").Substring(0,8))

try {
    Write-Host ""
    Write-Host "📥 Cloning easy-build-skills..."
    git clone --depth=1 --quiet $RepoUrl (Join-Path $TmpDir "repo")

    Write-Host "📂 Installing skill to $SkillsDir\$SkillName\"
    if (-not (Test-Path $SkillsDir)) {
        New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
    }

    $TargetDir = Join-Path $SkillsDir $SkillName
    if (Test-Path $TargetDir) {
        Write-Host "  (removing existing install)"
        Remove-Item -Path $TargetDir -Recurse -Force
    }

    Copy-Item -Path (Join-Path $TmpDir "repo\skill\$SkillName") `
              -Destination $SkillsDir `
              -Recurse -Force

    Write-Host ""
    Write-Host "✅ Installed."
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Restart Claude Code (Ctrl+Shift+P -> Reload Window)"
    Write-Host "  2. Say to Claude one of:"
    Write-Host "     - `"I want to define AI principles for myself`" (Mode A - principles doc)"
    Write-Host "     - `"Help me design a custom skill from scratch`" (Mode B - design new skill)"
    Write-Host "     - `"Help me extract weekly-report writing into a skill`" (Mode B - extract existing task)"
    Write-Host "     - 中文: `"我想给自己定义 AI principles`" / `"帮我设计一个 skill`" / `"把我会的 X 抽成一个 skill`""
    Write-Host ""
    Write-Host "Optional - for auto-updates, run inside Claude Code:"
    Write-Host "  /plugin marketplace add Fantasymax/easy-build-skills"
    Write-Host "  /plugin install user-research-for-ai-config@easy-build-skills"
    Write-Host ""
    Write-Host "To uninstall: Remove-Item -Recurse $TargetDir"
    Write-Host ""
}
finally {
    if (Test-Path $TmpDir) {
        Remove-Item -Path $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
