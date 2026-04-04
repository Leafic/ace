---
name: ace-design
description: "아키텍처/API/UI 설계"
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

# /ace design — 아키텍처/API/UI 설계

## 사용법

```
/ace-design [이슈번호]
```

## 선행 조건
- solo 모드: analysis 완료 또는 스킵 가능
- team 모드: analysis 완료 필수

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. `workspace/tasks/{번호}/design.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 설계입니다. 재설계하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 design.md를 읽어 **어떤 섹션까지 작성되었는지** 파악한다.
2. 비어있는 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 **절대 다시 작성하지 않는다.**

### 섹션별 저장
각 섹션 완료 시마다 design.md를 **즉시 저장**한다.

## 에이전트 폴백 규칙

1. `designer` 에이전트를 호출한다.
2. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면:
   - 메인 세션이 직접 해당 섹션을 수행한다.
   - `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. analysis.md 읽기 (있으면)
2. 스택 컨벤션 로딩 (.claude/rules/conv-*.md)
3. 기존 코드베이스 구조 파악

**이어하기 시**: 기존 design.md의 완료 섹션 파악 후 스킵.

### Step 2: 섹션별 설계 (완료된 섹션 스킵)

**섹션 1. 변경 개요**
- 수정/추가할 파일 목록
→ 완료 시 design.md 저장

**섹션 2. 데이터 모델**
- 테이블/컬럼 변경, DDL
→ 완료 시 design.md 저장

**섹션 3. API 설계**
- 엔드포인트, 요청/응답 스키마, 에러 응답
→ 완료 시 design.md 저장

**섹션 4. UI 설계**
- 컴포넌트 구조, 상태 관리, 인터랙션
→ 완료 시 design.md 저장

**섹션 5. 설계 결정**
- 트레이드오프 기록
→ 완료 시 design.md 저장, status: done

### Step 3: 상태 갱신

- design.md frontmatter: `status: done`
- taskDetail.json: `steps.design.status: completed`

## 완료 시 출력

```
═══ 설계 완료 요약 (#{번호}) ═══

[핵심 결론]
- 수정 파일 수, API/DB 변경 여부, 아키텍처 결정

[주요 결정 사항]
1. ...

[미해결/리스크]
- ...

[다음 명령]
→ /ace-dev     설계 기반 코드 구현
→ /ace-status  전체 파이프라인 현황 확인
```
