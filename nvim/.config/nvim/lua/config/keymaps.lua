local u = require("util")
local m, f = u.cmd_map, u.key_map

-- Normal maps
f("0", "^")
f("-", "0")

-- Maps
m("<leader>w", "up")
m("<leader>W", "wa")
m("<leader>qa", "qa")
m("<leader>qq", "q")
m("<leader>qo", "WinOnly")
m("<leader>ql", "WinOnlyFocusLeft")
m("<leader>qh", "WinOnlyFocusRight")
m("<leader>qc", "QuickFixClear")
m("<leader>bn", "bn")
m("<leader>bp", "bp")
m("<leader>bq", "Bdelete")
m("<leader>bd", "bd")
m("<leader>bu", "bufdo :Bdelete")
m("<leader>bo", "BufOnlyWindowOnly")
m("<leader>be", "new")
m("<leader>so", "only")
-- Widnow resizing
m("<leader><", "vertical resize -10")
m("<leader>>", "vertical resize +10")
m("<leader>-", "resize -10")
m("<leader>+", "resize +10")
m("<leader>tb", "TermOpenBottom")
m("<leader>tq", "tabclose")
m("<leader>tp", "InspectTree")

-- User commands
m("<bs>", "LoadPreviousBuffer")
m("<del>", "LoadPreviousBuffer")
m("<leader>cp", "CommentYankPaste", { "n", "x" })
m("<leader>hw", "HelpWord")
m("K", "HoverHandler")
m("<leader><Tab>", "TabPrevious")
m("<leader><S-Tab>", "TabNext")
m("<leader>df", "ConformFormatToggle")
m("<leader>y", "TestingFunction")
