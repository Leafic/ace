---
name: ace-status
description: "파이프라인 현황 조회 + 다음 액션 안내"
user-invocable: true
allowed-tools:
  - Read
  - Glob
---

# /ace status — 파이프라인 현황 + 다음 액션

## 사용법

```
/ace-status
```

## 목적
현재 프로젝트의 dev/biz 파이프라인 진행 상태를 한눈에 보여주고, 다음에 실행할 명령어를 안내한다.

## 실행 흐름

### Step 1: 프로필 확인

`.ace/profile.yaml`을 읽어 프로젝트명, 팩, 모드를 파악한다.

### Step 2: 태스크 현황 수집

`workspace/tasks/taskIndex.json`을 읽는다.
태스크가 없으면:
```
아직 태스크가 없습니다.
→ /ace-task start <이슈번호>  태스크 생성
```

### Step 3: 산출물 상태 확인

각 태스크 폴더에서 산출물 파일의 존재 여부와 frontmatter `status`를 확인한다.

**dev 파이프라인 체크:**
- `analysis.md` → analyze 단계
- `design.md` → design 단계
- `development.md` → dev 단계
- `test.md` → test 단계

**biz 파이프라인 체크:**
- `research.md` → research 단계
- `model.md` → model 단계
- `plan.md` → plan 단계
- `judgement.md` → judge 단계

### Step 4: 현황 출력

아래 형식으로 출력한다:

```
═══ {프로젝트명} 파이프라인 현황 ═══

[dev] 분석 → 설계 → 구현 → 검증
  {상태} analyze → {상태} design → {상태} dev → {상태} test

[biz] 리서치 → 모델링 → 계획 → 판단
  {상태} research → {상태} model → {상태} plan → {상태} judge

상태 아이콘:
  ✓ = 완료 (status: done)
  ◆ = 진행 중 (status: in_progress)
  ○ = 대기

[다음 액션]
→ /ace-{다음스킬}  {설명}
```

### Step 5: 다음 액션 결정

**dev 파이프라인 다음 액션:**

| 현재 상태 | 다음 명령 | 설명 |
|-----------|----------|------|
| 태스크 없음 | `/ace-task start` | 태스크 생성 |
| analyze ○ | `/ace-analyze` 또는 `/ace-dev-quick` | 분석 시작 또는 바로 개발 |
| analyze ✓, design ○ | `/ace-design` | 설계 시작 |
| design ✓, dev ○ | `/ace-dev` | 구현 시작 |
| dev ✓, test ○ | `/ace-test` | 테스트 시작 |
| test ✓ | 완료! 커밋/PR 진행 | - |
| 어딘가 ◆ | 해당 스킬 재실행 (이어하기) | 중단된 곳에서 이어서 |

**biz 파이프라인 다음 액션:**

| 현재 상태 | 다음 명령 | 설명 |
|-----------|----------|------|
| research ○ | `/ace-research` | 시장/경쟁/고객 리서치 |
| research ✓, model ○ | `/ace-model` | 비즈니스 모델 설계 |
| model ✓, plan ○ | `/ace-plan` | 실행 계획 수립 |
| plan ✓, judge ○ | `/ace-judge` | Go/No-Go 판단 |
| judge ✓ | 판단 완료! 결과에 따라 행동 | - |
| 어딘가 ◆ | 해당 스킬 재실행 (이어하기) | 중단된 곳에서 이어서 |

### 토큰 안내

마지막에 항상 다음 문구를 포함한다:

```
💡 다음 작업을 진행할까요? (토큰이 소모됩니다)
```

사용자가 명시적으로 승인한 후에만 다음 스킬을 실행한다.

## 규칙

- 이 스킬은 **읽기 전용** — 파일을 수정하지 않는다.
- 토큰 소모를 최소화하기 위해 파일은 frontmatter만 읽는다 (전체 내용 불필요).
- 태스크가 여러 개면 가장 최근 업데이트된 태스크를 기본으로 보여준다.
