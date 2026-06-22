---
name: setup
description: 当需要为项目建立或更新智能体协作上下文、领域文档位置、ADR 目录、issue tracker、标签体系、验证命令或技能运行约定时使用。
---

# Setup

## 设置检查点

当项目缺少智能体协作上下文，或现有技能不知道领域文档、ADR、issue tracker、验证命令、标签体系在哪里时，使用 `setup`。

`setup` 只建立项目约定，不实现业务功能，不替代 `zoom-out`、`deepen`、`review` 或 `git`。

## 目标

让后续技能知道：

- 项目如何描述领域语言。
- 架构决策记录在哪里。
- issue 或任务如何创建、标记和引用。
- 常用验证命令是什么。
- 哪些本地文件、报告或目录不应提交。
- 当前项目有哪些智能体协作入口和约束。

## 何时使用

- 首次在项目中使用本技能包。
- 项目没有 `CONTEXT.md`、`CONTEXT-MAP.md`、ADR 或同类约定。
- `grill`、`deepen`、`review` 多次需要询问文档位置。
- 需要接入 GitHub Issues、本地 markdown issue、PRD、ADR 或标签体系。
- 验证命令、发布命令或本地报告目录没有记录。
- 项目入口文件如 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 需要说明本技能包如何运行。

## 何时不使用

- 只是理解某个模块：进入 `zoom-out`。
- 只是评估架构摩擦：进入 `deepen`。
- 只是审查当前改动：进入 `review`。
- 只是提交、推送或设置 remote：进入 `git`。
- 只是创建或修改技能正文：进入 `skill-edit`。

## 流程

### 1. 读取现有约定

先只读检查：

- `AGENTS.md`、`CLAUDE.md`、`GEMINI.md`
- `CONTEXT.md`、`CONTEXT-MAP.md`
- `docs/adr/`、`docs/decisions/` 或项目已有 ADR 目录
- `README.md`、`CONTRIBUTING.md`
- `.github/ISSUE_TEMPLATE/`、`.github/PULL_REQUEST_TEMPLATE.md`
- 测试、构建、lint、验证脚本
- `.gitignore`

不要假设这些文件存在。缺少时标为“未发现”。

### 2. 固定项目约定

输出并在需要时建议记录：

- 领域文档位置：例如 `CONTEXT.md`、`CONTEXT-MAP.md`
- 决策记录位置：例如 `docs/adr/`
- issue tracker：GitHub Issues、本地 markdown，或暂不使用
- 标签体系：需求、缺陷、架构、诊断、文档、后续工作等项目已有标签
- 验证命令：结构校验、测试、lint、构建、压力场景
- 本地报告目录：例如 `.local/`
- 不应提交内容：缓存、报告、密钥、备份、构建产物

如果某项没有项目约定，不要擅自写成事实；给出推荐默认值并标注需要用户确认。

### 3. 更新协作入口

只有在用户同意或项目约定明显缺失时，才建议更新：

- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- README 或贡献指南

入口文件应说明：

- 使用 `skills/start/SKILL.md` 作为路由入口。
- 用户只描述目标，智能体负责路由。
- 领域文档、ADR、issue tracker 和验证命令的位置。
- 本地报告和敏感信息不要提交。

### 4. 完成检查

设置完成前必须确认：

- 新约定没有和已有文档冲突。
- 没有把临时偏好写成长期规范。
- 没有记录不存在的工具、目录或标签。
- 如果创建或修改文件，运行相关验证。

## 输出

必须输出：

- 已发现的项目约定。
- 缺失或需要用户确认的约定。
- 建议写入的位置和内容摘要。
- 已更新或建议更新的文件。
- 后续技能如何使用这些约定。
- 验证命令和结果，或无法验证的原因。

## 不要做

- 不要把 setup 变成功能实现计划。
- 不要为了整齐而强行创建 ADR 或领域文档。
- 不要覆盖用户已有约定。
- 不要把本地报告、临时文件或私有路径写入共享文档。
- 不要在未确认时提交或推送，涉及 Git 操作进入 `git`。

