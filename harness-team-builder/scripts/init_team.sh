#!/bin/bash
# harness-team-builder · 团队目录初始化脚本
# 用法：./init_team.sh <团队前缀> <项目名称> [团队规模]
# 示例：./init_team.sh dome ontology-brain standard
# 团队规模：minimal（4人）/ standard（7人，默认）/ extended（10人）

set -e

if [ $# -lt 2 ]; then
  echo "用法: $0 <团队前缀> <项目名称> [团队规模]"
  echo "示例: $0 dome ontology-brain standard"
  echo "团队规模: minimal(4人) / standard(7人,默认) / extended(10人)"
  exit 1
fi

TEAM="$1"
PROJECT="$2"
SIZE="${3:-standard}"
DATE=$(date +%Y-%m-%d)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../templates"

echo "=== harness-team-builder · 团队初始化 ==="
echo "团队前缀: ${TEAM}"
echo "项目名称: ${PROJECT}"
echo "团队规模: ${SIZE}"
echo "日期: ${DATE}"
echo ""

# 根据规模确定角色
case "$SIZE" in
  minimal)
    ROLES="orchestrator engineer acceptor pm"
    SIZE_LABEL="最小团队（4人）"
    ;;
  standard)
    ROLES="orchestrator engineer acceptor pm content-creator content-reviewer knowledge-keeper"
    SIZE_LABEL="标准团队（7人）"
    ;;
  extended)
    ROLES="orchestrator engineer acceptor pm content-creator content-reviewer knowledge-keeper merge-engineer research-agent modeling-agent"
    SIZE_LABEL="扩展团队（10人）"
    ;;
  *)
    echo "错误: 团队规模必须是 minimal / standard / extended"
    exit 1
    ;;
esac

# 创建目录
mkdir -p .claude/agents
mkdir -p ".claude/skills/${TEAM}-orchestrator/references"

echo "创建目录结构:"
echo "  .claude/agents/"
echo "  .claude/skills/${TEAM}-orchestrator/references/"
echo ""

# 生成角色文件
echo "生成角色定义文件:"
for role in $ROLES; do
  role_file=".claude/agents/${role}.md"
  if [ -f "${TEMPLATE_DIR}/agent.md.template" ]; then
    sed -e "s/{{TEAM}}/${TEAM}/g" \
        -e "s/{{ROLE}}/${role}/g" \
        -e "s/{{DATE}}/${DATE}/g" \
        "${TEMPLATE_DIR}/agent.md.template" > "$role_file"
    echo "  [OK] ${role}.md"
  else
    echo "  [FAIL] 模板不存在: agent.md.template"
  fi
done

# 生成编排器 skill
echo ""
echo "生成编排器 skill:"
if [ -f "${TEMPLATE_DIR}/orchestrator-SKILL.md.template" ]; then
  sed -e "s/{{TEAM}}/${TEAM}/g" \
      -e "s/{{DATE}}/${DATE}/g" \
      "${TEMPLATE_DIR}/orchestrator-SKILL.md.template" > ".claude/skills/${TEAM}-orchestrator/SKILL.md"
  echo "  [OK] ${TEAM}-orchestrator/SKILL.md"
else
  echo "  [FAIL] 模板不存在: orchestrator-SKILL.md.template"
fi

# 生成 roadmap 底稿
cat > ".claude/skills/${TEAM}-orchestrator/references/roadmap.md" << EOF
# ${PROJECT} · 项目状态底稿

> 由 harness-team-builder 生成 · ${DATE}

## 项目目标

${PROJECT}

## 已完成

- [ ] （待填写）

## 缺口

- [ ] （待填写）

## 仓库拓扑

- （待填写：主要目录和文件）

## 优先级

1. （待填写）
EOF
echo "  [OK] references/roadmap.md"

# 生成 CLAUDE.md
echo ""
echo "生成 CLAUDE.md:"
if [ -f "${TEMPLATE_DIR}/CLAUDE.md.template" ]; then
  sed -e "s/{{PROJECT_NAME}}/${PROJECT}/g" \
      -e "s/{{TEAM}}/${TEAM}/g" \
      -e "s/{{TEAM_SIZE}}/$(echo $ROLES | wc -w | tr -d ' ')/g" \
      -e "s/{{TEAM_LEVEL}}/${SIZE_LABEL}/g" \
      -e "s/{{DATE}}/${DATE}/g" \
      -e "s/{{PROJECT_GOAL}}/（待填写：项目一句话目标）/g" \
      "${TEMPLATE_DIR}/CLAUDE.md.template" > "CLAUDE.md"
  echo "  [OK] CLAUDE.md"
else
  echo "  [FAIL] 模板不存在: CLAUDE.md.template"
fi

echo ""
echo "=== 完成 ==="
echo "团队目录骨架已创建。角色: ${ROLES}"
echo ""
echo "下一步："
echo "  1. 编辑 .claude/agents/ 下各角色文件，填充具体职责（模板里的 {{占位符}}）"
echo "  2. 编辑 CLAUDE.md，填写项目一句话目标和实际路由表"
echo "  3. 编辑编排器 skill 的路由表和 Phase 流程"
echo "  4. 按质量门标准自检（见 harness-team-builder/references/quality-gates.md）"
echo "  5. git 提交"
