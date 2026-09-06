# 编排器设计规范

> `.claude/skills/{team}-orchestrator/SKILL.md` 是团队的大脑，负责路由、调度、质量门、Worktree 管理。

## 编排器必须包含

### 1. 路由表

| 用户指令（触发词） | 路由到 | 干什么 |
|---|---|---|
| <工程相关词> | engineer | 环境、git、依赖 |
| <验收相关词> | acceptor | 验收、测试 |
| <内容相关词> | content-creator | 文档、内容 |
| <审校相关词> | content-reviewer | 审稿、合规 |
| <产品相关词> | pm | PRD、需求、方案 |
| <沉淀相关词> | knowledge-keeper | 沉淀、蒸馏 |
| <合并相关词> | merge-engineer | 分支合并、冲突处理 |
| 模糊跨多角色 | orchestrator 拆子任务分别派 | 最后整合 |

### 2. Phase 流程

按团队架构模式定义执行流程。如 Pipeline 模式：

```
Phase 1: 需求澄清（pm）
    ↓ 质量门一：PRD + 验收标准确认
Phase 2: 执行（engineer / content-creator / research-agent）
    ↓ 质量门二：交付物完整 + 自测通过
Phase 3: 验收（acceptor / content-reviewer）
    ↓ 质量门三：PASS
Phase 4: 沉淀（knowledge-keeper）+ 交付
```

### 3. 数据传递协议

- 角色间通过文件交接，不靠上下文记忆
- 每个角色的产出有明确路径
- 下一环角色读取上一环的产出文件

### 4. 错误处理

| 错误类型 | 处理 |
|----------|------|
| 角色执行失败 | 重试 1 次 → 降级 → 上报 |
| 质量门不通过 | 退回上一阶段修复（最多 2 轮）→ BLOCKED |
| 角色不存在 | orchestrator 临时承担或上报 |
| 合并冲突 | merge-engineer 处理简单冲突；复杂冲突上报 |

### 5. Worktree 调度（如启用并行模式）

- 任务拆分后做依赖分析
- 无依赖任务分配到独立 worktree 并行
- 每个 worktree 有独立分支
- 完成后 merge-engineer 合并
- 合并后清理 worktree 和分支

详见 `worktree-parallel.md`。

### 6. 质量门

每道质量门有明确的通过条件，不可跳过。详见 `quality-gates.md`。

## 编排器文件结构

```
.claude/skills/{team}-orchestrator/
├── SKILL.md              # 主入口：路由表 + Phase 流程 + 错误处理 + Worktree
└── references/
    ├── roadmap.md        # 项目状态底稿（目标/已完成/缺口/优先级）
    ├── routing-rules.md  # 详细路由规则
    └── quality-gates.md  # 质量门标准
```

## 编排器的铁律

- 管流程的不管质量：orchestrator 只卡点，不替 acceptor 做验收决策
- 不替任何角色做执行决策：orchestrator 只分派，不抢活
- 质量门不可跳过：不通过就是不通过
- 任何降级必须记录：不允许静默降低标准
