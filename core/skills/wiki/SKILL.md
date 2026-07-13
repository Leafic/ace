---
name: ace-wiki
description: "작업 산출물과 대화/결정 기록을 바탕으로 workspace/wiki 내부 위키를 갱신합니다. 사용자가 '위키', '작업 기록', '이력관리', '내부 문서화', '히스토리', '작업 로그'를 언급하거나 작업 완료 후 지식 축적이 필요할 때 사용하세요."
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

# /ace wiki — 내부 위키 / 작업 이력 관리

## 사용법

```
/ace-wiki
/ace-wiki workspace/current
/ace-wiki workspace/tasks/12
```

경로를 생략하면 최근 작업 산출물을 기준으로 `workspace/wiki/`를 갱신한다.

## 목적

작업 산출물은 개별 태스크의 결과이고, 위키는 시간이 지나도 팀이 다시 찾을 수 있는 내부 지식이다.
이 스킬은 매 작업의 목적, 결정, 변경, 검증, 후속 과제를 `workspace/wiki`에 순차 기록한다.

## 위키 저장 위치

- 인덱스: `workspace/wiki/INDEX.md`
- 작업 로그: `workspace/wiki/work-log.md`
- 결정 기록: `workspace/wiki/decisions.md`
- 운영/하네스 메모: `workspace/wiki/harness.md`
- 태스크별 상세 기록: `workspace/wiki/tasks/{taskId}.md`
- 번호 없는 작업 기록: `workspace/wiki/current.md`

## 기초 원칙

1. **산출물은 그대로 두고, 위키는 요약한다** — analysis/design/development/test 전체를 복사하지 않는다.
2. **왜를 남긴다** — 무엇을 했는지보다 왜 그렇게 결정했는지를 우선 기록한다.
3. **검증을 남긴다** — 실행한 테스트, 실패, 미검증 영역을 명확히 기록한다.
4. **시간순으로 쌓는다** — 최신 기록을 위에 추가하고, 이전 기록을 덮어쓰지 않는다.
5. **민감정보를 제거한다** — 토큰, 개인 정보, 내부 고객명, 비공개 URL은 마스킹한다.

## 입력 우선순위

### 경로를 명시한 경우

- 지정한 파일 또는 디렉토리
- 디렉토리인 경우 `analysis.md`, `design.md`, `development.md`, `test.md`, `research.md`, `model.md`, `plan.md`, `judgement.md`, `planning/request.md`, `harness.md`, `retrospect.md`

### 경로를 생략한 경우

1. `workspace/current/*.md`
2. 최근 수정된 `workspace/tasks/*/*.md`
3. `git diff --stat`, `git log -1 --oneline`
4. `README.md`, `.ace/profile.yaml`

## 이어하기 규칙

### 실행 전 체크

1. `workspace/wiki/`가 없으면 생성한다.
2. `INDEX.md`, `work-log.md`, `decisions.md`, `harness.md`가 없으면 템플릿으로 생성한다.
3. 이미 같은 태스크/작업 기록이 있으면 새 항목을 추가하되 기존 내용을 덮어쓰지 않는다.

위키 문서 자체는 frontmatter 없이 누적 문서로 관리한다.
태스크별 상세 기록을 새로 만들 때는 필요하면 `status: in_progress`로 시작하고 기록 완료 후 `status: done`으로 바꾼다.

## 실행 흐름

### Step 1: 작업 범위 식별

- 작업이 `workspace/tasks/{번호}` 기반인지 `workspace/current` 기반인지 판단한다.
- 작업 제목, 날짜, 관련 산출물, 변경 파일을 수집한다.
- 목적과 완료 기준이 기록되어 있는지 확인한다.

→ 필요한 경우 `workspace/wiki/tasks/{번호}.md` 또는 `workspace/wiki/current.md` 생성

### Step 2: 작업 요약 작성

아래 항목을 짧게 기록한다.

- 작업 목적
- 변경/산출물 요약
- 주요 결정
- 검증 결과
- 남은 리스크
- 다음 액션

→ `work-log.md` 최상단에 새 항목 추가

### Step 3: 결정 기록 갱신

장기적으로 의미 있는 결정만 `decisions.md`에 추가한다.

추가 기준:
- API/DB/UI 흐름이 바뀜
- 하네스/스킬/규칙이 바뀜
- 기술 선택이나 운영 방식이 바뀜
- 나중에 왜 이렇게 했는지 다시 물을 가능성이 높음

추가하지 않을 것:
- 단순 오타 수정
- 포맷팅
- 임시 테스트 로그
- 산출물 전문 복사

### Step 4: 하네스 메모 갱신

작업 중 발견한 반복 실수, 검증 누락, 문맥 전달 문제, 스킬 개선점이 있으면 `harness.md`에 추가한다.

### Step 5: 인덱스 갱신

`INDEX.md`에 최근 작업, 주요 결정, 관련 태스크 링크를 갱신한다.

## 출력 형식

`workspace/wiki/work-log.md` 항목:

```md
## {{date}} — {{작업 제목}}

- 대상: `workspace/tasks/{{id}}` 또는 `workspace/current`
- 목적: ...
- 산출물: ...
- 주요 결정: ...
- 검증: ... (gate 채점이 있으면 `{총점}/100 {등급} passed={true|false}` 형식으로 기록 — development.md frontmatter의 gateScore/gateGrade/gatePassed에서)
- 남은 리스크: ...
- 다음 액션: ...
```

`workspace/wiki/decisions.md` 항목:

```md
## ADR-{{number}} — {{결정 제목}}

- 날짜: {{date}}
- 상태: accepted | superseded | proposed
- 배경: ...
- 결정: ...
- 대안: ...
- 영향: ...
- 관련 작업: ...
```

## 완료 시 출력

```
═══ 위키 갱신 완료 ═══

[갱신 파일]
- workspace/wiki/INDEX.md
- workspace/wiki/work-log.md
- workspace/wiki/decisions.md

[핵심 기록]
- 작업 목적/결정/검증/후속 과제 요약

[다음 명령]
→ /ace-status      전체 파이프라인 현황 확인
→ /ace-retrospect  누적 협업 패턴 회고
```
