# Harness 架构模式详解

Harness 提供 6 种预定义的团队架构模式，Hermes 可根据需求选择或组合使用。

## 1. Pipeline（流水线）

**适用场景**：顺序依赖的任务，前一阶段的输出是后一阶段的输入

```
[分析] → [设计] → [实现] → [验证]
```

**Hermes 应用**：
- Phase 1: Coordinator 分析任务
- Phase 2: Researcher 收集信息
- Phase 3: Writer 生成内容
- Phase 4: Editor 质量审计

**优点**：
- 清晰的阶段划分
- 每阶段有明确的输入输出
- 易于管理和追踪

**缺点**：
- 串行执行，速度较慢
- 某一阶段失败会阻塞整个流程

## 2. Fan-out/Fan-in（扇出/扇入）

**适用场景**：并行独立的任务，最后合并结果

```
         ┌→ [专家A] ─┐
[分发] → ├→ [专家B] ─┼→ [合并]
         └→ [专家C] ─┘
```

**Hermes 应用**：
- 多个 Researcher 并行研究不同方向
- 各自独立收集证据
- 最后由 Writer 合并研究成果

**优点**：
- 并行执行，速度快
- 多角度覆盖，更全面
- 适合深度研究场景

**缺点**：
- 合并阶段复杂度高
- 需要处理信息冲突

## 3. Expert Pool（专家池）

**适用场景**：根据输入类型动态选择合适的专家

```
[路由器] → { 专家A | 专家B | 专家C }
```

**Hermes 应用**：
- Coordinator 作为路由器
- 根据任务类型选择 Researcher/Writer/Editor
- 按需调用，不固定流程

**优点**：
- 灵活，按需调用
- 资源利用率高
- 适合多样化任务

**缺点**：
- 路由决策复杂
- 缺乏固定流程

## 4. Producer-Reviewer（生成-审核）

**适用场景**：生成内容后需要质量审核

```
[生成] → [审核] → (问题) → [生成] 重新执行
```

**Hermes 应用**：
- Writer 生成内容
- Editor 审核质量
- 发现问题则返回 Writer 修改
- 最多 3 轮迭代

**优点**：
- 质量有保障
- 明确的反馈循环
- 适合内容生产场景

**缺点**：
- 可能多次迭代
- 需要明确的审核标准

## 5. Supervisor（监督者）

**适用场景**：中央代理动态分配任务给工作代理

```
         ┌→ [工作者A]
[监督者] ─┼→ [工作者B]    ← 监督者根据状态动态分配
         └→ [工作者C]
```

**Hermes 应用**：
- Coordinator 作为监督者
- 动态分配任务给 Researcher/Writer
- 根据进度调整资源分配

**优点**：
- 动态调度，适应性强
- 可以处理优先级变化
- 适合大型复杂项目

**缺点**：
- 监督者可能成为瓶颈
- 调度逻辑复杂

## 6. Hierarchical Delegation（分层委托）

**适用场景**：复杂问题递归分解，上层委托给下层

```
[总控] → [团队负责人A] → [执行者A1]
                    → [执行者A2]
       → [团队负责人B] → [执行者B1]
```

**Hermes 应用**：
- 大型项目中，Coordinator 委托给子 Coordinator
- 子 Coordinator 管理各自的 Researcher/Writer/Editor
- 分层管理，降低复杂度

**优点**：
- 可以处理超大规模任务
- 分层管理，职责清晰
- 适合组织化协作

**缺点**：
- 层级过多会导致延迟
- 信息传递可能失真

## 复合模式

实际应用中，经常组合使用多种模式：

### Fan-out + Producer-Reviewer
```
多个 Researcher 并行研究 → Writer 生成 → Editor 审核
```

### Pipeline + Fan-out
```
分析（串行）→ 实现（并行）→ 集成测试（串行）
```

### Supervisor + Expert Pool
```
监督者分析任务 → 动态调用合适的专家
```

## Hermes 推荐配置

| 场景 | 推荐模式 | 执行模式 |
|------|---------|---------|
| 深度研究 | Fan-out/Fan-in | Agent Teams |
| 内容生产 | Producer-Reviewer | Agent Teams |
| 快速回答 | Expert Pool | Sub-agents |
| 复杂项目 | Supervisor + Hierarchical | 混合模式 |
| 标准流程 | Pipeline | Sub-agents |

## 模式选择决策树

```
任务是否可并行分解？
├── 是 → 需要实时协作吗？
│       ├── 是 → Fan-out/Fan-in (Agent Teams)
│       └── 否 → Fan-out/Fan-in (Sub-agents)
│
└── 否 → 需要多轮迭代吗？
        ├── 是 → Producer-Reviewer
        └── 否 → 任务复杂度？
                ├── 高 → Supervisor
                └── 低 → Pipeline/Expert Pool
```
