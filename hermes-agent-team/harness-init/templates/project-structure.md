# Hermes Agent Team — 项目结构模板

## 目标项目部署后的目录结构

```
{project}/
├── .claude/
│   ├── agents/
│   │   ├── hermes-coordinator.md      # 编排者角色定义
│   │   ├── hermes-researcher.md       # 研究员角色定义
│   │   ├── hermes-writer.md           # 执行者角色定义
│   │   ├── hermes-editor.md           # 质量审计角色定义
│   │   └── hermes-human-protocol.md   # 人类闸门协议
│   │
│   └── skills/
│       ├── hermes-orchestrator/
│       │   ├── SKILL.md               # 编排技能
│       │   └── references/
│       │       ├── routing-rules.md   # 路由规则
│       │       └── task-decomposition.md  # 任务拆解指南
│       │
│       ├── hermes-researcher/
│       │   ├── SKILL.md               # 研究技能
│       │   └── references/
│       │       ├── confidence-levels.md   # 置信度规范
│       │       └── verification-protocol.md  # 验证协议
│       │
│       ├── hermes-writer/
│       │   ├── SKILL.md               # 写作技能
│       │   └── references/
│       │       └── green-data-usage.md    # 绿色数据使用规范
│       │
│       ├── hermes-editor/
│       │   ├── SKILL.md               # 审计技能
│       │   └── references/
│       │       ├── fact-check-protocol.md  # 事实核查协议
│       │       └── pre-publish-checklist.md  # 发布前检查清单
│       │
│       └── hermes-harness-init/
│           ├── SKILL.md               # Harness 初始化技能
│           └── references/
│               ├── harness-patterns.md    # 架构模式详解
│               ├── init-checklist.md      # 初始化检查清单
│               └── troubleshooting.md     # 问题排查
│
├── .ai-workflow/
│   └── hermes/
│       ├── projects/                   # 项目数据
│       │   └── {project-id}/
│       │       ├── 01_coordinator_tasks.md  # 任务拆解
│       │       ├── 02_researcher_output.md  # 研究报告
│       │       ├── 03_writer_draft.md       # 产出草稿
│       │       ├── 04_editor_audit.md       # 审计报告
│       │       └── 05_human_decisions.md    # 人类决策
│       │
│       └── wiki/                       # 跨项目共享知识
│           ├── architecture-rules.md   # 架构铁律
│           ├── data-isolation.md       # 数据隔离规范
│           └── handoff-protocols.md    # 交接协议
│
└── CLAUDE.md                           # 已注册 Hermes 触发规则
```

## 目录职责说明

### `.claude/agents/` — 角色定义
- 每个文件定义一个 Agent 角色
- 定义"我是谁、我该做什么"
- 长期固定，不随项目变化

### `.claude/skills/` — 技能定义
- 每个目录定义一个技能的完整能力
- 定义"怎么做"
- 可跨项目复用

### `.ai-workflow/hermes/` — 运行数据
- `projects/`：每个项目一个目录，保存任务产出
- `wiki/`：跨项目共享的通用知识

### `CLAUDE.md` — 项目说明
- 注册 Hermes 触发规则
- 记录变更历史
- 新会话时自动加载

## 文件命名规范

### 阶段文件
```
{N}_{stage}_{artifact}.md
```

| 序号 | Stage | 含义 |
|------|-------|------|
| 01 | coordinator | 任务拆解 |
| 02 | researcher | 研究报告 |
| 03 | writer | 产出草稿 |
| 04 | editor | 审计报告 |
| 05 | human | 人类决策 |

### 项目 ID
```
{YYYYMMDD}-{短描述}
```
示例：`20260813-ai-agent-research`
