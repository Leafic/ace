---
name: ace-task
description: "GitHub Issue 생성(create), 태스크 시작(start), 상태 조회(status), 이력(history), 목록(list)을 관리합니다. 사용자가 '태스크', '이슈', '작업 시작'을 언급할 때 사용하세요."
argument-hint: "[create|start|status|history|list] [이슈번호|제목]"
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
/ace-task create "제목"        # GitHub Issue 생성 → 태스크 자동 시작
/ace-task start [이슈번호]     # 기존 이슈로 태스크 생성
/ace-task status [이슈번호]    # 상태 조회
/ace-task history [이슈번호]   # 산출물 변경 이력
/ace-task list                 # 전체 태스크 목록
```

## create — 이슈 생성 + 태스크 시작

### 실행 흐름

1. **사용자 입력 수집**
   - 제목 (필수): 인자로 받거나, 없으면 질문
   - 설명 (선택): 사용자에게 "설명을 추가하시겠습니까?" 질문
   - 라벨 (선택): enhancement, bug, task 등

2. **중복 이슈 검사** (github 연동 시)

   ```bash
   gh issue list --search "제목 키워드" --state all --limit 5
   ```

   유사 이슈가 발견되면:
   ```
   ⚠ 유사한 이슈가 존재합니다:

   | # | 제목 | 상태 |
   |---|------|------|
   | #3 | R2 presigned URL 구현 | open |
   | #1 | 파일 업로드 기능 | closed |

   [1] 기존 이슈 #3으로 태스크 시작
   [2] 새 이슈를 그대로 생성
   [3] 취소
   ```

   사용자 선택에 따라 분기한다.

3. **profile.yaml 확인**
   - `issue_tracker.type`이 `github`이면 → `gh issue create` 실행
   - `none`이면 → 로컬 번호 자동 채번

4. **GitHub Issue 생성** (github 연동 시)

   ```bash
   gh issue create --title "제목" --body "설명" --label "라벨"
   ```

   생성된 이슈 번호를 파싱한다.

5. **태스크 자동 시작** — start 흐름으로 이어감

### 출력

```
═══ 이슈 생성 완료 ═══
GitHub Issue: #5 — 파일 업로드 구현
URL: https://github.com/your-org/your-repo/issues/5

태스크 폴더 생성 중...
✓ workspace/tasks/5/taskDetail.json

[다음 명령]
→ /ace-analyze 5   요구사항 분석
→ /ace-dev-quick 5 바로 개발 (solo 모드)
```

## start — 기존 이슈로 태스크 생성

### 입력
- 이슈번호: 이슈 트래커 번호
  - `github`: `gh issue view {번호}` 로 제목/설명 조회
  - `none`: 수동 번호 입력 또는 자동 채번

### 실행 흐름

1. **이슈 검증** (github 연동 시)

   ```bash
   gh issue view {번호} --json title,body,labels
   ```

   이슈가 없으면 에러.

2. **태스크 폴더 생성**: `workspace/tasks/{이슈번호}/`

3. **taskDetail.json 초기화**:

```json
{
  "id": "{이슈번호}",
  "title": "{이슈 제목}",
  "description": "{이슈 설명 요약}",
  "createdAt": "{ISO 8601}",
  "stack": "{profile.yaml에서 읽은 스택}",
  "mode": "{solo|team}",
  "steps": {
    "analysis": { "status": "pending" },
    "design": { "status": "pending" },
    "development": { "status": "pending" },
    "test": { "status": "pending" }
  }
}
```

4. **taskIndex.json 갱신**: 전체 태스크 인덱스에 항목 추가

### 출력

```
═══ 태스크 생성 완료 ═══
이슈: #{번호} — {제목}
모드: {team|solo}

[다음 명령]
→ /ace-analyze {번호}   요구사항 분석 (team 모드 필수)
→ /ace-dev-quick {번호}  바로 개발 (solo 모드만)
→ /ace-status            전체 현황 확인

💡 다음 작업을 진행할까요? (토큰이 소모됩니다)
```

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

[다음 명령]
→ /ace-dev {번호}  구현 이어하기
```

## history — 변경 이력

산출물 파일의 frontmatter에서 rev, lastRevDate, lastRevSummary를 읽어 이력을 출력한다.

## list — 전체 태스크 목록

taskIndex.json을 읽어 전체 태스크를 테이블로 출력한다.

```
═══ 태스크 목록 ═══

| # | 제목 | 분석 | 설계 | 개발 | 테스트 | 최근 |
|---|------|------|------|------|--------|------|
| 3 | R2 업로드 | ✓ | ✓ | ◆ | ○ | 4/4 |
| 5 | 알림톡 연동 | ○ | ○ | ○ | ○ | 4/4 |
```

## 규칙

- 태스크 폴더는 반드시 이 스킬을 통해 생성 (직접 mkdir 금지)
- taskDetail.json은 이 스킬과 hooks에서만 수정
- team 모드: 이슈 트래커 연동 필수 (create 또는 기존 이슈 start)
- GitHub Issue 생성 시 `gh` CLI 사용 (사전 설치+인증 필요)
- 이슈 생성 전 반드시 사용자에게 제목/설명 확인
