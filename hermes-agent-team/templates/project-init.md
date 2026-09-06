# 项目初始化指南

## 快速部署

### 步骤 1: 复制角色定义

```bash
# 进入你的项目目录
cd /path/to/your/project

# 创建 .claude/agents 目录（如果不存在）
mkdir -p .claude/agents

# 复制 Hermes 角色定义
cp /path/to/hermes-agent-team/agents/*.md .claude/agents/
```

### 步骤 2: 复制技能定义

```bash
# 创建 .claude/skills 目录（如果不存在）
mkdir -p .claude/skills

# 复制 Hermes 技能
cp -r /path/to/hermes-agent-team/skills/* .claude/skills/
```

### 步骤 3: 注册到 CLAUDE.md

在你的项目根目录的 `CLAUDE.md` 文件中添加：

```markdown
## Hermes Agent Team

**触发规则**：当用户要求深度研究、内容生产、需要质量审计的复杂任务时，使用 hermes-agent-team skill。

**触发词**：
- 启动hermes团队
- 五角色协作
- 深度研究
- 需要事实核查
- 内容生产流程

**变更历史**：
| 日期 | 变更内容 | 目标 | 理由 |
|------|----------|------|------|
| 2026-08-13 | 初始化 Hermes v3.0 | 整体 | 引入五角色协作框架 |
```

### 步骤 4: 验证安装

在 Claude Code 中输入以下命令测试：

```
启动hermes团队，帮我深度研究"AI Agent 协作模式"
```

如果正确触发，Claude 会加载 hermes-agent-team skill 并开始五角色协作流程。

## 目录结构说明

部署后的项目结构：

```
your-project/
├── .claude/
│   ├── agents/
│   │   ├── hermes-coordinator.md      # 编排者角色
│   │   ├── hermes-researcher.md       # 研究员角色
│   │   ├── hermes-writer.md           # 执行者角色
│   │   ├── hermes-editor.md           # 质量审计角色
│   │   └── hermes-human-protocol.md   # 人类闸门协议
│   └── skills/
│       ├── hermes-orchestrator/       # 编排技能
│       │   └── SKILL.md
│       ├── hermes-researcher/         # 研究技能
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── confidence-levels.md
│       │       └── verification-protocol.md
│       ├── hermes-writer/             # 执行技能
│       │   ├── SKILL.md
│       │   └── references/
│       │       └── green-data-usage.md
│       └── hermes-editor/             # 审计技能
│           ├── SKILL.md
│           └── references/
│               ├── fact-check-protocol.md
│               └── pre-publish-checklist.md
├── .ai-workflow/
│   └── hermes/
│       └── projects/                  # 项目数据存放
│           └── {project-id}/
└── CLAUDE.md                          # 已添加 Hermes 触发规则
```

## 配置选项

### 执行模式选择

根据你的需求选择合适的执行模式：

**Agent Teams（推荐）**
- 五角色实时协作
- 适合复杂任务
- 需要频繁沟通
- 成本较高

**Sub-agents**
- 顺序执行
- 适合简单任务
- 成本更低
- 沟通有限

**混合模式**
- Phase 2 并行研究：Sub-agents
- Phase 3-4 协作执行：Agent Teams
- 平衡成本和质量

在 `hermes-orchestrator/SKILL.md` 中修改默认执行模式。

### 自定义角色

如需调整角色职责，编辑对应的 agent 文件：

```bash
# 编辑研究员角色
vim .claude/agents/hermes-researcher.md

# 编辑质量审计角色
vim .claude/agents/hermes-editor.md
```

### 自定义技能

如需调整技能流程，编辑对应的 skill 文件：

```bash
# 编辑编排技能
vim .claude/skills/hermes-orchestrator/SKILL.md

# 编辑研究技能
vim .claude/skills/hermes-researcher/SKILL.md
```

## 常见问题

### Q1: 如何更新 Hermes 到新版本？

```bash
# 备份现有配置
cp -r .claude/agents .claude/agents.backup
cp -r .claude/skills .claude/skills.backup

# 重新复制新版本
cp /path/to/new/hermes-agent-team/agents/*.md .claude/agents/
cp -r /path/to/new/hermes-agent-team/skills/* .claude/skills/

# 测试新版本
```

### Q2: 如何卸载 Hermes？

```bash
# 删除角色定义
rm .claude/agents/hermes-*.md

# 删除技能定义
rm -rf .claude/skills/hermes-*

# 从 CLAUDE.md 中删除 Hermes 相关配置
```

### Q3: 如何查看项目数据？

所有项目数据存放在 `.ai-workflow/hermes/projects/{project-id}/` 目录：

```bash
# 查看所有项目
ls .ai-workflow/hermes/projects/

# 查看特定项目
ls .ai-workflow/hermes/projects/{project-id}/
```

### Q4: 如何清理旧项目数据？

```bash
# 删除特定项目
rm -rf .ai-workflow/hermes/projects/{project-id}

# 清理所有项目（谨慎）
rm -rf .ai-workflow/hermes/projects/*
```

## 最佳实践

1. **定期备份** — 定期备份 `.claude/agents` 和 `.claude/skills` 目录
2. **版本控制** — 将 Hermes 配置纳入 Git 版本控制
3. **项目隔离** — 每个项目使用独立的 project-id
4. **数据清理** — 定期清理已完成的项目数据
5. **自定义调整** — 根据项目需求调整角色和技能

## 技术支持

如遇到问题，请检查：

1. 文件是否正确复制到 `.claude/agents/` 和 `.claude/skills/`
2. CLAUDE.md 中是否正确添加了触发规则
3. 触发词是否与 SKILL.md 中的 description 匹配
4. 查看 Claude Code 的日志输出
