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
/ace-test [이슈번호]
```

## 선행 조건
- 없음 (개발 완료 전에도 테스트 계획 수립 가능)

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. `workspace/tasks/{번호}/test.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 테스트입니다. 재실행하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 test.md를 읽어 **어떤 섹션까지 작성되었는지** 파악한다.
2. 비어있는 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 **절대 다시 작성하지 않는다.**

### 섹션별 저장
각 섹션 완료 시마다 test.md를 **즉시 저장**한다.

## 에이전트 폴백 규칙

1. `tester` 에이전트를 호출한다.
2. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면:
   - 메인 세션이 직접 해당 섹션을 수행한다.
   - `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.
4. `reviewer` 서브에이전트도 동일 규칙 적용.

## 실행 흐름

### Step 1: 컨텍스트 수집

1. analysis.md, design.md, development.md 읽기 (있는 것만)
2. 구현된 코드 파악
3. 기존 테스트 코드 확인

**이어하기 시**: 기존 test.md의 완료 섹션 파악 후 스킵.

### Step 2: 섹션별 테스트 (완료된 섹션 스킵)

**섹션 1. 테스트 전략/범위**
- 단위/API/컴포넌트/통합 테스트 범위 정의
→ 완료 시 test.md 저장

**섹션 2. 테스트 케이스 목록**
- 백엔드 + 프론트엔드 테스트 케이스
→ 완료 시 test.md 저장

**섹션 3. 테스트 작성/실행**
- 테스트 코드 작성 + 실행 결과
→ 완료 시 test.md 저장

**섹션 4. 설계 대비 리뷰**
- reviewer 에이전트 호출 (설계 vs 구현 정합성)
→ 완료 시 test.md 저장

**섹션 5. 잔존 리스크**
- 미커버 영역, 알려진 이슈
→ 완료 시 test.md 저장, status: done

### Step 3: 상태 갱신

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
