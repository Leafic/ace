---
name: ace-analyze
description: "요구사항 다관점 분석"
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

# /ace analyze — 요구사항 분석

## 사용법

```
/ace-analyze [이슈번호]
```

## 선행 조건
- 태스크가 생성되어 있어야 함 (`/ace-task start`)

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. `workspace/tasks/{번호}/analysis.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 분석입니다. 재분석하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 analysis.md를 읽어 **어떤 섹션까지 작성되었는지** 파악한다.
2. 비어있거나 `(미완료)`, `(TODO)` 마커가 있는 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 **절대 다시 작성하지 않는다.**

### 섹션별 저장
각 섹션 완료 시마다 analysis.md를 **즉시 저장**한다.

## 에이전트 폴백 규칙

1. `analyzer` 에이전트를 호출한다.
2. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면:
   - 메인 세션이 직접 해당 섹션을 수행한다.
   - `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.

## 실행 흐름

### Step 1: 입력 수집

- 이슈 트래커의 설명/첨부
- `workspace/tasks/{번호}/planning/` 폴더의 기획서
- 사용자가 대화로 제공한 요구사항

**이어하기 시**: 기존 analysis.md 상단 요약이 있으면 스킵.

### Step 2: 섹션별 분석 (완료된 섹션 스킵)

**섹션 1. 기능 요구사항**
- 구현해야 할 기능 목록, 우선순위
→ 완료 시 analysis.md 저장

**섹션 2. 데이터 모델**
- 필요한 엔티티/관계/속성
→ 완료 시 analysis.md 저장

**섹션 3. API 윤곽**
- 필요한 엔드포인트와 기본 스키마
→ 완료 시 analysis.md 저장

**섹션 4. 예외/엣지케이스**
- 비정상 흐름, 경계 조건
→ 완료 시 analysis.md 저장

**섹션 5. 미해결 사항**
- 기획 모호성, 추가 확인 필요 항목
→ 완료 시 analysis.md 저장, status: done

### Step 3: 상태 갱신

- analysis.md frontmatter: `status: done`
- taskDetail.json: `steps.analysis.status: completed`

## 완료 시 출력

```
═══ 분석 완료 요약 (#{번호}) ═══

[핵심 결론]
- (1-3줄)

[주요 결정 사항]
1. ...

[미해결/리스크]
- ...

[다음 단계 참고]
- 설계 시 확인할 핵심 포인트
```
