---
name: ace-kickoff
description: "사업 검증 산출물(research/model/plan/judgement)을 개발이 유추 없이 실행할 수 있는 기획 정의서(planning/request.md)와 제품 컨벤션(conv-product.md)으로 변환합니다. 사용자가 '킥오프', '기획 정의', '개발로 넘기자', '기획 확정'을 언급할 때 사용하세요."
argument-hint: "[이슈번호 또는 생략]"
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

# /ace kickoff — 기획 정의 → 개발 인수인계

## 사용법

```
/ace-kickoff [이슈번호]
/ace-kickoff
```

이슈번호를 생략하면 `workspace/current/`의 biz 산출물을 사용한다.

## 목적

사업 검증(biz)의 결론을 개발(dev)이 유추 없이 실행할 수 있는 **기획 정의서**로 굳힌다.
기획 정의서가 확정되면 이후 analyze→design→dev→test는 이 문서와
`.claude/rules/conv-product.md`의 제품 스타일을 기준으로 진행된다.

## ⚠ 원칙

- **유추 금지**: biz 산출물에 없는 내용은 지어내지 않는다. 사용자에게 질문한다(한 번에 하나, 객관식 우선).
- **go/no-go 존중**: judgement.md가 없거나 결론이 no-go/보류면 그대로 진행하지 않고 사용자 확인을 받는다.
- **확정/추정 구분**: 근거가 biz 산출물에 있으면 해당 파일·섹션을 출처로 표기, 없으면 '미확인'으로 남긴다.
- **범위는 Must만**: plan.md의 MoSCoW 중 Must만 MVP 범위에 넣고, 나머지는 "Won't(이번엔 안 함)"에 명시한다.

## 실행 흐름

1. **입력 수집** — 이슈번호가 있으면 `workspace/tasks/{번호}/`, 없으면 `workspace/current/`에서
   `research.md`, `model.md`, `plan.md`, `judgement.md` 중 존재하는 것을 읽는다.
   하나도 없으면 "biz 산출물이 없습니다 — /ace-research 부터 시작하시겠습니까?"를 묻고 중단한다.
2. **go/no-go 확인** — judgement.md의 결론을 확인한다. no-go/보류/없음이면 사용자에게
   "판단 없이 기획을 확정하시겠습니까?"를 확인받는다.
3. **기획 정의서 작성** — `.ace/templates/request.template.md`를 복사해
   (템플릿이 없으면 — 구버전 init 프로젝트 — 이 스킬의 6필드 구조로 직접 생성하고 `ace update` 실행을 안내)
   `workspace/tasks/{번호}/planning/request.md`(번호 없으면 `workspace/current/planning/request.md`)를 만들고,
   biz 산출물에서 6개 필드를 채운다: 목표 / 범위(MoSCoW) / 사용자 흐름 / 데이터·API / 예외·권한 / 완료 기준.
4. **빈 필드 질문** — 비어 있는 필드는 사용자에게 한 번에 하나씩 질문해 채운다.
   답을 받지 못한 항목은 지어내지 말고 "미해결 사항" 표에 남긴다.
5. **제품 컨벤션 생성** — `.claude/rules/conv-product.md`에 제품 스타일 가이드를 기록한다:
   타깃 사용자 / 톤·보이스 / UX 원칙 / 용어집(도메인 용어→표기) / 하지 않는 것.
   이미 존재하면 덮어쓰지 않고 변경점만 제안한다.
   (design 등 dev 스킬은 `.claude/rules/conv-*.md`를 로딩하므로 이 파일이 개발 전 단계의 스타일 기준이 된다.)
6. **다음 단계 연결** — dev 팩이 없으면 `ace add-pack dev`를 안내한다.
   있으면 `/ace-task create "{제목}"` 또는 `/ace-analyze`로 이어가라고 안내한다.

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. 대상 위치에 `planning/request.md`가 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → `.claude/rules/conv-product.md` 존재 여부를 함께 확인한다. 없으면 Step 5(제품 컨벤션)만 이어서 수행하고, 있으면 "이미 확정된 기획입니다. 재작성하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드**: 빈 섹션부터 이어 작성, 완료된 섹션은 다시 쓰지 않는다.

### 섹션별 저장
각 섹션 완료 시마다 request.md를 **즉시 저장**한다.
6개 필드가 모두 채워지고 미해결 사항이 0건이면 `status: done`으로 올린다.

## 완료 시 출력

```
✅ 기획 정의 완료 — {제목}

| 필드 | 상태 | 출처 |
|------|------|------|
| 목표 | 채움 | judgement.md |
| 범위 | 채움 | plan.md(MoSCoW) |
| ...  | 미확인 | — |

산출물: workspace/.../planning/request.md (status: done)
컨벤션: .claude/rules/conv-product.md
미해결: {n}건
다음: /ace-task create "{제목}" → /ace-analyze
```
