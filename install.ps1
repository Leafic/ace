#
# ACE Installer — Windows (PowerShell)
#
# Usage:
#   iwr https://raw.githubusercontent.com/hjkim/ace/main/install.ps1 | iex
#   또는
#   .\install.ps1
#

$ErrorActionPreference = "Stop"

# private 레포인 경우 SSH 사용:
#   $env:ACE_REPO = "git@github.com:Leafic/ace.git"; .\install.ps1
$ACE_REPO = if ($env:ACE_REPO) { $env:ACE_REPO } else { "https://github.com/Leafic/ace.git" }
$ACE_DIR = if ($env:ACE_HOME) { $env:ACE_HOME } else { "$env:USERPROFILE\.ace" }

Write-Host ""
Write-Host "═══ ACE Installer ═══" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────
# 1. Node.js 확인
# ─────────────────────────────────────────────
try {
    $nodeVersion = (node -v) -replace 'v', ''
    $major = [int]($nodeVersion.Split('.')[0])
    if ($major -lt 16) {
        Write-Host "❌ Node.js 16+ 필요 (현재: v$nodeVersion)" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Node.js v$nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js가 필요합니다." -ForegroundColor Red
    Write-Host "   https://nodejs.org 에서 설치하세요."
    exit 1
}

# ─────────────────────────────────────────────
# 2. Git 확인
# ─────────────────────────────────────────────
try {
    git --version | Out-Null
    Write-Host "✓ Git 설치됨" -ForegroundColor Green
} catch {
    Write-Host "❌ Git이 필요합니다." -ForegroundColor Red
    Write-Host "   https://git-scm.com 에서 설치하세요."
    exit 1
}

# ─────────────────────────────────────────────
# 3. 기존 설치 확인 / 클론
# ─────────────────────────────────────────────
if (Test-Path $ACE_DIR) {
    Write-Host ""
    Write-Host "⚠ $ACE_DIR 이미 존재합니다." -ForegroundColor Yellow
    $reply = Read-Host "  업데이트 하시겠습니까? (y/N)"
    if ($reply -eq 'y' -or $reply -eq 'Y') {
        Push-Location $ACE_DIR
        try {
            git pull --ff-only origin main
            Write-Host "✓ 업데이트 완료" -ForegroundColor Green
        } catch {
            Write-Host "  git pull 실패 — 수동 업데이트가 필요합니다." -ForegroundColor Red
            Pop-Location
            exit 1
        }
        Pop-Location
    } else {
        Write-Host "  취소됨."
        exit 0
    }
} else {
    Write-Host "📦 ACE 설치 중... ($ACE_DIR)"
    try {
        git clone --depth 1 $ACE_REPO $ACE_DIR
        Write-Host "✓ 클론 완료" -ForegroundColor Green
    } catch {
        Write-Host "❌ git clone 실패" -ForegroundColor Red
        Write-Host "   레포 URL을 확인하세요: $ACE_REPO"
        exit 1
    }
}

# ─────────────────────────────────────────────
# 4. PATH 등록 (사용자 환경변수)
# ─────────────────────────────────────────────
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$ACE_DIR*") {
    [Environment]::SetEnvironmentVariable(
        "PATH",
        "$currentPath;$ACE_DIR",
        "User"
    )
    $env:PATH = "$env:PATH;$ACE_DIR"
    Write-Host "✓ PATH 등록 (사용자 환경변수)" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚡ 새 터미널을 열거나 다음을 실행하세요:" -ForegroundColor Yellow
    Write-Host '   $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User")'
} else {
    Write-Host "✓ PATH 이미 등록됨" -ForegroundColor Green
}

# ─────────────────────────────────────────────
# 5. ace.cmd 래퍼 생성 (Windows에서 직접 실행용)
# ─────────────────────────────────────────────
$cmdWrapper = Join-Path $ACE_DIR "ace.cmd"
if (-not (Test-Path $cmdWrapper)) {
    @"
@echo off
node "%~dp0ace" %*
"@ | Out-File -FilePath $cmdWrapper -Encoding ascii
    Write-Host "✓ ace.cmd 래퍼 생성" -ForegroundColor Green
}

# ─────────────────────────────────────────────
# 6. 완료
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "═══ 설치 완료 ═══" -ForegroundColor Cyan
Write-Host ""
Write-Host "  사용법:"
Write-Host "    cd ~\project\MyProject"
Write-Host "    ace init --pack dev --stack nextjs-fastapi-pg"
Write-Host ""
Write-Host "  또는 대화형 세팅:"
Write-Host "    ace start"
Write-Host ""
