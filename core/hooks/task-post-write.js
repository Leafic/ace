#!/usr/bin/env node

/**
 * ACE Hook: task-post-write
 * Trigger: PostToolUse (Write, Edit)
 *
 * 태스크 산출물 파일 수정 후:
 * 1. taskDetail.json의 단계 상태 동기화
 * 2. taskIndex.json 갱신
 * 3. 산출물 frontmatter에서 status 읽기
 */

const fs = require('fs')
const path = require('path')

function main() {
  const cwd = process.env.PROJECT_DIR || process.cwd()

  // stdin에서 tool_result 읽기
  let input = ''
  try {
    input = fs.readFileSync('/dev/stdin', 'utf-8')
  } catch {
    process.exit(0)
  }

  let toolResult
  try {
    toolResult = JSON.parse(input)
  } catch {
    process.exit(0)
  }

  const filePath = toolResult.file_path || toolResult.path || ''
  if (!filePath) {
    process.exit(0)
  }

  const relativePath = path.relative(cwd, filePath)

  // workspace/tasks/ 하위 파일만 처리
  if (!relativePath.startsWith('workspace/tasks/')) {
    process.exit(0)
  }

  // 태스크 폴더 식별
  const parts = relativePath.split(path.sep)
  // workspace/tasks/{taskId}/... → parts[2] = taskId
  if (parts.length < 3) {
    process.exit(0)
  }

  const taskId = parts[2]
  const taskFolder = path.join(cwd, 'workspace', 'tasks', taskId)
  const taskDetailPath = path.join(taskFolder, 'taskDetail.json')

  if (!fs.existsSync(taskDetailPath)) {
    process.exit(0)
  }

  // 산출물 파일인지 확인
  const fileName = path.basename(filePath)
  const artifactMap = {
    'analysis.md': 'analysis',
    'design.md': 'design',
    'development.md': 'development',
    'test.md': 'test',
    // biz pack
    'research.md': 'research',
    'model.md': 'model',
    'plan.md': 'plan',
    'judgement.md': 'judge',
  }

  const stepName = artifactMap[fileName]
  if (!stepName) {
    process.exit(0) // 산출물 파일이 아님
  }

  // 산출물의 frontmatter에서 status 읽기
  try {
    const content = fs.readFileSync(filePath, 'utf-8')
    const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---/)
    if (!frontmatterMatch) {
      process.exit(0)
    }

    const frontmatter = frontmatterMatch[1]
    const statusMatch = frontmatter.match(/^status:\s*(.+)$/m)
    if (!statusMatch) {
      process.exit(0)
    }

    const artifactStatus = statusMatch[1].trim()

    // taskDetail.json 갱신
    const taskDetail = JSON.parse(fs.readFileSync(taskDetailPath, 'utf-8'))
    if (!taskDetail.steps) {
      taskDetail.steps = {}
    }
    if (!taskDetail.steps[stepName]) {
      taskDetail.steps[stepName] = { status: 'pending' }
    }

    // 산출물 status: done → 단계 status: completed
    if (artifactStatus === 'done') {
      taskDetail.steps[stepName].status = 'completed'
    } else if (artifactStatus === 'in_progress') {
      // 이미 completed가 아닌 경우에만 갱신
      if (taskDetail.steps[stepName].status !== 'completed') {
        taskDetail.steps[stepName].status = 'pending'
      }
    }

    taskDetail.updatedAt = new Date().toISOString()

    fs.writeFileSync(taskDetailPath, JSON.stringify(taskDetail, null, 2), 'utf-8')

    // taskIndex.json 동기화
    syncTaskIndex(cwd, taskId, taskDetail)

    console.log(`[ACE] ${stepName}: ${artifactStatus} → taskDetail synced`)
  } catch (err) {
    console.error(`[ACE] task-post-write error: ${err.message}`)
  }

  process.exit(0)
}

function syncTaskIndex(cwd, taskId, taskDetail) {
  const indexPath = path.join(cwd, 'workspace', 'tasks', 'taskIndex.json')

  let index = { tasks: [] }
  if (fs.existsSync(indexPath)) {
    try {
      index = JSON.parse(fs.readFileSync(indexPath, 'utf-8'))
    } catch {
      index = { tasks: [] }
    }
  }

  // 기존 항목 찾기 또는 추가
  const existingIdx = index.tasks.findIndex(t => t.id === taskId)
  const summary = {
    id: taskId,
    title: taskDetail.title || taskId,
    updatedAt: taskDetail.updatedAt,
    steps: {},
  }

  // 각 단계의 상태만 요약
  if (taskDetail.steps) {
    for (const [step, info] of Object.entries(taskDetail.steps)) {
      summary.steps[step] = info.status || 'pending'
    }
  }

  if (existingIdx >= 0) {
    index.tasks[existingIdx] = summary
  } else {
    index.tasks.push(summary)
  }

  fs.writeFileSync(indexPath, JSON.stringify(index, null, 2), 'utf-8')
}

main()
