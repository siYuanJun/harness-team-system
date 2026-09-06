#!/usr/bin/env bash
#
# Hermes Agent Team v3.0 — Harness 一键部署脚本
#
# 用法:
#   bash deploy.sh /path/to/target/project
#   bash deploy.sh /path/to/target/project --no-wiki
#   bash deploy.sh /path/to/target/project --custom wiki/dir
#
# 作用:
#   将 Hermes 五角色 Agent 定义 + Skill 定义 + 注册到 CLAUDE.md
#
# 退出码:
#   0 - 成功
#   1 - 参数错误
#   2 - 目标目录不存在
#   3 - 复制失败

set -euo pipefail

# ── 配置 ─────────────────────────────────────────────────────────
HERMES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_SRC="${HERMES_ROOT}/agents"
SKILLS_SRC="${HERMES_ROOT}/skills"
WIKI_SRC="${HERMES_ROOT}/wiki"
TEMPLATE_CLAUDE="${HERMES_ROOT}/harness-init/templates/claude.md"

VERSION="v3.0"
DATE="$(date +%Y-%m-%d)"

# ── 帮助 ─────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Hermes Agent Team v3.0 — Harness 部署脚本

用法:
  bash deploy.sh <target> [选项]

参数:
  <target>  目标项目绝对路径

选项:
  --no-wiki     不复制 wiki 知识库
  --custom PATH 使用自定义 wiki 目录
  -h, --help    显示帮助

示例:
  bash deploy.sh ~/my-project
  bash deploy.sh ~/my-project --no-wiki
EOF
}

# ── 参数解析 ─────────────────────────────────────────────────────
TARGET=""
COPY_WIKI=true
CUSTOM_WIKI=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --no-wiki)
            COPY_WIKI=false
            shift
            ;;
        --custom)
            CUSTOM_WIKI="$2"
            shift 2
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# ── 校验 ─────────────────────────────────────────────────────────
if [[ -z "$TARGET" ]]; then
    echo "❌ 错误: 未指定目标项目路径"
    usage
    exit 1
fi

if [[ ! -d "$TARGET" ]]; then
    echo "❌ 错误: 目标目录不存在: $TARGET"
    exit 2
fi

# 解析绝对路径
TARGET="$(cd "$TARGET" && pwd)"

echo "═══════════════════════════════════════════════════════════"
echo "  Hermes Agent Team v3.0 — Harness 部署"
echo "═══════════════════════════════════════════════════════════"
echo "  目标项目: $TARGET"
echo "  版本:     $VERSION"
echo "  日期:     $DATE"
echo ""

# ── 1. 创建目录结构 ──────────────────────────────────────────────
echo "▶ 创建目录结构..."
mkdir -p "${TARGET}/.claude/agents"
mkdir -p "${TARGET}/.claude/skills"
mkdir -p "${TARGET}/.ai-workflow/hermes/projects"

# ── 2. 复制 Agent 定义 ───────────────────────────────────────────
echo "▶ 复制 Agent 定义 (5个角色)..."
if ! cp "${AGENTS_SRC}"/*.md "${TARGET}/.claude/agents/"; then
    echo "❌ 错误: Agent 定义复制失败"
    exit 3
fi

AGENT_COUNT=$(ls "${TARGET}/.claude/agents"/hermes-*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  ✓ 已复制 ${AGENT_COUNT} 个 Agent 定义"
echo "    - hermes-coordinator.md"
echo "    - hermes-researcher.md"
echo "    - hermes-writer.md"
echo "    - hermes-editor.md"
echo "    - hermes-human-protocol.md"

# ── 3. 复制 Skill 定义 ───────────────────────────────────────────
echo "▶ 复制 Skill 定义..."
for skill in hermes-orchestrator hermes-researcher hermes-writer hermes-editor; do
    if [[ -d "${SKILLS_SRC}/${skill}" ]]; then
        rm -rf "${TARGET}/.claude/skills/${skill}"
        cp -r "${SKILLS_SRC}/${skill}" "${TARGET}/.claude/skills/"
        echo "  ✓ 已复制: ${skill}/"
    fi
done

# ── 4. 复制 Wiki 知识库 ──────────────────────────────────────────
if [[ "$COPY_WIKI" == true ]]; then
    WIKI_SELECTED="$WIKI_SRC"
    if [[ -n "$CUSTOM_WIKI" ]]; then
        WIKI_SELECTED="$CUSTOM_WIKI"
    fi
    echo "▶ 复制 Wiki 知识库..."
    if [[ -d "$WIKI_SELECTED" ]]; then
        mkdir -p "${TARGET}/.ai-workflow/hermes/wiki"
        cp -r "${WIKI_SELECTED}"/*.md "${TARGET}/.ai-workflow/hermes/wiki/"
        echo "  ✓ 已复制: wiki/ (${WIKI_SELECTED})"
    else
        echo "  ⚠️ 未找到 wiki 目录: $WIKI_SELECTED"
    fi
else
    echo "▶ 跳过 Wiki 知识库复制 (--no-wiki)"
fi

# ── 5. 注册到 CLAUDE.md ──────────────────────────────────────────
echo "▶ 注册到 CLAUDE.md..."

CLAUDE_MD="${TARGET}/CLAUDE.md"
if [[ ! -f "$CLAUDE_MD" ]]; then
    touch "$CLAUDE_MD"
    echo "# $(basename "$TARGET")" >> "$CLAUDE_MD"
    echo "" >> "$CLAUDE_MD"
    echo "> 项目说明文档" >> "$CLAUDE_MD"
    echo "" >> "$CLAUDE_MD"
fi

# 检查是否已注册
if grep -q "## Hermes Agent Team" "$CLAUDE_MD" 2>/dev/null; then
    echo "  ⚠️ Hermes 已注册，跳过注册步骤"
    echo "  (如需重新注册，请手动删除 CLAUDE.md 中的 Hermes 部分)"
else
    # 读取模板并替换变量
    if [[ -f "$TEMPLATE_CLAUDE" ]]; then
        sed "s/{DATE}/$DATE/g; s/{VERSION}/$VERSION/g" "$TEMPLATE_CLAUDE" >> "$CLAUDE_MD"
    else
        cat >> "$CLAUDE_MD" <<'EOF'

## Hermes Agent Team

**触发规则**：当用户要求深度研究、内容生产、需要质量审计的复杂任务时，使用 hermes-agent-team skill。

**触发词**：
- 启动hermes团队
- 五角色协作
- 深度研究
- 需要事实核查
- 内容生产流程
- hermes初始化
- 构建hermes架构

**变更历史**：
| 日期 | 变更内容 | 目标 | 理由 |
|------|----------|------|------|
| {DATE} | 初始化 Hermes v3.0 | 整体 | 引入五角色协作框架 |
EOF
    fi
    echo "  ✓ 已注册到 CLAUDE.md"
fi

# ── 6. 部署报告 ──────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  ✅ Hermes Agent Team v3.0 部署完成"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "  📂 Agent 定义:  .claude/agents/        (5个角色)"
echo "  📂 Skill 定义:  .claude/skills/        (4个技能)"
if [[ "$COPY_WIKI" == true ]]; then
    echo "  📂 Wiki 知识库: .ai-workflow/hermes/wiki/"
fi
echo "  📂 项目数据:    .ai-workflow/hermes/projects/"
echo ""
echo "  下一步:"
echo "    1. 在 Claude Code 中打开 $TARGET"
echo "    2. 输入: 启动hermes团队，帮我深度研究..."
echo "    3. 或输入: 用harness初始化hermes团队 进行完整初始化"
echo ""
exit 0
