# Hermes Agent Team v3.0 — 完整工程总结

## 工程概览

这是一个基于 Hermes Agent Team v3.0 架构的可复用 skill 工程，实现了五角色多 Agent 协作系统。

**核心架构铁律**：管流程的不能管质量

## 工程结构

```
hermes-agent-team/
├── SKILL.md                    # 主入口技能定义
├── README.md                   # 工程说明文档
│
├── agents/                     # 五角色定义（复制到 .claude/agents/）
│   ├── hermes-coordinator.md      # 编排者 - 流程管理
│   ├── hermes-researcher.md       # 研究员 - 证据收集
│   ├── hermes-writer.md           # 执行者 - 内容创作
│   ├── hermes-editor.md           # 质量审计 - 独立验证
│   └── hermes-human-protocol.md   # 人类闸门 - 关键决策
│
├── skills/                     # 角色技能定义（复制到 .claude/skills/）
│   ├── hermes-orchestrator/    # 编排技能
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── task-decomposition.md
│   │       └── routing-rules.md
│   │
│   ├── hermes-researcher/      # 研究技能
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── confidence-levels.md
│   │       └── verification-protocol.md
│   │
│   ├── hermes-writer/          # 写作技能
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── green-data-usage.md
│   │
│   ├── hermes-editor/          # 审计技能
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── fact-check-protocol.md
│   │       └── pre-publish-checklist.md
│   │
│   └── hermes-harness-init/    # Harness 初始化技能
│       ├── SKILL.md
│       └── references/
│           ├── harness-patterns.md
│           ├── init-checklist.md
│           └── troubleshooting.md
│
├── wiki/                       # 跨项目共享知识库
│   ├── architecture-rules.md   # 架构铁律
│   ├── data-isolation.md       # 四层数据隔离
│   └── handoff-protocols.md    # 角色交接协议
│
├── templates/                  # 项目模板
│   └── project-init.md         # 项目初始化指南
│
├── examples/                   # 使用示例
│   ├── deep-research.md        # 深度研究场景
│   └── content-production.md   # 内容生产场景
│
└── harness-init/               # Harness 初始化能力
    ├── README.md               # 初始化说明
    ├── deploy.sh               # 一键部署脚本
    ├── deploy-guide.md         # 手动部署指南
    ├── harness-workflow.md     # Harness 6阶段工作流
    ├── templates/              # 项目模板
    │   ├── claude.md
    │   ├── project-structure.md
    │   └── eval-metadata.json
    └── examples/               # 部署示例
        ├── research-project.md
        └── content-project.md
```

## 核心特性

### 1. 五角色模型

| 角色 | 职责 | 不做 |
|------|------|------|
| **Coordinator** | 定义目标、拆解任务、路由、汇总、检查边界 | ❌ 质量审计 |
| **Researcher** | 收集证据、对比来源、标注置信度(🟢🟡🔴) | ❌ 流程管理 |
| **Writer/Builder** | 只使用🟢绿色数据，转化为最终产出 | ❌ 质量判断 |
| **Editor** | 独立事实核查 + 发布前检查 | ❌ 流程管理 |
| **Human** | 关键节点决策，最终验收 | 不打断每步 |

### 2. 三级置信度体系

- 🟢 **绿色（L1）**：已核实，多源验证，可流入下游
- 🟡 **黄色（L2）**：估计值，单源或推断，需标注
- 🔴 **红色（L3）**：推测，无直接证据，禁止流入下游

### 3. 四层数据隔离

- **Profile**：角色定义（`.claude/agents/`）
- **Project**：项目数据（`.ai-workflow/hermes/projects/`）
- **Wiki**：共享知识（`wiki/`）
- **Session**：会话上下文

### 4. Harness 集成

通过 Harness 框架的 6 阶段工作流，可以将 Hermes 快速部署到任意项目：

1. **域分析**：分析项目类型和需求
2. **团队架构设计**：选择架构模式和执行模式
3. **Agent 定义生成**：生成角色定义文件
4. **Skill 生成**：生成技能定义文件
5. **集成与编排**：生成编排技能，注册 CLAUDE.md
6. **验证与测试**：结构验证、触发测试、干运行

## 使用方式

### 方式 1: 直接部署到项目

```bash
# 复制到目标项目
cp -r hermes-agent-team/agents/* {project}/.claude/agents/
cp -r hermes-agent-team/skills/* {project}/.claude/skills/

# 在 CLAUDE.md 中添加触发规则
```

### 方式 2: 使用 Harness 初始化

在 Claude Code 中输入：

```
用harness初始化hermes团队
```

### 方式 3: 使用一键部署脚本

```bash
bash harness-init/deploy.sh /path/to/target/project
```

## 适用场景

- ✅ 深度研究：多源信息收集 + 事实核查
- ✅ 内容生产：从研究到成品的完整流程
- ✅ 技术文档：需要准确性的文档编写
- ✅ 复杂分析：需要多角度验证的分析任务
- ❌ 简单问答：不需要多角色协作的简单任务
- ❌ 实时对话：需要即时响应的场景

## 关键设计决策

### 1. 为什么独立存放而不放在 skills 目录？

Hermes 是一个**提示词工程**，不是专门的 Agent 应用。它需要：
- 独立的工程结构
- 可被任意项目复用
- 支持 Harness 初始化能力
- 包含 wiki、templates、examples 等资源

### 2. 为什么需要 Harness 初始化？

Harness 提供了标准化的团队架构工厂能力：
- 自动分析项目需求
- 生成适配的 Agent 和 Skill
- 验证部署正确性
- 支持多种架构模式选择

### 3. 为什么强调"管流程的不管质量"？

这是 v3.0 的核心升级：
- Coordinator 负责流程有序运行
- Editor 独立进行质量审计
- 两者互不干涉，形成制衡
- 避免单一 Agent 同时负责流程和质量时的问题

## 文件统计

- **总文件数**：28 个 Markdown 文件
- **角色定义**：5 个
- **技能定义**：5 个（含 references）
- **Wiki 文档**：3 个
- **示例文档**：2 个
- **模板文档**：1 个
- **Harness 初始化**：6 个文件

## 版本信息

- **版本**：v3.0
- **日期**：2026-08-13
- **核心升级**：新增独立 Editor 角色，流程与质量完全分离

## 下一步

1. 在目标项目中部署 Hermes
2. 使用示例场景测试工作流
3. 根据实际使用反馈调整配置
4. 持续迭代优化角色和技能定义
