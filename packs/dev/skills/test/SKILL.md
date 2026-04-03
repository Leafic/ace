---
name: ace-test
description: "테스트 계획 수립/실행/문서화"
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

# /ace test — 테스트 계획/실행/문서화

## 사용법

```
/ace test [이슈번호]
```

## 선행 조건
- 없음 (개발 완료 전에도 테스트 계획 수립 가능)
- 단, development 완료 시 자동 검증 권장

## 실행 흐름

### Step 1: 컨텍스트 수집

1. analysis.md, design.md, development.md 읽기
2. 구현된 코드 파악
3. 기존 테스트 코드 확인

### Step 2: 에이전트 호출

`tester` 에이전트를 호출한다.

**에이전트 입력:**
```
- 이슈번호, 태스크 폴더 경로
- 산출물들 (analysis, design, development)
- 구현된 소스코드 경로
- 기존 테스트 코드
```

### Step 3: 테스트 계획 수립

**테스트 범위:**
1. **단위 테스트**: 서비스 로직, 유틸리티 함수
2. **API 테스트**: 엔드포인트 요청/응답 검증
3. **컴포넌트 테스트**: UI 렌더링, 인터랙션
4. **통합 테스트**: API → DB 흐름 검증

**우선순위:**
- 핵심 비즈니스 로직 > 엣지케이스 > 헬퍼 함수
- 새로 추가된 코드 > 수정된 코드

### Step 4: 테스트 작성/실행

- 백엔드: pytest + httpx (AsyncClient)
- 프론트엔드: Vitest + React Testing Library
- 테스트 실행 결과 기록

### Step 5: 설계 대비 리뷰

`reviewer` 에이전트를 호출하여 설계 vs 구현 정합성을 검증한다:
- 누락된 기능
- 추가된 기능 (설계에 없는)
- 변경된 동작
- 컨벤션 위반

리뷰 결과를 test.md에 추가.

### Step 6: 산출물 작성

`workspace/tasks/{번호}/test.md`를 작성한다.

**섹션:**
1. 테스트 범위/전략
2. 테스트 케이스 목록
3. 실행 결과 (통과/실패)
4. 설계 대비 리뷰 결과
5. 잔존 리스크

### Step 7: 상태 갱신

- test.md frontmatter: `status: done`
- taskDetail.json: `steps.test.status: completed`

## 완료 시 출력

```
═══ 테스트 완료 요약 (#{번호}) ═══

[핵심 결론]
- 테스트 커버리지, 통과/실패 현황

[주요 결정 사항]
1. ...

[미해결/리스크]
- ...
```
