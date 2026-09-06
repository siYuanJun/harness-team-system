# 手动部署指南

本指南介绍如何将 Hermes Agent Team v3.0 手动部署到目标项目。

## 部署前置条件

- 目标项目是一个可被 Agent 访问的目录
- 支持 `.claude/` 目录结构（Claude Code）或等效结构
- 目标项目有 `CLAUDE.md` 文件（如不存在，脚本会创建）

## 部署步骤

### 步骤 1: 创建目录结构

```bash
cd /path/to/your/project

# 创建必要的目录
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p .ai-workflow/hermes/projects
mkdir -p .ai-workflow/hermes/wiki
```

### 步骤 2: 复制 Agent 定义

```bash
# 假设 Hermes 源码位于 ~/hermes-agent-team/
HERMES_SRC=~/hermes-agent-team

# 复制五角色定义
cp ${HERMES_SRC}/agents/coordinator.md      .claude/agents/hermes-coordinator.md
cp ${HERMES_SRC}/agents/researcher.md       .claude/agents/hermes-researcher.md
cp ${HERMES_SRC}/agents/writer.md           .claude/agents/hermes-writer.md
cp ${HERMES_SRC}/agents/editor.md           .claude/agents/hermes-editor.md
cp ${HERMES_SRC}/agents/human-protocol.md   .claude/agents/hermes-human-protocol.md
```

### 步骤 3: 复制 Skill 定义

```bash
# 复制各角色的技能
cp -r ${HERMES_SRC}/skills/hermes-orchestrator  .claude/skills/
cp -r ${HERMES_SRC}/skills/hermes-researcher    .claude/skills/
cp -r ${HERMES_SRC}/skills/hermes-writer        .claude/skills/
cp -r ${HERMES_SRC}/skills/hermes-editor        .claude/skills/
cp -r ${HERMES_SRC}/skills/hermes-harness-init  .claude/skills/
```

### 步骤 4: 复制 Wiki 知识库

```bash
# 复制跨项目共享知识
cp ${HERMES_SRC}/wiki/architecture-rules.md  .ai-workflow/hermes/wiki/
cp ${HERMES_SRC}/wiki/data-isolation.md      .ai-workflow/hermes/wiki/
cp ${HERMES_SRC}/wiki/handoff-protocols.md   .ai-workflow/hermes/wiki/
```

### 步骤 5: 注册到 CLAUDE.md

在项目根目录的 `CLAUDE.md` 文件中添加：

```markdown
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
| 2026-08-13 | 初始化 Hermes v3.0 | 整体 | 引入五角色协作框架 |
```

### 步骤 6: 验证部署

#### 结构验证

```bash
# 确认目录结构
find .claude -type f -name "*.md" | sort

# 预期输出:
# .claude/agents/hermes-coordinator.md
# .claude/agents/hermes-editor.md
# .claude/agents/hermes-human-protocol.md
# .claude/agents/hermes-researcher.md
# .claude/agents/hermes-writer.md
# .claude/skills/hermes-editor/SKILL.md
# .claude/skills/hermes-harness-init/SKILL.md
# .claude/skills/hermes-orchestrator/SKILL.md
# .claude/skills/hermes-researcher/SKILL.md
# .claude/skills/hermes-writer/SKILL.md
```

#### 触发验证

在 Claude Code 中测试：

```
启动hermes团队，帮我深度研究"AI Agent协作模式"
```

预期行为：
- 加载 hermes-agent-team skill
- Coordinator 开始拆解任务
- 进入五角色协作流程

## 部署检查清单

- [ ] `.claude/agents/` 存在且包含 5 个角色定义
- [ ] `.claude/skills/` 存在且包含 5 个技能目录
- [ ] `.ai-workflow/hermes/` 目录已创建
- [ ] Wiki 知识库已复制
- [ ] CLAUDE.md 已注册 Hermes 触发规则
- [ ] 触发测试通过

## 常见问题

### Q1: 目标项目没有 CLAUDE.md

deploy.sh 会自动创建。手动部署时：

```bash
touch CLAUDE.md
echo "# 项目名称" > CLAUDE.md
```

### Q2: 与现有 skill 冲突

如果项目已有同名 skill，需要：
1. 备份现有配置
2. 使用 `--custom` 参数指定不同的目录名
3. 调整 CLAUDE.md 中的触发词避免冲突

### Q3: 如何卸载 Hermes？

```bash
# 删除 Agent 定义
rm .claude/agents/hermes-*.md

# 删除 Skill 定义
rm -rf .claude/skills/hermes-*

# 删除项目数据
rm -rf .ai-workflow/hermes

# 删除 CLAUDE.md 中的 Hermes 部分
```

### Q4: 如何更新到新版本？

```bash
# 备份现有配置
cp -r .claude/agents .claude/agents.backup
cp -r .claude/skills .claude/skills.backup

# 重新执行部署
bash ~/hermes-agent-team/harness-init/deploy.sh .

# 对比差异
diff -r .claude/agents.backup .claude/agents
```

## 平台适配

### Claude Code
完全支持。`.claude/agents/` 和 `.claude/skills/` 是原生结构。

### Codex
需适配 Agent 定义格式。核心提示词可复用，但需转换 YAML frontmatter 格式。

### Cursor
部分支持。需手动配置 Skills，Agent 定义需调整。

### 其他 Agent 应用
核心提示词可复用。需将 `.claude/` 结构映射到目标应用的结构。
