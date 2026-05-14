---
name: ace-karpathy-harness
description: "Andrej Karpathy의 Software 3.0, 문맥 설계, 에이전트 운영 설계 방향성을 바탕으로 에이전트 하네스 구조를 설계하여 harness.md를 작성합니다. 사용자가 '카파시', '하네스', '에이전트 운영', '문맥 설계', 'vibe coding 이후', '에이전트 운영 구조'를 언급할 때 사용하세요."
argument-hint: "[경로 또는 생략]"
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

# /ace karpathy-harness — 에이전트 하네스 설계

## 사용법

```
/ace-karpathy-harness
/ace-karpathy-harness workspace/current
/ace-karpathy-harness docs/agent-workflow.md
```

경로를 생략하면 `workspace/current/harness.md`를 사용한다.

## 목적

프로젝트의 AI 작업 방식을 단순 프롬프트 묶음이 아니라 **에이전트가 반복적으로 성공하도록 돕는 하네스**로 설계한다.

이 스킬은 Andrej Karpathy가 말한 Software 3.0, 문맥 설계, 에이전트 운영 설계 방향을 ACE에 맞게 운영 구조로 변환한다.
단, "harness engineering"이라는 용어 자체를 특정 개인에게 귀속하지 않는다. 여기서는 카파시 방향성에 OpenAI식 하네스 운영 관점을 결합해 사용한다.

## 핵심 원칙

1. **LLM은 새 컴퓨터다** — 코드는 전부가 아니라 실행 가능한 인터페이스 중 하나다.
2. **프롬프트보다 컨텍스트가 중요하다** — 긴 설명서보다 작은 문맥 지도와 최신 파일을 우선한다.
3. **인간은 방향을 잡고, 에이전트는 실행한다** — 목표/제약/검증 기준은 인간이 명확히 해야 한다.
4. **하네스가 반복 실패를 흡수한다** — 같은 실수는 프롬프트로 꾸짖지 말고 규칙, 체크, 테스트, 산출물로 막는다.
5. **코드는 신뢰 전 검증 대상이다** — AI가 만든 코드는 항상 테스트, 리뷰, diff 확인을 거친다.

## 카르파시 4원칙 적용

| 원칙 | 하네스 적용 |
|------|------------|
| Think Before Coding | 작업 전 목표 계약, 가정, 완료 기준을 문서화한다. |
| Simplicity First | 거대한 AGENTS/CLAUDE 문서보다 작은 스킬, 규칙, 산출물로 쪼갠다. |
| Surgical Changes | 에이전트가 바꿀 수 있는 파일/범위/권한을 좁게 제한한다. |
| Goal-Driven Execution | 테스트, 리뷰, 상태 갱신, 다음 액션으로 루프를 닫는다. |

## 입력 우선순위

### 경로를 명시한 경우

- 지정한 파일 또는 디렉토리
- 디렉토리인 경우 `README.md`, `CLAUDE.md`, `AGENTS.md`, `.ace/profile.yaml`, `.claude/rules/*.md`, `workspace/current/*.md`, `workspace/tasks/*/*.md`

### 경로를 생략한 경우

1. `.ace/profile.yaml`
2. `README.md`
3. `CLAUDE.md` 또는 `AGENTS.md`
4. `core/conv-*.md`, `.claude/rules/*.md`
5. `workspace/current/*.md`
6. 최근 `workspace/tasks/*/*.md`

## 출력 위치

- 경로 생략: `workspace/current/harness.md`
- 디렉토리 지정: 해당 디렉토리의 `harness.md`
- 파일 지정: 같은 디렉토리의 `harness.md`

## 이어하기 규칙

### 실행 전 체크

1. 대상 디렉토리의 `harness.md` 존재 여부를 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → 필요 시 재작성 여부만 확인
   - `status: in_progress` → 이어하기 모드

### 이어하기 모드

1. 기존 harness.md를 읽고 완료된 섹션을 파악한다.
2. 비어 있거나 `(TODO)`인 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 다시 쓰지 않는다.

## 실행 흐름

### Step 1: 현재 하네스 지도 작성

- 어떤 에이전트/스킬/문서/규칙/테스트가 있는지 나열한다.
- 실제로 쓰이는 것과 죽은 문서를 구분한다.
- 큰 문서 하나에 몰린 규칙이 있으면 작은 단위로 나눌 후보를 표시한다.

→ harness.md에 "현재 하네스 지도" 섹션 저장

### Step 2: 목표 계약 정의

작업 시작 전에 에이전트가 알아야 할 계약을 정리한다.

- 목표: 무엇을 달성해야 하는가
- 비목표: 이번 작업에서 하지 않을 것
- 입력: 읽어야 할 문서/파일
- 출력: 생성/수정해야 할 산출물
- 완료 기준: 어떤 테스트/검증을 통과해야 하는가
- 위험 범위: DB, 인증, 결제, 배포, 개인정보 등 승인 필요한 영역

→ "목표 계약" 섹션 저장

### Step 3: 문맥 지도 설계

에이전트에게 긴 매뉴얼을 먹이지 말고 탐색 가능한 문맥 지도를 만든다.

- 항상 읽을 파일
- 조건부로 읽을 파일
- 읽지 말아야 할 오래된 파일
- 스킬별 입력/출력 연결
- 최신 상태 확인 명령

→ "문맥 지도" 섹션 저장

### Step 4: 실행 하네스 설계

에이전트 실행을 안정화하는 장치를 정의한다.

- 파일 권한/수정 범위
- 단계별 산출물: analysis, design, development, test, research 등
- 실패 복구 루프: 테스트 실패, lint 실패, 리뷰 실패 시 행동
- 멀티 에이전트 사용 조건: 병렬 가능 작업과 금지 작업
- 상태 저장: `workspace/current`, `workspace/tasks`, frontmatter status

→ "실행 하네스" 섹션 저장

### Step 5: 검증 관문 설계

프롬프트 약속이 아니라 기계적으로 확인 가능한 게이트를 우선한다.

- 최소 명령: lint, test, build, typecheck, doctor, validate-skills
- 변경 전/후 diff 확인
- 민감 컨텍스트 검색
- 하네스 회귀 테스트
- 수동 확인이 필요한 영역

→ "검증 관문" 섹션 저장

### Step 6: 개선 백로그 작성

하네스 개선을 한 번에 다 하지 말고 작은 작업으로 쪼갠다.

- 즉시 적용할 개선
- 다음 커밋으로 분리할 개선
- 아직 가정 검증이 필요한 개선
- 만들면 안 되는 과한 자동화

→ "개선 백로그" 섹션 저장, status: done

## 출력 형식

`harness.md`

```yaml
---
status: in_progress  # → done
date: {{date}}
target: {{분석 대상}}
summary: "에이전트 하네스 설계 — 핵심 개선 X개, 검증 게이트 X개"
---
```

본문 구조:

```md
# 에이전트 하네스 설계

## 1. 현재 하네스 지도

## 2. 목표 계약

## 3. 문맥 지도

## 4. 실행 하네스

## 5. 검증 관문

## 6. 개선 백로그
```

## 완료 시 출력

```
═══ 하네스 설계 완료 ═══

[핵심 방향]
- 프롬프트보다 문맥 지도 / 검증 관문 / 상태 저장을 우선

[즉시 적용할 개선]
1. ...
2. ...
3. ...

[주의할 점]
- 과한 자동화 또는 범위 밖 변경

[다음 명령]
→ /ace-status           전체 파이프라인 현황 확인
→ /ace-coach            AI 활용 습관 코칭
→ /ace-retrospect       협업 패턴 회고
```
