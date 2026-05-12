---
name: ace-retrospect
description: "대화 로그, memory.md, CLAUDE.md, 태스크 산출물을 읽어 협업 패턴과 개선점을 회고 보고서로 정리합니다. 사용자가 '회고', '멘토링', '패턴 분석', '협업 리뷰'를 언급할 때 사용하세요."
argument-hint: "[경로 또는 생략]"
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Agent
  - AskUserQuestion
---

# /ace retrospect — 협업 회고 / 패턴 분석

## 사용법

```
/ace-retrospect
/ace-retrospect workspace/current
/ace-retrospect workspace/tasks/12
/ace-retrospect docs/session-notes.md
```

경로를 생략하면 `workspace/current/retrospect.md`를 사용한다.

## 목적

대화 로그, 프로젝트 문맥 문서, 태스크 산출물을 읽어 다음을 구조화한다.

- 어떤 협업 패턴이 반복됐는가
- 무엇이 잘 작동했는가
- 어떤 실수/마찰/누락이 있었는가
- 다음 세션에서 무엇을 바꿔야 하는가

이 스킬은 특정 에이전트 기능에 종속되지 않는다.
Claude 로그, Codex 메모, 프로젝트 산출물, Markdown 세션 요약을 모두 입력 자산으로 재사용할 수 있게 설계한다.

## 핵심 원칙

1. **로그보다 패턴을 본다** — 메시지 하나하나보다 반복되는 행동을 찾는다.
2. **칭찬과 비판을 함께 남긴다** — 잘한 점과 개선점이 모두 있어야 다음 작업에 쓸 수 있다.
3. **구조 바깥 자산을 우선한다** — 채팅 UI 안의 맥락보다 파일로 남은 문맥과 산출물을 더 신뢰한다.
4. **추측보다 근거를 쓴다** — 판단마다 근거가 된 파일/패턴을 짧게 남긴다.
5. **행동으로 끝낸다** — 마지막엔 다음 세션에서 바꿀 습관/체크리스트가 있어야 한다.

## 입력 우선순위

### 경로를 명시한 경우

다음 중 존재하는 것을 우선 읽는다.

- 지정한 파일 또는 디렉토리
- 디렉토리인 경우 그 안의 `*.md`, `taskDetail.json`, `INDEX.md`, `memory.md`

### 경로를 생략한 경우

다음 순서로 입력을 모은다.

1. `workspace/current/`
2. `memory.md`
3. `CLAUDE.md`
4. `README.md`
5. 최근 생성된 `workspace/tasks/*/*.md`

## 출력 위치

- 경로 생략: `workspace/current/retrospect.md`
- `workspace/tasks/{번호}` 지정: `workspace/tasks/{번호}/retrospect.md`
- 파일 경로 지정: 같은 디렉토리에 `retrospect.md`

## ⚡ 이어하기 규칙

### 실행 전 체크

1. 대상 디렉토리의 `retrospect.md` 존재 여부를 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → 필요 시 재작성 여부만 확인
   - `status: in_progress` → 이어하기 모드

### 이어하기 모드

1. 기존 retrospect.md를 읽고 완료된 섹션을 파악한다.
2. 비어 있거나 `(TODO)`인 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 다시 쓰지 않는다.

## 분석 관점

아래 6개 관점을 기본으로 본다.

1. **Goal** — 목적이 초반에 충분히 명확했는가
2. **Context** — 필요한 문맥이 파일로 남아 있었는가
3. **Verify** — 사실 확인과 검증이 충분했는가
4. **Orchestration** — 작업 순서와 산출물 연결이 자연스러웠는가
5. **Friction** — 반복된 마찰/실수/막힘은 무엇이었는가
6. **Next** — 다음 세션에서 바꿔야 할 행동은 무엇인가

## 실행 흐름

### Step 1: 입력 자산 스캔

- 읽을 문서 목록 정리
- 어떤 파일이 문맥이고 어떤 파일이 산출물인지 분류
- 로그형 문서가 있으면 최근 패턴을 요약

→ retrospect.md에 "입력 자산" 섹션 저장

### Step 2: 잘 작동한 패턴

- 명확했던 요청 방식
- 도움이 됐던 문맥 문서
- 다음 단계로 자연스럽게 이어진 산출물

→ "잘 작동한 점" 섹션 저장

### Step 3: 마찰 / 안티패턴

- 같은 설명 반복
- 문맥 누락
- 검증 부족
- 파일은 있는데 다음 단계로 안 이어짐
- 채팅 안에서만 끝난 결정

→ "마찰과 안티패턴" 섹션 저장

### Step 4: 6관점 점검

각 관점에 대해 1-2줄씩 요약한다.

- Goal
- Context
- Verify
- Orchestration
- Friction
- Next

→ "6관점 요약" 섹션 저장

### Step 5: 다음 세션 가이드

다음 세션에서 바로 쓸 수 있는 체크리스트 작성:

- 시작 전에 확인할 문서
- 먼저 만들 산출물
- 피해야 할 습관
- 다음에 남겨야 할 파일

→ "다음 세션 체크리스트" 섹션 저장, status: done

## 출력 형식

`retrospect.md`

```yaml
---
status: in_progress  # → done
date: {{date}}
target: {{분석 대상}}
summary: "협업 회고 — 강점 X개, 개선점 X개"
---
```

본문 구조:

```md
# 협업 회고

## 1. 입력 자산

## 2. 잘 작동한 점

## 3. 마찰과 안티패턴

## 4. 6관점 요약

## 5. 다음 세션 체크리스트
```

## 완료 시 출력

```text
═══ 협업 회고 완료 ═══

[한 줄 요약]
- 이번 세션/프로젝트에서 반복된 패턴

[잘 작동한 점]
- ...

[개선이 필요한 점]
- ...

[다음 세션 체크리스트]
1. ...
2. ...
3. ...
```
