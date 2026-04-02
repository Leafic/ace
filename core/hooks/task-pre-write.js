#!/usr/bin/env node

/**
 * ACE Hook: task-pre-write
 * Trigger: PreToolUse (Write, Edit, Bash)
 *
 * team 모드에서 역할 기반 파일 수정 권한을 검증한다.
 * solo 모드에서는 비활성화 (hooks.yaml의 mode: team 설정).
 *
 * 입력: stdin으로 tool_input JSON
 * 출력: 차단 시 stderr에 메시지 + exit 1
 */

const fs = require('fs')
const path = require('path')

// 역할별 수정 가능 경로
const ROLE_PERMISSIONS = {
  DEV: [
    'workspace/tasks/*/developer/',
    'workspace/tasks/*/shared/',
    'workspace/memo/',
  ],
  PUBL: [
    'workspace/tasks/*/publisher/',
    'workspace/tasks/*/shared/',
    'workspace/memo/',
  ],
  PLAN: [
    'workspace/tasks/*/planner/',
    'workspace/tasks/*/shared/',
    'workspace/memo/',
  ],
}

// 모든 역할이 수정 가능한 공유 파일
const SHARED_FILES = [
  'taskDetail.json',
  'processLog.json',
  'taskIndex.json',
]

function main() {
  const cwd = process.env.PROJECT_DIR || process.cwd()

  // profile.yaml 확인
  const profilePath = path.join(cwd, '.ace', 'profile.yaml')
  if (!fs.existsSync(profilePath)) {
    process.exit(0) // ACE 미설정
  }

  const profile = fs.readFileSync(profilePath, 'utf-8')
  const mode = extractYamlValue(profile, 'mode')

  // solo 모드는 권한 체크 안 함
  if (mode !== 'team') {
    process.exit(0)
  }

  // 현재 역할 확인 (환경변수 또는 profile에서)
  const role = process.env.ACE_ROLE || 'DEV'

  // stdin에서 tool_input 읽기
  let input = ''
  try {
    input = fs.readFileSync('/dev/stdin', 'utf-8')
  } catch {
    process.exit(0) // stdin 없으면 통과
  }

  let toolInput
  try {
    toolInput = JSON.parse(input)
  } catch {
    process.exit(0) // 파싱 실패 시 통과
  }

  // 수정 대상 파일 경로 추출
  const filePath = toolInput.file_path || toolInput.path || ''
  if (!filePath) {
    process.exit(0)
  }

  const relativePath = path.relative(cwd, filePath)

  // 공유 파일 체크
  const basename = path.basename(relativePath)
  if (SHARED_FILES.includes(basename)) {
    process.exit(0) // 공유 파일은 모든 역할 허용
  }

  // 역할별 권한 체크
  const allowedPaths = ROLE_PERMISSIONS[role] || []
  const isAllowed = allowedPaths.some(pattern => {
    const regex = new RegExp('^' + pattern.replace(/\*/g, '[^/]+').replace(/\//g, '\\/'))
    return regex.test(relativePath)
  })

  if (!isAllowed && relativePath.startsWith('workspace/')) {
    console.error(`[ACE] BLOCKED: Role '${role}' cannot modify '${relativePath}'`)
    console.error(`[ACE] Allowed paths for ${role}: ${allowedPaths.join(', ')}`)
    process.exit(1)
  }

  process.exit(0)
}

function extractYamlValue(yaml, key) {
  const match = yaml.match(new RegExp(`^${key}:\\s*(.+)$`, 'm'))
  return match ? match[1].trim() : null
}

main()
