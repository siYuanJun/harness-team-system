# 深度研究场景示例

## 场景描述

用户需要深度研究"AI Agent 协作模式"，要求：
- 收集多源信息
- 交叉验证事实
- 标注置信度
- 生成结构化报告

## 触发方式

```
启动hermes团队，帮我深度研究"AI Agent 协作模式"
```

## 执行流程

### Phase 1: Coordinator 编排

**Coordinator 输出**：

```markdown
## 任务拆解

### 目标
深度研究"AI Agent 协作模式"，生成结构化研究报告

### 子任务
1. [ ] 研究 AI Agent 基础概念 → Researcher
2. [ ] 研究主流协作模式 → Researcher
3. [ ] 研究实际应用场景 → Researcher
4. [ ] 撰写研究报告 → Writer（依赖子任务1、2、3）
5. [ ] 质量审计 → Editor（依赖子任务4）

### 依赖关系
- 子任务4 依赖 子任务1、2、3 的🟢绿色数据
- 子任务5 依赖 子任务4 的产出

### 交付标准
- 报告长度：3000-5000字
- 包含至少10个🟢绿色数据点
- 所有引用标注来源
```

### Phase 2: Researcher 研究

**Researcher 输出**：

```markdown
# 研究报告: AI Agent 协作模式

## 摘要
AI Agent 协作模式是指多个 AI Agent 通过特定机制协同工作...

## 发现列表

### 发现 1: AI Agent 定义
**置信度**: 🟢
**内容**: AI Agent 是能够感知环境、做出决策并执行动作的智能体
**来源**: 
- [Stanford AI Lab](https://ai.stanford.edu/)
- [OpenAI Research](https://openai.com/research)
**验证状态**: ✅已核实

### 发现 2: 主流协作模式
**置信度**: 🟢
**内容**: 主要包括 Pipeline、Fan-out/Fan-in、Expert Pool 等模式
**来源**:
- [Harness Documentation](https://github.com/revfactory/harness)
- [LangGraph Docs](https://langchain-ai.github.io/langgraph/)
**验证状态**: ✅已核实

### 发现 3: 市场规模
**置信度**: 🟡
**内容**: 预计2026年 AI Agent 市场规模约 50 亿美元
**来源**:
- [Gartner Report](https://gartner.com)（单源）
**验证状态**: ⚠️待确认

## 关键数据（仅🟢绿色）

| 数据点 | 值 | 来源 |
|--------|-----|------|
| Pipeline 模式 | 顺序依赖任务 | Harness Docs |
| Fan-out/Fan-in | 并行独立任务 | LangGraph Docs |
| Expert Pool | 情境选择调用 | Harness Docs |

## 待确认事项（🟡黄色）
- 市场规模数据仅有单一来源
```

### Phase 3: Writer 执行

**Writer 输出**：

```markdown
# AI Agent 协作模式深度研究报告

## 摘要
本报告深入研究了 AI Agent 协作模式的定义、主流模式和应用场景...

## 1. AI Agent 基础概念

AI Agent 是能够感知环境、做出决策并执行动作的智能体 🟢。
根据 Stanford AI Lab 和 OpenAI Research 的定义...

## 2. 主流协作模式

### 2.1 Pipeline 模式
Pipeline 模式适用于顺序依赖任务 🟢。在这种模式下...

### 2.2 Fan-out/Fan-in 模式
Fan-out/Fan-in 模式用于并行独立任务 🟢。该模式...

### 2.3 Expert Pool 模式
Expert Pool 模式根据情境选择调用 🟢。这种模式...

## 3. 应用场景

### 3.1 软件开发
在软件开发领域，AI Agent 协作模式可以...

### 3.2 内容创作
在内容创作领域，多 Agent 协作可以...

## 4. 市场展望

预计2026年 AI Agent 市场规模约 50 亿美元 🟡（基于 Gartner 报告推断）。
注意：此数据为估计值，实际规模可能有所不同。

## 参考来源

### 🟢 已核实来源
1. [Stanford AI Lab](https://ai.stanford.edu/)
2. [OpenAI Research](https://openai.com/research)
3. [Harness Documentation](https://github.com/revfactory/harness)
4. [LangGraph Docs](https://langchain-ai.github.io/langgraph/)

### 🟡 估计值来源
1. [Gartner Report](https://gartner.com) - 市场规模预测

## 置信度说明
- 🟢: 已核实数据（4个数据点）
- 🟡: 估计值/推断（1个数据点）
- 🔴: 推测（本文未使用）
```

### Phase 4: Editor 质量审计

**Editor 输出**：

```markdown
# 审计报告: AI Agent 协作模式研究

## 审计摘要
- 审计时间: 2026-08-13
- 审计范围: 事实核查 + 发布前检查
- 总体结论: PASS

## 阶段 A: 事实核查

### 核查列表

| # | 断言内容 | 验证结果 | 来源 | 说明 |
|---|---------|---------|------|------|
| 1 | AI Agent 定义 | ✅ | Stanford AI Lab | 与官方定义一致 |
| 2 | Pipeline 模式 | ✅ | Harness Docs | 描述准确 |
| 3 | Fan-out/Fan-in | ✅ | LangGraph Docs | 描述准确 |
| 4 | Expert Pool | ✅ | Harness Docs | 描述准确 |
| 5 | 市场规模50亿 | ⚠️ | Gartner Report | 单源，已标注为估计值 |

### 核查统计
- ✅ 已确认: 4
- ⚠️ 待确认: 1
- ❌ 不一致: 0

## 阶段 B: 发布前检查

### 检查清单

| # | 检查项 | 结果 | 说明 |
|---|-------|------|------|
| 1 | 结构完整 | ✅ | 包含摘要、正文、参考 |
| 2 | 格式规范 | ✅ | Markdown 格式正确 |
| 3 | 引用标注 | ✅ | 所有引用都有来源 |
| 4 | 无原始数据泄露 | ✅ | 无 Researcher 原始笔记 |
| 5 | 无敏感信息 | ✅ | 无敏感内容 |
| 6 | 外部依赖完整 | ✅ | 链接可访问 |
| 7 | 逻辑连贯 | ✅ | 论述清晰 |
| 8 | 表述清晰 | ✅ | 语言简洁 |

### 检查统计
- 通过: 8
- 未通过: 0

## 结论

报告质量良好，事实核查通过，发布前检查全部通过。
建议：可以发布。
```

### Phase 5: Human 人类闸门

**Human 决策**：

```markdown
## 决策记录

### 决策节点: 最终验收
### 决策时间: 2026-08-13

### 背景
Editor 审计通过，报告质量良好

### 决策
✅ 验收通过

### 理由
- 事实核查通过
- 发布前检查全部通过
- 报告结构完整，内容准确

### 后续行动
- 发布报告
- 归档项目数据
```

## 最终产出

```
.ai-workflow/hermes/projects/ai-agent-research/
├── 01_coordinator_tasks.md
├── 02_researcher_output.md
├── 03_writer_draft.md
├── 04_editor_audit.md
└── 05_human_decisions.md

最终报告: AI Agent 协作模式深度研究报告.md
```

## 关键要点

1. **三级置信度**：Researcher 标注 🟢🟡🔴，Writer 只使用 🟢 数据
2. **独立验证**：Editor 独立搜索验证，不依赖 Researcher
3. **流程分离**：Coordinator 管流程，Editor 管质量
4. **人类决策**：Human 在关键节点介入
