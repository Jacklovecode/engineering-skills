# 安装

`engineering-skills` 是一个多平台智能体技能包。核心文件在 `skills/`，平台入口在根目录和 `hooks/`。

## 推荐安装

1. 克隆或下载本仓库。
2. 使用安装脚本复制技能包和平台入口。
3. 运行验证脚本，确认文件结构正常。

Windows:

```powershell
.\scripts\install.ps1
```

macOS / Linux:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

默认目标目录：

```text
Windows: $HOME\.engineering-skills
macOS / Linux: $HOME/.engineering-skills
```

安装脚本不会执行 git 操作。

## 手动安装

如果不使用安装脚本：

1. 将 `skills/` 放到智能体运行时能发现的位置，或让运行时读取本仓库根目录。
2. 根据平台选择入口文件：`AGENTS.md`、`CLAUDE.md`、`GEMINI.md` 或 `.codex-plugin/plugin.json`。
3. 让平台入口先加载 `skills/start/SKILL.md`。

## 安装后验证

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

macOS / Linux:

```bash
chmod +x scripts/validate.sh hooks/run-hook.sh hooks/session-start-codex.sh
./scripts/validate.sh
```

## Codex

Codex 插件入口在 `.codex-plugin/plugin.json`。

默认 hook 文件是 `hooks/hooks-codex.json`，适合 Windows 环境，调用：

```text
hooks/run-hook.cmd
```

macOS / Linux 可参考：

```text
hooks/hooks-codex.unix.json
hooks/run-hook.sh
hooks/session-start-codex.sh
```

如果你的 Codex 插件系统允许选择 hook 配置，将 Unix 配置指向 `hooks/hooks-codex.unix.json`。如果不允许，保留默认配置，并在运行时上下文中引用 `AGENTS.md`。

## Claude Code

Claude Code 可优先读取：

```text
CLAUDE.md
```

该文件会把 `skills/start/SKILL.md` 作为入口。其他技能只在任务明确匹配时再读取。

## Gemini CLI

Gemini CLI 可读取：

```text
GEMINI.md
gemini-extension.json
```

`GEMINI.md` 会把 `skills/start/SKILL.md` 作为入口。

## GitHub Copilot CLI 或其他智能体

优先读取：

```text
AGENTS.md
```

如果平台支持技能目录，指向 `skills/`。如果不支持，至少把 `skills/start/SKILL.md` 放入上下文，并按它的路由读取其他技能。

## 安装后检查

确认以下结果：

- 能看到 15 个技能目录。
- 每个技能都有 `SKILL.md`。
- 每个 `SKILL.md` 都有 `name` 和 `description`。
- `description` 为中文触发条件。
- JSON 清单文件可解析。
- 没有旧术语或旧命名残留。

## 脚本权限

macOS / Linux 首次使用前，建议执行：

```bash
chmod +x scripts/*.sh hooks/*.sh skills/*/scripts/*.sh
```
