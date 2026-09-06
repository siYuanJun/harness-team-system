---
name: harness-team-builder
description: 为任意项目构建 Harness 多 Agent 团队。输入项目路径+项目名+一句话目标，通过交互式角色选择，产出 .claude/agents/ 角色定义 + .claude/skills/ 编排器 + CLAUDE.md 路由表。支持最小/标准/扩展三级团队规模，内置 Git Worktree 并行开发模式和团队维护机制。是 team-building-methodology.md 的工程化升级版，蒸馏了 khazix 目标七问法和 harness-main 6 种架构模式。
version: 1.0.0
category: harness
tags: [agent-team, claude-code, team-architecture, worktree, digital-employee]
---

# Harness Team Builder · 团队搭建器

## 概述

本 Skill 将一个项目转化为一个可被 Claude Code 调度的多 Agent 团队。产出的团队**垂直于当前项目**（角色前缀、职责、路由表都针对项目定制），不是通用模板。

**核心理论**：项目需要常驻的、深入项目的团队成员。有了团队后，成员能帮用户思考没考虑到的边界和编排，让开发更顺畅。团队不是越大越好，按项目复杂度分级。

## 使用场景

- 新项目启动，需要搭建 AI 协作团队
- 现有项目没有 `.claude/agents/`，需要补建
- 团队职责过时，需要重建
- 想给项目增加 Git Worktree 并行开发能力

**不适用**：团队已存在且只需微调（用 neat-freak 对齐即可）；只想生成单条任务指令（用 harness-team-mission-planner）。

## 前置依赖

- 当前项目有 git 仓库（Worktree 模式需要）
- Claude Code 支持 Agent Teams（`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`）

## 核心流程（9 步）

### 步骤 0：目标七问（khazix 心法）
动手前用"目标七问"把需求想清楚：① 目的 ② 完成态 ③ 证据 ④ 反作弊 ⑤ 地界 ⑥ 取舍 ⑦ 未知。**第零问**：这张海图是你自己测的还是听来的——先钻进项目亲手跑一遍，读 README / 代码结构 / git 状态 / 依赖可行性，文档里写的命令可能根本不存在。

详见 `references/goal-seven-questions.md`。

### 步骤 1：分析项目现状
输出三件事：① 项目目标 ② 已完成什么 ③ 还缺什么（区分"代码逻辑缺口"与"工程化/交付缺口"）。

### 步骤 2：团队架构选型（harness-main 6 模式）
按任务特性选架构模式：流水线 / 扇出扇入 / 专家池 / 生产者-审校者 / 监督者 / 层级委派，可混合。

详见 `references/team-architecture-patterns.md`。

### 步骤 3：交互式角色选择
展示角色库（每个角色带职责+特点+适用场景），让用户选择团队规模：

| 选项 | 角色数 | 包含角色 | 适用场景 |
|------|--------|----------|----------|
| `最小` | 4 人 | lead + engineer + acceptor + pm | 小项目、快速验证 |
| `标准`（推荐） | 7 人 | 最小 + content-creator + content-reviewer + knowledge-keeper | 中等项目、长期维护 |
| `扩展` | 10+ 人 | 标准 + merge-engineer + research-agent + modeling-agent | 大项目、多 worktree 并行 |
| `自定义` | 任选 | 用户从角色库勾选 | 特殊需求 |

角色库详见 `references/role-catalog.md`。团队规模选型详见 `references/team-sizing.md`。

### 步骤 4：落盘团队配置
- `.claude/agents/<角色>.md` × N：每个角色含【核心角色 / 工作原则 / 输入 / 输出 / 协作 / 团队通信协议 / 错误处理】，frontmatter 带 `model: opus`
- `.claude/skills/{team}-orchestrator/SKILL.md`：编排器（路由表 + Phase 流程 + 数据传递协议 + 错误处理 + Worktree 调度）
- `.claude/skills/{team}-orchestrator/references/roadmap.md`：项目状态底稿
- 根目录 `CLAUDE.md`：触发规则 + 路由表 + 团队维护记录 + 变更记录

模板见 `templates/`。

### 步骤 5：写路由表（团队不空壳的关键）
在 CLAUDE.md 与编排器里写清"哪类指令 → 哪个成员"。模糊跨多角色的指令，由 orchestrator 拆子任务分别派，最后整合。

### 步骤 6：给 pm "装大脑"（如选了 pm）
- 基座① 领域知识：读项目文档，知道"这个领域好产品该长什么样"
- 基座② 评审框架：把通用评审框架垂直适配到本项目语境
- 基座③ 设计红线：本项目独有的取舍原则 / 避坑清单

### 步骤 7：配置 Worktree 并行模式（如选了扩展团队或用户需要）
- orchestrator 职责增加：任务依赖分析 + 并行性判断
- merge-engineer 角色：分支合并、冲突处理、git 清理
- 标准流程：任务拆分 → 依赖分析 → 无依赖任务进 worktree 并行 → 自测 → merge-engineer 合并 → 清理

详见 `references/worktree-parallel.md`。

### 步骤 8：知识蒸馏者配置（如选了 knowledge-keeper）
- 价值闸门：只沉淀"能干活的能力资产"（决策 / 方法论 / 框架 / 避坑 / 话术），不搬过程记录
- 目标目录：项目 docs/ 下的知识库；新主题新建文件 + 登记到 MOC

### 步骤 9：git 提交 + 自检
按逻辑单元 conventional commits 提交。然后按质量门自检（见下）。

## 角色库

| 角色 | 职责 | 分级 |
|------|------|------|
| `{team}-lead` 编排者 | 调度、监控、整合交付、任务依赖分析、Worktree 调度 | 最小 |
| `engineer` 工程手 | 环境、git、代码修复、依赖 | 最小 |
| `acceptor` 验收官 | 独立验收，逐条 PASS/FAIL | 最小 |
| `pm` 产品经理 | 需求→PRD、验收标准、优先级 | 最小 |
| `content-creator` 内容生产者 | 文档、内容产出 | 标准 |
| `content-reviewer` 审校官 | 质量、合规、一致性 | 标准 |
| `knowledge-keeper` 知识蒸馏者 | 方法论沉淀进知识库 | 标准 |
| `merge-engineer` 合并工程师 | Worktree 分支合并、冲突处理、git 清理 | 扩展 |
| `research-agent` 研究员 | 资料调研、样本构造 | 扩展 |
| `modeling-agent` 建模师 | 数据建模、算法设计 | 扩展 |

## 质量门（全部满足才算搭建完成）

- [ ] `.claude/agents/` 每个角色都有定义文件（含 `model: opus`）
- [ ] 编排器 skill 含路由表 + Phase 流程 + 错误处理 + Worktree 调度（如启用）
- [ ] CLAUDE.md 含触发规则 + 路由表 + 团队维护记录 + 变更记录
- [ ] pm 有大脑基座（如选了 pm）
- [ ] knowledge-keeper 有沉淀目标目录（如选了）
- [ ] 团队规模与项目复杂度匹配（不是盲目满配）
- [ ] 结构验证通过（frontmatter 合法、无多余 `.claude/commands`）
- [ ] git 已提交

## 团队维护机制

团队搭建完成不是终点。以下情况必须更新团队定义：
- 项目技术栈发生重大变化
- 新增角色职责或角色职责变化
- 路由表失效（某类指令不再路由到原角色）
- 项目规模变化需要调整团队分级

推荐配合 `neat-freak` Skill 做定期对齐。详见 `references/team-maintenance.md`。

## 与其他 Skill 的关系

```
harness-team-builder（本 Skill · 搭团队）
        ↓ 产出
   .claude/agents/ + CLAUDE.md（团队就绪）
        ↓ 然后用
harness-team-mission-planner（派任务）
        ↓ 产出
   docs/internal/harness-Mx/ 任务指令
        ↓ 然后
   Claude Code 按 LAUNCH.md 调度执行
        ↓ 定期
   neat-freak（对齐文档/记忆/团队定义，防脑腐）
```

## 参考文件

- `references/goal-seven-questions.md` — khazix 目标七问法完整心法
- `references/team-architecture-patterns.md` — harness-main 6 种架构模式详解
- `references/role-catalog.md` — 角色库详细说明
- `references/team-sizing.md` — 团队分级选型指南
- `references/agent-definition-spec.md` — 角色定义文件规范
- `references/orchestrator-design.md` — 编排器设计规范
- `references/worktree-parallel.md` — Git Worktree 并行开发模式
- `references/team-maintenance.md` — 团队维护机制
- `references/quality-gates.md` — 搭建质量门标准
- `templates/` — 角色定义、编排器、CLAUDE.md 模板
- `scripts/init_team.sh` — 团队目录初始化脚本
- `examples/ontology-brain-team.md` — 成品案例
