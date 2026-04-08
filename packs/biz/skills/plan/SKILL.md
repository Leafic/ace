---
name: ace-plan
description: "MVP 정의(MoSCoW), 3단계 로드맵, 리소스 계획, GTM 전략, 리스크 관리를 포함한 plan.md를 작성합니다. 사용자가 '실행 계획', 'MVP', '로드맵'을 언급할 때 사용하세요."
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
  - WebSearch
  - WebFetch
---

# /ace plan — 실행 계획 수립

## 사용법

```
/ace-plan [이슈번호]
```

## 목적
비즈니스 모델을 실현하기 위한 구체적 실행 계획을 수립한다.

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. `workspace/tasks/{번호}/plan.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 계획입니다. 재작성하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 plan.md를 읽어 **어떤 섹션까지 작성되었는지** 파악한다.
2. 비어있는 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 **절대 다시 작성하지 않는다.**

### 섹션별 저장
각 섹션 완료 시마다 plan.md를 **즉시 저장**한다.

## 에이전트 폴백 규칙

1. `planner` 에이전트를 호출한다.
2. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면:
   - 메인 세션이 직접 해당 섹션을 수행한다.
   - `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.
4. 에이전트의 중간 출력(도구 실행 로그, 사고 과정)을 직접 읽지 않는다. 최종 결과만 수신한다.

## 선행 조건
- model.md 완료 권장 (없어도 진행 가능)

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. research.md, model.md 읽기 (있으면)
2. 사용자 제약 조건 수집 (예산, 인력, 시간)

**이어하기 시**: 기존 plan.md의 완료 섹션 파악 후 스킵.

### Step 2: 섹션별 계획 수립 (완료된 섹션 스킵)

**섹션 1. MVP 정의**
- MoSCoW 우선순위 (Must/Should/Could/Won't)
- MVP 성공 지표 (KPI)
- MVP 타임라인
→ 완료 시 plan.md 저장

**섹션 2. 로드맵**
- Phase 1: MVP (0-3개월)
- Phase 2: 핵심 확장 (3-6개월)
- Phase 3: 스케일업 (6-12개월)
→ 완료 시 plan.md 저장

**섹션 3. 리소스 계획**
- 인력, 기술 스택, 인프라 비용, 총 예산
→ 완료 시 plan.md 저장

**섹션 4. Go-to-Market 전략**
- 초기 고객 확보, 채널, 마케팅
→ 완료 시 plan.md 저장

**섹션 5. 리스크 관리 + 의사결정 포인트**
- 리스크 목록, Kill criteria, Phase별 Go/No-Go 기준
→ 완료 시 plan.md 저장, status: done

### Step 3: 상태 갱신

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

[다음 명령]
→ /ace-judge   Go/No-Go/Pivot 최종 판단
→ /ace-status  전체 파이프라인 현황 확인
```
