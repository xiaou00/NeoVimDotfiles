-- 全局插入模式缩写。输入缩写后按空格等分隔符展开。

-- C++ 与竞赛编程
vim.cmd [[
  inoreabbrev mian main
  inoreabbrev fori for(int i=1;i<=n;++i){}<left><C-R>
  inoreabbrev forj for(int j=1;j<=n;++j){}<left><C-R>
  inoreabbrev cin cin>><C-R>
  inoreabbrev cout cout<<<C-R>
  inoreabbrev lb lower_bound()<C-R>
  inoreabbrev ub upper_bound()<C-R>
  inoreabbrev // /*  */<left><left><left><C-R>
]]

-- Typst 运算符、字体与图形
vim.cmd [[
  inoreabbrev <+ <=
  inoreabbrev >+ >=
  inoreabbrev +. plus.o
  inoreabbrev x. times.o
  inoreabbrev ++. plus.o.big
  inoreabbrev xx. times.o.big

  inoreabbrev ca cal()<left><C-R>
  inoreabbrev fr frak()<left><C-R>
  inoreabbrev bo bold()<left><C-R>
  inoreabbrev sc scr()<left><C-R>
]]

-- Typst 希腊字母：\\小写键 → 小写名称，\\大写键 → 大写名称。
-- q = theta，h = eta，f = phi，c = chi，y = psi，w = omega。
-- 第三列为 true 时，同时注册 \\\\键 → 对应的 .alt 变体。
-- https://typst.app/docs/reference/symbols/sym/
local greek = {
  { "a", "alpha" },
  { "b", "beta" },
  { "g", "gamma" },
  { "d", "delta" },
  { "e", "epsilon", true },
  { "z", "zeta" },
  { "h", "eta" },
  { "i", "iota" },
  { "k", "kappa", true },
  { "l", "lambda" },
  { "m", "mu" },
  { "n", "nu" },
  { "x", "xi" },
  { "p", "pi", true },
  { "r", "rho", true },
  { "s", "sigma", true },
  { "t", "tau" },
  { "u", "upsilon" },
  { "f", "phi", true },
  { "c", "chi" },
  { "y", "psi" },
  { "o", "omega" },
  { "w", "omega" },
}

for _, letter in ipairs(greek) do
  local key, name, has_variant = unpack(letter)
  local capitalized = name:sub(1, 1):upper() .. name:sub(2)
  vim.cmd.inoreabbrev { "\\" .. key, name }
  vim.cmd.inoreabbrev { "\\" .. key:upper(), capitalized }
  if has_variant then
    vim.cmd.inoreabbrev { "\\\\" .. key, name .. ".alt" }
  end
end

-- 保留 \R 的原样输入，不展开为 Rho。
vim.cmd [[silent! iunabbrev \R]]

-- Typst 数学文本与定理环境
vim.cmd [[
  inoreabbrev 无穷范畴 $oo$-范畴<C-R>
  inoreabbrev \< chevron.l chevron.r<left><left><left><left><left><left><left><left><left><left>
  inoreabbrev #d #definition(title:[])[<enter><enter>]<left><left><tab><left><left><left><left><left><left><C-R>
  inoreabbrev #t #theorem(title:[])[<enter><enter>]<left><left><tab><left><left><left><left><left><left><C-R>
  inoreabbrev #c #corollary[<enter><enter>]<left><left><tab><C-R>
  inoreabbrev #l #lemma[<enter><enter>]<left><left><tab><C-R>
  inoreabbrev #r #remark[<enter><enter>]<left><left><tab><C-R>
  inoreabbrev #p #proof[<enter><enter>]<left><left><tab><C-R>
]]

vim.cmd [[
  inoreabbrev wqfc $oo$-范畴
  inoreabbrev wq $oo$-<C-R>
]]
