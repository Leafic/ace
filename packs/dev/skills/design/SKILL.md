---
name: ace-design
description: "분석 결과를 기반으로 파일목록/데이터모델/API/UI/설계결정을 포함한 design.md를 작성합니다. 사용자가 '설계', '아키텍처', 'API 설계'를 언급할 때 사용하세요."
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

## 에이전트 사용 규칙

### 에이전트 호출 조건
- **메인 세션이 직접 수행** (기본): 섹션 1-2개 작성, API 3개 이하, 테이블 변경 2개 이하
- **에이전트 위임**: API 10개 이상이거나 화면 5개 이상의 대규모 설계만
- **병렬 에이전트 금지**: 같은 산출물을 여러 에이전트가 동시에 쓰지 않는다
- **큰 파일 주의**: 필요한 부분만 offset/limit로 읽어서 요약 후 전달

### 폴백
1. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면 메인 세션이 직접 수행한다.
2. `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.
4. 에이전트의 중간 출력을 직접 읽지 않는다. 최종 결과만 수신한다.

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
