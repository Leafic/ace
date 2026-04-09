# 개발 컨벤션 — 프론트엔드 (Next.js 14+ App Router + TypeScript + Tailwind)

## 포맷팅 (Prettier/ESLint)

| 항목 | 규칙 |
|------|------|
| 들여쓰기 | **2 spaces** |
| 세미콜론 | 없음 |
| 따옴표 | 싱글쿼트 |
| printWidth | 100자 |
| 후행 쉼표 | 항상 |

## 네이밍

| 대상 | 규칙 | 예시 |
|------|------|------|
| 파일 (페이지) | kebab-case | `client-list/page.tsx` |
| 파일 (컴포넌트) | kebab-case | `session-card.tsx` |
| 파일 (서비스/훅) | kebab-case | `use-clients.ts`, `client-api.ts` |
| 컴포넌트 | PascalCase | `ClientList`, `SessionCard` |
| 변수/함수 | camelCase | `clientData`, `fetchSessions` |
| 상수 | UPPER_SNAKE | `MAX_PAGE_SIZE` |
| 타입/인터페이스 | PascalCase | `Client`, `SessionFormData` |

## 디렉토리 구조 (App Router)

```
src/
├── app/                     # 라우트 (App Router)
│   ├── (auth)/              # 인증 필요 라우트 그룹
│   │   ├── clients/
│   │   ├── sessions/
│   │   └── layout.tsx
│   ├── p/[uuid]/            # Magic Link 공개 라우트
│   └── layout.tsx
├── components/
│   ├── ui/                  # shadcn/ui 컴포넌트
│   └── {도메인}/            # 도메인별 컴포넌트
├── lib/
│   ├── api/                 # API 호출 함수 (도메인별)
│   └── utils.ts
├── hooks/                   # 커스텀 훅
├── stores/                  # Zustand 스토어
├── types/                   # 타입 정의 (도메인별)
└── styles/                  # 전역 스타일
```

## 컴포넌트 구조

```tsx
// 함수형 컴포넌트 + arrow function
const ClientCard = ({ client, onEdit }: ClientCardProps) => {
  // hooks
  // state
  // handlers
  // render
  return (...)
}

export default ClientCard
```

**필수 규칙:**
- 함수형 컴포넌트 + arrow function
- Props 타입은 `{ComponentName}Props` 네이밍
- `'use client'` / `'use server'` 디렉티브 명시

## 상태 관리

| 분류 | 도구 | 용도 |
|------|------|------|
| 서버 상태 | TanStack React Query | API 데이터 캐싱/동기화 |
| 클라이언트 전역 | Zustand | 인증, UI 상태 등 |
| 로컬 | useState / useReducer | 컴포넌트 내부 상태 |

## API 호출 패턴

```typescript
// src/lib/api/clients.ts
export const clientApi = {
  list: (params: ClientListParams) =>
    api.get<PaginatedResponse<Client>>('/api/v1/clients', { params }),

  getById: (id: string) =>
    api.get<DataResponse<Client>>(`/api/v1/clients/${id}`),

  create: (data: ClientCreate) =>
    api.post<DataResponse<Client>>('/api/v1/clients', data),
}
```

```typescript
// 컴포넌트에서 React Query 사용
const { data, isLoading } = useQuery({
  queryKey: ['clients', params],
  queryFn: () => clientApi.list(params),
})
```

## UI 컴포넌트

| 항목 | 규칙 |
|------|------|
| 기본 UI | shadcn/ui 컴포넌트 사용 (`src/components/ui/`) |
| 스타일링 | Tailwind CSS (인라인 유틸리티 클래스) |
| 아이콘 | Lucide React |
| 커스텀 | shadcn/ui 기반 확장, 도메인별 폴더에 배치 |

## UX 상태 처리

> 모든 UI 변경은 아래 상태를 고려한다. 누락하면 불완전한 구현이다.

| 상태 | 처리 |
|------|------|
| loading | 데이터 로딩 중 시각적 피드백 (Skeleton, Spinner) |
| empty | 데이터 없을 때 안내 메시지 |
| error | API 실패 시 사용자 친화적 에러 + 재시도 |
| disabled | 권한 없음/조건 미충족 시 비활성 표시 |
| 폼 검증 | 인라인 에러 메시지 + 제출 차단 |
| 파괴적 액션 | 삭제 등 확인 다이얼로그 필수 |
| 중복 제출 | 로딩 중 disabled 또는 debounce |

## 접근성

| 항목 | 규칙 |
|------|------|
| 시맨틱 HTML | `<button>`, `<nav>`, `<main>` 등 의미 있는 태그 |
| 키보드 접근 | 인터랙티브 요소는 키보드로 접근/조작 가능 |
| label 연결 | 폼 요소에 `<label>` 또는 `aria-label` 필수 |
| 이미지 alt | `<img>`에 `alt` 필수 |

## 성능

| 항목 | 규칙 |
|------|------|
| 서버 컴포넌트 | 가능한 한 Server Component 활용 (기본값) |
| 클라이언트 최소화 | `'use client'`는 필요한 곳에만 |
| 이미지 최적화 | `next/image` 사용 |
| 코드 분할 | dynamic import (`next/dynamic`) |
| 리스트 | 대량 목록은 가상화 검토 |
