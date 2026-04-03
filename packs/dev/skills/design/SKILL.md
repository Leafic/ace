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
/ace design [이슈번호]
```

## 선행 조건
- solo 모드: analysis 완료 또는 스킵 가능
- team 모드: analysis 완료 필수

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. analysis.md 읽기
2. 스택 컨벤션 로딩 (profile.yaml → stack 프리셋)
3. 도메인 용어집 로딩 (있으면)
4. 기존 코드베이스 구조 파악

### Step 2: 에이전트 호출

`designer` 에이전트를 호출한다.

**에이전트 입력:**
```
- 이슈번호, 태스크 폴더 경로
- analysis.md
- 스택 컨벤션 (conv-backend.md, conv-frontend.md, conv-db.md)
- 기존 코드 구조
```

### Step 3: 산출물 작성

`workspace/tasks/{번호}/design.md`를 작성한다.

**설계 섹션 (solo 모드):**
1. **변경 개요**: 수정/추가할 파일 목록
2. **데이터 모델**: 테이블/컬럼 변경 (DDL 포함)
3. **API 설계**: 엔드포인트, 요청/응답 스키마
4. **UI 설계**: 컴포넌트 구조, 주요 인터랙션
5. **설계 결정**: 트레이드오프 기록

**설계 섹션 (team 모드):**
위 항목 + 다음 추가:
6. **화면별 상세 설계**: 화면 흐름, 상태 관리
7. **설계 검증**: design-critic 에이전트의 리뷰 결과
8. **담당자 배분**: 작업 단위별 담당

### Step 4: 설계 검증 (team 모드)

`design-critic` 서브에이전트를 호출하여 설계를 검증한다:
- 컨벤션 준수 여부
- 누락된 엣지케이스
- 성능/보안 우려
- 결과를 design.md에 "설계 검증" 섹션으로 추가

### Step 5: 상태 갱신

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

[다음 단계 참고]
- 구현 시 확인할 핵심 포인트
```
