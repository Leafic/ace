# ACE — Agent-powered Code Engine

Claude Code 기반 태스크 파이프라인 프레임워크.
프로젝트별 커스텀 환경을 주입하고, 에이전트가 분석/설계/구현/검증을 수행한다.

## 특징

- **Solo / Team 모드** — 1인 개발부터 다인 협업까지
- **스킬팩 교체** — dev(코드 개발), biz(사업 아이디어) 등 도메인별 파이프라인
- **스택 프리셋** — 기술 스택별 컨벤션 자동 주입
- **프로젝트 프로필** — `profile.yaml` 한 장으로 전체 환경 정의
- **크로스 플랫폼** — macOS / Windows 지원

## 구조

```
ace/
├── core/                    # 프레임워크 코어 (불변)
│   ├── modes/               # solo.yaml, team.yaml
│   ├── hooks/               # 공통 훅 엔진
│   ├── pipeline/            # 파이프라인 상태 머신
│   └── templates/           # 산출물 템플릿 (solo/team)
│
├── packs/                   # 스킬팩 (교체 가능)
│   ├── dev/                 # 코드 개발 (분석→설계→구현→검증)
│   │   ├── skills/
│   │   └── agents/
│   └── biz/                 # 사업 아이디어 (리서치→모델링→판단)
│       ├── skills/
│       └── agents/
│
├── stacks/                  # 기술 스택 프리셋
│   ├── nextjs-fastapi-pg/
│   ├── spring-vue-mssql/
│   └── react-native-expo/
│
├── docs/                    # 가이드 문서
└── ace                      # CLI 진입점
```

## 사용법

```bash
# 프로젝트에 ACE 세팅
cd ~/project/MyProject
ace init --pack dev --stack nextjs-fastapi-pg --mode solo

# 태스크 시작
/ace task start #123

# 파이프라인 실행
/ace analyze → /ace design → /ace dev → /ace test
```

## 프로젝트 프로필

```yaml
# .ace/profile.yaml
name: RoverCare
mode: team
pack: dev

stack:
  backend: fastapi
  frontend: nextjs
  db: postgresql

roles:
  - DEV
  - PLAN
  - PUBL

mcp:
  - postgresql

domain:
  terms: ./domain/terms.md
```

## 모드

| 모드 | 설명 |
|------|------|
| **solo** | 에이전트가 모든 역할 대행. 간소화된 산출물. 빠른 파이프라인. |
| **team** | 역할 분리 + 권한 제어. 표준화된 산출물. 교차 리뷰. |

## 스킬팩

| 팩 | 파이프라인 |
|----|-----------|
| **dev** | 분석 → 설계 → 구현 → 검증 |
| **biz** | 리서치 → 모델링 → 실행계획 → 판단 |

## 라이선스

MIT
