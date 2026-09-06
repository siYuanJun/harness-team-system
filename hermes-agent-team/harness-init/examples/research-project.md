# 研究项目部署示例

本示例演示如何使用 Harness 将 Hermes 部署到一个研究项目。

## 场景

**项目名称**：AI Agent 研究项目
**项目类型**：深度研究
**核心需求**：
- 多源信息收集
- 交叉验证事实
- 生成研究报告

## 域分析（Phase 1）

```markdown
## 域分析报告

### 项目信息
- 项目名称: AI Agent 研究项目
- 项目类型: 研究项目
- 技术栈: 无（纯研究）

### 核心需求
1. 收集 AI Agent 协作模式的多源信息
2. 交叉验证关键事实
3. 生成深度研究报告

### 角色需求
| 角色 | 是否需要 | 定制需求 |
|------|---------|---------|
| Coordinator | ✅ | 标准编排者 |
| Researcher | ✅ | 增加学术来源优先级 |
| Writer | ✅ | 标准执行者 |
| Editor | ✅ | 加强事实核查 |
| Human | ✅ | 标准人类闸门 |
```

## 团队架构设计（Phase 2）

```markdown
## 团队架构设计

### 架构模式
- 模式: Fan-out/Fan-in（并行研究）
- 理由: 多源研究需要并行收集，然后合并

### 执行模式
- 模式: 混合模式
- 理由: 研究阶段并行，写作审计阶段协作

### 团队架构图
Coordinator
    ├──→ Researcher 1: 学术来源
    ├──→ Researcher 2: 行业来源
    ├──→ Researcher 3: 社区来源
    └──→ Researcher 4: 官方来源
              ↓
         Writer（合并研究）
              ↓
         Editor（审计）
              ↓
         Human（验收）
```

## Agent 定义生成（Phase 3）

部署命令：
```bash
bash hermes-agent-team/harness-init/deploy.sh /path/to/research-project
```

定制 Researcher 角色：
```markdown
# 定制 hermes-researcher.md

## 定制原则
1. 学术来源优先级最高（ArXiv、IEEE、Google Scholar）
2. 标注学术置信度（引用次数、发表年限）
3. 交叉验证至少 3 个独立来源
```

## Skill 生成（Phase 4）

定制研究技能：
```markdown
# 定制 hermes-researcher/SKILL.md

## 来源优先级
1. A级: 学术论文、官方文档
2. B级: 行业报告、权威媒体
3. C级: 社区讨论、技术博客
```

## 集成与编排（Phase 5）

CLAUDE.md 注册：
```markdown
## Hermes Agent Team
**触发词**：深度研究、AI Agent 研究、学术调研、行业分析
```

## 验证与测试（Phase 6）

测试用例：
```markdown
## 测试 1: 深度研究触发
输入: "启动hermes团队，深度研究AI Agent协作模式"
预期: 五角色协作流程启动

## 测试 2: 事实核查
输入: "帮我验证这个研究结论"
预期: Editor 独立搜索验证

## 测试 3: 非触发场景
输入: "帮我把这段文字翻译成英文"
预期: 不触发 Hermes
```

## 部署验证

```bash
# 验证结构
find .claude -type f | sort

# 验证 Agent
cat .claude/agents/hermes-researcher.md | head -20

# 验证注册
grep "Hermes" CLAUDE.md
```

## 项目数据流向

```
.ai-workflow/hermes/projects/ai-agent-research/
├── 01_coordinator_tasks.md      # Coordinator 任务拆解
├── 02_researcher_output.md      # Researcher 研究报告
├── 03_writer_draft.md           # Writer 产出草稿
├── 04_editor_audit.md           # Editor 审计报告
└── 05_human_decisions.md        # Human 决策记录
```

## 关键要点

1. **并行研究**：Fan-out/Fan-in 模式支持多个 Researcher 并行
2. **学术优先**：定制 Researcher 增加学术来源优先级
3. **独立验证**：Editor 独立核查，不依赖 Researcher
4. **流程分离**：Coordinator 管流程，Editor 管质量
