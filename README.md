# ACE

ACE는 프로젝트에 작업 컨텍스트를 연결하고, 분석 → 설계 → 구현 → 검증 흐름을 바로 시작할 수 있게 해주는 CLI입니다.

## 설치

- macOS / Linux: [README.mac.md](/Users/hjkim/project/ace/README.mac.md)
- Windows: [README.windows.md](/Users/hjkim/project/ace/README.windows.md)

설치 스크립트:

- macOS / Linux: `install.sh`
- Windows: `install.ps1`

## 설치 후 바로 이해해야 하는 흐름

ACE는 이렇게 씁니다.

1. ACE를 한 번 전역 설치합니다.
2. 작업할 프로젝트 폴더로 이동합니다.
3. `ace init`으로 그 프로젝트에 ACE 구성을 심습니다.
4. 그 뒤 태스크를 만들고 `analyze → design → dev → test` 순서로 진행합니다.

가장 짧은 예시는 아래입니다.

```bash
mkdir -p ~/project/ace-demo
cd ~/project/ace-demo
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
ace
```

## 핵심 명령

```bash
ace start
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
ace add-pack biz
ace export-codex --pack dev --dest ~/.codex/skills
ace update
```

## 프로젝트에 무엇이 생기나

`ace init`을 실행하면 프로젝트 안에 아래가 생성됩니다.

- `.ace/profile.yaml`
- `.ace/templates/`
- `.claude/skills/`
- `.claude/agents/`
- `.claude/rules/`
- `workspace/tasks/`

즉, ACE 코어는 전역에 두고, 프로젝트별 컨텍스트와 산출물만 로컬에 둡니다.

## Codex 사용

Codex 앱/CLI에서 ACE 스킬을 쓰려면:

```bash
ace export-codex --pack dev --dest ~/.codex/skills
```

그 다음 Codex를 재시작하면 `$ace-analyze`, `$ace-dev` 같은 스킬을 사용할 수 있습니다.

## 지원 구성

- 모드: `solo`, `team`
- 팩: `dev`, `biz`
- 예시 스택:
  - `nextjs-fastapi-pg`
  - `spring-vue-mssql`
  - `react-native-expo`
  - `django-react-pg`

## 저장소 주소

- GitHub: `https://github.com/Leafic/ace`

## 라이선스

MIT
