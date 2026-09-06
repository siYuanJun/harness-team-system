# Ontology-Dome Team · 本体工程师数字员工团队

> 一个 Harness 团队工程：把"本体工程师"装进数字员工，六环流水线 + 7 角色协作（目标 9 角色），输入业务文档 → 产出 6 份标准本体产物。

## 是什么

Ontology-Dome Team 是一个面向**本体工程领域**的 Harness 多智能体团队。它模拟一名资深本体工程师的完整工作流，从业务文档中自动提取术语、构建本体 Schema、灌入实例、接入 RAG、并完成对比评测——全程无人值守。

### 核心定位

- **产品形态**：本体工程师数字员工（谁部署谁就获得一名本体工程师）
- **工作模式**：六环流水线（术语→概念→Schema→实例→RAG→评测）
- **团队规模**：v0.3 已落地 **7 角色** / 5 层架构（产品 / 监督 / 执行 / 质量 / 工程）；9 角色为 v1.0 目标（待补知识层双岗）
- **质量保障**：4 个裁决点规则化 + QA 独立验收 + 暗卷抽查

## 团队架构（v0.3 · 已落地 7 角色）

| 层级 | 角色 | 职责 | 状态 |
|------|------|------|------|
| 产品定义层 | PM 产品经理 | 需求澄清 · PRD 产出 · 四视角评审 | ✅ v0.3 |
| 监督层 | Orchestrator 总监 | 路由调度 · 异常兜底 · 质量门管控 | ✅ v0.2 |
| 执行层 | 业务调研 Agent | 术语提取 · 消歧规则 · 够用原则 | ✅ v0.2 |
| 执行层 | 本体建模 Agent | Schema 设计 · 实例抽取 · 中英映射 | ✅ v0.2 |
| 执行层 | 应用对接 Agent | RAG 集成 · 评测设计 · 指标计算 | ✅ v0.2 |
| 质量层 | QA 验收官 | 结构校验 · 口径对齐 · 反作弊检查 | ✅ v0.2 |
| 工程层 | Engineer 工程手 | 环境配置 · git 操作 · 依赖管理 | ✅ v0.2 |
| 知识层 | Content Creator | 知识蒸馏 · 文档写作 · 方法论沉淀 | ⏳ P1 |
| 知识层 | Content Reviewer | 质量审校 · 一致性检查 · 价值闸门 | ⏳ P1 |

## 目录结构

```
ontology-dome-team/
├── README.md              # 本文件
├── SKILL.md               # Harness Skill 入口定义
├── visualizations/        # 可视化展示文档
│   ├── analysis-report.html   # 团队架构分析报告（工程蓝图风格）
│   └── upgrade-plan.html      # 9 角色升级方案（工程蓝图风格）
├── agents/               # Agent 角色定义（7 个，已落地）
│   ├── dome-pm.md        # 产品经理（v0.3 新增）
│   ├── dome-orchestrator.md / dome-research-agent.md / dome-modeling-agent.md
│   └── dome-app-agent.md / dome-qa-auditor.md / dome-engineer.md
├── skills/               # 子 Skill 定义（dome-orchestrator 编排器，已落地）
├── wiki/                 # 团队协作规范（架构铁律 + 交接协议，已落地）
└── examples/             # 运行示例（六环流水线，已落地）
```

> 落地方式：本目录为团队 Skill **源**；项目内副本在 `ontology-dome/.claude/`（agents + skills + CLAUDE.md），同步后两边一致。

## 可视化展示

### [📊 团队架构分析报告](visualizations/analysis-report.html)

项目现状全景 · 核心目标 · 7 角色架构 · 综合建议

### [⬆️ 9 角色升级方案](visualizations/upgrade-plan.html)

差异对比 · 9 角色架构 · 路由表 · PM 三基座 · 9 步落地路径

## 路由表（核心机制）

| 触发指令 | 目标角色 | 行动 |
|----------|----------|------|
| "分析一下当前项目状态" / "总览" | Orchestrator | 汇总进展，输出项目总览 |
| "跑一下流水线" / "开始六环" | Orchestrator 调度 | 按六环顺序调度，每环过 QA 质量门 |
| "验收一下" / "检查质量" | QA 验收官 | 独立跑验收，输出 PASS/FAIL 报告 |
| "提交代码" / "git 一下" | Engineer 工程手 | git 操作 + 环境配置 + 发布收尾 |
| "写个 PRD" / "产品定义" | PM 产品经理 | 需求澄清 → PRD → 四视角评审 → 设计红线 |
| "沉淀一下" / "蒸馏经验" | Content Creator | 提取方法论 → 写入知识库 → 登记 MOC |
| "检查知识库" / "审一下" | Content Reviewer | 过价值闸门，只留能力资产 |
| 模糊指令 / 跨多角色 | Orchestrator 拆解 | 理解需求 → 拆子任务 → 分派 → 整合交付 |

## 业务背景

企业 RAG 场景中，纯向量检索的语义漂移是系统性问题——串险种、术语歧义、隐含假设缺失。本体工程是解法之一，但传统本体建模成本高、周期长、依赖专家。

Ontology-Dome Team 要做的是**把本体工程的门槛打平**，让它变成一个可复制、可规模化的数字员工能力。

## 里程碑

- ✅ **M0** 理赔六环实战闭环（practice/claim-qa/）
- ✅ **M1** 六环 Agent 流水线 CLI（run_pipeline.py，已验收）
- ✅ **M2** 4 个裁决点规则化 + 第二域考勤闭环 + 总验收 **71.2 分 B 级**（122 测试全过，反作弊双域全绿）
- ○ **M2.1** 差距收口：LLM 裁决实测（+6~8 分）· 空实例清零（+4~5 分）· 服务化生产面（+3 分）
- ○ **M3** 评测闭环自动化 + 真实 Embedding
- ○ **M4** 新业务域验证

## 相关资源

- 源项目：[ontology-dome](../../../../siyuan-www/ontology-dome/)
- 领域知识库：[knowledge-base](../../../../siyuan-www/ontology-dome/knowledge-base/)
- 通用模板：Harness 团队组建提示词-通用模板
- 参考团队：[hermes-agent-team](../hermes-agent-team/) · [prd-review-team](../prd-review-team/)
