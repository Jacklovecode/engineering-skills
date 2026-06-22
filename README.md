# Engineering Skills

[English README](README_EN.md)

面向真实工程项目的多平台智能体技能包，适用于项目功能新增、旧功能问题排查、项目架构审查和技能文档维护。

本项目融合两类能力：

- [obra/superpowers](https://github.com/obra/superpowers) 风格的流程纪律：先澄清，再计划；先失败测试，再实现；先审查验证，再完成。
- [mattpocock/skills](https://github.com/mattpocock/skills) 风格的工程深度：领域语言、任务分层、行为测试、反馈循环、根因诊断。

目标不是让智能体接管所有判断，而是让它在关键节点少犯错。

## 致敬

本项目的设计参考了 [obra/superpowers](https://github.com/obra/superpowers) 和 [mattpocock/skills](https://github.com/mattpocock/skills) 的优秀实践：前者启发了流程纪律和技能检查点，后者启发了工程任务设计和诊断审查方法。本仓库的技能文本和组织方式为重新编写，面向中文工程使用场景和多平台发布进行整合。

本项目在开发过程中使用 OpenAI Codex 辅助完成设计、整理和验证。

## 核心技能

| 技能 | 作用 |
| --- | --- |
| `start` | 入口路由。任务明显匹配某个技能时，先启用该技能。 |
| `zoom-out` | 上升一层理解代码位置、模块关系、数据流和影响范围。 |
| `deepen` | 寻找架构改进机会，降低耦合，改善模块深度和可测试性。 |
| `brainstorm` | 目标已清楚但方向未定时，生成候选方案并比较取舍。 |
| `clarify` | 澄清需求、成功标准、边界、领域语言和必要决策。 |
| `grill` | 连续追问并压力测试想法、方案或计划，拆清边界和验收。 |
| `plan` | 把确认后的需求拆成按任务分层组织的实现计划。 |
| `execute` | 按确认计划逐项执行：TDD、验证、审查，失败则诊断。 |
| `tdd` | 行为优先 TDD：失败测试、最小实现、重构。 |
| `diagnose` | 问题诊断：反馈循环、复现、假设、验证、根因、回归。 |
| `review` | 双维度审查：需求符合度和工程质量。 |
| `finish` | 交付前收口：验证证据、风险说明、PR/合并/清理决策。 |
| `git` | 版本控制操作：提交、推送、合并、PR、远程仓库和清理风险控制。 |
| `skill-edit` | 创建或修改技能：先压力场景，再写技能，再验证。 |

## 工作模式

默认推荐“引导模式”：

- 用户只需要描述目标、范围和约束，不需要记住或手动选择技能链。
- `start` 负责根据用户意图选择技能路径，并用一句话说明路由判断。
- 明显匹配某个技能时，必须先启用对应技能。
- 不明显时，只做简短建议。
- 用户目标和边界优先，但不能要求智能体跳过验证、安全确认或完成证据。

本技能包是路由式流程，不是所有任务都必须走完整长链。`start` 负责判断任务类型，选择最短但足够可靠的技能路径。

常见边界：

- `zoom-out` 负责看懂系统和影响范围。
- `clarify` 负责弄清目标、边界和成功标准。
- `brainstorm` 负责在目标已清楚时比较多种方案。
- `grill` 负责压力测试已选方案。
- `deepen` 负责发现架构改进和重构机会。
- `review` 负责审查需求符合度和工程质量。
- `diagnose` 负责定位具体故障根因。

所有完整路径最终都收束到 `finish` 的交付前收口：确认结果是不是用户真正需要的，确认代码、文档或技能产物是不是正确的，并给出验证证据和残余风险。

## 安装和使用

- 安装方式见 [INSTALL.md](INSTALL.md)。
- 日常用法和示例见 [USAGE.md](USAGE.md)。
- 版本变更见 [CHANGELOG.md](CHANGELOG.md)。
- 贡献方式见 [CONTRIBUTING.md](CONTRIBUTING.md)。
- 发布前可运行 `scripts/validate.ps1` 或 `scripts/validate.sh` 做结构校验。

## 快速开始

Windows:

```powershell
git clone https://github.com/Jacklovecode/engineering-skills.git
cd engineering-skills
.\scripts\install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

macOS / Linux:

```bash
git clone https://github.com/Jacklovecode/engineering-skills.git
cd engineering-skills
chmod +x scripts/install.sh scripts/validate.sh scripts/simulate-pressure.sh
./scripts/install.sh
./scripts/validate.sh
./scripts/simulate-pressure.sh
```

安装脚本只复制技能包和平台入口，不执行 git 操作。

## 参与贡献

欢迎通过 Issue 和 Pull Request 参与改进本技能包，尤其是技能设计、中文表达、验证场景和多平台适配。

- 贡献方式和 PR 要求见 [CONTRIBUTING.md](CONTRIBUTING.md)。
- 社区沟通规则见 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。
- 安全问题反馈见 [SECURITY.md](SECURITY.md)。

提交 PR 前请运行结构校验和压力场景验证，并确认没有把本地报告、缓存、备份文件或敏感信息提交到仓库。

## 语言策略

- 技能名使用英文短名，便于跨平台调用。
- 技能主体使用中文，尤其约束、检查点和执行要求。
- frontmatter 元数据和清单文件使用英文，便于技能索引和平台识别。

## English Summary

Engineering Skills is a cross-runtime skill pack for coding agents. It provides a guided workflow for clarification, planning, behavior-first TDD, diagnosis, review, safe git operations, and completion. The core skill content is written in Chinese, while skill names and metadata stay short and English-friendly for platform compatibility.
