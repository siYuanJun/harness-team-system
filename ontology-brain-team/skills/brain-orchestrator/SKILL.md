---
name: brain-orchestrator
description: "Ontology-Brain 六环流水线编排器。用户说跑流水线/做本体建模/开始六环时触发，自动调度业务调研→本体建模→应用对接三个执行 Agent，每环经 QA 独立验收，异常兜底，最终交付全套产物。"
---

# Dome Orchestrator · 六环流水线编排

## 触发场景

用户说以下内容时启用本 Skill：

- "跑一下流水线"
- "开始六环"
- "做本体建模"
- "对这个文档做本体分析"
- "生成术语表和 Schema"
- "本体工程师数字员工"
- "ontology-brain 团队"

## 角色配置

| 角色 | Agent 文件 | 职责 |
|------|-----------|------|
| Orchestrator（你） | brain-orchestrator.md | 调度、质量门、异常兜底、交付 |
| PM 产品经理 | brain-pm.md | 需求→PRD / 验收标准 / 优先级 |
| 业务调研 Agent | brain-research-agent.md | 环①② 术语+范围 |
| 本体建模 Agent | brain-modeling-agent.md | 环③④ Schema+实例 |
| 应用对接 Agent | brain-app-agent.md | 环⑤⑥ RAG+评测 |
| QA 验收官 | brain-qa-auditor.md | 每环独立验收 |
| Engineer 工程手 | brain-engineer.md | 环境/git/提交 |

## 工作流

```
Phase 0: 任务理解与拆解
  ├─ 读取输入（业务文档目录）
  ├─ 确认业务域（或自动推导）
  └─ 创建工作目录 + PROGRESS.md

Phase 1: 环①② 业务调研
  ├─ → 业务调研 Agent（术语提取 + 概念识别）
  ├─ → QA 验收官（环①②独立验收）
  └─ PASS → 进 Phase 2 / FAIL → 退回修改（最多 2 轮）

Phase 2: 环③④ 本体建模
  ├─ → 本体建模 Agent（Schema 设计 + 实例抽取）
  ├─ → QA 验收官（环③④独立验收 + validate 校验）
  └─ PASS → 进 Phase 3 / FAIL → 退回修改（最多 2 轮）

Phase 3: 环⑤⑥ 应用对接
  ├─ → 应用对接 Agent（RAG 代码 + 对比评测）
  ├─ → QA 验收官（环⑤⑥独立验收 + 评测真实性核查）
  └─ PASS → 交付 / FAIL → 退回修改（最多 2 轮）

Phase 4: 汇总交付
  ├─ 收集 6 份产物
  ├─ 汇总 PENDING 待裁决项
  ├─ 生成交付清单
  └─ 报告给 Human
```

## 质量门机制

每环完成后 → QA 独立验收 → 只有 PASS 才进入下一环。

QA 验收内容：
- **明卷**：结构校验、规范检查、接口对齐
- **暗卷**：泛化测试、边界测试、反作弊检查
- **反作弊**：硬编码、绕过校验、数据泄露、评测造假

退回修改最多 2 轮，第 3 次还不通过 → 降级处理（STUB 标记 + PENDING 记录）或停止（关键环）。

## 异常处理矩阵

| 情况 | 处理 |
|------|------|
| 执行 Agent 产出 QA 验收不通过 | 退回修改，附问题清单 |
| 第 2 次还不通过 | 第 3 次降级：STUB + PENDING，继续下一环（标注不可用） |
| 关键环（③ / ⑥）连续失败 | 停，写 BLOCKED.md，等 Human 决策 |
| 接口断裂（上下游对不上） | 停，写 BLOCKED.md，等 Human 决定哪侧改 |
| 环境 / 依赖问题 | 转 Engineer 工程手解决 |
| 需求超出范围 | 停，写 BLOCKED.md，等 Human 确认 |

## 路由表

| 用户输入 | 路由 |
|----------|------|
| "跑流水线" / "开始六环" / "做本体建模" | 全流程：Phase 0 → 1 → 2 → 3 → 4 |
| "只跑前两环" / "术语提取" | 只执行 Phase 1 |
| "只跑建模" / "生成 Schema" | 从 Phase 2 开始（需要 scope 输入） |
| "只跑评测" / "对比一下" | 从 Phase 3 开始（需要 schema + instances 输入） |
| "验收一下" / "检查质量" | 直接调 QA 验收官 |
| "提交代码" / "git 一下" | 转 Engineer 工程手 |
| "进度怎么样" / "状态" | 读 PROGRESS.md + PENDING.md，汇总回答 |
| 模糊指令 | 先问清楚（≤3 个问题），再开工 |

## 产出物清单

六环标准产物：
1. `01_terms.md` — 术语对齐表
2. `02_scope.md` — 建模范围清单
3. `03_schema.json` — 本体 Schema
4. `04_instances.json` — 实例库
5. `05_rag.py` — RAG 接入代码
6. `06_eval_report.md` — 对比评测报告

附加产出：
- `PENDING.md` — 待裁决清单
- `BLOCKED.md` — 阻塞问题（如果有）
- `PROGRESS.md` — 进度记录
- QA 验收报告 × 3（每环组一份）

## References

- `references/routing-rules.md` — 详细路由规则
- `references/quality-gates.md` — 质量门详细标准
- `references/handoff-protocols.md` — 角色交接协议
- 各角色完整定义：项目根 `.claude/agents/`（brain-orchestrator / brain-research-agent / brain-modeling-agent / brain-app-agent / brain-qa-auditor / brain-engineer）
