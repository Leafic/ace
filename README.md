# ACE

ACE는 AI 에이전트와 함께 일할 때 필요한 **작업 흐름, 산출물, 검증, 기록을 표준화하는 하네스**입니다.

AI에게 좋은 답변을 한 번 받는 것보다 더 어려운 일은, 여러 사람이 여러 프로젝트에서 같은 품질로 반복해서 일하는 것입니다.
ACE는 그 문제를 해결하기 위해 만들어졌습니다.

핵심은 특정 에이전트에 종속된 프롬프트가 아닙니다.
`analysis.md`, `design.md`, `development.md`, `test.md`, `research.md`, `model.md`, `plan.md`, `judgement.md`, `wiki` 같은 산출물 흐름을 만들어 Claude Code, Codex 등 여러 실행 환경에서 재사용할 수 있게 하는 것입니다.

## 왜 만들었나

처음의 고민은 단순했습니다.

사업 아이디어를 검증하고, 실제 개발까지 이어가려면 매번 사람이 같은 설명을 반복해야 했습니다.
어떤 프로젝트는 기획이 충분히 정리되지 않은 채 개발로 넘어갔고, 어떤 프로젝트는 좋은 분석이 나와도 다음 사람이 이어받기 어려웠습니다.
AI 에이전트는 빠르게 답을 만들 수 있지만, 그 답이 팀의 자산으로 남지 않으면 다음 작업에서 다시 처음부터 시작하게 됩니다.

ACE는 이 흐름을 정리하기 위한 시도입니다.

- 아이디어를 `research → model → plan → judge`로 검증합니다.
- 개발 요건을 `analyze → design → dev → test`로 단계화합니다.
- 작업 과정에서 생긴 결정과 검증 결과를 `workspace/wiki`에 남깁니다.
- Claude Code, Codex처럼 실행 엔진이 달라져도 같은 산출물 구조를 유지합니다.
- 기획이 불명확하면 유추해서 구현하지 않고, 먼저 사용자에게 확인합니다.

즉 ACE의 목표는 “AI가 알아서 잘하게 만들기”가 아니라, **AI와 사람이 같은 작업 기준 위에서 덜 흔들리게 만드는 것**입니다.

## 어디에 도움이 되나

ACE는 아래 상황에서 특히 유용합니다.

- 사업 아이디어를 빠르게 검토하고, 개발 착수 여부를 판단해야 할 때
- 여러 사용자가 AI 에이전트와 협업하면서 산출물 품질을 맞춰야 할 때
- Claude Code에서 쓰던 작업 흐름을 Codex에서도 이어가고 싶을 때
- 기획, 설계, 구현, 테스트, 회고가 채팅 안에 흩어지는 것을 막고 싶을 때
- “어제 왜 이렇게 결정했지?”를 다시 찾을 수 있는 내부 기록이 필요할 때
- AI가 요구사항을 추측해서 구현하는 일을 줄이고 싶을 때

## 어디에 쓸 수 있나

ACE는 크게 두 가지 팩으로 동작합니다.

`dev` 팩은 개발 작업용입니다.

- 요구사항 분석
- 아키텍처/API/UI 설계
- 코드 구현
- 테스트 및 검증
- 코드베이스 진단
- 빠른 버그 수정

`biz` 팩은 사업 검증용입니다.

- 시장/경쟁 리서치
- 비즈니스 모델 설계
- MVP와 실행 계획 수립
- Go/No-Go/Pivot 판단

공통 스킬은 작업 운영을 돕습니다.

- `ace-status`: 현재 파이프라인 상태 확인
- `ace-wiki`: 작업 기록과 결정 사항을 내부 위키로 누적
- `ace-retrospect`: 협업 패턴 회고
- `ace-coach`: AI 활용 방식 코칭
- `ace-karpathy-harness`: context map, execution harness, verification gates 설계

## 설치

- macOS / Linux: [README.mac.md](/Users/hjkim/project/ace/README.mac.md)
- Windows: [README.windows.md](/Users/hjkim/project/ace/README.windows.md)

설치 스크립트:

- macOS / Linux: `install.sh`
- Windows: `install.ps1`

## 기본 흐름

ACE는 이렇게 씁니다.

1. ACE를 한 번 전역 설치합니다.
2. 작업할 프로젝트 폴더로 이동합니다.
3. `ace init`으로 그 프로젝트에 ACE 구성을 심습니다.
4. 필요하면 `ace export-codex --global`로 Codex 전역 스킬에 동기화합니다.
5. `analyze → design → dev → test` 또는 `research → model → plan → judge` 흐름을 사용합니다.
6. 작업이 끝나면 `ace-wiki`로 이력과 결정을 누적합니다.

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

## 프로젝트에 생기는 것

`ace init`을 실행하면 프로젝트 안에 아래가 생성됩니다.

- `.ace/profile.yaml`
- `.ace/templates/`
- `.claude/skills/`
- `.claude/agents/`
- `.claude/rules/`
- `workspace/current/`
- `workspace/tasks/`
- `workspace/wiki/`

즉, ACE 코어와 Codex 스킬은 전역에 둘 수 있고, 프로젝트별 컨텍스트와 산출물은 로컬에 둡니다.

`workspace/current`는 번호 없는 현재 작업을 위한 공간입니다.
`workspace/tasks`는 이슈/태스크 단위 작업을 위한 공간입니다.
`workspace/wiki`는 작업 이력, 결정 기록, 운영 메모를 누적하는 내부 위키입니다.

## Codex 사용

Codex 앱/CLI에서 ACE 스킬을 쓰려면:

```bash
ace export-codex --pack all --global
```

그 다음 Codex를 재시작하면 `$ace-analyze`, `$ace-dev`, `$ace-research`, `$ace-coach` 같은 스킬을 사용할 수 있습니다.
하네스 자체를 점검하려면 `$ace-karpathy-harness`로 context map, execution harness, verification gates를 설계할 수 있습니다.
작업 이력과 내부 지식은 `$ace-wiki`로 `workspace/wiki`에 누적합니다.

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

개발 작업에서는 추가로 **기획 정의 우선 원칙**을 적용합니다.
목표, 범위, 사용자 흐름, 데이터/API, 예외/권한, acceptance criteria가 불명확하면 구현하지 않고 먼저 질문합니다.
사용자가 명시적으로 “가정하고 진행”을 승인한 경우에만 가정을 기록하고 진행합니다.

## ACE가 지향하는 것

ACE는 완성된 정답이라기보다, AI 협업을 운영 가능한 형태로 만들기 위한 기반입니다.

좋은 모델을 고르는 일도 중요하지만, 장기적으로 더 중요한 것은 어느 에이전트를 쓰더라도 팀의 실행력이 유지되는 구조입니다.
ACE는 그 구조를 만들기 위해 산출물, 규칙, 검증, 위키 기록을 함께 다룹니다.

작업이 쌓일수록 채팅은 사라지고, 산출물과 위키가 남아야 합니다.
ACE는 그 기록을 다음 작업의 출발점으로 만드는 것을 목표로 합니다.

## 저장소 주소

- GitHub: `https://github.com/Leafic/ace`

## 라이선스

MIT
