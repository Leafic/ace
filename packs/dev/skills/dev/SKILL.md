---
name: ace-dev
description: "design.md 기반으로 DB→백엔드→프론트엔드 순서로 코드를 구현하고 gate 에이전트로 자동 검증합니다. 사용자가 '개발', '구현', '코딩'을 언급할 때 사용하세요."
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

# /ace dev — 코드 구현

## 사용법

```
/ace-dev [이슈번호]
```

## 선행 조건
- solo 모드: design 완료 또는 스킵 가능
- team 모드: design 완료 필수

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. `workspace/tasks/{번호}/development.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 구현입니다. 추가 작업하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 development.md를 읽어 **어떤 항목까지 구현되었는지** 파악한다.
2. "구현 완료 항목" 테이블과 "다음 작업" 체크리스트를 확인한다.
3. 미완료 항목부터 이어서 구현한다.
4. 이미 구현 완료된 코드를 **절대 다시 작성하지 않는다.**

### 항목별 저장
각 구현 항목 완료 시마다 development.md를 **즉시 갱신**한다.

## 에이전트 폴백 규칙

구현 완료 후 자동 검증 시:
1. `gate` 에이전트를 호출한다.
2. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면:
   - 메인 세션이 직접 검증을 수행한다.
   - development.md에 `<!-- gate 에이전트 실패 — 메인 세션에서 직접 검증 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.
4. 에이전트의 중간 출력(도구 실행 로그, 사고 과정)을 직접 읽지 않는다. 최종 결과만 수신한다.

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. design.md 읽기 (없으면 analysis.md)
2. 스택 컨벤션 로딩
3. 기존 코드 파악 (변경 대상 파일)

**이어하기 시**: development.md의 완료/미완료 항목 파악.

### Step 2: 구현 (완료된 항목 스킵)

design.md 기반으로 코드를 구현한다.

**구현 순서:**
1. DB 마이그레이션 (스키마 변경이 있으면)
2. 백엔드 — 모델 → 스키마 → 서비스 → 라우터
3. 프론트엔드 — 타입 → API → 컴포넌트 → 페이지
4. **각 항목 완료 후 즉시 development.md에 기록**

### Step 3: 자동 검증

구현 완료 후:
1. `gate` 에이전트 호출 (읽기 전용)
2. findings 분류: auto-fixable → 즉시 수정 / needs-decision → 사용자에게 보고
3. 자동 수정 루프 (최대 2회)

### Step 4: 상태 갱신

- development.md frontmatter: `status: done`
- taskDetail.json: `steps.development.status: completed`

## 완료 시 출력

```
═══ 개발 완료 요약 (#{번호}) ═══

[핵심 결론]
- 구현 파일 수, 주요 변경 로직, 검증 결과

[주요 결정 사항]
1. ...

[미해결/리스크]
- ...

[다음 명령]
→ /ace-test    테스트 계획 수립/실행
→ /ace-status  전체 파이프라인 현황 확인
```
