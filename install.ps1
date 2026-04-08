#
# ACE Installer — Windows (PowerShell)
#
# Usage:
#   1. PowerShell을 관리자 권한으로 실행
#   2. 실행 정책 허용 (최초 1회):
#      Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#   3. 설치:
#      .\install.ps1
#
# private 레포인 경우:
#   방법 A — GitHub 개인 액세스 토큰 (PAT):
#     $env:ACE_REPO = "https://<토큰>@github.com/Leafic/ace.git"; .\install.ps1
#   방법 B — SSH (사전에 ssh-keygen + GitHub에 키 등록 필요):
#     $env:ACE_REPO = "git@github.com:Leafic/ace.git"; .\install.ps1
#

$ErrorActionPreference = "Stop"

function PauseAndExit($code) {
    Write-Host ""
    Write-Host "아무 키나 누르면 종료됩니다..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit $code
}

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
        PauseAndExit 1
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
            PauseAndExit 1
        }
        Pop-Location
    } else {
        Write-Host "  취소됨."
        PauseAndExit 0
    }
} else {
    Write-Host "📦 ACE 설치 중... ($ACE_DIR)"
    try {
        git clone --depth 1 $ACE_REPO $ACE_DIR 2>&1 | Out-Null
        Write-Host "✓ 클론 완료" -ForegroundColor Green
    } catch {
        Write-Host "❌ git clone 실패" -ForegroundColor Red
        Write-Host ""
        Write-Host "   private 레포라면 인증이 필요합니다:" -ForegroundColor Yellow
        Write-Host '   $env:ACE_REPO = "https://<GitHub PAT>@github.com/Leafic/ace.git"'
        Write-Host "   .\install.ps1"
        Write-Host ""
        Write-Host "   GitHub PAT 발급: https://github.com/settings/tokens"
        PauseAndExit 1
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
PauseAndExit 0
