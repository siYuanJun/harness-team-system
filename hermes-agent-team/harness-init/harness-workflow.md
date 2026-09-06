# Harness 6 阶段工作流详解

本指南详细说明使用 Harness 框架初始化 Hermes Agent Team 的完整工作流。

## 工作流总览

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

---

## Phase 1: 域分析

### 目标
分析目标项目的类型、核心需求，确定 Hermes 团队的角色需求。

### 处理步骤

1. **识别项目类型**
   - 技术项目（软件开发、API 集成）
   - 内容项目（博客、文档、营销）
   - 研究项目（深度研究、数据分析）
   - 混合项目（多类型组合）

2. **分析核心需求**
   - 用户的主要任务是什么？
   - 需要哪些角色支持？
   - 是否全部五角色都需要？

3. **评估项目规模**
   - 小型项目（<10 任务）
   - 中型项目（10-20 任务）
   - 大型项目（>20 任务）

### 输出
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
```

---

## Phase 2: 团队架构设计

### 目标
选择适合项目的架构模式和执行模式。

### 架构模式选择

| 场景 | 推荐模式 | Hermes 应用 |
|------|---------|-------------|
| 深度研究 | Fan-out/Fan-in | 多 Researcher 并行 |
| 内容生产 | Producer-Reviewer | Writer → Editor |
| 快速回答 | Expert Pool | 按需调用角色 |
| 复杂项目 | Supervisor | Coordinator 动态分配 |

### 执行模式选择

| 模式 | 适用场景 | 特点 |
|------|---------|------|
| **Agent Teams** | 复杂协作、实时沟通 | 五角色实时协作 |
| **Sub-agents** | 简单任务、成本敏感 | 顺序执行 |
| **混合模式** | 阶段性任务 | 按阶段选择模式 |

### 输出
```markdown
## 团队架构设计

### 架构模式
- 模式: {模式}
- 理由: {理由}

### 执行模式
- 模式: {模式}
- 理由: {理由}

### 团队架构图
[图形化展示]
```

---

## Phase 3: Agent 定义生成

### 目标
生成 `.claude/agents/` 下的五角色定义文件。

### 处理步骤

1. **复制基础定义**
```bash
cp hermes-agent-team/agents/*.md {project}/.claude/agents/
```

2. **定制角色**
   - 调整角色职责
   - 添加项目特定原则
   - 定制协作协议

3. **验证定义**
   - 格式正确性
   - 职责边界清晰
   - 协作协议完整

### Agent 文件模板

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

---

## Phase 4: Skill 生成

### 目标
生成 `.claude/skills/` 下的角色技能定义。

### 处理步骤

1. **复制基础技能**
```bash
cp -r hermes-agent-team/skills/* {project}/.claude/skills/
```

2. **定制技能**
   - 调整工作流程
   - 添加项目特定规则
   - 定制输出格式

3. **生成 references**
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

---

## Phase 5: 集成与编排

### 目标
将 Agent 和 Skill 集成到项目的编排系统中。

### 处理步骤

1. **生成编排技能**
   - 工作流程定义
   - 路由规则
   - 交接协议
   - 错误处理

2. **注册到 CLAUDE.md**
```markdown
## Hermes Agent Team
**触发规则**：...
**触发词**：...
**变更历史**：...
```

3. **配置数据传递**
   - 消息基于（SendMessage）
   - 任务基于（TaskCreate）
   - 文件基于（约定路径）
   - 返回值基于（Agent 返回）

---

## Phase 6: 验证与测试

### 目标
验证 Hermes 部署的正确性和完整性。

### 结构验证

- [ ] 所有 Agent 文件在正确位置
- [ ] 所有 Skill 文件格式正确
- [ ] Agent 间引用一致
- [ ] CLAUDE.md 已注册

### 触发测试

**Should-trigger 查询**：
1. "启动hermes团队"
2. "帮我深度研究"
3. "需要事实核查"
4. "五角色协作"
5. "内容生产流程"

**Should-NOT-trigger 查询**：
1. "简单问题"
2. "快速回答"
3. "直接写代码"
4. "修复这个bug"

### 干运行测试

- [ ] 工作流程逻辑正确
- [ ] 数据传递路径完整
- [ ] 所有 Agent 输入匹配前一阶段输出
- [ ] 错误场景有回退路径

---

## 部署产出清单

初始化完成后，目标项目应生成：

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
│       ├── projects/
│       └── wiki/
└── CLAUDE.md (已注册 Hermes 触发规则)
```
