# /ace dev — 코드 구현

## 사용법

```
/ace dev [이슈번호]
```

## 선행 조건
- solo 모드: design 완료 또는 스킵 가능
- team 모드: design 완료 필수

## 실행 흐름

### Step 1: 컨텍스트 로딩

1. design.md 읽기 (없으면 analysis.md)
2. 스택 컨벤션 로딩
3. 기존 코드 파악 (변경 대상 파일)

### Step 2: 구현

design.md의 설계를 기반으로 코드를 구현한다.

**구현 순서:**
1. DB 마이그레이션 (스키마 변경이 있으면)
2. 백엔드 — 모델 → 스키마 → 서비스 → 라우터
3. 프론트엔드 — 타입 → API → 컴포넌트 → 페이지
4. 각 항목 완료 후 즉시 development.md에 기록

### Step 3: 산출물 작성

`workspace/tasks/{번호}/development.md`를 작성/갱신한다.

**기록 내용:**
- 구현 완료 항목 (파일명, 변경 내용)
- 설계 대비 변경 사항 (있으면)
- 다음 작업 계획
- 합의 사항

### Step 4: 자동 검증

구현 완료 후 자동으로 검증을 수행한다:

1. **gate 에이전트 호출** (읽기 전용 검증)
   - 컨벤션 준수 여부
   - 보안 패턴 위반
   - 잠재적 버그
   - 설계 대비 누락

2. **findings 분류:**
   - `auto-fixable`: 자동 수정 가능 → 즉시 수정
   - `needs-decision`: 판단 필요 → 사용자에게 보고

3. **자동 수정 루프** (최대 2회):
   - auto-fixable 항목 수정
   - 재검증
   - 잔존 findings 보고

### Step 5: 상태 갱신

- development.md frontmatter: `status: done`
- taskDetail.json: `steps.development.status: completed`

## 완료 시 출력

```
═══ 개발 완료 요약 (#{번호}) ═══

[핵심 결론]
- 구현 파일 수, 주요 변경 로직, 검증 결과

[주요 결정 사항]
1. ...

[미해결/리스크]
- ...

[다음 단계 참고]
- 테스트 시 확인할 핵심 포인트
```
