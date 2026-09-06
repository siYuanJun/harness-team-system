# 初始化检查清单

## Phase 1: 域分析

- [ ] 项目类型已识别
- [ ] 核心需求已分析
- [ ] 角色需求已确定
- [ ] 执行模式已选择
- [ ] 项目规模已评估

## Phase 2: 团队架构设计

- [ ] 架构模式已选择
- [ ] 执行模式已确定
- [ ] 团队架构图已绘制
- [ ] 角色职责已定义

## Phase 3: Agent 定义生成

- [ ] Agent 文件已复制到 `.claude/agents/`
- [ ] 角色定义已根据项目定制
- [ ] 职责边界已明确
- [ ] 协作协议已定义
- [ ] 所有 Agent 使用 `model: "opus"`

## Phase 4: Skill 生成

- [ ] Skill 文件已复制到 `.claude/skills/`
- [ ] 工作流程已根据项目定制
- [ ] references 文件已生成
- [ ] 触发词已配置

## Phase 5: 集成与编排

- [ ] hermes-orchestrator 技能已生成
- [ ] 路由规则已定义
- [ ] 交接协议已配置
- [ ] 错误处理已定义
- [ ] CLAUDE.md 已注册 Hermes 触发规则

## Phase 6: 验证与测试

### 结构验证
- [ ] 所有 Agent 文件在正确位置
- [ ] 所有 Skill 文件格式正确
- [ ] Agent 间引用一致
- [ ] 无命令生成（只在 `.claude/commands/`）

### 执行模式验证
- [ ] Agent Teams: 通信路径、任务依赖、团队大小已验证
- [ ] Sub-agents: 输入输出连接、返回逻辑已验证
- [ ] 混合模式: 各阶段模式明确、数据传递完整

### 触发测试
- [ ] Should-trigger 查询测试通过（8-10个）
- [ ] Should-NOT-trigger 查询测试通过（8-10个）
- [ ] 与现有 Skill 无冲突

### 干运行测试
- [ ] 工作流程逻辑正确
- [ ] 数据传递路径完整
- [ ] 所有 Agent 输入匹配前一阶段输出
- [ ] 错误场景有回退路径

## 最终检查

- [ ] `.claude/agents/` — Agent 定义文件已生成
- [ ] `.claude/skills/` — Skill 文件已生成
- [ ] 编排技能已生成（包含数据流 + 错误处理 + 测试场景）
- [ ] 执行模式已明确
- [ ] 所有 Agent 调用使用 `model: "opus"`
- [ ] 新 Agent 已检查重复
- [ ] 新 Skill 已检查重复
- [ ] `.claude/commands/` — 未生成任何内容
- [ ] 与现有 Agent/Skill 无冲突
- [ ] Skill description 已积极编写（包含后续工作关键词）
- [ ] SKILL.md 正文在 500 行以内
- [ ] 测试提示已执行验证（2-3个）
- [ ] 触发验证已完成
- [ ] CLAUDE.md 已注册 Harness 指针
- [ ] CLAUDE.md 变更历史已记录

## 常见问题排查

### 问题 1: Skill 不触发

**检查项**：
- [ ] description 是否包含具体触发场景
- [ ] 触发词是否在 description 中明确列出
- [ ] 是否与现有 Skill 冲突

**解决方案**：
- 修改 description，使其更"pushy"
- 添加更多触发关键词
- 调整触发边界

### 问题 2: Agent 间通信失败

**检查项**：
- [ ] 通信协议是否明确
- [ ] 文件路径是否正确
- [ ] 消息格式是否一致

**解决方案**：
- 明确通信协议
- 使用绝对路径
- 标准化消息格式

### 问题 3: 数据传递丢失

**检查项**：
- [ ] 文件是否已生成
- [ ] 路径是否正确
- [ ] 是否有读取权限

**解决方案**：
- 检查文件生成逻辑
- 验证路径配置
- 确认权限设置

### 问题 4: 质量审计不独立

**检查项**：
- [ ] Editor 是否使用 Researcher 的数据
- [ ] 是否独立搜索验证
- [ ] 验证过程是否记录

**解决方案**：
- 强调 Editor 独立性
- 要求独立搜索
- 记录验证过程

## 初始化完成报告模板

```markdown
# Hermes 初始化完成报告

## 项目信息
- 项目名称: {名称}
- 初始化日期: {日期}
- Harness 版本: v3.0

## 配置摘要
- 架构模式: {模式}
- 执行模式: {模式}
- Agent 数量: {数量}
- Skill 数量: {数量}

## 生成的文件
### Agents
- [ ] hermes-coordinator.md
- [ ] hermes-researcher.md
- [ ] hermes-writer.md
- [ ] hermes-editor.md
- [ ] hermes-human-protocol.md

### Skills
- [ ] hermes-orchestrator/
- [ ] hermes-researcher/
- [ ] hermes-writer/
- [ ] hermes-editor/
- [ ] hermes-harness-init/

### 配置
- [ ] CLAUDE.md 已更新
- [ ] .ai-workflow/ 目录已创建

## 验证结果
- [ ] 结构验证通过
- [ ] 触发测试通过
- [ ] 干运行测试通过

## 下一步
1. 执行测试任务
2. 收集反馈
3. 根据反馈调整配置
```
