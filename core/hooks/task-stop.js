#!/usr/bin/env node

/**
 * ACE Hook: task-stop
 * Trigger: Stop (세션 종료)
 * Timeout: 10000ms
 *
 * 세션 종료 시:
 * 1. 현재 작업 중인 태스크의 상태 정리
 * 2. 완료 요약 출력
 */

const fs = require('fs')
const path = require('path')

function main() {
  const cwd = process.env.PROJECT_DIR || process.cwd()

  const taskIndexPath = path.join(cwd, 'workspace', 'tasks', 'taskIndex.json')
  if (!fs.existsSync(taskIndexPath)) {
    process.exit(0)
  }

  let index
  try {
    index = JSON.parse(fs.readFileSync(taskIndexPath, 'utf-8'))
  } catch {
    process.exit(0)
  }

  if (!index.tasks || index.tasks.length === 0) {
    process.exit(0)
  }

  // 가장 최근 업데이트된 태스크 찾기
  const sorted = [...index.tasks].sort((a, b) => {
    const dateA = a.updatedAt ? new Date(a.updatedAt) : new Date(0)
    const dateB = b.updatedAt ? new Date(b.updatedAt) : new Date(0)
    return dateB - dateA
  })

  const latest = sorted[0]
  if (!latest || !latest.steps) {
    process.exit(0)
  }

  // 요약 출력
  const lines = [
    '',
    `═══ ACE Session Summary ═══`,
    `Task: ${latest.id} — ${latest.title || '(untitled)'}`,
    '',
  ]

  const stepNames = {
    // dev pack
    analysis: '분석',
    design: '설계',
    development: '개발',
    test: '테스트',
    // biz pack
    research: '리서치',
    model: '모델링',
    plan: '실행계획',
    judge: '판단',
  }

  const statusIcons = {
    completed: '✓',
    pending: '○',
    skipped: '—',
  }

  lines.push('| 단계 | 상태 |')
  lines.push('|------|------|')

  for (const [step, status] of Object.entries(latest.steps)) {
    const name = stepNames[step] || step
    const icon = statusIcons[status] || '?'
    lines.push(`| ${name} | ${icon} ${status} |`)
  }

  lines.push('')

  console.log(lines.join('\n'))
  process.exit(0)
}

main()
