---
status: in_progress
rev: 1
lastRevDate: {{date}}
lastRevSummary: 초기 설계
---

# 설계 — {{taskId}}

> {{taskTitle}}

## 1. 변경 개요

### 수정/추가 파일 목록

| 파일 | 유형 | 변경 내용 |
|------|------|----------|
| | 신규/수정 | |

## 2. 데이터 모델

### DDL

```sql
-- 테이블 생성/변경
```

### ERD 관계

```
엔티티A 1──N 엔티티B
```

## 3. API 설계

### 엔드포인트

| method | path | 설명 | 인증 |
|--------|------|------|------|
| | | | |

### 요청/응답 스키마

```typescript
// Request
interface CreateFooRequest {
  // ...
}

// Response
interface FooResponse {
  // ...
}
```

### 에러 응답

| 상황 | status | detail |
|------|--------|--------|
| | 400 | |
| | 404 | |

## 4. UI 설계

### 컴포넌트 구조

```
PageComponent
├── HeaderSection
├── ContentArea
│   ├── FilterBar
│   └── DataList
│       └── DataItem
└── ActionButtons
```

### 상태 관리

| 상태 | 도구 | 설명 |
|------|------|------|
| | React Query / Zustand / useState | |

## 5. 설계 결정

| # | 결정 | 대안 | 근거 |
|---|------|------|------|
| 1 | | | |

## 6. 설계 검증 (team 모드)

> design-critic 에이전트 리뷰 결과

| # | 카테고리 | 발견 | 조치 |
|---|---------|------|------|
| | | | |

---

## 변경 이력

| rev | 날짜 | 요약 |
|-----|------|------|
| 1 | {{date}} | 초기 설계 |
