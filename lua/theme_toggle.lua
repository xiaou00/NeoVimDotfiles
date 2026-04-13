local M = {}

local is_light = false

-- ── color palette for light mode ────────────────────────────────────────────
local c = {
    bg       = "#ffffff",   -- main background
    bg1      = "#f5f5f5",   -- slightly off-white (panels, float)
    bg2      = "#eeeeee",   -- darker panel (statusline, tabline)
    bg3      = "#e4e4e4",   -- border / separator fill
    fg       = "#111111",   -- main text
    fg2      = "#444444",   -- secondary text (strings, doc)
    fg3      = "#777777",   -- muted (comments, line numbers)
    red      = "#cc0000",   -- keywords, operators, errors
    teal     = "#007777",   -- types, properties
    orange   = "#cc5500",   -- numbers, float literals
    blue     = "#0055cc",   -- info, tags, imports
    green    = "#006600",   -- git add, ok
    yellow   = "#886600",   -- warnings, decorators, lifetimes
    purple   = "#6600cc",   -- special, attributes
    sel      = "#cce4ff",   -- visual selection
    search   = "#ffdd00",   -- search highlight bg
}

-- ── helper: make a hl entry ──────────────────────────────────────────────────
local function hl(fg, bg, opts)
    local t = {}
    if fg  then t.fg   = fg  end
    if bg  then t.bg   = bg  end
    if opts then for k,v in pairs(opts) do t[k]=v end end
    return t
end

-- ── all overrides ────────────────────────────────────────────────────────────
local light = {

    -- ── Editor UI ────────────────────────────────────────────────────────────
    Normal            = hl(c.fg,  c.bg),
    NormalFloat       = hl(c.fg,  c.bg1),
    NormalNC          = hl(c.fg,  c.bg1),
    SignColumn        = hl(nil,   c.bg),
    LineNr            = hl(c.fg3, c.bg),
    CursorLineNr      = hl(c.red, c.bg1, {bold=true}),
    CursorLine        = hl(nil,   c.bg1),
    ColorColumn       = hl(nil,   c.bg1),
    Visual            = hl(nil,   c.sel),
    VisualNOS         = hl(nil,   c.sel),
    Search            = hl(c.fg,  c.search),
    IncSearch         = hl("#ffffff", "#ff8800"),
    CurSearch         = hl(c.fg,  "#ffcc00"),
    MatchParen        = hl(nil,   c.bg3, {bold=true}),
    EndOfBuffer       = hl(c.bg3, nil),
    Folded            = hl(c.fg3, c.bg2),
    FoldColumn        = hl(c.bg3, c.bg),
    Conceal           = hl(c.fg3, nil),
    NonText           = hl(c.bg3, nil),
    SpecialKey        = hl(c.fg3, nil),
    Whitespace        = hl(c.bg3, nil),
    WinSeparator      = hl(c.bg3, nil),
    VertSplit         = hl(c.bg3, nil),

    -- ── Statusline / tabline ─────────────────────────────────────────────────
    StatusLine        = hl(c.fg2, c.bg2),
    StatusLineNC      = hl(c.fg3, c.bg2),
    TabLine           = hl(c.fg3, c.bg2),
    TabLineFill       = hl(nil,   c.bg2),
    TabLineSel        = hl(c.fg,  c.bg, {bold=true}),
    WildMenu          = hl(c.fg,  c.sel),

    -- ── Popup / completion ───────────────────────────────────────────────────
    Pmenu             = hl(c.fg,  c.bg1),
    PmenuSel          = hl("#ffffff", c.red),
    PmenuSbar         = hl(nil,   c.bg2),
    PmenuThumb        = hl(nil,   c.fg3),
    FloatBorder       = hl(c.bg3, c.bg1),
    FloatTitle        = hl(c.fg2, c.bg1, {bold=true}),

    -- ── Messages ─────────────────────────────────────────────────────────────
    ErrorMsg          = hl(c.red,    nil, {bold=true}),
    WarningMsg        = hl(c.yellow, nil),
    ModeMsg           = hl(c.fg,     nil, {bold=true}),
    MoreMsg           = hl(c.green,  nil),
    Question          = hl(c.blue,   nil),

    -- ── Classic syntax groups ─────────────────────────────────────────────────
    Comment           = hl(c.fg3,   nil, {italic=true}),
    Constant          = hl(c.fg,    nil),
    String            = hl(c.fg2,   nil),
    Character         = hl(c.fg2,   nil),
    Number            = hl(c.orange, nil),
    Float             = hl(c.orange, nil),
    Boolean           = hl(c.red,   nil, {bold=true}),
    Identifier        = hl(c.fg,    nil),
    Function          = hl(c.fg,    nil, {bold=true}),
    Statement         = hl(c.red,   nil, {bold=true}),
    Conditional       = hl(c.red,   nil, {bold=true}),
    Repeat            = hl(c.red,   nil, {bold=true}),
    Label             = hl(c.red,   nil, {bold=true}),
    Operator          = hl(c.red,   nil),
    Keyword           = hl(c.red,   nil, {bold=true}),
    Exception         = hl(c.red,   nil, {bold=true}),
    PreProc           = hl(c.red,   nil),
    Include           = hl(c.blue,  nil),
    Define            = hl(c.red,   nil),
    Macro             = hl(c.red,   nil, {bold=true}),
    PreCondit         = hl(c.red,   nil),
    StorageClass      = hl(c.red,   nil, {bold=true}),
    Structure         = hl(c.teal,  nil, {bold=true}),
    Typedef           = hl(c.teal,  nil, {bold=true}),
    Type              = hl(c.teal,  nil, {bold=true}),
    Special           = hl(c.purple, nil),
    SpecialChar       = hl(c.orange, nil),
    Tag               = hl(c.blue,  nil),
    Delimiter         = hl(c.fg3,   nil),
    SpecialComment    = hl(c.fg3,   nil, {italic=true}),
    Debug             = hl(c.red,   nil),
    Underlined        = hl(nil,     nil, {underline=true}),
    Error             = hl(c.red,   nil, {bold=true}),
    Todo              = hl(c.blue,  c.bg1, {bold=true}),
    Variable          = hl(c.fg,    nil, {italic=true}),

    -- ── Treesitter — generic ─────────────────────────────────────────────────
    ["@comment"]                    = hl(c.fg3,    nil, {italic=true}),
    ["@comment.documentation"]      = hl(c.fg3,    nil, {italic=true}),
    ["@error"]                      = hl(c.red,    nil, {bold=true}),

    ["@keyword"]                    = hl(c.red,    nil, {bold=true}),
    ["@keyword.function"]           = hl(c.red,    nil, {bold=true}),
    ["@keyword.operator"]           = hl(c.red,    nil),
    ["@keyword.return"]             = hl(c.red,    nil, {bold=true}),
    ["@keyword.conditional"]        = hl(c.red,    nil, {bold=true}),
    ["@keyword.conditional.ternary"]= hl(c.red,    nil),
    ["@keyword.repeat"]             = hl(c.red,    nil, {bold=true}),
    ["@keyword.exception"]          = hl(c.red,    nil, {bold=true}),
    ["@keyword.import"]             = hl(c.blue,   nil),
    ["@keyword.directive"]          = hl(c.red,    nil),
    ["@keyword.directive.define"]   = hl(c.red,    nil),
    ["@keyword.coroutine"]          = hl(c.red,    nil, {bold=true}),
    ["@keyword.debug"]              = hl(c.red,    nil),

    ["@operator"]                   = hl(c.red,    nil),
    ["@punctuation.bracket"]        = hl(c.fg3,    nil),
    ["@punctuation.delimiter"]      = hl(c.fg3,    nil),
    ["@punctuation.special"]        = hl(c.orange, nil),

    ["@variable"]                   = hl(c.fg,     nil),
    ["@variable.builtin"]           = hl(c.red,    nil, {bold=true}),
    ["@variable.parameter"]         = hl(c.teal,   nil),
    ["@variable.parameter.builtin"] = hl(c.teal,   nil, {italic=true}),
    ["@variable.member"]            = hl(c.teal,   nil),

    ["@constant"]                   = hl(c.fg,     nil),
    ["@constant.builtin"]           = hl(c.red,    nil, {bold=true}),
    ["@constant.macro"]             = hl(c.red,    nil, {bold=true}),

    ["@string"]                     = hl(c.fg2,    nil),
    ["@string.documentation"]       = hl(c.fg2,    nil, {italic=true}),
    ["@string.escape"]              = hl(c.orange, nil),
    ["@string.special"]             = hl(c.orange, nil),
    ["@string.special.url"]         = hl(c.blue,   nil, {underline=true}),
    ["@string.special.path"]        = hl(c.blue,   nil),
    ["@string.regexp"]              = hl(c.orange, nil),

    ["@character"]                  = hl(c.fg2,    nil),
    ["@character.special"]          = hl(c.orange, nil),
    ["@number"]                     = hl(c.orange, nil),
    ["@number.float"]               = hl(c.orange, nil),
    ["@boolean"]                    = hl(c.red,    nil, {bold=true}),

    ["@type"]                       = hl(c.teal,   nil, {bold=true}),
    ["@type.builtin"]               = hl(c.teal,   nil, {bold=true}),
    ["@type.qualifier"]             = hl(c.red,    nil, {bold=true}),
    ["@type.definition"]            = hl(c.teal,   nil, {bold=true}),

    ["@attribute"]                  = hl(c.yellow, nil),
    ["@attribute.builtin"]          = hl(c.yellow, nil),

    ["@function"]                   = hl(c.fg,     nil, {bold=true}),
    ["@function.call"]              = hl(c.fg,     nil, {bold=true}),
    ["@function.builtin"]           = hl(c.red,    nil, {bold=true}),
    ["@function.macro"]             = hl(c.red,    nil, {bold=true}),
    ["@function.method"]            = hl(c.fg,     nil, {bold=true}),
    ["@function.method.call"]       = hl(c.fg,     nil, {bold=true}),

    ["@constructor"]                = hl(c.teal,   nil, {bold=true}),
    ["@property"]                   = hl(c.teal,   nil),
    ["@field"]                      = hl(c.teal,   nil),
    ["@tag"]                        = hl(c.blue,   nil, {bold=true}),
    ["@tag.attribute"]              = hl(c.teal,   nil),
    ["@tag.delimiter"]              = hl(c.fg3,    nil),

    ["@module"]                     = hl(c.fg,     nil),
    ["@module.builtin"]             = hl(c.red,    nil, {bold=true}),
    ["@label"]                      = hl(c.red,    nil),

    ["@markup.heading"]             = hl(c.fg,     nil, {bold=true}),
    ["@markup.heading.1"]           = hl(c.red,    nil, {bold=true}),
    ["@markup.heading.2"]           = hl(c.red,    nil, {bold=true}),
    ["@markup.heading.3"]           = hl(c.orange, nil, {bold=true}),
    ["@markup.heading.4"]           = hl(c.orange, nil, {bold=true}),
    ["@markup.raw"]                 = hl(c.fg2,    c.bg1),
    ["@markup.raw.block"]           = hl(c.fg2,    c.bg1),
    ["@markup.link"]                = hl(c.blue,   nil, {underline=true}),
    ["@markup.link.label"]          = hl(c.blue,   nil),
    ["@markup.link.url"]            = hl(c.blue,   nil, {underline=true}),
    ["@markup.italic"]              = hl(nil,      nil, {italic=true}),
    ["@markup.strong"]              = hl(nil,      nil, {bold=true}),
    ["@markup.strikethrough"]       = hl(c.fg3,    nil, {strikethrough=true}),
    ["@markup.list"]                = hl(c.red,    nil),
    ["@markup.list.checked"]        = hl(c.green,  nil),
    ["@markup.list.unchecked"]      = hl(c.fg3,    nil),
    ["@markup.quote"]               = hl(c.fg2,    nil, {italic=true}),
    ["@markup.math"]                = hl(c.teal,   nil),

    ["@diff.plus"]                  = hl(c.green,  nil),
    ["@diff.minus"]                 = hl(c.red,    nil),
    ["@diff.delta"]                 = hl(c.blue,   nil),

    -- ── C / C++ specific ─────────────────────────────────────────────────────
    ["@keyword.c"]                  = hl(c.red,    nil, {bold=true}),
    ["@type.c"]                     = hl(c.teal,   nil, {bold=true}),
    ["@type.builtin.c"]             = hl(c.teal,   nil, {bold=true}),
    ["@keyword.cpp"]                = hl(c.red,    nil, {bold=true}),
    ["@type.cpp"]                   = hl(c.teal,   nil, {bold=true}),
    ["@type.builtin.cpp"]           = hl(c.teal,   nil, {bold=true}),
    ["@keyword.directive.cpp"]      = hl(c.red,    nil),     -- #include, #define …
    ["@keyword.directive.define.cpp"] = hl(c.red,  nil, {bold=true}),
    ["@string.cpp"]                 = hl(c.fg2,    nil),
    ["@number.cpp"]                 = hl(c.orange, nil),
    ["@operator.cpp"]               = hl(c.red,    nil),
    ["@variable.cpp"]               = hl(c.fg,     nil),
    ["@variable.member.cpp"]        = hl(c.teal,   nil),
    ["@function.cpp"]               = hl(c.fg,     nil, {bold=true}),
    ["@function.method.cpp"]        = hl(c.fg,     nil, {bold=true}),
    ["@constructor.cpp"]            = hl(c.fg,     nil, {bold=true}),
    ["@namespace.cpp"]              = hl(c.fg,     nil),         -- std::, etc.
    -- Namespace / using
    cppSTLnamespace                 = hl(c.fg,     nil),
    cppSTLtype                      = hl(c.teal,   nil, {bold=true}),
    cppSTLexception                 = hl(c.red,    nil, {bold=true}),
    cppSTLfunction                  = hl(c.fg,     nil, {bold=true}),
    cppSTLios                       = hl(c.teal,   nil),
    cppSTLiterator                  = hl(c.teal,   nil),
    cppSTLiterator_tag              = hl(c.teal,   nil),
    cppSTLconstant                  = hl(c.orange, nil),
    cppSTLconcept                   = hl(c.teal,   nil, {bold=true}),

    -- ── Python specific ──────────────────────────────────────────────────────
    ["@keyword.python"]             = hl(c.red,    nil, {bold=true}),
    ["@keyword.import.python"]      = hl(c.blue,   nil),
    ["@type.python"]                = hl(c.teal,   nil, {bold=true}),
    ["@type.builtin.python"]        = hl(c.teal,   nil, {bold=true}),
    ["@string.python"]              = hl(c.fg2,    nil),
    ["@string.documentation.python"]= hl(c.fg3,    nil, {italic=true}),
    ["@number.python"]              = hl(c.orange, nil),
    ["@boolean.python"]             = hl(c.red,    nil, {bold=true}),
    ["@operator.python"]            = hl(c.red,    nil),
    ["@function.python"]            = hl(c.fg,     nil, {bold=true}),
    ["@function.call.python"]       = hl(c.fg,     nil, {bold=true}),
    ["@function.builtin.python"]    = hl(c.red,    nil, {bold=true}),
    ["@function.method.python"]     = hl(c.fg,     nil, {bold=true}),
    ["@variable.python"]            = hl(c.fg,     nil),
    ["@variable.builtin.python"]    = hl(c.red,    nil, {bold=true}),  -- self, cls
    ["@variable.parameter.python"]  = hl(c.teal,   nil),
    ["@attribute.python"]           = hl(c.yellow, nil),               -- decorators
    ["@constant.python"]            = hl(c.fg,     nil),
    ["@constant.builtin.python"]    = hl(c.red,    nil, {bold=true}),  -- None, True, False
    ["@constructor.python"]         = hl(c.teal,   nil, {bold=true}),
    ["@exception.python"]           = hl(c.red,    nil, {bold=true}),
    ["@punctuation.bracket.python"] = hl(c.fg3,    nil),
    -- legacy vim-python highlights
    pythonBuiltin                   = hl(c.red,    nil, {bold=true}),
    pythonExceptions                = hl(c.red,    nil, {bold=true}),
    pythonDecorator                 = hl(c.yellow, nil),
    pythonDecoratorName             = hl(c.yellow, nil),
    pythonDottedName                = hl(c.fg,     nil),
    pythonImport                    = hl(c.blue,   nil),
    pythonFunction                  = hl(c.fg,     nil, {bold=true}),
    pythonClass                     = hl(c.teal,   nil, {bold=true}),
    pythonOperator                  = hl(c.red,    nil),
    pythonString                    = hl(c.fg2,    nil),
    pythonNumber                    = hl(c.orange, nil),
    pythonComment                   = hl(c.fg3,    nil, {italic=true}),

    -- ── Rust specific ────────────────────────────────────────────────────────
    ["@keyword.rust"]               = hl(c.red,    nil, {bold=true}),
    ["@keyword.function.rust"]      = hl(c.red,    nil, {bold=true}),
    ["@type.rust"]                  = hl(c.teal,   nil, {bold=true}),
    ["@type.builtin.rust"]          = hl(c.teal,   nil, {bold=true}),
    ["@string.rust"]                = hl(c.fg2,    nil),
    ["@number.rust"]                = hl(c.orange, nil),
    ["@operator.rust"]              = hl(c.red,    nil),
    ["@function.rust"]              = hl(c.fg,     nil, {bold=true}),
    ["@function.call.rust"]         = hl(c.fg,     nil, {bold=true}),
    ["@function.macro.rust"]        = hl(c.red,    nil, {bold=true}),  -- println!, vec!
    ["@function.method.rust"]       = hl(c.fg,     nil, {bold=true}),
    ["@variable.rust"]              = hl(c.fg,     nil),
    ["@variable.builtin.rust"]      = hl(c.red,    nil, {bold=true}),  -- self
    ["@variable.parameter.rust"]    = hl(c.teal,   nil),
    ["@attribute.rust"]             = hl(c.yellow, nil),               -- #[derive(...)]
    ["@constant.rust"]              = hl(c.orange, nil, {bold=true}),
    ["@constant.builtin.rust"]      = hl(c.orange, nil, {bold=true}),
    ["@constructor.rust"]           = hl(c.teal,   nil, {bold=true}),
    ["@punctuation.bracket.rust"]   = hl(c.fg3,    nil),
    ["@punctuation.special.rust"]   = hl(c.orange, nil),               -- ..
    ["@label.rust"]                 = hl(c.red,    nil),               -- 'loop labels
    -- Rust lifetimes (covered by @label in nvim-treesitter-rust)
    rustLifetime                    = hl(c.yellow, nil, {italic=true}),
    rustSigil                       = hl(c.red,    nil),
    rustModPath                     = hl(c.fg,     nil),
    rustModPathSep                  = hl(c.fg3,    nil),
    rustDerive                      = hl(c.yellow, nil),
    rustDeriveTrait                 = hl(c.teal,   nil, {italic=true}),
    rustTrait                       = hl(c.teal,   nil, {bold=true}),
    rustEnum                        = hl(c.teal,   nil, {bold=true}),
    rustEnumVariant                 = hl(c.teal,   nil),
    rustStructure                   = hl(c.teal,   nil, {bold=true}),
    rustSelf                        = hl(c.red,    nil, {bold=true}),
    rustSuper                       = hl(c.red,    nil, {bold=true}),
    rustMacro                       = hl(c.red,    nil, {bold=true}),
    rustAttribute                   = hl(c.yellow, nil),
    rustStorage                     = hl(c.red,    nil, {bold=true}),
    rustKeyword                     = hl(c.red,    nil, {bold=true}),
    rustBoolean                     = hl(c.red,    nil, {bold=true}),
    rustArrowCharacter              = hl(c.red,    nil),
    rustOperator                    = hl(c.red,    nil),
    rustRepeat                      = hl(c.red,    nil, {bold=true}),
    rustConditional                 = hl(c.red,    nil, {bold=true}),
    rustString                      = hl(c.fg2,    nil),
    rustStringDelimiter             = hl(c.fg3,    nil),
    rustNumber                      = hl(c.orange, nil),
    rustFloat                       = hl(c.orange, nil),
    rustComment                     = hl(c.fg3,    nil, {italic=true}),
    rustCommentLine                 = hl(c.fg3,    nil, {italic=true}),
    rustCommentBlock                = hl(c.fg3,    nil, {italic=true}),
    rustDocComment                  = hl(c.fg3,    nil, {italic=true}),

    -- ── TeX / LaTeX specific ─────────────────────────────────────────────────
    ["@keyword.tex"]                = hl(c.red,    nil, {bold=true}),
    ["@function.macro.tex"]         = hl(c.red,    nil, {bold=true}),  -- \command
    ["@operator.tex"]               = hl(c.red,    nil),
    ["@string.tex"]                 = hl(c.fg2,    nil),
    ["@string.special.tex"]         = hl(c.orange, nil),
    ["@comment.tex"]                = hl(c.fg3,    nil, {italic=true}),
    ["@markup.math.tex"]            = hl(c.teal,   nil),
    ["@markup.heading.tex"]         = hl(c.fg,     nil, {bold=true}),
    ["@markup.strong.tex"]          = hl(nil,      nil, {bold=true}),
    ["@markup.italic.tex"]          = hl(nil,      nil, {italic=true}),
    ["@markup.link.url.tex"]        = hl(c.blue,   nil, {underline=true}),
    ["@punctuation.bracket.tex"]    = hl(c.fg3,    nil),
    ["@punctuation.special.tex"]    = hl(c.orange, nil),
    ["@variable.tex"]               = hl(c.fg,     nil),
    -- legacy vim-tex highlights
    texCmd                          = hl(c.red,    nil, {bold=true}),
    texCmdPart                      = hl(c.red,    nil, {bold=true}),
    texCmdDef                       = hl(c.red,    nil, {bold=true}),
    texCmdEnv                       = hl(c.red,    nil, {bold=true}),
    texCmdGreek                     = hl(c.teal,   nil),
    texCmdMath                      = hl(c.teal,   nil),
    texCmdItem                      = hl(c.red,    nil, {bold=true}),
    texCmdRef                       = hl(c.blue,   nil),
    texCmdCite                      = hl(c.blue,   nil),
    texCmdTitle                     = hl(c.red,    nil, {bold=true}),
    texEnvName                      = hl(c.teal,   nil, {bold=true}),
    texMathEnvName                  = hl(c.teal,   nil, {bold=true}),
    texMathOper                     = hl(c.red,    nil),
    texMathDelim                    = hl(c.fg3,    nil),
    texMathZone                     = hl(c.teal,   nil),
    texMathZoneEnv                  = hl(c.teal,   nil),
    texMathZoneX                    = hl(c.teal,   nil),
    texMathZoneXX                   = hl(c.teal,   nil),
    texMathZoneLI                   = hl(c.teal,   nil),
    texZone                         = hl(c.fg2,    nil),
    texComment                      = hl(c.fg3,    nil, {italic=true}),
    texString                       = hl(c.fg2,    nil),
    texArg                          = hl(c.fg,     nil),
    texOpt                          = hl(c.yellow, nil),
    texOptSep                       = hl(c.fg3,    nil),
    texLength                       = hl(c.orange, nil),
    texSpecialChar                  = hl(c.orange, nil),
    texSymbol                       = hl(c.red,    nil),

    -- ── Bash / Shell specific ────────────────────────────────────────────────
    ["@keyword.bash"]               = hl(c.red,    nil, {bold=true}),
    ["@keyword.conditional.bash"]   = hl(c.red,    nil, {bold=true}),
    ["@keyword.repeat.bash"]        = hl(c.red,    nil, {bold=true}),
    ["@function.bash"]              = hl(c.fg,     nil, {bold=true}),
    ["@function.call.bash"]         = hl(c.fg,     nil, {bold=true}),
    ["@variable.bash"]              = hl(c.fg,     nil),
    ["@variable.builtin.bash"]      = hl(c.red,    nil, {bold=true}),  -- $0 $@ $#
    ["@variable.parameter.bash"]    = hl(c.teal,   nil),
    ["@string.bash"]                = hl(c.fg2,    nil),
    ["@string.special.bash"]        = hl(c.orange, nil),
    ["@number.bash"]                = hl(c.orange, nil),
    ["@operator.bash"]              = hl(c.red,    nil),
    ["@punctuation.bracket.bash"]   = hl(c.fg3,    nil),
    ["@punctuation.special.bash"]   = hl(c.orange, nil),               -- $( ), ${ }
    ["@comment.bash"]               = hl(c.fg3,    nil, {italic=true}),
    -- legacy vim-bash / sh highlights
    shCmd                           = hl(c.fg,     nil, {bold=true}),
    shFunctionKey                   = hl(c.red,    nil, {bold=true}),
    shFunction                      = hl(c.fg,     nil, {bold=true}),
    shStatement                     = hl(c.red,    nil, {bold=true}),
    shConditional                   = hl(c.red,    nil, {bold=true}),
    shLoop                          = hl(c.red,    nil, {bold=true}),
    shRepeat                        = hl(c.red,    nil, {bold=true}),
    shExpr                          = hl(c.red,    nil),
    shOption                        = hl(c.fg,     nil),
    shParen                         = hl(c.fg3,    nil),
    shCmdSubRegion                  = hl(c.orange, nil),
    shCommandSub                    = hl(c.orange, nil),
    shQuote                         = hl(c.fg3,    nil),
    shDeref                         = hl(c.red,    nil),
    shSpecial                       = hl(c.orange, nil),
    shVariable                      = hl(c.fg,     nil),
    shVarAssign                     = hl(c.teal,   nil),
    shString                        = hl(c.fg2,    nil),
    shNumber                        = hl(c.orange, nil),
    shComment                       = hl(c.fg3,    nil, {italic=true}),
    bashStatement                   = hl(c.red,    nil, {bold=true}),

    -- ── LSP semantic tokens ───────────────────────────────────────────────────
    ["@lsp.type.keyword"]           = hl(c.red,    nil, {bold=true}),
    ["@lsp.type.function"]          = hl(c.fg,     nil, {bold=true}),
    ["@lsp.type.method"]            = hl(c.fg,     nil, {bold=true}),
    ["@lsp.type.macro"]             = hl(c.red,    nil, {bold=true}),
    ["@lsp.type.type"]              = hl(c.teal,   nil, {bold=true}),
    ["@lsp.type.class"]             = hl(c.teal,   nil, {bold=true}),
    ["@lsp.type.struct"]            = hl(c.teal,   nil, {bold=true}),
    ["@lsp.type.enum"]              = hl(c.teal,   nil, {bold=true}),
    ["@lsp.type.enumMember"]        = hl(c.teal,   nil),
    ["@lsp.type.interface"]         = hl(c.teal,   nil, {bold=true}),
    ["@lsp.type.typeParameter"]     = hl(c.teal,   nil, {italic=true}),
    ["@lsp.type.namespace"]         = hl(c.fg,     nil),
    ["@lsp.type.variable"]          = hl(c.fg,     nil),
    ["@lsp.type.parameter"]         = hl(c.teal,   nil),
    ["@lsp.type.property"]          = hl(c.teal,   nil),
    ["@lsp.type.decorator"]         = hl(c.yellow, nil),
    ["@lsp.type.selfParameter"]     = hl(c.red,    nil, {bold=true}),
    ["@lsp.type.builtinType"]       = hl(c.teal,   nil, {bold=true}),
    ["@lsp.type.operator"]          = hl(c.red,    nil),
    ["@lsp.type.lifetime"]          = hl(c.yellow, nil, {italic=true}),
    ["@lsp.mod.readonly"]           = hl(nil,      nil, {bold=true}),
    ["@lsp.mod.static"]             = hl(nil,      nil, {bold=true}),
    ["@lsp.mod.deprecated"]         = hl(c.fg3,    nil, {strikethrough=true}),
    ["@lsp.typemod.function.defaultLibrary"] = hl(c.red, nil, {bold=true}),
    ["@lsp.typemod.variable.defaultLibrary"] = hl(c.red, nil, {bold=true}),

    -- ── LSP reference / diagnostic ───────────────────────────────────────────
    LspReferenceText              = hl(nil, c.bg2),
    LspReferenceRead              = hl(nil, c.bg2),
    LspReferenceWrite             = hl(nil, "#ffe0e0"),
    DiagnosticError               = hl(c.red,    nil),
    DiagnosticWarn                = hl(c.yellow, nil),
    DiagnosticInfo                = hl(c.blue,   nil),
    DiagnosticHint                = hl(c.teal,   nil),
    DiagnosticUnderlineError      = hl(nil, nil, {sp=c.red,    underline=true}),
    DiagnosticUnderlineWarn       = hl(nil, nil, {sp=c.yellow, underline=true}),
    DiagnosticUnderlineInfo       = hl(nil, nil, {sp=c.blue,   underline=true}),
    DiagnosticUnderlineHint       = hl(nil, nil, {sp=c.teal,   underline=true}),
    DiagnosticVirtualTextError    = hl(c.red,    c.bg1),
    DiagnosticVirtualTextWarn     = hl(c.yellow, c.bg1),
    DiagnosticVirtualTextInfo     = hl(c.blue,   c.bg1),
    DiagnosticVirtualTextHint     = hl(c.teal,   c.bg1),

    -- ── Git ──────────────────────────────────────────────────────────────────
    GitSignsAdd                   = hl(c.green,  nil),
    GitSignsChange                = hl(c.blue,   nil),
    GitSignsDelete                = hl(c.red,    nil),
    DiffAdd                       = hl(nil,      "#e6ffe6"),
    DiffChange                    = hl(nil,      "#e6eeff"),
    DiffDelete                    = hl(nil,      "#ffe6e6"),
    DiffText                      = hl(nil,      "#cce4ff"),

    -- ── NvChad tabufline ─────────────────────────────────────────────────────
    TbLineBufOn                   = hl(c.fg,  c.bg,  {bold=true}),
    TbLineBufOff                  = hl(c.fg3, c.bg2),
    TbLineTabOn                   = hl(c.fg,  c.bg,  {bold=true}),
    TbLineTabOff                  = hl(c.fg3, c.bg2),
    TbLineBufOnModified           = hl(c.red, c.bg),
    TbLineBufOffModified          = hl(c.red, c.bg2),
    TbLineCloseBtn                = hl(c.fg3, c.bg),
    TbLineBufOnClose              = hl(c.fg3, c.bg),
    TbLineBufOffClose             = hl(c.fg3, c.bg2),
    TbLineTheme                   = hl(c.fg3, c.bg2),
    TbLineBackground              = hl(nil,   c.bg2),

    -- ── Telescope ────────────────────────────────────────────────────────────
    TelescopeNormal               = hl(c.fg,  c.bg),
    TelescopeBorder               = hl(c.bg3, c.bg),
    TelescopePromptBorder         = hl(c.bg3, c.bg1),
    TelescopePromptNormal         = hl(c.fg,  c.bg1),
    TelescopePromptPrefix         = hl(c.red, c.bg1),
    TelescopeResultsBorder        = hl(c.bg3, c.bg),
    TelescopeResultsNormal        = hl(c.fg,  c.bg),
    TelescopePreviewBorder        = hl(c.bg3, c.bg),
    TelescopePreviewNormal        = hl(c.fg,  c.bg),
    TelescopeSelectionCaret       = hl(c.red, c.sel),
    TelescopeSelection            = hl(c.fg,  c.sel),
    TelescopeMatching             = hl(c.red, nil, {bold=true}),

    -- ── nvim-tree ────────────────────────────────────────────────────────────
    NvimTreeNormal                = hl(c.fg,  c.bg1),
    NvimTreeNormalNC              = hl(c.fg,  c.bg1),
    NvimTreeWinSeparator          = hl(c.bg3, c.bg1),
    NvimTreeRootFolder            = hl(c.red, nil, {bold=true}),
    NvimTreeFolderIcon            = hl(c.red, nil),
    NvimTreeFolderName            = hl(c.fg,  nil),
    NvimTreeOpenedFolderName      = hl(c.fg,  nil, {bold=true}),
    NvimTreeFileName              = hl(c.fg,  nil),
    NvimTreeOpenedFile            = hl(c.red, nil),
    NvimTreeGitNew                = hl(c.green,  nil),
    NvimTreeGitDirty              = hl(c.yellow, nil),
    NvimTreeGitDeleted            = hl(c.red,    nil),
    NvimTreeGitStaged             = hl(c.green,  nil),
    NvimTreeIndentMarker          = hl(c.bg3, nil),

    -- ── render-markdown ──────────────────────────────────────────────────────
    RenderMarkdownH1Bg            = hl(c.red,    "#ffeeee", {bold=true}),
    RenderMarkdownH2Bg            = hl(c.red,    "#fff4ee", {bold=true}),
    RenderMarkdownH3Bg            = hl(c.orange, "#fffaee", {bold=true}),
    RenderMarkdownH4Bg            = hl(c.orange, "#fffaee"),
    RenderMarkdownH5Bg            = hl(c.fg2,    c.bg1),
    RenderMarkdownH6Bg            = hl(c.fg3,    c.bg1),
    RenderMarkdownH1              = hl(c.red,    nil, {bold=true}),
    RenderMarkdownH2              = hl(c.red,    nil, {bold=true}),
    RenderMarkdownH3              = hl(c.orange, nil, {bold=true}),
    RenderMarkdownCode            = hl(c.fg2,    c.bg1),
    RenderMarkdownCodeBorder      = hl(c.bg3,    nil),
    RenderMarkdownCodeInline      = hl(c.fg2,    c.bg1),
    RenderMarkdownMath            = hl(c.teal,   nil),
    RenderMarkdownBullet          = hl(c.red,    nil),
    RenderMarkdownDash            = hl(c.bg3,    nil),
    RenderMarkdownLink            = hl(c.blue,   nil, {underline=true}),
    RenderMarkdownChecked         = hl(c.green,  nil),
    RenderMarkdownUnchecked       = hl(c.fg3,    nil),
    RenderMarkdownQuote           = hl(c.fg2,    nil, {italic=true}),
    RenderMarkdownTableHead       = hl(c.teal,   nil, {bold=true}),
    RenderMarkdownTableRow        = hl(c.fg,     nil),
    RenderMarkdownTableFill       = hl(c.bg3,    nil),
}

-- Only these fields are safe to round-trip through nvim_get_hl → nvim_set_hl.
-- Other fields (e.g. "id", "default") can cause unexpected behavior.
local hl_fields = {
    fg=true, bg=true, sp=true, blend=true,
    bold=true, italic=true, underline=true, undercurl=true,
    underdouble=true, underdotted=true, underdashed=true,
    strikethrough=true, reverse=true, nocombine=true,
    link=true,
}

local function snapshot_hl(group)
    local ok, val = pcall(vim.api.nvim_get_hl, 0, { name = group, create = false, link = true })
    if not ok or type(val) ~= "table" then return {} end
    local clean = {}
    for k, v in pairs(val) do
        if hl_fields[k] then clean[k] = v end
    end
    return clean
end

-- Snapshot of dark-mode values, populated just before entering light mode
local dark_snapshot = {}

function M.toggle()
    if is_light then
        for group, saved in pairs(dark_snapshot) do
            if next(saved) == nil then
                -- Was undefined in dark mode: truly undefine it so that
                -- treesitter fallback chains (@keyword.cpp → @keyword) work again.
                -- nvim_set_hl(0, group, {}) would make it "explicitly empty",
                -- breaking the fallback. "hi clear" actually removes the definition.
                pcall(vim.cmd, "hi clear " .. group)
            else
                vim.api.nvim_set_hl(0, group, saved)
            end
        end
        -- NvChad rebuilds its compiled groups on top (treesitter, syntax, ui …)
        require("base46").load_all_highlights()
        dark_snapshot = {}
        is_light = false
        vim.notify("Dark mode", vim.log.levels.INFO)
    else
        dark_snapshot = {}
        for group in pairs(light) do
            dark_snapshot[group] = snapshot_hl(group)
        end
        for group, opts in pairs(light) do
            vim.api.nvim_set_hl(0, group, opts)
        end
        is_light = true
        vim.notify("Light mode", vim.log.levels.INFO)
    end
end

function M.is_light()
    return is_light
end

return M
