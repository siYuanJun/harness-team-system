# Hermes Harness Init — 使用 Harness 初始化 Hermes 团队

本目录包含使用 Harness 框架将 Hermes Agent Team 部署到任意项目的初始化能力。

## 核心理念

Hermes 是一个**提示词工程**，不是专门的 Agent 应用。它可以被任意 Claude Code、Codex 或其他 Agent 应用直接接入。

Harness Init 的职责：
1. 分析目标项目的域和需求
2. 生成适配的 Agent 定义（`.claude/agents/`）
3. 生成适配的 Skill 定义（`.claude/skills/`）
4. 注册到项目的 `CLAUDE.md`
5. 验证部署正确性

## 快速开始

### 方式 1: 一键部署（推荐）

在目标项目中运行：

```bash
# 复制 Hermes 到目标项目
bash harness-init/deploy.sh /path/to/target/project
```

### 方式 2: 手动部署

参见 [deploy-guide.md](deploy-guide.md)

### 方式 3: 通过 Harness Skill 触发

在 Claude Code 中输入：

```
用harness初始化hermes团队
```

触发 `hermes-harness-init` skill，按照 Harness 6 阶段工作流自动部署。

## 目录结构

```
harness-init/
├── README.md              # 本文件
├── deploy.sh              # 一键部署脚本
├── deploy-guide.md        # 手动部署指南
├── harness-workflow.md    # Harness 6阶段工作流详解
├── templates/             # 项目模板
│   ├── claude.md          # CLAUDE.md 模板
│   ├── project-structure.md # 项目结构模板
│   └── eval-metadata.json # 评估元数据模板
└── examples/              # 部署示例
    ├── research-project.md    # 研究项目部署示例
    └── content-project.md     # 内容项目部署示例
```

## Harness 6 阶段工作流

| 阶段 | 名称 | 说明 |
|------|------|------|
| Phase 1 | 域分析 | 分析项目类型、核心需求、角色需求 |
| Phase 2 | 团队架构设计 | 选择架构模式、执行模式 |
| Phase 3 | Agent 定义生成 | 生成 `.claude/agents/*.md` |
| Phase 4 | Skill 生成 | 生成 `.claude/skills/*/SKILL.md` |
| Phase 5 | 集成与编排 | 生成编排技能、注册 CLAUDE.md |
| Phase 6 | 验证与测试 | 结构验证、触发测试、干运行 |

详见 [harness-workflow.md](harness-workflow.md)

## 部署产出

部署完成后，目标项目中会生成：

```
{project}/
├── .claude/
│   ├── agents/
│   │   ├── hermes-coordinator.md
│   │   ├── hermes-researcher.md
│   │   ├── hermes-writer.md
│   │   ├── hermes-editor.md
│   │   └── hermes-human-protocol.md
│   └── skills/
│       ├── hermes-orchestrator/
│       ├── hermes-researcher/
│       ├── hermes-writer/
│       ├── hermes-editor/
│       └── hermes-harness-init/
├── .ai-workflow/
│   └── hermes/
│       └── projects/
└── CLAUDE.md (已注册 Hermes 触发规则)
```

## 兼容性

| 平台 | 支持状态 | 说明 |
|------|---------|------|
| Claude Code | ✅ 完整支持 | 原生 Agent Teams + Skills |
| Codex | ✅ 支持 | 需适配 Agent 定义格式 |
| Cursor | ⚠️ 部分支持 | 需手动配置 Skills |
| 其他 Agent 应用 | ⚠️ 需适配 | 核心提示词可复用 |

## 参考

- [deploy-guide.md](deploy-guide.md) — 手动部署指南
- [harness-workflow.md](harness-workflow.md) — Harness 6阶段工作流详解
- [templates/](templates/) — 项目模板
- [examples/](examples/) — 部署示例
