---
name: ace-task
description: "태스크 생성/상태 조회"
argument-hint: "[start|status|history] [이슈번호]"
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

# /ace task — 태스크 관리

## 사용법

```
/ace task start [이슈번호]    # 태스크 생성
/ace task status [이슈번호]   # 상태 조회
/ace task history [이슈번호]  # 산출물 변경 이력
```

## start — 태스크 생성

### 입력
- 이슈번호: 이슈 트래커 번호 (profile.yaml의 issue_tracker 설정에 따라)
  - `none`: 수동 번호 입력 또는 자동 채번
  - `github`: GitHub Issue 번호 → API로 제목/설명 조회
  - `linear`, `jira`, `redmine`: 해당 트래커 API 연동

### 실행 흐름

1. **이슈 검증**: 이슈 트래커 연동 시 이슈 존재 여부 확인
2. **태스크 폴더 생성**: `workspace/tasks/{이슈번호}/`
3. **taskDetail.json 초기화**:

```json
{
  "id": "{이슈번호}",
  "title": "{이슈 제목 또는 수동 입력}",
  "createdAt": "{ISO 8601}",
  "stack": "{profile.yaml에서 읽은 스택}",
  "steps": {
    "analysis": { "status": "pending" },
    "design": { "status": "pending" },
    "development": { "status": "pending" },
    "test": { "status": "pending" }
  }
}
```

4. **taskIndex.json 갱신**: 전체 태스크 인덱스에 항목 추가

## status — 상태 조회

taskDetail.json을 읽어 각 단계별 상태를 테이블로 출력한다.

```
═══ 태스크 #{번호} 현황 ═══
제목: {제목}
생성: {날짜}

| 단계 | 상태 | 산출물 |
|------|------|--------|
| 분석 | completed | analysis.md (rev 2) |
| 설계 | completed | design.md (rev 1) |
| 개발 | in_progress | development.md |
| 테스트 | pending | - |
```

## history — 변경 이력

산출물 파일의 frontmatter에서 rev, lastRevDate, lastRevSummary를 읽어 이력을 출력한다.

## 규칙

- 태스크 폴더는 반드시 이 스킬을 통해 생성 (직접 mkdir 금지)
- taskDetail.json은 이 스킬과 hooks에서만 수정
- solo 모드: 이슈 트래커 미연동 시 자유 번호 허용
- team 모드: 이슈 트래커 연동 필수
