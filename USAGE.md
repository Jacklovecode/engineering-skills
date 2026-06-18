# 使用

## 入口

日常使用从 `start` 开始。

```text
请使用 engineering-skills 的 start 判断这次任务应该走哪条路径。
```

`start` 只负责路由，不负责实现、诊断或审查。

## 常见路径

小修改：

```text
start
  -> 需求不清时进入 clarify
  -> tdd
  -> 失败、异常或无法解释时进入 diagnose
  -> review
  -> finish
```

问题诊断：

```text
start -> diagnose -> tdd -> review -> finish
```

新功能：

```text
start -> clarify -> grill -> plan -> execute -> finish
```

复杂架构：

```text
start -> zoom-out -> deepen -> clarify -> grill -> plan -> execute -> finish
```

技能创建或修改：

```text
start -> skill-edit -> finish
```

提交或推送：

```text
start -> git
```

## 示例请求

实现功能：

```text
使用 start 帮我判断路径，并实现“用户可以重置密码”这个功能。
```

诊断问题：

```text
使用 diagnose 诊断这个测试为什么偶发失败，不要直接猜修。
```

审查改动：

```text
使用 review 检查当前改动是否满足需求，以及工程质量是否可靠。
```

架构改进：

```text
使用 zoom-out 和 deepen 看看这个模块是否有值得重构的结构性摩擦。
```

完成前验收：

```text
使用 finish 做最终验收，确认结果是不是我需要的，产物是不是正确的。
```

## 使用原则

- 明显匹配技能时，先读取对应 `SKILL.md`。
- 不确定时，先用 `start` 选择路径。
- 需求不清时，不要直接实现，进入 `clarify`。
- 计划不清时，不要直接执行，进入 `grill` 或 `plan`。
- 验证失败或结果无法解释时，进入 `diagnose`。
- 准备声明完成前，必须进入 `finish`。
- 准备提交、推送、合并、创建 PR 或清理分支前，必须进入 `git`。

## 辅助脚本

这些脚本用于收集状态或做结构检查，不替代技能判断：

```text
scripts/validate.ps1
scripts/validate.sh
scripts/simulate-pressure.ps1
scripts/simulate-pressure.sh
skills/git/scripts/preflight.ps1
skills/git/scripts/preflight.sh
skills/skill-edit/scripts/check.ps1
skills/skill-edit/scripts/check.sh
skills/review/scripts/collect-context.ps1
skills/review/scripts/collect-context.sh
skills/finish/scripts/collect-evidence.ps1
skills/finish/scripts/collect-evidence.sh
```

脚本不会自动提交或推送。涉及上传到 GitHub 时，仍然必须使用 `git` 技能列出上传清单并等待用户确认。
