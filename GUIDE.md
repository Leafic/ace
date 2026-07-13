# ACE 사용 가이드

어느 프로젝트·어느 팀에서든 ACE를 바로 쓸 수 있도록 정리한 실전 가이드입니다.
ACE가 무엇인지는 [README.md](README.md), 설치는 [README.mac.md](README.mac.md) / [README.windows.md](README.windows.md)를 보세요.

---

## 1. 빠른 시작 — 상황별 진입점

| 상황 | 시작 명령 | 흐름 |
|------|-----------|------|
| 신규 사업을 검증하고 개발까지 | `ace init --pack biz --mode solo` | research → model → plan → judge → **kickoff** → (dev 팩 추가) analyze → design → dev → test |
| 이미 확정된 개발 작업 | `ace init --pack dev --stack <스택> --mode solo` | analyze → design → dev → test |
| 보고·조사·제안 등 문서 산출물 | `ace init --pack seed` | /new로 시작, 실패가 반복되면 `ace grow`로 성장 |
| 뭘 고를지 모르겠으면 | `ace start` | 대화형 선택 |

설치 후 해당 폴더에서 Claude Code(`claude`) 또는 Codex를 실행하면 `/ace-*` 스킬이 보입니다.
(Codex는 `ace export-codex --global` 후 `$ace-*` 표기)

---

## 2. 신규 사업 흐름 (추천 워크플로)

기획을 먼저 확정하고, 개발이 그 기획과 스타일을 따르게 하는 흐름입니다.

```
ace init --pack biz --mode solo
```

### 2-1. 사업 검증 (biz)

| 순서 | 명령 | 산출물 | 핵심 |
|------|------|--------|------|
| 1 | `/ace-research` | research.md | TAM/SAM/SOM, 경쟁, 고객 + 안 될 이유 5가지 (비판 우선) |
| 2 | `/ace-model` | model.md | BMC, 가격, CAC/LTV — 모든 수치에 출처·확신도 필수 |
| 3 | `/ace-plan` | plan.md | MVP(MoSCoW)·사용자 흐름·데이터/API·예외 개요·Kill criteria |
| 4 | `/ace-judge` | judgement.md | 근거 앵커 기반 채점 → verdict: Go/No-Go/Pivot/Hold |

judge 판정 기준: 가중평균 **7.0 이상 Go / 5.0~7.0 미만 Pivot / 5.0 미만 No-Go**.
미검증 가정 3개 이상이면 **Hold**(보류). 점수는 감이 아니라 근거 품질 앵커로 매깁니다
(공개 데이터 '확정' 근거 = 상위 점수, '미확인'뿐이면 6점 초과 불가).

### 2-2. 기획 확정 (kickoff) — 개발 직행 금지

```
/ace-kickoff
```

judge가 Go일 때 실행합니다. 산출물 2개가 생깁니다:

- **`planning/request.md` (기획 정의서)** — 개발이 유추 없이 실행할 수 있는 6필드:
  목표 / 범위(MoSCoW) / 사용자 흐름 / 데이터·API / 예외·권한 / 완료 기준.
  비어 있는 필드는 지어내지 않고 한 번에 하나씩 질문으로 채웁니다.
- **`.claude/rules/conv-product.md` (제품 스타일)** — 타깃, 톤·보이스, UX 원칙, 용어집.
  design 등 dev 단계가 자동 로딩하므로 이 파일이 "그 스타일로 개발"의 기준이 됩니다.

### 2-3. 개발 (dev)

```
ace add-pack dev --stack nextjs-fastapi-pg   # 또는 spring-vue-mssql 등
```

| 순서 | 명령 | 산출물 | 통과 조건 |
|------|------|--------|-----------|
| 1 | `/ace-analyze` | analysis.md | 미해결 0건(또는 사용자 승인 기록)일 때만 done |
| 2 | `/ace-design` | design.md | "기획 미정" 0건일 때만 done |
| 3 | `/ace-dev` | development.md | **gate 채점 통과 필수** (아래 3장) |
| 4 | `/ace-test` | test.md | 테스트 전부 통과 + acceptance criteria 전 항목 충족 |
| 5 | `/ace-wiki` | workspace/wiki/ | 결정·검증(채점 포함) 기록 |

각 단계는 앞 단계 산출물의 `status: done`을 확인하며, 안 됐으면 진행하지 않습니다.
간단한 수정은 `/ace-dev-quick`(분석/설계 스킵, 채점은 동일 기준).
현황과 다음 액션은 언제든 `/ace-status`.

---

## 3. 품질 시스템 — 채점 게이트와 근거 규약

### gate 채점 (코드 검증)

구현이 끝나면 gate가 100점 감점식으로 채점합니다.

- 감점: CRITICAL -20 / HIGH -10 / MEDIUM -5 / LOW -2 (건당)
- 등급: S 90+ / A+ 85 / **B+ 80 = 통과선** / B 70 / C 이하
- **통과(passed) = 80점 이상 AND CRITICAL 0건 AND 미해소(unresolved) 0건**
- 불통과 → 수정 → 재채점(최대 2회). 재채점은 이전 지적이 실제로 해소됐는지 코드에서 확인하며,
  미해소가 있으면 통과할 수 없습니다. 임의 통과 처리 금지.
- 결과는 development.md frontmatter(`gateScore`/`gateGrade`/`gatePassed`)에 남고 status·wiki에 표시됩니다.

### conv-evidence (근거·정량 표기 규약)

모든 팩에 설치되는 공통 규칙(`.claude/rules/conv-evidence.md`)입니다.

- **추측 금지** — 공개 데이터·직접 확인 없이는 단언하지 않는다
- **확신도 3분류** — 확정 / 추정(산출식 명시) / 미확인
- **정량 표기 4요소** — `값+단위 (기준시점, 출처: 공개 데이터+접근일, 확신도)`
  - 예: `국내 시장 규모 1,200억 원 (2025 기준, 출처: 통계청 KOSIS 접근 2026-07-13, 확정)`
- **검증 보고 3종 분리** — 긍정(strength) / 부정(finding) / 공백(gap).
  근거가 없어 판단 못 한 항목(공백)은 생략하지 않고 그 자체로 도출한다.

### 코드베이스 진단

```
/ace-audit [경로]
```

구조/품질/보안/성능 4개 영역을 gate와 같은 감점식으로 점수화(영역별 10점 만점,
CRITICAL 있는 영역은 5.0 상한)하고, 긍정/부정/공백을 분리해 보고합니다.

---

## 4. 지식노동 씨앗 (seed)

문서 산출물(보고·조사·제안) 작업은 완성형 하네스 대신 씨앗으로 시작합니다.

```
ace init --pack seed     # 기존 파일은 절대 덮어쓰지 않음 — 기존 레포에도 안전
claude                   # → /new {제목} 으로 첫 산출물 시작, /check 로 근거 점검
```

- 산출물 1건 = `workspace/projects/{id}-{slug}/` 폴더 1개, `brief.md`가 SSoT(논점·확신도·출처)
- 같은 실패가 2번 반복되면 `workspace/improvements/`에 기록 → 규칙/훅/스킬로 승격
- 검증된 부품이 필요해지면:

```
ace grow            # 성장 메뉴 + 심는 신호 확인
ace grow gate       # 예: 채점 게이트 이식 (judge/researcher/reviewer/hooks도 가능)
```

무엇을 언제 심을지는 씨앗과 함께 설치되는 `BLUEPRINT.md`(성장 메뉴 9개 결정)가 안내합니다.
원칙: **실제 신호가 온 부품만 심는다. 미리 짓지 않는다.**

---

## 5. 명령 레퍼런스

```bash
ace start                                  # 대화형 세팅
ace init --pack dev|biz|all|seed [...]     # 프로젝트 초기화
ace add-pack <dev|biz>                     # 기존 설치에 팩 추가
ace grow [부품]                            # 검증된 부품 개별 이식 (씨앗 성장)
ace export-codex --global                  # Codex 스킬 동기화
ace doctor                                 # 설치 상태 점검
ace update                                 # ACE 코어 + 프로젝트 스킬 갱신 (seed는 누락 보충만)
ace validate-skills                        # 스킬 정적 검증 (배포 전)
```

## 6. 스킬 레퍼런스

| 스킬 | 팩 | 역할 | 산출물 |
|------|-----|------|--------|
| /ace-research | biz | 시장·경쟁·고객 리서치 (비판 우선) | research.md |
| /ace-model | biz | BMC·가격·단위경제학 | model.md |
| /ace-plan | biz | MVP·로드맵·리소스·GTM·Kill criteria | plan.md |
| /ace-judge | biz | Go/No-Go/Pivot/Hold 판정 (근거 앵커 채점) | judgement.md |
| /ace-kickoff | core | 사업 검증 → 기획 정의서 + 제품 스타일 | planning/request.md, conv-product.md |
| /ace-analyze | dev | 요구사항 분석 + acceptance criteria | analysis.md |
| /ace-design | dev | 아키텍처/API/UI 설계 | design.md |
| /ace-dev | dev | 구현 + gate 채점 | development.md |
| /ace-dev-quick | dev | 분석/설계 스킵 간편 수정 (채점 동일) | development.md |
| /ace-test | dev | 테스트 + acceptance criteria 충족 표 | test.md |
| /ace-audit | dev | 코드베이스 진단 (감점식 점수) | audit.md |
| /ace-task | dev | 이슈/태스크 관리 | taskDetail.json |
| /ace-status | core | 파이프라인 현황 + 다음 액션 | (읽기 전용) |
| /ace-wiki | core | 결정·검증·이력 누적 | workspace/wiki/ |
| /ace-retrospect | core | 협업 회고 | retrospect.md |
| /ace-coach | core | AI 활용 코칭 | coach.md |
| /ace-karpathy-harness | core | 문맥 지도·하네스·검증 관문 설계 | harness.md |
| /new, /check | seed | 산출물 시작 / 근거 점검 | brief.md |

## 7. 문제 해결

- 스킬이 안 보임 → Claude Code/Codex 재시작, `ace doctor`로 설치 확인
- 구버전 프로젝트에 새 스킬 반영 → 프로젝트 폴더에서 `ace update`
- 회사/프로젝트 민감 컨텍스트 점검 → `ACE_FORBIDDEN_TERMS="이름1,이름2" ace validate-skills`
- seed 프로젝트 파일 누락 → `ace update` (기존 파일은 덮어쓰지 않고 누락분만 보충)
