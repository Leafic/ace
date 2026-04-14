#!/usr/bin/env bash
#
# ACE Installer — Mac / Linux
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/hjkim/ace/main/install.sh | bash
#   또는
#   bash install.sh
#

set -euo pipefail

# private 레포인 경우 SSH 사용:
#   ACE_REPO=git@github.com:Leafic/ace.git bash install.sh
ACE_REPO="${ACE_REPO:-https://github.com/Leafic/ace.git}"
ACE_DIR="${ACE_HOME:-$HOME/.ace}"
ACE_BIN="$ACE_DIR/ace"

echo ""
echo "═══ ACE Installer ═══"
echo ""

# ─────────────────────────────────────────────
# 1. Node.js 확인
# ─────────────────────────────────────────────
if ! command -v node &> /dev/null; then
  echo "❌ Node.js가 필요합니다."
  echo "   brew install node  또는  https://nodejs.org"
  exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 16 ]; then
  echo "❌ Node.js 16+ 필요 (현재: $(node -v))"
  exit 1
fi
echo "✓ Node.js $(node -v)"

# ─────────────────────────────────────────────
# 2. 기존 설치 확인
# ─────────────────────────────────────────────
if [ -d "$ACE_DIR" ]; then
  echo ""
  echo "⚠ $ACE_DIR 이미 존재합니다."
  read -p "  업데이트 하시겠습니까? (y/N) " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  기존 설치 업데이트 중..."
    cd "$ACE_DIR"
    git pull --ff-only origin main 2>/dev/null || {
      echo "  git pull 실패 — 수동 업데이트가 필요합니다."
      exit 1
    }
    echo "✓ 업데이트 완료"
  else
    echo "  취소됨."
    exit 0
  fi
else
  # ─────────────────────────────────────────────
  # 3. 클론
  # ─────────────────────────────────────────────
  echo "📦 ACE 설치 중... ($ACE_DIR)"
  git clone --depth 1 "$ACE_REPO" "$ACE_DIR" 2>/dev/null || {
    echo "❌ git clone 실패"
    echo "   레포 URL을 확인하세요: $ACE_REPO"
    exit 1
  }
  echo "✓ 클론 완료"
fi

# ─────────────────────────────────────────────
# 4. 실행 권한
# ─────────────────────────────────────────────
chmod +x "$ACE_BIN"

# ─────────────────────────────────────────────
# 5. PATH 등록
# ─────────────────────────────────────────────
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
  zsh)  RC_FILE="$HOME/.zshrc" ;;
  bash) RC_FILE="$HOME/.bashrc" ;;
  *)    RC_FILE="$HOME/.profile" ;;
esac

ACE_PATH_LINE="export PATH=\"\$PATH:$ACE_DIR\""

if ! grep -qF "$ACE_DIR" "$RC_FILE" 2>/dev/null; then
  echo "" >> "$RC_FILE"
  echo "# ACE — Agent-powered Code Engine" >> "$RC_FILE"
  echo "$ACE_PATH_LINE" >> "$RC_FILE"
  echo "✓ PATH 등록 ($RC_FILE)"
  echo ""
  echo "⚡ 터미널을 재시작하거나 다음을 실행하세요:"
  echo "   source $RC_FILE"
else
  echo "✓ PATH 이미 등록됨"
fi

# ─────────────────────────────────────────────
# 6. 완료
# ─────────────────────────────────────────────
echo ""
echo "═══ 설치 완료 ═══"
echo ""
echo "  사용법:"
echo "    cd ~/project/MyProject"
echo "    ace init --pack dev --stack nextjs-fastapi-pg"
echo ""
echo "  바로 테스트:"
echo "    mkdir -p ~/project/ace-smoke && cd ~/project/ace-smoke && ace init --pack dev --stack nextjs-fastapi-pg --mode solo && ace"
echo ""
echo "  또는 대화형 세팅:"
echo "    ace start"
echo ""
