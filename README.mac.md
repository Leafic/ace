# ACE for macOS / Linux

macOS 또는 Linux에서 ACE를 설치하고 바로 테스트하는 가장 빠른 가이드입니다.

## 1. 요구사항

- `Node.js 16+`
- `git`
- `bash` 또는 `zsh`

확인:

```bash
node -v
git --version
```

## 2. 설치

원격 설치:

```bash
curl -fsSL https://raw.githubusercontent.com/Leafic/ace/main/install.sh | bash
```

로컬 파일로 설치:

```bash
bash install.sh
```

사설 저장소에서 설치:

```bash
ACE_REPO=git@github.com:Leafic/ace.git bash install.sh
```

설치 후 새 터미널을 열거나:

```bash
source ~/.zshrc
```

`bash` 사용 중이면:

```bash
source ~/.bashrc
```

## 3. 설치 확인

```bash
ace
```

도움말이 나오면 정상입니다.

## 설치 직후 바로 이해하기

설치가 끝나면 사용 흐름은 딱 이겁니다.

```bash
cd ~/project/my-app
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
```

그러면 현재 프로젝트 안에 `.ace`, `.claude`, `workspace/tasks`가 생기고, 그 프로젝트는 ACE 작업 대상이 됩니다.

## 4. 프로젝트에 바로 연결

```bash
mkdir -p ~/project/ace-demo
cd ~/project/ace-demo
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
```

생성 확인:

```bash
find .ace .claude workspace -maxdepth 2 -type d
```

## 5. 단숨에 스모크 테스트

아래 한 번이면 초기화와 확인까지 됩니다.

```bash
mkdir -p ~/project/ace-smoke && cd ~/project/ace-smoke && ace init --pack dev --stack nextjs-fastapi-pg --mode solo && ace
```

정상이라면:

- `.ace/`
- `.claude/`
- `workspace/tasks/`
- CLI 도움말 출력

이 보입니다.

원격 설치부터 테스트까지 한 번에 돌리고 싶으면:

```bash
curl -fsSL https://raw.githubusercontent.com/Leafic/ace/main/install.sh | bash && source ~/.zshrc && mkdir -p ~/project/ace-smoke && cd ~/project/ace-smoke && ace init --pack dev --stack nextjs-fastapi-pg --mode solo && ace
```

## 6. Codex에서 사용하려면

Codex 앱/CLI에 스킬을 내보내려면:

```bash
ace export-codex --pack dev --dest ~/.codex/skills
```

그 다음 Codex를 재시작하세요.

## 7. 자주 쓰는 명령

```bash
ace start
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
ace add-pack biz
ace export-codex --pack dev --dest ~/.codex/skills
ace update
```

## 문제 해결

`ace: command not found`

```bash
source ~/.zshrc
```

또는

```bash
source ~/.bashrc
```

`git clone 실패`

- `install.sh` 안의 기본 `ACE_REPO`가 올바른지 확인
- private 저장소라면 SSH 또는 토큰 URL 사용

`Node.js 버전 오류`

- `node -v` 확인
- 16 이상으로 업그레이드
