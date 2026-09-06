---
name: prd-review-team
description: "PRD 评审团队 v1.2 —— 3 名产品经理 + 1 名技术经理的四角色评审框架，支持安装到千问办公助手、OpenAI Codex、Claude Code、腾讯 CodeBuddy。对产品需求文档（PRD）做多视角评审：PM1 审行业痛点真实性、PM2 审功能价值、PM3 审合理性与夸大性，三人圆桌辩论形成共识后，由技术经理从成本/可行性/复杂度维度最终拍板，产出评审报告、PRD 修改清单（P0/P1/P2）与全程对话日志（谁说了什么/确定了什么/理解了什么/定性了什么）。触发词：PRD评审、评审PRD、需求文档评审、启动prd-review团队。"
---

# PRD Review Team v1.2

四角色 PRD 评审团队：**3 名产品经理并行独立评审 → 圆桌辩论 → 共识汇总 → 技术经理最终拍板**。
支持安装到千问办公助手、OpenAI Codex、Claude Code、腾讯 CodeBuddy。

## 架构铁律

1. **三名 PM 只做产品判断**，互不越界（痛点 / 价值 / 合理性各管一摊）
2. **技术经理只审共识**，不重新评审 PRD 全文，避免角色越位
3. **否决必须附替代方案**——只拆不建禁止
4. **评审不改原文**——只产出评审意见和修改清单，改不改由作者决定

## 角色一览

| 角色 | 定义文件 | 一句话职责 | 不做 |
|------|----------|-----------|------|
| PM1 · 行业痛点官 | `agents/prd-pm-industry.md` | 痛点真实性、行业痛点对照（含数据治理）、竞品对照 | 不判价值大小、不评实现 |
| PM2 · 价值守门人 | `agents/prd-pm-value.md` | 价值三问、ROI 推演、识别自嗨型功能 | 不质疑痛点真伪 |
| PM3 · 理性卫士 | `agents/prd-pm-rationality.md` | 逻辑自洽、夸大探测、边界完整性 | 不判痛点、不判价值 |
| 技术经理 · 最终裁决人 | `agents/prd-tech-lead.md` | 按成本/可行性/复杂度审视共识并拍板 | 不重审 PRD 全文 |

## 工作流（六阶段）

```
Phase 0  准备：读 PRD 全文、建输出目录、初始化对话日志
Phase 1  独立评审：3 名 PM 并行（互不可见，避免锚定）
Phase 2  圆桌辩论：2 轮（轮1交叉质疑 → 轮2收敛表态）
Phase 3  共识汇总：一致通过 / 有保留同意 / 分歧保留
Phase 4  技术经理裁决：同意 / 同意但修改 / 降级 / 否决（必附替代方案）
Phase 5  产出交付：评审报告 + PRD 修改清单（P0/P1/P2）+ 对话日志
```

**对话日志**：每个阶段结束后，编排者按 `references/dialogue-log-protocol.md` 追加记录——谁说了什么（🗣️）、确定了什么（✅）、理解了什么（🧠）、定性了什么（🏷️），先记录后流转。

详细编排协议见 `skills/prd-review-orchestrator/SKILL.md`。

## 快速开始

**首选**：把 `prd-review-team/` 目录发给 Agent，说"把这个 PRD 评审团队装到当前项目"。Agent 读 `INSTALL.md` 自动完成安装。

**兜底**（CI / 无 Agent 环境）：

```bash
# auto：按项目已有配置自动判断工具
bash harness-init/install.sh /path/to/your/project
# 指定工具：qianwen / codex / claude / codebuddy / all
bash harness-init/install.sh /path/to/your/project --tools all
```

然后对 Agent 说：**"用 prd-review-team 评审这份 PRD：<路径>"**

产出位于项目内 `.prd-reviews/{日期}-{文档名}/`：
- `08-review-report.md` — 评审报告
- `09-prd-change-list.md` — PRD 修改清单（P0 必改 / P1 建议改 / P2 可选）
- `10-dialogue-log.md` — 对话日志（谁说了什么 / 确定了什么 / 理解了什么 / 定性了什么）

## 目录结构

```
prd-review-team/
├── SKILL.md                          # 本文件（团队入口）
├── README.md                         # 使用说明
├── agents/                           # 4 个角色定义
│   ├── prd-pm-industry.md
│   ├── prd-pm-value.md
│   ├── prd-pm-rationality.md
│   └── prd-tech-lead.md
├── skills/prd-review-orchestrator/   # 编排技能
│   ├── SKILL.md                      # 六阶段编排协议
│   ├── references/
│   │   ├── debate-protocol.md        # 辩论协议
│   │   ├── consensus-rules.md        # 共识分类与裁决规则
│   │   └── dialogue-log-protocol.md  # 对话日志协议（全程留痕）
│   └── templates/
│       ├── review-report.md          # 评审报告模板
│       └── change-list.md            # 修改清单模板
├── INSTALL.md                        # 给大模型读的安装指令（首选安装方式）
└── harness-init/
    └── install.sh                    # 一键安装脚本（兜底）
```
