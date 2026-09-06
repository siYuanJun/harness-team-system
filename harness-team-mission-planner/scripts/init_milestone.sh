#!/bin/bash
# harness-team-mission-planner · 里程碑任务指令初始化脚本
# 用法：./init_milestone.sh <里程碑编号> <子任务编号> <任务名称>
# 示例：./init_milestone.sh M3 M0 通神经
#
# 功能：在当前项目的 docs/internal/harness-Mx/ 下创建 8 个文件骨架，
#       自动替换里程碑编号、子任务编号、任务名称、日期等占位符。
#       其他占位符（{{GOAL}}、{{ACCEPTANCE}} 等）需根据具体需求人工填充。

set -e

if [ $# -lt 3 ]; then
  echo "用法: $0 <里程碑编号> <子任务编号> <任务名称>"
  echo "示例: $0 M3 M0 通神经"
  exit 1
fi

MX="$1"
MY="$2"
TASK="$3"
DATE=$(date +%Y-%m-%d)

# 模板目录（脚本所在目录的上级 /templates）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/../templates"

# 输出目录（当前项目的 docs/internal/harness-Mx）
OUTPUT_DIR="docs/internal/harness-${MX}"

echo "=== harness-team-mission-planner ==="
echo "里程碑: ${MX}-${MY} ${TASK}"
echo "模板目录: ${TEMPLATE_DIR}"
echo "输出目录: ${OUTPUT_DIR}"
echo ""

# 检查模板目录
if [ ! -d "${TEMPLATE_DIR}" ]; then
  echo "错误: 模板目录不存在: ${TEMPLATE_DIR}"
  exit 1
fi

# 创建输出目录
mkdir -p "${OUTPUT_DIR}"

# 复制模板并替换基础占位符
copy_template() {
  local template_file="$1"
  local output_file="$2"

  if [ -f "${TEMPLATE_DIR}/${template_file}" ]; then
    sed -e "s/{{MX}}/${MX}/g" \
        -e "s/{{MY}}/${MY}/g" \
        -e "s/{{TASK}}/${TASK}/g" \
        -e "s/{{DATE}}/${DATE}/g" \
        "${TEMPLATE_DIR}/${template_file}" > "${OUTPUT_DIR}/${output_file}"
    echo "  [OK] ${output_file}"
  else
    echo "  [FAIL] 模板不存在: ${template_file}"
  fi
}

echo "创建文件骨架:"
copy_template "00-INDEX.md.template" "00-INDEX.md"
copy_template "任务书.md.template" "${MX}-${MY}-总任务书.md"
copy_template "PM.md.template" "${MX}-${MY}-PM.md"
copy_template "ENG.md.template" "${MX}-${MY}-ENG.md"
copy_template "APP.md.template" "${MX}-${MY}-APP.md"
copy_template "QA.md.template" "${MX}-${MY}-QA.md"
copy_template "ORCH.md.template" "${MX}-${MY}-ORCH.md"
copy_template "LAUNCH.md.template" "${MX}-${MY}-LAUNCH.md"

echo ""
echo "完成！8 个文件骨架已创建在 ${OUTPUT_DIR}/"
echo ""
echo "下一步："
echo "  1. 检测当前项目的团队（.claude/agents/）或指定团队"
echo "  2. 读取团队角色定义，替换 {{PREFIX}}、{{TEAM_NAME}} 等占位符"
echo "  3. 根据具体需求填充 {{GOAL}}、{{ACCEPTANCE}}、{{GATE1_CONDITION}} 等内容"
echo "  4. 自检后交付"
