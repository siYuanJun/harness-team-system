# INSTALL.md — 给大模型的安装指令

> **本文件是给 AI Agent 读的**。当用户说"把这个 PRD 评审团队装到当前项目 / 安装 prd-review-team / 部署评审团队"时，请按本文档执行安装。不要让用户手动跑 bash。

## 你要做什么

把 `prd-review-team` 团队包安装到用户指定的目标项目，使该项目内的 Agent 能按"用 prd-review-team 评审这份 PRD：<路径>"触发评审流程。

## 第一步：确认目标项目

- 若用户在对话中给出了项目路径，使用该路径
- 若未给出，使用当前工作目录作为目标项目
- 若目标路径不存在或是文件而非目录，**停下来问用户**，不要猜测

## 第二步：判断目标工具

检查目标项目根目录，按下表判断需要安装到哪些工具：

| 检测条件 | 判定工具 |
|----------|----------|
| 存在 `.claude/` 目录 或 `CLAUDE.md` 文件 | Claude Code |
| 存在 `.codebuddy/` 目录 或 `CODEBUDDY.md` 文件 | CodeBuddy |
| 以上都不存在 | 千问办公助手 / Codex（通用模式） |

> 若用户明确指定了工具（如"只装 Claude Code"），以用户指定为准，忽略自动检测。

## 第三步：复制团队资产

**始终执行**（所有工具的单一事实来源）：

将本团队包目录下的以下内容复制到目标项目的 `.agents/prd-review-team/`：

```
.agents/prd-review-team/
├── agents/
│   ├── prd-pm-industry.md      # PM1 行业痛点官
│   ├── prd-pm-value.md         # PM2 价值守门人
│   ├── prd-pm-rationality.md   # PM3 理性卫士
│   └── prd-tech-lead.md        # 技术经理·最终裁决
└── skills/prd-review-orchestrator/
    ├── SKILL.md                # 六阶段编排流程
    ├── references/
    │   ├── debate-protocol.md  # 辩论协议
    │   └── consensus-rules.md  # 共识与裁决规则
    └── templates/
        ├── review-report.md    # 评审报告模板
        └── change-list.md      # 修改清单模板
```

若目标已存在该目录，先询问用户是否覆盖；用户同意后再删除重建。

## 第四步：按工具分发副本

### Claude Code（检测到 `.claude/` 或 `CLAUDE.md` 时执行）

- 将 `agents/` 下 4 个角色文件复制到 `<目标>/.claude/agents/`
- 将 `skills/prd-review-orchestrator/` 整个目录复制到 `<目标>/.claude/skills/prd-review-orchestrator/`

### CodeBuddy（检测到 `.codebuddy/` 或 `CODEBUDDY.md` 时执行）

- 将 `agents/` 下 4 个角色文件复制到 `<目标>/.codebuddy/agents/`

### 千问办公助手 / Codex（通用模式）

无需额外分发，`.agents/prd-review-team/` 即为规范位置。

## 第五步：注册指令段

在目标项目的指令文件中追加以下注册段。**若文件中已存在 `<!-- prd-review-team:begin -->` 标记，则替换整个标记块（从 begin 到 end），不要重复追加。**

### AGENTS.md（始终写入）

```markdown
<!-- prd-review-team:begin -->
## PRD Review Team（prd-review-team v1.2）

本项目已安装 PRD 评审团队：3 名产品经理（行业痛点官 / 价值守门人 / 理性卫士）+ 1 名技术经理（最终裁决）。

- 团队资产（角色定义 + 编排流程）：`.agents/prd-review-team/`
- 编排流程：`.agents/prd-review-team/skills/prd-review-orchestrator/SKILL.md`

**使用方式**：对 Agent 说"用 prd-review-team 评审这份 PRD：<路径>"。
流程：三名 PM 并行独立评审 → 两轮圆桌辩论 → 共识汇总 → 技术经理按成本/可行性/复杂度拍板 → 产出评审报告、P0/P1/P2 修改清单与全程对话日志（输出目录 `.prd-reviews/`）。

**铁律**：评审不改 PRD 原文；技术经理可否决但必须附替代方案；辩论固定 2 轮；评审全程对话日志留痕（谁说了什么/确定了什么/理解了什么/定性了什么），先记录后流转。
<!-- prd-review-team:end -->
```

### CLAUDE.md（仅 Claude Code 模式写入）

同上注册段内容。

### CODEBUDDY.md（仅 CodeBuddy 模式写入）

同上注册段内容。

## 第六步：向用户确认

安装完成后，向用户报告：

1. 安装了哪些工具（列出实际执行的步骤）
2. 团队资产位置：`<目标>/.agents/prd-review-team/`
3. 使用方式：**"用 prd-review-team 评审这份 PRD：<路径>"**
4. 产出位置：`<目标>/.prd-reviews/{日期}-{文档名}/`

## 兜底：bash 脚本

若用户明确要求跑脚本、或当前环境无法由 Agent 直接写文件，可执行：

```bash
bash <团队包路径>/harness-init/install.sh <目标项目路径> [--tools auto|all|claude,codebuddy,...] [--force]
```

脚本行为与本文件描述的步骤完全一致。

## 禁止事项

- ❌ 不要修改 PRD 原文或项目已有代码
- ❌ 不要在未确认目标路径的情况下猜测安装位置
- ❌ 不要跳过注册段写入——没有注册段，Agent 不知道团队存在
- ❌ 不要在已有标记块的情况下重复追加——必须替换
