---
name: hermes-orchestrator
description: "Hermes编排技能。定义五角色协作流程、任务路由规则、交接协议。当用户启动hermes团队或需要多角色协作时使用。"
---

# Hermes Orchestrator — 编排技能

本技能定义 Hermes Agent Team 的完整协作流程。

## 工作流总览

```
Phase 1: Coordinator 编排
    ↓
Phase 2: Researcher 研究（可并行）
    ↓
Phase 3: Writer/Builder 执行
    ↓
Phase 4: Editor 质量审计
    ↓
Phase 5: Human 人类闸门
```

## Phase 1: Coordinator 编排

### 输入
- 用户任务描述

### 处理步骤
1. **解析任务** — 理解用户真实需求
2. **拆解子任务** — 分解为可执行单元
3. **确定路由** — 决定每个子任务交给谁
4. **创建任务列表** — 明确依赖关系

### 输出
- 任务拆解文档
- 各角色的任务包

### 任务包模板

**给 Researcher 的任务包**：
```markdown
## 研究任务: {任务ID}

### 目标
{需要研究的问题}

### 范围
- {范围1}
- {范围2}

### 期望输出
- 证据列表（含来源）
- 置信度标注（🟢🟡🔴）
- 关键发现摘要

### 截止时间
{时间}
```

**给 Writer 的任务包**：
```markdown
## 写作任务: {任务ID}

### 输入
- Researcher 产出: {路径}
- 仅使用🟢绿色数据

### 期望输出
- {产出格式}
- {产出路径}

### 约束
- 不使用🟡🔴数据作为核心依据
```

**给 Editor 的任务包**：
```markdown
## 审计任务: {任务ID}

### 输入
- Writer 产出: {路径}

### 审计范围
- 事实核查: 提取关键断言，独立验证
- 发布前检查: 按清单核对

### 期望输出
- 审计报告: {路径}
```

## Phase 2: Researcher 研究

### 输入
- Coordinator 的任务包

### 处理步骤
1. **信息收集** — WebSearch、WebFetch、代码分析
2. **来源验证** — 至少 2 个独立来源
3. **置信度标注** — 🟢🟡🔴 三级标注
4. **生成报告** — 结构化输出

### 输出
- `research-output.md` — 研究报告

### 质量门控
- 只有 🟢 绿色数据可流入下游
- 🟡 黄色数据需标注，不可作为核心依据
- 🔴 红色数据禁止流入下游

## Phase 3: Writer/Builder 执行

### 输入
- Coordinator 的任务包
- Researcher 的研究报告

### 处理步骤
1. **读取数据** — 检查 🟢 数据是否充足
2. **转化产出** — 文章、代码、设计等
3. **质量自检** — 确保符合任务要求
4. **数据不足反馈** — 如需补充，反馈 Coordinator

### 输出
- `draft-output.md` — 产出草稿

### 数据不足处理
```markdown
## 数据不足反馈

### 缺失数据
1. {数据点1}: 需要 🟢 级别证据
2. {数据点2}: 需要 🟢 级别证据

### 影响
- {影响说明}

### 建议
- 请 Researcher 补充研究
```

## Phase 4: Editor 质量审计

### 输入
- Coordinator 的任务包
- Writer 的产出草稿

### 处理步骤

**阶段 A: 事实核查**
1. 提取关键断言
2. 独立搜索验证（不依赖 Researcher 数据）
3. 标注验证结果（✅/⚠️/❌）

**阶段 B: 发布前检查**
1. 格式检查
2. 内容检查
3. 质量检查
4. 生成检查报告

### 输出
- `audit-report.md` — 审计报告

### 审计结论
- **PASS** — 通过，进入 Phase 5
- **NEEDS_FIX** — 需修改，返回 Phase 3
- **REJECT** — 拒绝，需重新来过

### 修改循环
- 最多 3 轮修改
- 超过 3 轮需 Human 决策

## Phase 5: Human 人类闸门

### 介入节点
1. **任务启动** — 确认目标和范围
2. **审计问题** — 决定是否接受产出
3. **数据不足** — 决定继续研究还是调整范围
4. **最终验收** — 确认交付

### 决策选项
- ✅ 确认/通过
- 🔄 调整/修改
- ❌ 取消/拒绝

## 交接协议

### 文件命名规范
```
_workspace/
├── 01_coordinator_tasks.md      # 任务拆解
├── 02_researcher_output.md      # 研究报告
├── 03_writer_draft.md           # 产出草稿
├── 04_editor_audit.md           # 审计报告
└── 05_human_decisions.md        # 人类决策记录
```

### 消息协议

**Coordinator → Researcher**：
```
任务: {任务ID}
目标: {研究目标}
范围: {研究范围}
期望: {输出格式}
```

**Researcher → Coordinator**：
```
完成: {任务ID}
输出: {文件路径}
摘要: {关键发现}
置信度分布: 🟢{N} 🟡{N} 🔴{N}
```

**Coordinator → Writer**：
```
任务: {任务ID}
输入: {文件路径}
约束: 仅使用🟢数据
期望: {产出格式}
```

**Writer → Coordinator**：
```
完成: {任务ID}
输出: {文件路径}
状态: 完成/数据不足
```

**Coordinator → Editor**：
```
任务: {任务ID}
输入: {文件路径}
审计范围: 事实核查 + 发布检查
```

**Editor → Coordinator**：
```
完成: {任务ID}
输出: {文件路径}
结论: PASS/NEEDS_FIX/REJECT
问题数: {N}
```

## 错误处理

| 情况 | 处理 |
|------|------|
| Researcher 返回🟢数据不足 | 要求补充研究或 Human 决策 |
| Editor 发现问题 | 反馈 Writer 修改（最多3轮） |
| 任务超出范围 | 暂停，与 Human 确认 |
| 角色间冲突 | 收集意见，Human 裁决 |

## 执行模式选择

### Agent Teams（推荐）
- 五角色实时协作
- 适合复杂任务
- 需要频繁沟通

### Sub-agents
- 顺序执行
- 适合简单任务
- 成本更低

### 混合模式
- Phase 2 并行研究：Sub-agents
- Phase 3-4 协作执行：Agent Teams
