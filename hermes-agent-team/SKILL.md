---
name: hermes-agent-team
description: "Hermes Agent Team v3.0 — 五角色多Agent协作框架。当用户要求启动hermes团队、五角色协作、深度研究、内容生产、需要质量审计的复杂任务时使用。包含Coordinator(编排)、Researcher(研究)、Writer(执行)、Editor(审计)、Human(闸门)五个角色。触发词：启动hermes、hermes团队、五角色协作、深度研究、需要事实核查、内容生产流程、hermes初始化。"
---

# Hermes Agent Team v3.0

五角色多Agent协作框架，核心架构铁律：**管流程的不能管质量**。

## 五角色模型

| 角色 | 职责 | 不做 |
|------|------|------|
| **Coordinator** | 定义目标、拆解任务、路由、汇总、检查边界 | ❌ 质量审计 |
| **Researcher** | 收集证据、对比来源、标注置信度(🟢🟡🔴) | ❌ 流程管理 |
| **Writer/Builder** | 只使用🟢绿色数据，转化为最终产出 | ❌ 质量判断 |
| **Editor** | 独立事实核查 + 发布前检查 | ❌ 流程管理 |
| **Human** | 关键节点决策，最终验收 | 不打断每步 |

## 三级置信度体系

| 级别 | 颜色 | 定义 | 流转规则 |
|------|------|------|----------|
| L1 | 🟢 绿色 | 已核实：多源验证、有直接证据 | 可流入下游 |
| L2 | 🟡 黄色 | 估计值：单源或合理推断 | 需标注、不可作为核心依据 |
| L3 | 🔴 红色 | 推测：无直接证据 | 禁止流入下游 |

## 工作流

```
Phase 1: Coordinator 编排
  ├─ 解析任务目标
  ├─ 拆解子任务
  ├─ 确定路由（Researcher / Writer）
  └─ 创建任务列表

Phase 2: Researcher 研究（可并行）
  ├─ 收集证据
  ├─ 对比来源（至少2个独立源）
  ├─ 标注置信度（🟢🟡🔴）
  └─ 输出：research-output.md

  【质量门控】只有🟢绿色数据可流入下游

Phase 3: Writer/Builder 执行
  ├─ 只读取🟢绿色数据
  ├─ 转化为最终产出
  ├─ 绿色数据不足 → 召回Researcher
  └─ 输出：draft-output.md

Phase 4: Editor 质量审计（独立于Coordinator）
  ├─ 【阶段A: 事实核查】
  │   ├─ 提取关键断言
  │   ├─ 独立搜索验证（不依赖Researcher数据）
  │   └─ 标注：✅已确认 / ⚠️待确认 / ❌不一致
  ├─ 【阶段B: 发布前检查】
  │   ├─ 按检查清单核对
  │   ├─ 验证外部依赖完整性
  │   └─ 确认无原始数据泄露
  └─ 输出：audit-report.md

  如发现问题 → 返回Phase 3修改（最多3轮）

Phase 5: Human 人类闸门
  ├─ 任务启动时确认目标
  ├─ 审计发现问题时决策
  └─ 最终交付时验收
```

## 四层数据隔离

| 概念 | 存放位置 | 生命周期 | 内容 |
|------|----------|----------|------|
| **Profile** | `.claude/agents/hermes-*.md` | 永久 | 角色定义 |
| **Project** | `.ai-workflow/hermes/projects/{id}/` | 项目周期 | 任务产出 |
| **Wiki** | `hermes-agent-team/wiki/` | 永久 | 通用知识 |
| **Session** | 对话上下文 | 会话周期 | 临时状态 |

## Harness 集成

本框架遵循 Harness 规范，可通过 Harness 初始化部署到任意项目：

1. **Agent 定义**：`agents/` 目录下的文件可直接复制到 `.claude/agents/`
2. **Skill 定义**：`skills/` 目录下的文件可直接复制到 `.claude/skills/`
3. **Wiki 知识库**：`wiki/` 目录包含跨项目共享的通用知识

### 快速部署

```bash
# 复制到目标项目
cp -r hermes-agent-team/agents/* {project}/.claude/agents/
cp -r hermes-agent-team/skills/* {project}/.claude/skills/
```

或在 CLAUDE.md 中添加触发规则：

```markdown
## Hermes Agent Team
**触发：** 深度研究、内容生产、需要质量审计的复杂任务 → 使用 hermes-agent-team skill
```

## References

- `agents/` — 五角色定义模板
- `skills/hermes-orchestrator/` — 编排流程
- `skills/hermes-researcher/` — 研究 + 置信度标注
- `skills/hermes-writer/` — 执行转化
- `skills/hermes-editor/` — 两阶段审计
- `wiki/` — 跨项目共享知识库
- `templates/` — 项目初始化模板
- `examples/` — 使用示例
