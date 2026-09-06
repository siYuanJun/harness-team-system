# Harness Team System · AI 多 Agent 团队体系

> 为任意项目构建可被 Claude Code 调度的多 Agent 团队。从方法论到搭建工具，再到垂直团队实例，三层完整体系。

---

## 这是什么

Harness Team System 是一套 **AI 多 Agent 团队搭建与任务调度体系**，解决一个核心问题：

> 项目需要常驻的、深入项目的 AI 团队成员，而不是每次重新解释项目的单次对话。

有了团队后，成员能帮你思考没考虑到的边界和编排，让开发更顺畅。一句话通过多层过滤，最终产出准确、有价值的结果。

## 三层体系

```
理论层                  工具层                   实例层
┌──────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ _methodology/ │    │ harness-team-     │    │ ontology-dome-  │
│ 团队搭建方法论  │───▶│ builder           │───▶│ team            │
│ (9步流程)      │    │ (搭团队)          │    │ (本体工程师团队)  │
└──────────────┘    ├──────────────────┤    ├─────────────────┤
                    │ harness-team-     │    │ hermes-agent-   │
                    │ mission-planner   │    │ team            │
                    │ (派任务)          │    │ (内容生产团队)    │
                    └──────────────────┘    ├─────────────────┤
                                            │ prd-review-     │
                                            │ team            │
                                            │ (PRD评审团队)    │
                                            └─────────────────┘
```

### 理论层：`_methodology/`

团队搭建的通用方法论——9 步流程，从需求澄清到 git 提交。

### 工具层：两个元工具

| 工具 | 用途 |
|------|------|
| `harness-team-builder` | 为任意项目搭建垂直团队。交互式角色选择，支持最小/标准/扩展三级规模，内置 Git Worktree 并行模式和团队维护机制 |
| `harness-team-mission-planner` | 为已有团队生成里程碑任务指令。输入需求，输出一整套可直接交给 Claude Code 执行的任务指令文件夹（含 LAUNCH 启动入口） |

### 实例层：垂直团队

| 团队 | 领域 | 状态 |
|------|------|------|
| `ontology-dome-team` | 本体工程师数字员工（六环流水线） | ✅ 已落地，v0.3 |
| `hermes-agent-team` | 内容生产团队 | ✅ 已落地 |
| `prd-review-team` | PRD 评审团队 | ✅ 已落地 |

**关键原则**：工具是通用的，但用工具创建的团队是**垂直于当前项目**的——角色前缀、职责、路由表都针对项目定制。创建完就不再是通用的了。

## 核心概念

### 团队不是越大越好

按项目复杂度分级：
- **最小团队（4人）**：lead + engineer + acceptor + pm — 小项目、快速验证
- **标准团队（7人）**：加 content-creator + content-reviewer + knowledge-keeper — 中等项目、长期维护
- **扩展团队（10+人）**：加 merge-engineer + research-agent + modeling-agent — 大项目、多 Worktree 并行

### 管流程的不管质量

核心铁律：orchestrator 管调度卡点，acceptor 管独立验收，执行和验收分离。QA 不碰执行、不改产物，只验数据。

### 团队会脑腐，需要维护

常驻团队的定义文件如果不随项目演进而更新，3 个月后就会脱节。体系内置团队维护机制，推荐配合 `neat-freak` 定期对齐。

### Git Worktree 并行

大任务拆成小任务，通过 git worktree 实现多窗口/多 Agent 并行开发。orchestrator 做任务依赖分析，无依赖任务进 worktree 并行，merge-engineer 负责合并和清理。

## 借鉴与合规声明

本项目在设计思想上借鉴了以下开源项目，**蒸馏其核心思想而非直接复制代码**，秉持合规开源精神：

### 1. revfactory/harness（Apache License 2.0）

- **仓库**：https://github.com/revfactory/harness
- **借鉴内容**：
  - 6 种团队架构模式（Pipeline / Fan-out/Fan-in / Expert Pool / Producer-Reviewer / Supervisor / Hierarchical Delegation）
  - 6 阶段工作流（Domain Analysis → Team Design → Agent Generation → Skill Generation → Integration → Validation）
  - `.claude/agents/` + `.claude/skills/` 的团队配置结构
  - "Team-Architecture Factory"的定位思路
- **说明**：本项目的架构模式选型和团队配置结构参考了该项目的设计理念，但具体实现、角色定义、工作流程均为独立设计。

### 2. KKKKhazix/khazix-skills（MIT License）

- **仓库**：https://github.com/KKKKhazix/khazix-skills
- **借鉴内容**：
  - `leader` Skill 的**目标七问法**（目的/完成态/证据/反作弊/地界/取舍/未知），用于团队搭建前的需求澄清
  - `neat-freak` Skill 的**脑腐概念**（文档/记忆/团队定义随时间脱节），用于团队维护机制设计
- **说明**：目标七问法的框架和心法蒸馏自该项目，具体落地到团队搭建流程为独立设计。

### 合规原则

- 所有借鉴均为**思想和框架层面**的参考，不直接复制源代码
- 保留原项目的 LICENSE 信息和来源标注
- 本项目原创部分采用 **MIT License** 开源
- 如原项目作者认为有任何不当借鉴，请通过 Issues 联系，将及时修正

## 目录结构

```
harness/
├── README.md                          # 本文件
├── LICENSE                            # MIT License
├── _methodology/
│   └── team-building-methodology.md   # 团队搭建方法论（9步流程）
├── harness-team-builder/              # 元工具：搭团队
│   ├── SKILL.md
│   ├── references/                    # 10个参考文档
│   ├── templates/                     # 3个模板
│   ├── scripts/init_team.sh           # 团队初始化脚本
│   └── examples/
├── harness-team-mission-planner/      # 元工具：派任务
│   ├── SKILL.md
│   ├── templates/                     # 8个任务指令模板
│   └── scripts/init_milestone.sh      # 任务指令初始化脚本
├── ontology-dome-team/                # 实例：本体工程师团队
├── hermes-agent-team/                 # 实例：内容生产团队
└── prd-review-team/                   # 实例：PRD评审团队
```

## 使用方法

本体系的所有操作都由 **AI 执行**，人只需要说一句话。

### 搭建一个新团队

对 AI 说：

> "用 harness-team-builder 给这个项目搭个团队，项目是做 [XX] 的"

AI 会自动执行完整流程：
1. 目标七问澄清需求
2. 选型团队架构模式
3. 交互式选择角色（最小/标准/扩展）
4. 生成角色定义、编排器、CLAUDE.md
5. 质量门自检
6. 部署到项目的 `.claude/` 目录

> `init_team.sh` 是 AI 内部使用的骨架生成脚本，不需要人手动运行。

### 给已有团队派任务

对 AI 说：

> "用 harness-team-mission-planner 生成 M4 的任务指令，需求是：[你的需求]"

AI 会自动检测当前项目的团队，生成一整套任务指令文件夹（含总索引、各角色指令、LAUNCH 启动入口）。

### 让 Claude Code 执行任务

把生成的 `Mx-My-LAUNCH.md` 丢给 Claude Code，它会扮演 orchestrator 调度团队成员并行执行。

## 当前状态

- **仓库状态**：公开
- **方法论**：v1.0（9步流程）
- **harness-team-builder**：v1.0（含 Worktree 并行、团队维护、三级规模）
- **harness-team-mission-planner**：v1.0（含完成定义、阻碍闭环、7条红线）
- **团队实例**：3 个（ontology-dome / hermes / prd-review）

## License

本项目原创部分采用 **MIT License**。借鉴的开源项目分别保留其原始 License（Apache 2.0 / MIT），详见上方借鉴声明。

---

> 秉持合规开源精神，所有借鉴均标注来源，不直接复制代码。
