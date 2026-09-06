# 内容项目部署示例

本示例演示如何使用 Harness 将 Hermes 部署到一个内容生产项目。

## 场景

**项目名称**：技术博客内容生产
**项目类型**：内容项目
**核心需求**：
- 基于可靠数据写文章
- 质量审计
- 适合发布

## 域分析（Phase 1）

```markdown
## 域分析报告

### 项目信息
- 项目名称: 技术博客内容生产
- 项目类型: 内容项目
- 技术栈: Markdown 博客

### 核心需求
1. 基于可靠数据撰写技术文章
2. 确保事实准确、引用完整
3. 产出适合发布的内容

### 角色需求
| 角色 | 是否需要 | 定制需求 |
|------|---------|---------|
| Coordinator | ✅ | 标准编排者 |
| Researcher | ✅ | 增加技术来源优先级 |
| Writer | ✅ | 定制文章格式模板 |
| Editor | ✅ | 增加发布标准检查 |
| Human | ✅ | 标准人类闸门 |
```

## 团队架构设计（Phase 2）

```markdown
## 团队架构设计

### 架构模式
- 模式: Producer-Reviewer（生成-审核）
- 理由: 内容生产需要 Writer 生成 → Editor 审核

### 执行模式
- 模式: Agent Teams
- 理由: Writer 与 Editor 需要实时反馈

### 团队架构图
Coordinator
    ↓
Researcher（收集数据）
    ↓
Writer（生成文章）
    ↓
Editor（质量审计）
    ↕ （发现问题返回 Writer）
    ↓
Human（验收发布）
```

## Agent 定义生成（Phase 3）

部署命令：
```bash
bash hermes-agent-team/harness-init/deploy.sh /path/to/blog-project
```

定制 Writer 角色：
```markdown
# 定制 hermes-writer.md

## 定制原则
1. 文章格式符合技术博客模板
2. 引用完整标注来源
3. 适合发布标准
```

## Skill 生成（Phase 4）

定制写作技能：
```markdown
# 定制 hermes-writer/SKILL.md

## 文章模板
# {标题}

## 摘要
{概述}

## 正文
{内容}

## 参考来源
{引用列表}
```

## 集成与编排（Phase 5）

CLAUDE.md 注册：
```markdown
## Hermes Agent Team
**触发词**：写博客、内容生产、技术文章、内容创作
```

## 验证与测试（Phase 6）

测试用例：
```markdown
## 测试 1: 博客写作触发
输入: "启动hermes团队，帮我写一篇技术博客"
预期: 五角色协作流程启动

## 测试 2: 质量审计
输入: "审计这篇博客草稿"
预期: Editor 独立核查事实

## 测试 3: 非触发场景
输入: "帮我把这个 PDF 转成图片"
预期: 不触发 Hermes
```

## 部署验证

```bash
# 验证结构
find .claude -type f | sort

# 验证 Writer 定制
cat .claude/agents/hermes-writer.md | head -20

# 验证注册
grep "Hermes" CLAUDE.md
```

## 项目数据流向

```
.ai-workflow/hermes/projects/tech-blog/
├── 01_coordinator_tasks.md      # Coordinator 任务拆解
├── 02_researcher_output.md      # Researcher 研究报告
├── 03_writer_draft.md           # Writer 文章草稿
├── 04_editor_audit.md           # Editor 审计报告
└── 05_human_decisions.md        # Human 决策记录
```

## 关键要点

1. **生成-审核**：Producer-Reviewer 模式保障内容质量
2. **格式定制**：Writer 定制文章格式模板
3. **发布标准**：Editor 增加发布标准检查
4. **反馈循环**：Editor 发现问题返回 Writer 修改
