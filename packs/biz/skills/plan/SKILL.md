---
name: ace-plan
description: "MVP 정의 + 실행 계획 수립"
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

# /ace plan — 실행 계획 수립

## 사용법

```
/ace plan [이슈번호]
```

## 목적
비즈니스 모델을 실현하기 위한 구체적 실행 계획을 수립한다.

## 선행 조건
- solo 모드: model 완료 권장 (스킵 가능)
- team 모드: model 완료 필수

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. research.md, model.md 읽기
2. 사용자 추가 입력 (제약 조건, 리소스 현황)

### Step 2: 에이전트 호출

`planner` 에이전트를 호출한다.

### Step 3: 산출물 작성

`workspace/tasks/{번호}/plan.md`를 작성한다.

**실행 계획 섹션:**

1. **MVP 정의**
   - MVP 범위 (포함/제외 기능)
   - MVP 성공 지표 (KPI)
   - MVP 타임라인 (주 단위)

2. **로드맵**
   - Phase 1: MVP (0-3개월)
   - Phase 2: 핵심 기능 확장 (3-6개월)
   - Phase 3: 스케일업 (6-12개월)
   - 각 Phase별 마일스톤 + 성공 기준

3. **리소스 계획**
   - 인력 (역할별 필요 인원/시간)
   - 기술 스택 선정 + 근거
   - 인프라/서비스 비용
   - 총 예산 추정

4. **Go-to-Market 전략**
   - 초기 고객 확보 방법
   - 마케팅 채널 + 예산
   - 파트너십/제휴 계획

5. **리스크 관리**
   - 리스크 목록 (확률 x 영향)
   - 각 리스크별 완화 방안
   - 중단 기준 (Kill criteria)

6. **의사결정 포인트**
   - Phase별 Go/No-Go 기준
   - 피벗 신호 (Pivot triggers)

### Step 4: 상태 갱신

- plan.md frontmatter: `status: done`
- taskDetail.json: `steps.plan.status: completed`

## 완료 시 출력

```
═══ 실행 계획 완료 요약 ═══

[MVP]
- 범위, 타임라인, 핵심 KPI

[리소스]
- 예산, 인력

[핵심 리스크]
- Top 3 리스크 + 완화 방안

[다음 단계]
- Go/No-Go 판단 시 기준
```
