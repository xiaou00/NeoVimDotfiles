# Neovim 配置

基于 NvChad v2.5 和 lazy.nvim，保留 NvChad 的默认设置，再叠加个人配置。

## 修改入口

| 文件 | 内容 |
| --- | --- |
| `init.lua` | 启动顺序、额外文件类型、插件与主题初始化 |
| `lua/options.lua` | 缩进、换行、透明度、Neovide 字体与动画 |
| `lua/mappings.lua` | 快捷键；Leader 是空格 |
| `lua/abbreviations.lua` | C++、Typst 输入缩写与希腊字母，由 mappings.lua 加载 |
| `lua/autocmds.lua` | 自动保存、Markdown 引用续行、预览功能初始化 |
| `lua/plugins/init.lua` | 编辑、搜索、Copilot、截图、启动页、输入法 |
| `lua/plugins/languages.lua` | LSP、格式化、Treesitter、Lean、Sage、Flutter |
| `lua/plugins/writing.lua` | Markdown 渲染、VimTeX、Typst 预览 |
| `lua/plugins/coding.lua` | 文件运行、CompetiTest |
| `lua/plugins/ai.lua` | Codex CLI 浮动窗口与快捷键 |
| `lua/plugins/ui.lua` | 搜索、文件树、补全、Git 标记等界面外观 |
| `lua/plugins/snippets.lua` | mini.snippets、片段加载、补全展开与 Tab 跳转 |
| `lua/configs/ui.lua` | 底栏、标签栏、细线边框与诊断符号 |
| `lua/configs/ghost.lua` | 复用 fish 欢迎页的小幽灵，供 Alpha 与 NvDash 使用 |
| `lua/configs/` | LSP/格式化/解析器选项，以及 Typst、LaTeX、Markdown 的自定义功能 |
| `lua/chadrc.lua` | NvChad 基础主题与透明度 |
| `lua/theme_toggle.lua` | 系统/窗口主题同步、监听与刷新 |
| `lua/theme/highlights.lua` | 编辑器、语言、插件的高亮配色表 |
| `lua/theme/palette.lua` | Neovim 本地前景色；背景继续读取系统主题 |

lazy.nvim 自动导入 `lua/plugins/` 下的配置。添加插件时放到对应文件即可。
CompetiTest 和 Markdown 代码块省略了与当前插件默认值相同的设置；版本由
`lazy-lock.json` 记录，升级这两个插件时应检查默认值变化。

## 自定义功能

- 输入缩写集中在 `lua/abbreviations.lua`，输入后按空格等分隔符展开。希腊字母覆盖 24 个字母的大小写，如 `@a → alpha`、`@G → Gamma`；其中 `@h → eta`、`@q → theta`、`@f → phi`、`@c → chi`、`@y → psi`、`@w → omega`。变体使用双 `@`：`@@e`、`@@q`、`@@k`、`@@p`、`@@r`、`@@s`、`@@f` 分别展开为对应名称的 `.alt` 形式，名称遵循 [Typst 符号表](https://typst.app/docs/reference/symbols/sym/)。
- 片段使用已安装的 `mini.nvim` 中的 `mini.snippets`，加载 friendly-snippets 和 `~/.config/nvim/snippets/` 下的 JSON/Lua 片段，通过内置的进程内 LSP 接入 nvim-cmp。
- 补全菜单内 `Tab` / `Shift-Tab` 选择候选，`Enter` 确认；菜单关闭时 `Tab` / `Shift-Tab` 在片段占位符之间跳转，`Ctrl-c` 结束片段。没有活动片段时，`Tab` 展开精确匹配的片段前缀，否则正常缩进。
- `<leader>cc`（空格 c c）：打开/隐藏 Codex 浮动窗口，打开后可直接输入；窗口内 `Ctrl+q` 隐藏，保留会话。
- `:Codex` / `:CodexToggle`：也可打开/隐藏 Codex；处于普通模式时按 `i` 输入。使用社区插件 [codex.nvim](https://github.com/kkrampis/codex.nvim)，复用系统 `codex` 和现有登录、模型配置；首次登录可在终端运行 `codex login`。
- `<leader>r`：运行当前文件；在 Markdown 中运行光标所在代码块。
- `<leader>tp` / `<leader>tc`：Typst 预览 / watch。
- `<leader>lk`：TeX、HTML 中预览光标处或选中的公式。
- Markdown 保留数学 callout、证明末尾 Q.E.D. 和 LaTeX 渲染补丁。
- Typst 保留 `chapters/` 书籍入口识别、Tinymist 主文件选择和 PDF 更新流程。

主题使用 `~/.config/theme/` 下的 `palette.json`、`mode` 和 `generation`，并支持
运行目录中的 `nvim-window-theme-<PID>` 窗口覆盖。`theme_toggle.init()`、`sync()`
和 `dark_highlights` 接口保留；`setup()` 集中注册刷新事件，通过 Base46 的
`NvThemeReload` 事件恢复自定义配色。

界面采用红黑、白色和鲜艳朱橙（暗色模式 `#ff5a36`），灰色、青色辅助。
上下栏不填充背景，模式、文件名、Git 增删改、诊断和行列位置以彩色文字区分；
边框与缩进保留细直线，保留箭头、圆点和数学符号，减少装饰性字体图标。
`palette.lua` 中蓝、紫、绿、黄的兼容色名映射到这套配色，不引入黄橙。
启动页使用 fish 欢迎页里的五行小幽灵，保留主体与红色细节。

## 来源

基于 [NvChad starter](https://github.com/NvChad/starter)，其结构受到
[LazyVim starter](https://github.com/LazyVim/starter) 启发。
