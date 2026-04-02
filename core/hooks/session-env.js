#!/usr/bin/env node

/**
 * ACE Hook: session-env
 * Trigger: SessionStart
 *
 * 프로젝트 프로필(.ace/profile.yaml)을 읽어 환경 정보를 출력한다.
 * Claude Code가 세션 시작 시 프로젝트 컨텍스트를 파악할 수 있게 한다.
 */

const fs = require('fs')
const path = require('path')

function main() {
  const cwd = process.env.PROJECT_DIR || process.cwd()

  // .ace/profile.yaml 찾기
  const profilePath = path.join(cwd, '.ace', 'profile.yaml')
  if (!fs.existsSync(profilePath)) {
    // ACE 미설정 프로젝트 — 조용히 종료
    process.exit(0)
  }

  const profile = fs.readFileSync(profilePath, 'utf-8')

  // 간단한 YAML 파싱 (외부 의존성 없이)
  const name = extractYamlValue(profile, 'name')
  const mode = extractYamlValue(profile, 'mode')
  const pack = extractYamlValue(profile, 'pack')

  const lines = [
    `[ACE] Project: ${name}`,
    `[ACE] Mode: ${mode} | Pack: ${pack}`,
  ]

  // 스택 정보
  const backendMatch = profile.match(/^\s+backend:\s*(.+)$/m)
  const frontendMatch = profile.match(/^\s+frontend:\s*(.+)$/m)
  const dbMatch = profile.match(/^\s+db:\s*(.+)$/m)

  if (backendMatch || frontendMatch || dbMatch) {
    const parts = []
    if (backendMatch) parts.push(backendMatch[1].trim())
    if (frontendMatch) parts.push(frontendMatch[1].trim())
    if (dbMatch) parts.push(dbMatch[1].trim())
    lines.push(`[ACE] Stack: ${parts.join(' + ')}`)
  }

  // 이슈 트래커
  const trackerType = extractYamlValue(profile, 'type')
  if (trackerType && trackerType !== 'none') {
    lines.push(`[ACE] Tracker: ${trackerType}`)
  }

  // workspace/tasks/ 태스크 현황
  const taskIndexPath = path.join(cwd, 'workspace', 'tasks', 'taskIndex.json')
  if (fs.existsSync(taskIndexPath)) {
    try {
      const taskIndex = JSON.parse(fs.readFileSync(taskIndexPath, 'utf-8'))
      const taskCount = taskIndex.tasks ? taskIndex.tasks.length : 0
      lines.push(`[ACE] Tasks: ${taskCount} registered`)
    } catch {
      // taskIndex 파싱 실패 — 무시
    }
  }

  console.log(lines.join('\n'))
}

function extractYamlValue(yaml, key) {
  const match = yaml.match(new RegExp(`^${key}:\\s*(.+)$`, 'm'))
  return match ? match[1].trim() : null
}

main()
