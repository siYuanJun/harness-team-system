# 路由规则

## 路由决策树

```
用户任务
    │
    ▼
需要收集新信息？
├── 是 → Researcher
│       │
│       ▼
│   信息充足？
│   ├── 是 → Writer
│   └── 否 → Researcher 补充
│
└── 否 → 直接 Writer 或 Coordinator 处理
```

## 路由矩阵

| 任务特征 | 路由 | 说明 |
|---------|------|------|
| 需要事实数据 | Researcher → Writer | 先研究后写作 |
| 需要多源验证 | Researcher（并行）→ Writer | 多 Researcher 并行研究 |
| 需要质量审计 | Writer → Editor | 先写作后审计 |
| 需要完整流程 | Researcher → Writer → Editor | 全流程 |
| 简单整理 | Coordinator 直接处理 | 无需其他角色 |
| 需要人类决策 | → Human | 关键节点 |

## 并行路由

当任务可以并行时，使用多个 Researcher：

```
Coordinator
    │
    ├──→ Researcher 1: 方向A
    ├──→ Researcher 2: 方向B
    └──→ Researcher 3: 方向C
              │
              ▼
         Writer（汇总）
              │
              ▼
         Editor（审计）
```

## 召回路由

当 Writer 发现数据不足时：

```
Writer → Coordinator → Researcher（补充）→ Writer
```

## 修改路由

当 Editor 发现问题时：

```
Editor → Coordinator → Writer（修改）→ Editor
```

最多 3 轮修改循环。
