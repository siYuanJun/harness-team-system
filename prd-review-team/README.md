# PRD Review Team v1.2

3 名产品经理 + 1 名技术经理的 PRD 评审团队。支持安装到 **千问办公助手、OpenAI Codex、Claude Code、腾讯 CodeBuddy**，对 PRD 文档进行多视角评审，产出评审报告和带优先级的修改清单。

## 团队构成

| 角色 | 视角 | 口头禅 |
|------|------|--------|
| PM1 · 行业痛点官 | 行业痛点真实性、数据治理核心痛点、竞品对照 | "这痛点是谁的痛？证据呢？" |
| PM2 · 价值守门人 | 功能价值三问、ROI 推演、自嗨功能识别 | "说不清价值的功能，没资格进开发队列" |
| PM3 · 理性卫士 | 逻辑自洽、夸大探测、边界完整性 | "听起来很美，但经得起追问吗？" |
| 技术经理 · 最终裁决 | 成本消耗、技术可行性、实现复杂度 | "否决必须带替代方案" |

## 评审流程

```
PRD 文档
   ↓
① 三名 PM 独立评审（并行，互不可见）
   ↓
② 圆桌辩论（轮1交叉质疑 → 轮2收敛表态，固定2轮）
   ↓
③ 共识汇总（一致通过 / 有保留同意 / 分歧保留）
   ↓
④ 技术经理裁决（同意 / 同意但修改 / 降级 / 否决+替代方案）
   ↓
⑤ 交付：评审报告 + PRD 修改清单（P0必改 / P1建议改 / P2可选）
```

**对话日志**：评审全程留痕——谁说了什么、确定了什么、理解了什么、定性了什么，逐阶段追加到 `10-dialogue-log.md`，可完整还原决策链。

## 安装

### 首选：扔给大模型

把整个 `prd-review-team/` 目录发给 Agent，说一句：

> **把这个 PRD 评审团队装到当前项目**

Agent 会读 `INSTALL.md` 自动完成全部安装（检测工具、复制资产、注册指令段）。无需手动跑命令。

### 兜底：bash 脚本

CI 流水线或无 Agent 环境可用脚本：

```bash
bash harness-init/install.sh /path/to/project                      # auto：按项目已有配置自动判断
bash harness-init/install.sh /path/to/project --tools all          # 四个工具全装
bash harness-init/install.sh /path/to/project --tools claude,codex # 指定工具
bash harness-init/install.sh /path/to/project --force              # 覆盖重装
```

### 各工具安装内容

| 工具 | 安装位置 | 指令注册 |
|------|----------|----------|
| 千问办公助手 / Codex（通用） | `.agents/prd-review-team/`（规范目录，始终安装） | `AGENTS.md`（始终写入） |
| Claude Code | `.claude/agents/`（4 角色）+ `.claude/skills/prd-review-orchestrator/` | `CLAUDE.md` |
| CodeBuddy | `.codebuddy/agents/`（4 角色） | `CODEBUDDY.md` |

- `auto` 模式：始终装规范目录 + AGENTS.md；若项目已有 `.claude/`/`CLAUDE.md` 则追加 Claude Code 集成，`.codebuddy/`/`CODEBUDDY.md` 同理
- 指令注册幂等：重装时标记块（`<!-- prd-review-team:begin/end -->`）原地替换，不重复追加
- 团队资产单一事实来源：`.agents/prd-review-team/`，各工具目录为分发副本

## 使用

对 Agent 说：

> 用 prd-review-team 评审这份 PRD：docs/prd-xxx.md

产出位于 `.prd-reviews/{日期}-{文档名}/`：

| 文件 | 内容 |
|------|------|
| `08-review-report.md` | 评审报告（总评 + 三方意见 + 辩论纪要 + 裁决摘要） |
| `09-prd-change-list.md` | PRD 修改清单（P0/P1/P2，逐条：位置+问题+改法+提出人） |
| `10-dialogue-log.md` | 对话日志（谁说了什么/确定了什么/理解了什么/定性了什么，追加式留痕） |
| `01`~`07` | 过程文件（独立评审、辩论记录、共识、裁决明细） |

## 设计铁律

1. **三名 PM 独立评审互不可见**——防止锚定效应
2. **技术经理只审共识不重审全文**——防止角色越位
3. **否决必须附替代方案**——只拆不建禁止
4. **评审不改原文**——只出意见和清单，改不改由作者决定
5. **辩论 2 轮封顶**——收不了的分歧转技术经理仲裁
