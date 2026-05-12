# ACE

ACE는 프로젝트에 작업 컨텍스트와 반복 가능한 AI 스킬을 연결하는 하네스입니다.
핵심은 특정 에이전트에 묶인 프롬프트가 아니라, `analysis.md`, `design.md`, `research.md` 같은 산출물 흐름을 Claude Code, Codex 등 여러 실행 환경에서 재사용할 수 있게 만드는 것입니다.

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
4. 필요하면 `ace export-codex --global`로 Codex 전역 스킬에 동기화합니다.
5. 그 뒤 `analyze → design → dev → test` 또는 `research → model → plan → judge` 흐름을 사용합니다.

가장 짧은 예시는 아래입니다.

```bash
mkdir -p ~/project/ace-demo
cd ~/project/ace-demo
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
ace doctor
```

## 핵심 명령

```bash
ace start
ace init --pack dev --stack nextjs-fastapi-pg --mode solo
ace init --pack all --stack nextjs-fastapi-pg --mode solo
ace add-pack biz
ace export-codex --pack all --global
ace doctor
ace validate-skills
ace update
```

배포 전 특정 회사/프로젝트 컨텍스트가 스킬에 남았는지 확인하려면:

```bash
ACE_FORBIDDEN_TERMS="내부프로젝트명,회사명" ace validate-skills
```

## 프로젝트에 무엇이 생기나

`ace init`을 실행하면 프로젝트 안에 아래가 생성됩니다.

- `.ace/profile.yaml`
- `.ace/templates/`
- `.claude/skills/`
- `.claude/agents/`
- `.claude/rules/`
- `workspace/current/`
- `workspace/tasks/`

즉, ACE 코어와 Codex 스킬은 전역에 둘 수 있고, 프로젝트별 컨텍스트와 산출물만 로컬에 둡니다.

## Codex 사용

Codex 앱/CLI에서 ACE 스킬을 쓰려면:

```bash
ace export-codex --pack all --global
```

그 다음 Codex를 재시작하면 `$ace-analyze`, `$ace-dev`, `$ace-research`, `$ace-coach` 같은 스킬을 사용할 수 있습니다.
하네스 자체를 점검하려면 `$ace-karpathy-harness`로 context map, execution harness, verification gates를 설계할 수 있습니다.

`~/.codex`가 이미 있으면 `ace export-codex`만 실행해도 기본적으로 전역 `~/.codex/skills`에 내보냅니다. 프로젝트 로컬에만 만들고 싶으면 `--local`을 사용하세요.

## 지원 구성

- 모드: `solo`, `team`
- 팩: `dev`, `biz`, `all`
- 예시 스택:
  - `nextjs-fastapi-pg`
  - `spring-vue-mssql`
  - `react-native-expo`
  - `django-react-pg`

## 작업 원칙

ACE는 하네스와 스킬 실행 기준으로 카르파시 4원칙을 적용합니다.

- `Think Before Coding`: 애매하면 추측하지 않고 가정/선택지/트레이드오프를 먼저 드러냅니다.
- `Simplicity First`: 요청을 해결하는 최소 구현을 우선합니다.
- `Surgical Changes`: 변경 범위를 좁게 유지하고 관련 없는 리팩토링을 섞지 않습니다.
- `Goal-Driven Execution`: 완료 기준과 검증 결과를 기준으로 작업을 닫습니다.

## 저장소 주소

- GitHub: `https://github.com/Leafic/ace`

## 라이선스

MIT
