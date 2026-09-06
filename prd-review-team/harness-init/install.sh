#!/usr/bin/env bash
#
# PRD Review Team v1.1 — 多工具一键安装脚本
#
# 支持工具:
#   qianwen    千问办公助手（规范目录 .agents/ + AGENTS.md 注册）
#   codex      OpenAI Codex（规范目录 .agents/ + AGENTS.md 注册）
#   claude     Claude Code（.claude/agents/ + .claude/skills/ + CLAUDE.md 注册）
#   codebuddy  腾讯 CodeBuddy（.codebuddy/agents/ + CODEBUDDY.md 注册）
#
# 用法:
#   bash install.sh /path/to/project                        # auto: 按项目已有配置自动判断
#   bash install.sh /path/to/project --tools all            # 全部工具都装
#   bash install.sh /path/to/project --tools claude,codex   # 指定工具（逗号分隔）
#   bash install.sh /path/to/project --force                # 覆盖已有安装
#
# 说明:
#   - 团队资产始终安装在 .agents/prd-review-team/（单一事实来源）
#   - AGENTS.md 注册段始终写入（Codex / 千问办公助手 / 通用 Agent 均读取）
#   - claude / codebuddy 额外复制角色与技能到各自原生目录
#
# 退出码:
#   0 - 成功
#   1 - 参数错误
#   2 - 目标目录不存在
#   3 - 复制失败

set -euo pipefail

TEAM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_SRC="${TEAM_ROOT}/agents"
SKILLS_SRC="${TEAM_ROOT}/skills"
VERSION="v1.2"
MARKER_BEGIN="<!-- prd-review-team:begin -->"
MARKER_END="<!-- prd-review-team:end -->"

usage() {
    cat <<EOF
PRD Review Team ${VERSION} — 多工具一键安装

用法:
  bash install.sh <目标项目绝对路径> [选项]

选项:
  --tools LIST  安装目标，逗号分隔，可选值:
                auto(默认) / all / qianwen / codex / claude / codebuddy
                auto = 规范目录 + AGENTS.md，若项目已有 .claude/ 或
                CLAUDE.md 则追加 Claude Code 集成，.codebuddy/ 或
                CODEBUDDY.md 同理
  --force       覆盖目标项目中已有的 prd-review-team 安装
  -h, --help    显示帮助

示例:
  bash install.sh ~/my-project
  bash install.sh ~/my-project --tools all
  bash install.sh ~/my-project --tools claude,codebuddy --force
EOF
}

TARGET=""
TOOLS="auto"
FORCE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        --force) FORCE=true; shift ;;
        --tools)
            [[ $# -ge 2 ]] || { echo "错误: --tools 缺少取值" >&2; exit 1; }
            TOOLS="$2"; shift 2 ;;
        --tools=*) TOOLS="${1#--tools=}"; shift ;;
        -*) echo "错误: 未知选项 $1" >&2; usage; exit 1 ;;
        *) TARGET="$1"; shift ;;
    esac
done

if [[ -z "${TARGET}" ]]; then
    echo "错误: 缺少目标项目路径" >&2
    usage
    exit 1
fi

if [[ ! -d "${TARGET}" ]]; then
    echo "错误: 目标目录不存在: ${TARGET}" >&2
    exit 2
fi

# ── 解析安装目标 ─────────────────────────────────────────────────
DO_CLAUDE=false
DO_CODEBUDDY=false

case "${TOOLS}" in
    auto)
        [[ -d "${TARGET}/.claude" || -f "${TARGET}/CLAUDE.md" ]] && DO_CLAUDE=true
        [[ -d "${TARGET}/.codebuddy" || -f "${TARGET}/CODEBUDDY.md" ]] && DO_CODEBUDDY=true
        ;;
    all)
        DO_CLAUDE=true
        DO_CODEBUDDY=true
        ;;
    *)
        IFS=',' read -ra TOOL_LIST <<< "${TOOLS}"
        for t in "${TOOL_LIST[@]}"; do
            case "${t}" in
                qianwen|codex) ;;  # 规范目录 + AGENTS.md，始终执行
                claude) DO_CLAUDE=true ;;
                codebuddy) DO_CODEBUDDY=true ;;
                *) echo "错误: 未知工具 '${t}'（可选: qianwen/codex/claude/codebuddy/all/auto）" >&2; exit 1 ;;
            esac
        done
        ;;
esac

DEST="${TARGET}/.agents/prd-review-team"
ROLE_FILES=(prd-pm-industry.md prd-pm-value.md prd-pm-rationality.md prd-tech-lead.md)

# ── 冲突检查 ─────────────────────────────────────────────────────
if [[ -d "${DEST}" && "${FORCE}" != "true" ]]; then
    echo "检测到已安装: ${DEST}"
    echo "如需覆盖请使用 --force"
    exit 1
fi

# ── 安装规范目录（所有工具共用的单一事实来源） ──────────────────
if [[ -d "${DEST}" ]]; then
    rm -rf "${DEST}"
fi
mkdir -p "${DEST}/agents" "${DEST}/skills"
cp -R "${AGENTS_SRC}/." "${DEST}/agents/" || { echo "错误: 复制角色定义失败" >&2; exit 3; }
cp -R "${SKILLS_SRC}/." "${DEST}/skills/" || { echo "错误: 复制编排技能失败" >&2; exit 3; }
echo "✅ 规范目录: ${DEST}"

# ── Claude Code 集成 ─────────────────────────────────────────────
if [[ "${DO_CLAUDE}" == "true" ]]; then
    mkdir -p "${TARGET}/.claude/agents" "${TARGET}/.claude/skills"
    for f in "${ROLE_FILES[@]}"; do
        rm -f "${TARGET}/.claude/agents/${f}"
        cp "${AGENTS_SRC}/${f}" "${TARGET}/.claude/agents/${f}"
    done
    rm -rf "${TARGET}/.claude/skills/prd-review-orchestrator"
    cp -R "${SKILLS_SRC}/prd-review-orchestrator" "${TARGET}/.claude/skills/prd-review-orchestrator"
    echo "✅ Claude Code: .claude/agents/（4 个角色）+ .claude/skills/prd-review-orchestrator/"
fi

# ── CodeBuddy 集成 ───────────────────────────────────────────────
if [[ "${DO_CODEBUDDY}" == "true" ]]; then
    mkdir -p "${TARGET}/.codebuddy/agents"
    for f in "${ROLE_FILES[@]}"; do
        rm -f "${TARGET}/.codebuddy/agents/${f}"
        cp "${AGENTS_SRC}/${f}" "${TARGET}/.codebuddy/agents/${f}"
    done
    echo "✅ CodeBuddy: .codebuddy/agents/（4 个角色）"
fi

# ── 指令文件注册（幂等：标记块原地替换） ─────────────────────────
BLOCK=$(cat <<EOF
${MARKER_BEGIN}
## PRD Review Team（prd-review-team ${VERSION}）

本项目已安装 PRD 评审团队：3 名产品经理（行业痛点官 / 价值守门人 / 理性卫士）+ 1 名技术经理（最终裁决）。

- 团队资产（角色定义 + 编排流程）：\`.agents/prd-review-team/\`
- 编排流程：\`.agents/prd-review-team/skills/prd-review-orchestrator/SKILL.md\`

**使用方式**：对 Agent 说"用 prd-review-team 评审这份 PRD：<路径>"。
流程：三名 PM 并行独立评审 → 两轮圆桌辩论 → 共识汇总 → 技术经理按成本/可行性/复杂度拍板 → 产出评审报告、P0/P1/P2 修改清单与全程对话日志（输出目录 \`.prd-reviews/\`）。

**铁律**：评审不改 PRD 原文；技术经理可否决但必须附替代方案；辩论固定 2 轮；评审全程对话日志留痕（谁说了什么/确定了什么/理解了什么/定性了什么），先记录后流转。
${MARKER_END}
EOF
)
export BLOCK

register_instruction() {
    local file="$1"
    if [[ -f "${file}" ]] && grep -qF "${MARKER_BEGIN}" "${file}"; then
        awk -v mb="${MARKER_BEGIN}" -v me="${MARKER_END}" '
            BEGIN { block = ENVIRON["BLOCK"] }
            $0 == mb { print block; skip = 1; next }
            skip && $0 == me { skip = 0; next }
            !skip { print }
        ' "${file}" > "${file}.tmp" && mv "${file}.tmp" "${file}"
        echo "✅ 已更新注册段: ${file}"
    else
        { [[ -f "${file}" ]] && printf '\n' >> "${file}"; printf '%s\n' "${BLOCK}" >> "${file}"; } \
            || { echo "错误: 写入 ${file} 失败" >&2; exit 3; }
        echo "✅ 已写入注册段: ${file}"
    fi
}

# AGENTS.md 始终注册（Codex / 千问办公助手 / 通用 Agent 读取）
register_instruction "${TARGET}/AGENTS.md"
# 对应工具存在时注册各自指令文件
[[ "${DO_CLAUDE}" == "true" ]] && register_instruction "${TARGET}/CLAUDE.md"
[[ "${DO_CODEBUDDY}" == "true" ]] && register_instruction "${TARGET}/CODEBUDDY.md"

echo ""
echo "🎉 PRD Review Team ${VERSION} 安装完成"
echo "   使用方式: 对 Agent 说「用 prd-review-team 评审这份 PRD：<路径>」"
