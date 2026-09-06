# Git Worktree 并行开发模式

> 大任务拆成小任务，通过 git worktree 实现多窗口/多 Agent 并行开发。扩展团队标配。

## 核心概念

**git worktree**：允许一个 git 仓库同时检出多个分支到不同目录，每个目录是独立的工作区，可以并行开发。

```
main-repo/               # 主工作区（orchestrator 用）
├── .git
├── src/
└── ...

../worktree-task-a/      # 任务 A 的工作区（分支 feature/a）
../worktree-task-b/      # 任务 B 的工作区（分支 feature/b）
../worktree-task-c/      # 任务 C 的工作区（分支 feature/c）
```

## 标准流程

### 1. 任务拆分（orchestrator）

大任务拆成小任务，每个小任务：
- 有明确的目标和验收标准
- 有明确的产出文件
- 有负责人（Agent 或人）

### 2. 依赖分析（orchestrator）

判断任务间是否有依赖：
- **无依赖**：可以进 worktree 并行
- **有依赖**：串行执行，等前置任务完成

依赖判断标准：
- 是否修改同一文件的同一区域？→ 有依赖
- B 是否需要 A 的产出作为输入？→ 有依赖
- 是否共享同一配置/接口定义？→ 可能有依赖，需协调

### 3. 创建 Worktree（engineer / merge-engineer）

```bash
# 为任务 A 创建 worktree
git worktree add ../worktree-task-a -b feature/task-a

# 为任务 B 创建 worktree
git worktree add ../worktree-task-b -b feature/task-b
```

每个 worktree 是独立目录，Agent 可以在不同窗口/会话中并行开发。

### 4. 并行开发（各 Agent）

每个 Agent 在自己的 worktree 里：
- 开发
- 自测
- 提交（conventional commits）

### 5. 自测（acceptor / 各 Agent）

每个任务完成后：
- 跑测试
- 检查代码规范
- 确认产出符合验收标准
- 不通过 → 修复，不进入合并

### 6. 合并（merge-engineer）

```bash
# 切换到主工作区
cd main-repo
git checkout main

# 合并任务 A
git merge feature/task-a

# 合并任务 B
git merge feature/task-b
```

**冲突处理边界**：
- 简单冲突（不同文件、不同区域）：merge-engineer 自动解决
- 复杂冲突（同一文件同一区域）：**停止，上报 orchestrator**，由相关任务负责人协调
- 不允许硬合、不允许 `--force` 覆盖

### 7. 清理（merge-engineer）

合并完成后：
```bash
# 删除 worktree
git worktree remove ../worktree-task-a
git worktree remove ../worktree-task-b

# 删除已合并的分支
git branch -d feature/task-a
git branch -d feature/task-b
```

### 8. 集成验收（acceptor）

所有分支合并后：
- 跑全量测试
- 检查集成后功能正常
- 出具集成验收报告

## 分支命名规范

```
feature/{任务编号}-{简短描述}
如：feature/M3-M0-llm-connect
    feature/M4-M1-agent-deploy
```

## Worktree 数量建议

- 并行任务数 ≤ CPU 核心数（避免资源争抢）
- 建议 3-6 个并行 worktree
- 太多会导致合并冲突概率上升和管理混乱

## 角色分工

| 角色 | Worktree 中的职责 |
|------|------------------|
| orchestrator | 任务拆分、依赖分析、分派、监控 |
| engineer | 创建 worktree、环境配置 |
| 各执行 Agent | 在自己的 worktree 里开发、自测、提交 |
| acceptor | 每个任务的自测验收 + 最终集成验收 |
| merge-engineer | 合并分支、处理简单冲突、清理 worktree |

## 反模式

| 反模式 | 问题 | 正确做法 |
|--------|------|----------|
| 有依赖的任务强行并行 | 合并冲突、返工 | 依赖分析，有依赖的串行 |
| 不自测就合并 | 集成后 bug 满天飞 | 每个任务自测通过才合并 |
| merge-engineer 硬合复杂冲突 | 引入隐蔽 bug | 复杂冲突上报，不硬合 |
| worktree 不清理 | 磁盘占用、分支混乱 | 合并后立即清理 |
| 并行任务太多 | 管理混乱、冲突多 | 控制在 3-6 个 |
| 没有集成验收 | 合并后整体功能异常 | 全量合并后跑集成验收 |
