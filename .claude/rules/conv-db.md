# 개발 컨벤션 — DB (PostgreSQL 15+ + SQLAlchemy)

## 네이밍

| 대상 | 규칙 | 예시 |
|------|------|------|
| 테이블 | snake_case, 복수형 | `clients`, `training_sessions` |
| 컬럼 | snake_case | `created_at`, `trainer_id` |
| PK | `id` (UUID) | 모든 테이블 공통 |
| FK | `{참조테이블_단수}_id` | `client_id`, `dog_id` |
| 인덱스 | `ix_{테이블}_{컬럼}` | `ix_sessions_trainer_id` |
| 유니크 | `uq_{테이블}_{컬럼}` | `uq_trainers_email` |

## 필수 컬럼

모든 테이블에 아래 컬럼을 포함한다:

| 컬럼 | 타입 | 설명 |
|------|------|------|
| `id` | UUID | PK, `gen_random_uuid()` 기본값 |
| `created_at` | TIMESTAMPTZ | 생성 시각, `now()` 기본값 |
| `updated_at` | TIMESTAMPTZ | 수정 시각, 트리거/앱에서 갱신 |

## 쿼리 규칙

| 항목 | 규칙 |
|------|------|
| ORM 우선 | SQLAlchemy ORM 사용, raw SQL은 성능 최적화 시에만 |
| 파라미터 바인딩 | `:param` 바인딩 필수, 문자열 연결 금지 (SQL injection 방지) |
| 페이징 | `LIMIT-OFFSET` 또는 커서 기반 |
| 정렬 | `ORDER BY` 명시, 기본: `created_at DESC` |
| N+1 방지 | `selectinload` / `joinedload` 활용 |
| 불필요한 SELECT * | 필요한 컬럼만 선택 (`select(Client.id, Client.name)`) |

## 데이터 안전

| 항목 | 규칙 |
|------|------|
| UPDATE/DELETE | WHERE 조건으로 범위 명확히 제한 |
| soft delete | MVP에서는 hard delete, 추후 필요 시 `deleted_at` 컬럼 추가 |
| null 처리 | nullable 컬럼은 ORM 모델에서 `Optional` 타입으로 명시 |
| 참조 정합성 | FK 관계 설정, CASCADE 규칙 명시 |
| row multiplication | JOIN 시 1:N 관계 행 증폭 주의 |

## 마이그레이션 (Alembic)

| 항목 | 규칙 |
|------|------|
| 자동 생성 | `alembic revision --autogenerate -m "설명"` |
| 추가적 변경 | 컬럼 추가 > 수정/삭제, 파괴적 변경은 최후 수단 |
| 롤백 | downgrade 함수 반드시 작성 |
| 데이터 backfill | 대용량 시 배치 분할 |
| 배포 순서 | 마이그레이션 → 코드 배포 |

## 인덱스 판단

| 항목 | 규칙 |
|------|------|
| 추가 근거 | WHERE/JOIN/ORDER BY에서 사용되는 컬럼에만 |
| FK 컬럼 | 외래키 컬럼에는 기본적으로 인덱스 추가 |
| 복합 인덱스 | 자주 같이 조회되는 컬럼 조합 (순서 주의) |
| 중복 제거 | 기존 인덱스와 겹치지 않는지 확인 |

## JSONB 사용

| 항목 | 규칙 |
|------|------|
| 허용 대상 | 체크리스트, 설정값 등 유연한 구조 |
| 금지 대상 | 검색/정렬이 빈번한 데이터 (정규화 테이블로 분리) |
| 인덱스 | GIN 인덱스 활용 (`jsonb_path_ops`) |

## PostgreSQL 고유 기능

| 기능 | 용도 |
|------|------|
| `gen_random_uuid()` | UUID PK 기본값 |
| `TIMESTAMPTZ` | 시간대 포함 타임스탬프 |
| `JSONB` | 유연한 구조 데이터 |
| Array 타입 | 태그, 카테고리 등 단순 목록 |
| `ILIKE` | 대소문자 무시 검색 |
| Full-text search | `tsvector` / `tsquery` (필요 시) |
