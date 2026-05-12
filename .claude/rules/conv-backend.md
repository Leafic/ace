# 개발 컨벤션 — 백엔드 (FastAPI + Python 3.10+ + SQLAlchemy)

## 포맷팅

| 항목 | 규칙 |
|------|------|
| 들여쓰기 | **4 spaces** |
| 인코딩 | UTF-8 |
| 포매터 | Black (line-length=88) |
| 린터 | Ruff |
| import 정렬 | isort (Black 호환 프로파일) |

## 네이밍

| 대상 | 규칙 | 예시 |
|------|------|------|
| 모듈/파일 | snake_case | `user_router.py`, `task_service.py` |
| 클래스 | PascalCase | `UserService`, `TaskSchema` |
| 함수/변수 | snake_case | `get_user_list`, `task_count` |
| 상수 | UPPER_SNAKE | `MAX_PAGE_SIZE`, `DEFAULT_SORT` |
| 환경변수 | UPPER_SNAKE | `DATABASE_URL`, `JWT_SECRET` |

## 디렉토리 구조

```
backend/app/
├── api/                 # 라우터 (도메인별 파일)
│   ├── users.py
│   ├── projects.py
│   ├── tasks.py
│   └── deps.py          # 공통 의존성 (get_db, get_current_user)
├── models/              # SQLAlchemy ORM 모델
├── schemas/             # Pydantic v2 스키마 (Request/Response 분리)
├── services/            # 비즈니스 로직
├── core/                # 설정, 보안, 미들웨어
│   ├── config.py
│   ├── security.py
│   └── database.py
└── main.py              # FastAPI 앱 진입점
```

## 레이어 규칙

| 레이어 | 규칙 |
|--------|------|
| Router | 비즈니스 로직 금지, Service 위임만 수행 |
| Router | `APIRouter` + 태그/prefix 설정, Depends로 의존성 주입 |
| Router | 응답 모델 명시: `response_model=UserResponse` |
| Service | 비즈니스 로직 집중, DB 세션은 파라미터로 주입 |
| Service | 단일 책임 — 도메인별 서비스 클래스 분리 |
| Model | SQLAlchemy 모델, 테이블 매핑, 관계 정의 |
| Schema | Pydantic v2 — `UserCreate`(입력), `UserResponse`(출력) 분리 |

## API 패턴

```python
# Router 예시
@router.get("", response_model=PaginatedResponse[UserResponse])
async def list_users(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    q: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await user_service.list_users(db, current_user.id, page, size, q)
```

## 응답/예외

| 항목 | 규칙 |
|------|------|
| 응답 래핑 | `{ "data": T }` (단건), `{ "data": [...], "total": N }` (목록) |
| 비즈니스 예외 | `HTTPException(status_code=400, detail="메시지")` |
| 공통 예외 | 예외 핸들러 등록 (`@app.exception_handler`) |
| Validation | Pydantic v2 자동 검증 (422 응답) |

## SQLAlchemy 패턴

```python
# Model 예시
class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    owner_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("accounts.id"))
    name: Mapped[str] = mapped_column(String(50))
    email: Mapped[str | None] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(server_default=func.now(), onupdate=func.now())

    tasks: Mapped[list["Task"]] = relationship(back_populates="owner")
```

## 기타

| 항목 | 규칙 |
|------|------|
| DI | FastAPI Depends |
| 비동기 | async/await 기본, SQLAlchemy async session |
| 로깅 | `logging` 모듈 + structlog 권장 |
| 설정 | Pydantic Settings (`BaseSettings`) |
| 마이그레이션 | Alembic |
| API prefix | `/api/v1/` |
| PK | UUID (모든 엔티티) |

## 판단 기준

### 트랜잭션

| 상황 | 판단 |
|------|------|
| 조회만 | `db.execute()` — 별도 커밋 불필요 |
| 단순 CUD | `db.commit()` 1회 |
| 복합 CUD | `async with db.begin()` 명시적 트랜잭션 |
| 외부 API 포함 | DB 변경과 외부 호출 분리, 보상 트랜잭션 고려 |

### 에러 처리

| 상황 | 판단 |
|------|------|
| 리소스 미존재 | `HTTPException(404)` |
| 권한 없음 | `HTTPException(403)` |
| 비즈니스 규칙 위반 | `HTTPException(400, detail="구체적 사유")` |
| 서버 내부 오류 | 로깅 후 `HTTPException(500)` (스택트레이스 숨김) |
