# Engineering Skills

面向真实工程项目的多平台智能体技能包，适用于项目功能新增、旧功能问题排查、项目架构审查和技能文档维护。

本项目融合两类能力：

- [obra/superpowers](https://github.com/obra/superpowers) 风格的流程纪律：先澄清，再计划；先失败测试，再实现；先审查验证，再完成。
- [mattpocock/skills](https://github.com/mattpocock/skills) 风格的工程深度：领域语言、任务分层、行为测试、反馈循环、根因诊断。

目标不是让智能体接管所有判断，而是让它在关键节点少犯错。

## 致敬

本项目的设计参考了 [obra/superpowers](https://github.com/obra/superpowers) 和 [mattpocock/skills](https://github.com/mattpocock/skills) 的优秀实践：前者启发了流程纪律和技能门禁，后者启发了工程任务设计和诊断审查方法。本仓库的技能文本和组织方式为重新编写，面向中文工程使用场景和多平台发布进行整合。

## 核心技能

| 技能 | 作用 |
| --- | --- |
| `start` | 入口路由。任务明显匹配某个技能时，先启用该技能。 |
| `zoom-out` | 上升一层理解代码位置、模块关系、数据流和影响范围。 |
| `deepen` | 寻找架构深化机会，降低耦合，改善模块深度和可测试性。 |
| `clarify` | 澄清需求、成功标准、边界、领域语言和必要决策。 |
| `grill` | 连续追问并压力测试想法、方案或计划，拆清边界和验收。 |
| `plan` | 把确认后的需求拆成按任务分层组织的实现计划。 |
| `execute` | 按确认计划逐项执行：TDD、验证、审查，失败则诊断。 |
| `tdd` | 行为优先 TDD：失败测试、最小实现、重构。 |
| `diagnose` | 问题诊断：反馈循环、复现、假设、验证、根因、回归。 |
| `review` | 双轴审查：需求符合度和工程质量。 |
| `finish` | 完成前验证、风险说明、PR/合并/清理决策。 |
| `skill-edit` | 创建或修改技能：先压力场景，再写技能，再验证。 |

## 工作模式

默认推荐“引导模式”：

- 明显匹配某个技能时，必须先启用对应技能。
- 不明显时，只做简短建议。
- 用户目标和边界优先，但不能要求智能体跳过验证、安全确认或完成证据。

本技能包是路由式流程，不是所有任务都必须走完整长链。`start` 负责判断任务类型，选择最短但足够可靠的技能路径。

所有完整路径最终都收束到 `finish` 的最终验收点：确认结果是不是用户真正需要的，确认代码、文档或技能产物是不是正确的，并给出验证证据和残余风险。

## 安装和使用

- 安装方式见 [INSTALL.md](INSTALL.md)。
- 日常用法和示例见 [USAGE.md](USAGE.md)。
- 发布前可运行 `scripts/validate.ps1` 或 `scripts/validate.sh` 做结构校验。

## 典型路径

小修改路径：

```text
start
  -> 需求不清时进入 clarify
  -> tdd
  -> 失败、异常或无法解释时进入 diagnose
  -> review
  -> finish
```

问题诊断路径：

```text
start -> diagnose -> tdd -> review -> finish
```

新功能路径：

```text
start -> clarify -> grill -> plan -> execute -> finish
```

复杂架构路径：

```text
start -> zoom-out -> deepen -> clarify -> grill -> plan -> execute -> finish
```

## 语言策略

- 技能名使用英文短名，便于跨平台调用。
- 技能主体使用中文，尤其约束、门禁和执行要求。
- frontmatter 元数据和清单文件使用英文，便于技能索引和平台识别。

## English Summary

Engineering Skills is a cross-runtime skill pack for coding agents. It provides a guided workflow for clarification, planning, behavior-first TDD, diagnosis, review, and completion. The core skill content is written in Chinese, while skill names and metadata stay short and English-friendly for platform compatibility.
