---
name: ace-model
description: "비즈니스 모델 캔버스 + 수익 구조 설계"
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

# /ace model — 비즈니스 모델 캔버스 + 수익 구조

## 사용법

```
/ace model [이슈번호]
```

## 목적
리서치 결과를 바탕으로 비즈니스 모델을 설계하고 수익 구조를 정의한다.

## 선행 조건
- solo 모드: research 완료 권장 (스킵 가능)
- team 모드: research 완료 필수

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. research.md 읽기
2. 사용자 추가 입력 수집

### Step 2: 에이전트 호출

`modeler` 에이전트를 호출한다.

### Step 3: 산출물 작성

`workspace/tasks/{번호}/model.md`를 작성한다.

**모델링 섹션:**

1. **비즈니스 모델 캔버스 (BMC)**
   - 고객 세그먼트 (Customer Segments)
   - 가치 제안 (Value Propositions)
   - 채널 (Channels)
   - 고객 관계 (Customer Relationships)
   - 수익원 (Revenue Streams)
   - 핵심 자원 (Key Resources)
   - 핵심 활동 (Key Activities)
   - 핵심 파트너 (Key Partnerships)
   - 비용 구조 (Cost Structure)

2. **수익 모델**
   - 가격 전략 (프리미엄/구독/종량 등)
   - 가격 포인트 + 근거
   - 예상 매출 시나리오 (보수적/기본/낙관적)
   - 단위 경제학 (Unit Economics): CAC, LTV, LTV/CAC

3. **비용 구조**
   - 고정비 vs 변동비
   - 초기 투자 필요 항목
   - 손익분기점 추정

4. **핵심 가정 & 검증 방법**
   - 모델의 핵심 가정 목록
   - 각 가정의 검증 방법 제안

### Step 4: 상태 갱신

- model.md frontmatter: `status: done`
- taskDetail.json: `steps.model.status: completed`

## 완료 시 출력

```
═══ 모델링 완료 요약 ═══

[비즈니스 모델]
- 핵심 가치 제안, 수익 모델 유형

[수익 전망]
- 손익분기점, LTV/CAC

[핵심 가정]
- 검증 필요 항목

[다음 단계]
- 실행 계획 수립 시 반영할 사항
```
