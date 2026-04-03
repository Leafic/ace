---
name: ace-dev-quick
description: "설계 없이 바로 개발 (버그픽스, 소규모 수정)"
argument-hint: "[이슈번호]"
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

# /ace dev-quick — 간편 개발 (분석/설계 스킵)

## 사용법

```
/ace dev-quick [이슈번호]
```

## 용도
- 버그 수정, 소규모 변경, 설정 수정 등
- 분석/설계가 불필요한 간단한 작업

## 실행 흐름

### Step 1: 전처리

pending 상태인 analysis, design을 `skipped`로 변경한다.
(이미 completed인 경우는 변경하지 않음)

### Step 2: 구현

사용자의 요청을 바로 구현한다.
- 스택 컨벤션은 동일하게 적용
- development.md에 변경 내용 기록

### Step 3: 간이 검증

`gate` 에이전트로 코드 품질 검증 (자동 수정 포함).
full dev와 동일한 검증이지만 설계 대비 체크는 생략.

### Step 4: 상태 갱신

- development.md frontmatter: `status: done`
- taskDetail.json: `steps.development.status: completed`

## 규칙

- analysis, design이 이미 completed이면 그 산출물을 참고하되 스킵하지 않음
- 검증은 생략하지 않음 (컨벤션/보안 체크는 항상 수행)
