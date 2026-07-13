---
name: ace-judge
description: "시장기회/실행가능성/수익성/차별성 가중 평가, 가정 검증, 시나리오 분석으로 Go/No-Go/Pivot 판단을 내립니다. 사용자가 '판단', '의사결정', 'Go/No-Go'를 언급할 때 사용하세요."
argument-hint: "[이슈번호 또는 생략]"
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

# /ace judge — Go / No-Go / Pivot 판단

## 사용법

```
/ace-judge [이슈번호]
/ace-judge
```

이슈번호를 생략하면 `workspace/current/judgement.md`를 사용한다.

## 목적
리서치, 모델링, 실행 계획을 종합하여 최종 의사결정을 지원한다.

## ⚠ 판단 원칙
- **확증 편향 경계**: 앞 단계 산출물이 긍정적이어도 의심한다. "research가 Go라고 했으니 Go"가 아님
- **No-Go도 가치 있는 결론이다** — Go를 기본값으로 두지 않는다
- **미검증 가정이 3개 이상이면** 판정을 보류(`verdict: Hold`)하고 검증 방법을 제안한다
- **근거 규약 준수**: 점수의 근거는 `.claude/rules/conv-evidence.md`를 따른다 — 공개 데이터·직접 확인 근거만 인정, 추측 금지, 긍정/부정/공백을 분리해 보고
- 판정 기준 (종합 점수 = 가중 평균, X.X):
  - **7.0 이상** → Go
  - **5.0 이상 ~ 7.0 미만** → Pivot 검토
  - **5.0 미만** → No-Go

### 항목 점수 앵커 (1-10, 감으로 매기지 않는다)

| 점수 | 앵커 기준 |
|------|-----------|
| 9-10 | 공개 데이터 출처 있는 '확정' 근거가 긍정을 뒷받침, 반증 근거 없음 |
| 7-8 | '확정' 근거 위주지만 일부 '추정' 포함, 부정 근거는 경미 |
| 5-6 | '추정' 근거 위주, 긍정·부정 근거가 혼재 |
| 3-4 | 부정 근거가 우세하거나 핵심 근거가 '미확인' |
| 1-2 | '확정' 부정 근거 존재 (반증됨) |

- 각 항목 점수에는 반드시 **긍정 근거 / 부정 근거 / 공백**을 나눠 적는다. 근거가 '미확인'뿐인 항목은 6점을 넘을 수 없다.

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. 이슈번호가 있으면 `workspace/tasks/{번호}/judgement.md`, 없으면 `workspace/current/judgement.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 판단입니다. 재평가하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 judgement.md를 읽어 **어떤 섹션까지 작성되었는지** 파악한다.
2. 비어있는 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 **절대 다시 작성하지 않는다.**

### 섹션별 저장
각 섹션 완료 시마다 judgement.md를 **즉시 저장**한다.

## 번호 없는 실행 모드

- 이슈번호가 없으면 `workspace/current/` 디렉토리를 생성해서 사용한다.
- 산출물은 `workspace/current/judgement.md`에 저장한다.
- 선행 자료는 `workspace/current/research.md`, `workspace/current/model.md`, `workspace/current/plan.md`를 우선 읽는다.
- 이 경우 `taskDetail.json` 갱신은 생략한다.

## 에이전트 사용 규칙

### 에이전트 호출 조건
- **메인 세션이 직접 수행** (기본): 섹션 1-2개 작성, 기존 산출물 요약/판단
- **에이전트 위임**: 전체 섹션을 한번에 작성해야 하는 대규모 작업만
- **병렬 에이전트 금지**: 같은 산출물을 여러 에이전트가 동시에 쓰지 않는다
- **큰 파일 주의**: 필요한 부분만 offset/limit로 읽어서 요약 후 전달

### 폴백
1. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면 메인 세션이 직접 수행한다.
2. `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.
4. 에이전트의 중간 출력을 직접 읽지 않는다. 최종 결과만 수신한다.

## 선행 조건
- 최소 1개 이상의 선행 산출물 필요 (research.md, model.md, plan.md 중)

## 실행 흐름

### Step 1: 전체 산출물 로딩

research.md, model.md, plan.md를 모두 읽는다 (있는 것만).

**이어하기 시**: 기존 judgement.md의 완료 섹션 파악 후 스킵.

### Step 2: 섹션별 판단 (완료된 섹션 스킵)

**섹션 1. 종합 평가**
- 시장 기회 (30%), 실행 가능성 (25%), 수익성 (25%), 차별성 (20%)
- 각 항목 1-10 점수 + 근거
- 종합 점수 (가중 평균)
→ 완료 시 judgement.md 저장

**섹션 2. 핵심 가정 검증 현황**
- 각 가정의 검증 상태 (검증/미검증/반증)
- 검증율 계산
→ 완료 시 judgement.md 저장

**섹션 3. 시나리오 분석**
- Best / Base / Worst case
→ 완료 시 judgement.md 저장

**섹션 4. 판정 + 최종 권고**
- Go / No-Go / Pivot 판정
- 다음 행동, 재검토 시점
→ 완료 시 judgement.md 저장, status: done

### Step 3: 상태 갱신

- judgement.md frontmatter: `status: done`, `verdict: Go/No-Go/Pivot/Hold`, `score: X.X`
- `Hold`(보류)는 미검증 가정 3개 이상 등으로 판정을 유보한 경우 — kickoff는 Go가 아니면 진행 전 사용자 확인을 받는다
- 이슈번호가 있을 때만 taskDetail.json의 `steps.judge.status: completed` 갱신

## 완료 시 출력

```
═══ 판단 완료 요약 ═══

[판정] Go / No-Go / Pivot

[종합 점수] X.X / 10

[핵심 근거]
- (3줄 이내)

[다음 행동]
- 즉시 해야 할 것

[다음 명령]
→ Go 판정 시: /ace-kickoff 로 기획 정의서 확정 후 개발 시작 (개발 직행 금지)
→ Hold 판정 시: 미검증 가정을 검증한 뒤 /ace-judge 재실행
→ Pivot 판정 시: /ace-research 로 새 방향 리서치
→ /ace-status  전체 파이프라인 현황 확인
```
