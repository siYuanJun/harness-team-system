---
name: hermes-harness-init
description: "使用Harness框架初始化Hermes Agent Team。当用户要求用harness初始化hermes团队、构建hermes架构、部署hermes到项目时使用。本skill会读取Harness的6阶段工作流，生成定制化的Hermes五角色团队配置。触发词：harness初始化hermes、构建hermes架构、部署hermes团队、初始化hermes项目。"
---

# Hermes Harness Init — 使用 Harness 初始化 Hermes

本技能结合 Harness 框架的 6 阶段工作流，将 Hermes Agent Team 部署到目标项目。

## Harness 6 阶段工作流

```
Phase 1: 域分析 (Domain Analysis)
    ↓
Phase 2: 团队架构设计 (Team Architecture Design)
    ↓
Phase 3: Agent 定义生成 (Agent Definition Generation)
    ↓
Phase 4: Skill 生成 (Skill Generation)
    ↓
Phase 5: 集成与编排 (Integration & Orchestration)
    ↓
Phase 6: 验证与测试 (Validation & Testing)
```

## Phase 1: 域分析

### 输入
- 用户项目描述
- 目标使用场景

### 处理步骤
1. **识别项目类型** — 技术项目/内容项目/研究项目
2. **分析核心需求** — 需要哪些 Hermes 角色
3. **确定执行模式** — Agent Teams / Sub-agents / 混合模式
4. **评估项目规模** — 小/中/大型项目

### 输出
- 域分析报告
- 角色需求清单
- 执行模式建议

### 域分析模板

```markdown
## 域分析报告

### 项目信息
- 项目名称: {名称}
- 项目类型: {类型}
- 技术栈: {技术栈}

### 核心需求
1. {需求1}
2. {需求2}

### 角色需求
| 角色 | 是否需要 | 定制需求 |
|------|---------|---------|
| Coordinator | ✅/❌ | {定制} |
| Researcher | ✅/❌ | {定制} |
| Writer | ✅/❌ | {定制} |
| Editor | ✅/❌ | {定制} |
| Human | ✅/❌ | {定制} |

### 执行模式建议
- 推荐模式: {模式}
- 理由: {理由}

### 项目规模
- 规模: 小/中/大
- 预计任务数: {数量}
```

## Phase 2: 团队架构设计

### 架构模式选择

Hermes v3.0 默认使用 **Producer-Reviewer** 模式（生成-验证），但可根据需求调整：

| 场景 | 推荐模式 | 说明 |
|------|---------|------|
| 深度研究 | Fan-out/Fan-in | 多 Researcher 并行研究 |
| 内容生产 | Pipeline | 研究 → 写作 → 审计 |
| 快速回答 | Expert Pool | 按需调用角色 |
| 复杂项目 | Supervisor | Coordinator 动态分配 |

### 执行模式选择

| 模式 | 适用场景 | 特点 |
|------|---------|------|
| **Agent Teams** | 复杂协作、需要实时沟通 | 五角色实时协作 |
| **Sub-agents** | 简单任务、成本敏感 | 顺序执行 |
| **混合模式** | 阶段性任务 | 按阶段选择模式 |

### 输出
- 团队架构图
- 执行模式确定
- 角色职责定义

## Phase 3: Agent 定义生成

### 生成步骤

1. **复制基础角色定义**
```bash
cp hermes-agent-team/agents/*.md {project}/.claude/agents/
```

2. **根据域分析定制角色**
- 调整角色职责
- 添加项目特定原则
- 定制协作协议

3. **验证角色定义**
- 检查格式正确性
- 确认职责边界清晰
- 验证协作协议完整

### Agent 文件结构

```markdown
---
name: hermes-{role}
description: "{角色描述}"
---

# {角色名称}

## 核心职责
1. {职责1}
2. {职责2}

## 工作原则
- {原则1}
- {原则2}

## 输入/输出协议
- 输入: {输入}
- 输出: {输出}

## 协作关系
- {关系1}
- {关系2}
```

## Phase 4: Skill 生成

### 生成步骤

1. **复制基础技能定义**
```bash
cp -r hermes-agent-team/skills/* {project}/.claude/skills/
```

2. **根据域分析定制技能**
- 调整工作流程
- 添加项目特定规则
- 定制输出格式

3. **生成 references 文件**
- 置信度标注规范
- 验证协议
- 检查清单

### Skill 文件结构

```
skill-name/
├── SKILL.md
└── references/
    ├── {参考文档1}
    └── {参考文档2}
```

## Phase 5: 集成与编排

### 生成编排技能

创建 `hermes-orchestrator` 技能，定义：
- 工作流程
- 路由规则
- 交接协议
- 错误处理

### 注册到 CLAUDE.md

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
| {日期} | 初始化 Hermes v3.0 | 整体 | 引入五角色协作框架 |
```

### 数据传递协议

| 策略 | 方式 | 适用模式 |
|------|------|---------|
| 消息基于 | SendMessage | Agent Teams |
| 任务基于 | TaskCreate/TaskUpdate | Agent Teams |
| 文件基于 | 约定路径读写 | 所有模式 |
| 返回值基于 | Agent 工具返回 | Sub-agents |

## Phase 6: 验证与测试

### 结构验证

- [ ] 所有 Agent 文件在正确位置
- [ ] 所有 Skill 文件格式正确
- [ ] Agent 间引用一致
- [ ] CLAUDE.md 已注册

### 执行模式验证

- [ ] Agent Teams: 通信路径、任务依赖、团队大小
- [ ] Sub-agents: 输入输出连接、返回逻辑
- [ ] 混合模式: 各阶段模式明确、数据传递完整

### 触发测试

**Should-trigger 查询**（8-10个）：
1. "启动hermes团队"
2. "帮我深度研究"
3. "需要事实核查"
4. "五角色协作"
5. "内容生产流程"
6. "hermes初始化"
7. "构建hermes架构"
8. "部署hermes团队"

**Should-NOT-trigger 查询**（8-10个）：
1. "简单问题"
2. "快速回答"
3. "不需要审计"
4. "直接写代码"
5. "帮我查个东西"
6. "翻译这段文字"
7. "修复这个bug"
8. "解释这个概念"

### 干运行测试

- [ ] 工作流程逻辑正确
- [ ] 数据传递路径完整
- [ ] 所有 Agent 输入匹配前一阶段输出
- [ ] 错误场景有回退路径

## 输出清单

初始化完成后，生成以下文件：

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
│       │   ├── SKILL.md
│       │   └── references/
│       ├── hermes-researcher/
│       │   ├── SKILL.md
│       │   └── references/
│       ├── hermes-writer/
│       │   ├── SKILL.md
│       │   └── references/
│       └── hermes-editor/
│           ├── SKILL.md
│           └── references/
├── .ai-workflow/
│   └── hermes/
│       └── projects/
└── CLAUDE.md (已添加 Hermes 触发规则)
```

## References

- `references/harness-patterns.md` — Harness 6种架构模式详解
- `references/init-checklist.md` — 初始化检查清单
- `references/troubleshooting.md` — 常见问题排查
