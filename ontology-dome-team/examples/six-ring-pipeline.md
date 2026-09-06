# 六环流水线运行示例

> 场景：对"理赔制度问答"业务文档做一次完整的本体建模六环流水线

## 触发

用户说："跑一下流水线，输入是 practice/claim-qa/docs"

## Phase 0：任务拆解（Orchestrator）

1. 确认输入：`practice/claim-qa/docs`（保险理赔制度文档 3 篇）
2. 业务域推导：保险 / 理赔
3. 创建工作目录：`pipeline/output/claim-qa/`
4. 写 PROGRESS.md：
   - 目标：跑通六环，产出 6 份标准产物
   - 顺序：环①② → 环③④ → 环⑤⑥
   - 最大风险：环③接口断裂（中文 scope → 英文 Schema 映射）

## Phase 1：环①② 业务调研

**执行者**：业务调研 Agent

**输入**：3 篇理赔制度文档

**产出**：
- 01_terms.md：42 个专业术语 + 消歧规则
- 02_scope.md：40 个类候选 + 12 个关系候选 + 不建清单
- 返回 JSON：`{"terms": {...}, "scope": {"classes": 40, "relations": 12}}`

**PENDING 项**：
- "理赔"和"索赔"是否完全同义 → 暂定归并，待确认
- "报案"是动作还是实体 → 暂定类，待确认

**QA 验收**：
- 明卷：结构 ✅ / 来源 ✅ / 消歧 ✅
- 暗卷：泛化（人事考勤文档测试通过）✅ / 边界（空输入正确返回）✅
- 结论：**PASS**

## Phase 2：环③④ 本体建模

**执行者**：本体建模 Agent

**输入**：scope 数据 + 原文档

**产出**：
- 03_schema.json：28 个类 + 9 个关系 + 中英映射
- 04_instances.json：31 个实例 + 30 组三元组 + 来源标注
- validate_ontology.py：**PASS**

**PENDING 项**：
- InsuranceType 类的枚举值是否齐全 → 暂列 3 种，待补充
- Policy 和 Clause 的关系方向 → 暂定 `Policy hasClause Clause`，待确认

**QA 验收**：
- 明卷：validate PASS ✅ / 命名规范 ✅ / 中英映射 ✅ / 实例来源 ✅
- 暗卷：结构深度合理 ✅ / 抽查实例来源真实 ✅
- 结论：**PASS**

## Phase 3：环⑤⑥ 应用对接

**执行者**：应用对接 Agent

**输入**：Schema + 实例库 + 原文档

**产出**：
- 05_rag.py：有本体 / 无本体双模式 RAG 检索代码
- 06_eval_report.md：4 题对比评测报告
- eval_result.json：结构化结果

**评测数字**：
| 指标 | 无本体 | 有本体 | Δ |
|------|--------|--------|---|
| Precision | 0.062 | 0.124 | +6.2% |
| Recall | 0.083 | 0.166 | +8.3% |
| F1 | 0.071 | 0.142 | +7.1% |
| 串险种率 | 0.5 | 0.0 | -50% |

**QA 验收**：
- 明卷：代码可运行 ✅ / 数字完整 ✅ / 方法清晰 ✅
- 暗卷：重跑一致 ✅ / 基线公平 ✅ / 评测集从实例派生 ✅ / 串险种率真实 ✅
- 反作弊：无硬编码 ✅ / 无数据泄露 ✅
- 结论：**PASS**

## Phase 4：汇总交付（Orchestrator）

**交付清单**：
1. ✅ 01_terms.md — 术语对齐表
2. ✅ 02_scope.md — 建模范围清单
3. ✅ 03_schema.json — 本体 Schema
4. ✅ 04_instances.json — 实例库
5. ✅ 05_rag.py — RAG 接入代码
6. ✅ 06_eval_report.md — 对比评测报告

**PENDING 汇总**：5 项待裁决（详见 PENDING.md）

**核心结论**：六环全通，Precision +6.2%，串险种率从 50% 降到 0。

---

## 如果出了问题

### 场景：环③接口断裂（scope 是中文，Schema 要英文，映射缺失）

**发生在**：Phase 2 本体建模

**本体建模 Agent 发现后**：
1. 立刻停
2. 写 BLOCKED.md：
   - 标题：环③接口断裂 — scope 中文名 vs _pascalize() 只接受英文
   - 严重度：P0 阻断
   - 证据：B 输出 40 个中文类名 / C 的 _pascalize 正则 `^[A-Z][A-Za-z0-9]*$` 全部匹配失败
   - 影响：环③④ 完全无法推进
   - 建议方向：需要增加中→英映射层（B 侧加或 C 侧加都行，建议 C 侧加因为映射是建模职责）
3. 通知 Orchestrator

**Orchestrator 处理**：
1. 确认阻塞
2. 判断：这是关键环，不能降级
3. 上报 Human，等决策
4. 同时让不依赖环③的任务先做（如文档整理、PENDING 梳理）

**Human 决策后**：Orchestrator 按决策执行（比如：C 侧加映射层，B 侧不动）
