# ACE for Windows

Windows에서 ACE를 설치하고 바로 테스트하는 가장 빠른 가이드입니다.

## 1. 요구사항

- `Node.js 16+`
- `git`
- `PowerShell`

확인:

```powershell
node -v
git --version
```

## 2. 설치

PowerShell을 열고 프로젝트 루트에서:

```powershell
.\install.ps1
```

최초 1회 실행 정책이 막혀 있으면:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

사설 저장소에서 설치하려면:

```powershell
$env:ACE_REPO = "https://<GitHub PAT>@github.com/Leafic/ace.git"
.\install.ps1
```

또는 SSH:

```powershell
$env:ACE_REPO = "git@github.com:Leafic/ace.git"
.\install.ps1
```

설치 후 새 PowerShell을 열거나:

```powershell
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
```

## 3. 설치 확인

```powershell
ace
```

도움말이 나오면 정상입니다.

## 설치 직후 바로 이해하기

설치가 끝나면 사용 흐름은 딱 이겁니다.

```powershell
Set-Location "$HOME\project\my-app"
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
```

그러면 현재 프로젝트 안에 `.ace`, `.claude`, `workspace\tasks`가 생기고, 그 프로젝트는 ACE 작업 대상이 됩니다.

## 4. 프로젝트에 바로 연결

```powershell
New-Item -ItemType Directory -Force "$HOME\project\ace-demo" | Out-Null
Set-Location "$HOME\project\ace-demo"
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
```

생성 확인:

```powershell
Get-ChildItem .ace, .claude, workspace -Recurse -Depth 2
```

## 5. 단숨에 스모크 테스트

아래 한 번이면 초기화와 확인까지 됩니다.

```powershell
New-Item -ItemType Directory -Force "$HOME\project\ace-smoke" | Out-Null; Set-Location "$HOME\project\ace-smoke"; ace init --pack dev --stack nextjs-fastapi-pg --mode solo; ace
```

정상이라면:

- `.ace\`
- `.claude\`
- `workspace\tasks\`
- CLI 도움말 출력

이 보입니다.

설치 후 바로 한 줄 테스트를 하려면:

```powershell
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User"); New-Item -ItemType Directory -Force "$HOME\project\ace-smoke" | Out-Null; Set-Location "$HOME\project\ace-smoke"; ace init --pack dev --stack nextjs-fastapi-pg --mode solo; ace
```

## 6. Codex에서 사용하려면

Codex 앱/CLI에 스킬을 내보내려면:

```powershell
ace export-codex --pack dev --dest "$HOME\.codex\skills"
```

그 다음 Codex를 재시작하세요.

## 7. 자주 쓰는 명령

```powershell
ace start
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
ace add-pack biz
ace export-codex --pack dev --dest "$HOME\.codex\skills"
ace update
```

## 문제 해결

`ace` 명령이 안 잡힘

```powershell
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
```

`install.ps1 실행 차단`

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

`git clone 실패`

- `install.ps1`의 기본 `ACE_REPO` 확인
- private 저장소라면 PAT 또는 SSH 사용

`Node.js 버전 오류`

- `node -v` 확인
- 16 이상으로 업그레이드
