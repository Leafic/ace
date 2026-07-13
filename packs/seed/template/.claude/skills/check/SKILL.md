---
name: check
description: 현재 산출물이 근거·인용 규약을 지키는지 자가점검한다. "/check" 또는 "근거 점검"에 사용.
---

# /check — 근거·인용 자가점검
현재 산출물(brief.md + draft)을 .claude/rules/evidence-and-citation.md 기준으로 점검.
draft = 산출물 폴더 안의 본문 문서(brief.md 외 .md 파일, 통상 draft.md). 없으면 brief.md만 점검.
1. 대상 폴더 확인(불명확하면 한 번 질문).
2. brief.md 논점 표 + draft 본문 읽기.
3. 표로 보고: 확정 논점 출처 유무 / 확정·추정 분리 / 미확인 것 확증단언 여부 / 외부수치
출처표기.
4. 위반마다 "무엇을/어디서/어떻게 고칠지" 한 줄씩.
- 읽기·판정만. 본문 수정은 사용자 지시로만.
