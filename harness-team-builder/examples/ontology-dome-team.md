# 成品案例：ontology-dome-team

> 这是用 harness-team-builder 方法论搭建的第一个垂直团队，位于：
> `/Users/siyuan/Documents/www/skills/ai-skills-prompt/harness/ontology-dome-team/`

## 团队概况

- **团队名**：ontology-dome-team
- **领域**：本体工程师数字员工
- **架构模式**：Pipeline + Producer-Reviewer（六环流水线，每环后 QA 独立验收）
- **团队规模**：标准团队（7 人）
- **角色**：dome-pm、dome-orchestrator、dome-research-agent、dome-modeling-agent、dome-app-agent、dome-qa-auditor、dome-engineer

## 为什么是垂直团队

这个团队绑定了本体工程的特定内容：
- 六环流水线（术语→概念→Schema→实例→RAG→评测）
- 产出物（术语表、Schema.json、实例库、RAG 代码、评测报告）
- 质量门标准（泛化能力、Schema validate、RAG 数字可复现）
- 角色前缀 `dome-*`

换一个项目（如电商系统），这个团队不适用，需要用 harness-team-builder 重新搭建。

## 可以复用的部分

虽然团队是垂直的，但以下部分是通用的，其他团队搭建时可以参考：
- 7 角色架构（pm + orchestrator + 3 执行 + qa + engineer）
- 管流程不管质量的铁律
- 3 质量门机制
- 明卷 + 暗卷 + 反作弊的验收方法
- 角色文件结构（核心角色/工作原则/输入输出/协作/错误处理）

## 项目副本

该团队的项目副本（实际运行时）位于：
`/Users/siyuan/Documents/www/siyuan-www/ontology-dome/.claude/`

副本比源目录多一行 `model: opus`（运行时模型指定），这是有意差异，不需要同步。

## 里程碑任务指令

该团队的任务指令用 `harness-team-mission-planner` Skill 生成，位于：
`/Users/siyuan/Documents/www/siyuan-www/ontology-dome/docs/internal/harness-m3/`

## 参考价值

新团队搭建时，可以参考这个案例的：
1. 角色职责描述的具体程度
2. 编排器的路由表写法
3. 质量门标准的可验证性
4. CLAUDE.md 的触发规则设计
