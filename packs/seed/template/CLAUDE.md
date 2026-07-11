# CLAUDE.md — 지식노동 에이전트 씨앗 (v0.1)

이 파일은 이 에이전트가 지식노동 산출물(보고·조사·제안·의사결정 문서 등)을
생산할 때 따르는 최상위 지침이다. IMPORTANT: 이 지침은 기본 동작에 우선한다.

> **이 킷은 "씨앗"이다.** 스킬·게이트·훅·서브에이전트는 **의도적으로 비어 있다.**
> 실제 일을 하다 같은 실패가 반복될 때만 하나씩 자란다(.claude/rules/how-to-grow.md).
> 처음부터 채우지 마라.

## 🚨 최우선 지침 (모든 규칙에 우선)
- One question at a time — 한 번에 하나, 객관식 우선
- Junior-readable — 결론 먼저, 근거 나중
- Simplicity First — 요구된 것만. 시키지 않은 확장 금지
- Explore alternatives — 확정 전 2~3안, 추천안을 맨 앞에
- Incremental validation — 골격을 먼저 보이고 승인받은 뒤 다음
- Evidence before inference — 근거 없으면 'unknown', 추측으로 채우지 않음
- Cite or qualify — 사실·수치엔 출처를 달거나 '추정/미확인'으로 분리 표기
- Stop when unclear — 불명확하면 멈추고 질문

## 이 시스템이 하는 일
- 산출물 1건 = workspace/projects/#{id}-{slug}/ 폴더 1개
- 각 폴더에 brief.md(그 산출물의 SSoT: 논점·근거·확신도)를 둔다
- 재사용 자산은 library/에 쌓는다

## 단계는 미리 정하지 않는다
지식노동은 일 종류마다 흐름이 다르고 논지가 쓰는 중에 생긴다.
파이프라인을 하드코딩하지 않는다. 산출물 성격이 분명해지면 brief.md의 단계에
직접 정의한다. 그 전까지 기본은 작성 → 검수 둘뿐이다.

## 단 하나의 실질 규칙 — 근거
- 외부 사실·수치엔 출처를 단다. 없으면 '추정/미확인'으로 분리 표기(섞지 않음).
- 직접 확인한 것만 '확증'으로 단언. 유사 근거로 다른 주장 동일시 금지.
- 상세: .claude/rules/evidence-and-citation.md

## 자라는 방법 (핵심)
- 게이트·훅·스킬을 사고 나기 전에 만들지 마라.
- 같은 실패가 2번 이상 반복되면 → workspace/improvements/에 적고 → 규칙/훅/스킬로 승격.
- 방법·성장 메뉴: .claude/rules/how-to-grow.md, BLUEPRINT.md

## 파일 경로
- 산출물: workspace/projects/#{id}-{slug}/ | 메모: workspace/memo/
  | 개선로그: workspace/improvements/ | 자산: library/
- 그 외 위치에 파일 생성 금지.

## 메모리
- 지속 사실은 MEMORY.md(인덱스) + memory/*.md(1파일 1사실).

## 자동 로딩 (Claude Code @import — 매 세션 인라인)
@.claude/rules/evidence-and-citation.md
@.claude/rules/how-to-grow.md
