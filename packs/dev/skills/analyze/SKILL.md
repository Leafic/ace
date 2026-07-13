---
name: ace-analyze
description: "요구사항을 기능/데이터/API/예외/미해결 5관점으로 분석하여 analysis.md를 작성합니다. 사용자가 '분석', '요구사항', '기획 검토'를 언급할 때 사용하세요."
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

# /ace analyze — 요구사항 분석

## 사용법

```
/ace-analyze [이슈번호]
/ace-analyze
```

## 선행 조건
- 이슈번호가 있으면 태스크가 생성되어 있어야 함 (`/ace-task start`)
- 이슈번호가 없으면 `workspace/current/analysis.md`를 사용한다.

## 기획 정의 확인

분석의 1차 목적은 구현을 시작하기 전에 기획 정의 범위를 확정하는 것이다.
`planning/request.md`(기획 정의서)가 있으면 6필드를 우선 원천으로 쓰고, 없으면 /ace-kickoff 실행을 안내하거나 아래 항목을 직접 질문으로 채운다.
요구사항을 유추하지 말고, 아래 항목 중 비어 있는 것은 "미해결 사항"에 남기고 사용자에게 질문한다.

- 목표: 사용자가 얻어야 할 결과
- 범위: 포함/제외할 기능
- 사용자 흐름: 주요 시나리오와 화면/행동 순서
- 데이터/API: 입력, 출력, 저장, 연동
- 예외/권한: 실패 케이스, 권한, 빈 상태, 중복, 취소
- 완료 기준: 테스트, 화면, 응답, 지표 등 acceptance criteria

## 저토큰 모드

사용자가 `스모크 테스트`, `테스트용`, `짧게`, `토큰 적게`를 명시하면:
- 에이전트를 호출하지 않는다.
- 각 섹션은 **최소 1개 항목만** 작성한다.
- 설명은 한 줄 또는 짧은 구로 제한한다.
- 미해결 사항이 없으면 `없음` 1건만 적는다.
- 완료 요약은 최대 3줄로 끝낸다.

## 번호 없는 실행 모드

- 이슈번호가 없으면 `workspace/current/` 디렉토리를 생성해서 사용한다.
- 산출물은 `workspace/current/analysis.md`에 저장한다.
- 입력은 사용자 요청, `workspace/current/planning/request.md`(기획 정의서), `workspace/current/brief.md`, `README.md`, 관련 문서를 우선 읽는다.
- 이 경우 `taskDetail.json` 갱신은 생략한다.

## ⚡ 이어하기 규칙 (필수)

### 실행 전 체크
1. 이슈번호가 있으면 `workspace/tasks/{번호}/analysis.md`, 없으면 `workspace/current/analysis.md` 파일이 이미 존재하는지 확인한다.
2. 존재하면 frontmatter의 `status`를 읽는다.
   - `status: done` → "이미 완료된 분석입니다. 재분석하시겠습니까?" 확인
   - `status: in_progress` → **이어하기 모드** 진입

### 이어하기 모드
1. 기존 analysis.md를 읽어 **어떤 섹션까지 작성되었는지** 파악한다.
2. 비어있거나 `(미완료)`, `(TODO)` 마커가 있는 섹션부터 이어서 작성한다.
3. 이미 완료된 섹션은 **절대 다시 작성하지 않는다.**

### 섹션별 저장
각 섹션 완료 시마다 analysis.md를 **즉시 저장**한다.

## 에이전트 사용 규칙

### 에이전트 호출 조건
- **메인 세션이 직접 수행** (기본): 섹션 1-2개 작성, 파일 5개 이하 참조, 단순 분석
- **에이전트 위임**: 기획서가 10페이지 이상이거나, 영향 분석 대상 파일이 20개 이상인 경우만
- **병렬 에이전트 금지**: 같은 산출물을 여러 에이전트가 동시에 쓰지 않는다
- **큰 파일 주의**: 필요한 부분만 offset/limit로 읽어서 요약 후 전달

### 폴백
1. 에이전트가 타임아웃/에러/불완전한 결과를 반환하면 메인 세션이 직접 수행한다.
2. `<!-- 에이전트 실패 — 메인 세션에서 직접 수행 -->` 주석을 남긴다.
3. 에이전트를 재시도하지 않는다.
4. 에이전트의 중간 출력을 직접 읽지 않는다. 최종 결과만 수신한다.

## 실행 흐름

### Step 1: 입력 수집

- 이슈 트래커의 설명/첨부
- `workspace/tasks/{번호}/planning/` 폴더의 기획서 (request.md가 있으면 기획 정의의 1차 기준)
- `workspace/current/brief.md` 또는 사용자가 지정한 문서
- 사용자가 대화로 제공한 요구사항

**이어하기 시**: 기존 analysis.md 상단 요약이 있으면 스킵.

### Step 2: 섹션별 분석 (완료된 섹션 스킵)

**섹션 1. 기능 요구사항**
- 구현해야 할 기능 목록, 우선순위
→ 완료 시 analysis.md 저장

**섹션 2. 데이터 모델**
- 필요한 엔티티/관계/속성
→ 완료 시 analysis.md 저장

**섹션 3. API 윤곽**
- 필요한 엔드포인트와 기본 스키마
→ 완료 시 analysis.md 저장

**섹션 4. 예외/엣지케이스**
- 비정상 흐름, 경계 조건
→ 완료 시 analysis.md 저장

**섹션 5. 완료 기준 (acceptance criteria)**
- `planning/request.md`의 '완료 기준'을 옮겨 적고 기능 요구사항과 매핑한다 (design/test가 이 표를 기준으로 검증)
- request.md가 없으면 사용자에게 완료 기준을 질문해 채운다 — 유추 금지
→ 완료 시 analysis.md 저장

**섹션 6. 미해결 사항**
- 기획 모호성, 추가 확인 필요 항목 (공백으로 분리 표기 — `.claude/rules/conv-evidence.md`)
→ 완료 시 analysis.md 저장

### Step 3: 상태 갱신

- **done 판정 조건**: 미해결 사항 0건, 또는 잔존 항목에 대해 사용자가 "이대로 진행"을 승인하고 그 승인을 미해결 표에 기록했을 때만 `status: done`. 그 외에는 `in_progress` 유지
- analysis.md frontmatter: `status: done`
- 이슈번호가 있을 때만 taskDetail.json의 `steps.analysis.status: completed` 갱신

## 완료 시 출력

```
═══ 분석 완료 요약 (#{번호}) ═══

[핵심 결론]
- (1-3줄)

[주요 결정 사항]
1. ...

[미해결/리스크]
- ...

[다음 명령]
→ /ace-design     아키텍처/API/UI 설계
→ /ace-dev-quick  간단한 건 설계 스킵하고 바로 개발
→ /ace-status     전체 파이프라인 현황 확인
```
