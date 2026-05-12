---
name: ace-dev-quick
description: "분석/설계 없이 바로 코드를 구현합니다. 버그 수정, 소규모 변경, 설정 수정 등 간단한 작업용. 사용자가 '빠른 수정', '버그픽스', '간단한 변경'을 언급할 때 사용하세요."
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
/ace-dev-quick [이슈번호]
/ace-dev-quick
```

## 용도
- 버그 수정, 소규모 변경, 설정 수정 등
- 분석/설계가 불필요한 간단한 작업

## 번호 없는 실행 모드

- 이슈번호가 없으면 `workspace/current/` 디렉토리를 생성해서 사용한다.
- 산출물은 `workspace/current/development.md`에 저장한다.
- 이 경우 `taskDetail.json` 갱신은 생략하고, 변경 내용과 검증 결과만 기록한다.

## 실행 흐름

### Step 1: 전처리

pending 상태인 analysis, design을 `skipped`로 변경한다.
(이미 completed인 경우는 변경하지 않음)
이슈번호가 없으면 이 단계는 생략한다.

### Step 2: 구현

사용자의 요청을 바로 구현한다.
- 스택 컨벤션은 동일하게 적용
- development.md에 변경 내용 기록

### Step 3: 간이 검증

가능하면 `gate` 에이전트로 코드 품질을 검증한다.
현재 실행 환경에서 보조 에이전트가 허용되지 않으면 메인 세션이 직접 리뷰한다.
full dev와 동일한 검증이지만 설계 대비 체크는 생략한다.

### Step 4: 상태 갱신

- development.md frontmatter: `status: done`
- 이슈번호가 있을 때만 taskDetail.json의 `steps.development.status: completed` 갱신

## 규칙

- analysis, design이 이미 completed이면 그 산출물을 참고하되 스킵하지 않음
- 검증은 생략하지 않음 (컨벤션/보안 체크는 항상 수행)

## 완료 시 출력

```
═══ 빠른 개발 완료 요약 ═══

[변경 내용]
- 수정 파일과 핵심 변경

[검증]
- 실행한 명령과 결과

[다음 명령]
→ /ace-test    필요 시 테스트 계획/실행
→ /ace-status  전체 파이프라인 현황 확인
```
