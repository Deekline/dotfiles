local m = require("util").lazy_map

local opts = {
	highlight_moving_win = true,
	focused_hl_group = "Visual",
	moving_win_options = {
		wrap = false,
		cursorline = false,
		cursorcolumn = false,
		colorcolumn = "",
	},
	picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
	filter_rules = {
		cur_win = true,
		floats = true,
		buftype = {
			"terminal",
		},
		bufname = {},
	},
}

return {
	"sindrets/winshift.nvim",
	opts = opts,
	cmd = "WinShift",
	keys = {
		m("<leader>sd", [[WinShift<cr>]], {}, { desc = "Win shift" }),
		m("<leader>sa", [[WinShift swap]], {}, { desc = "WinShift swap" }),
		m("<leader>sh", [[WinShift left]], {}, { desc = "Winshift left" }),
		m("<leader>sj", [[WinShift down]], {}, { desc = "Winshift down" }),
		m("<leader>sk", [[WinShift up]], {}, { desc = "Winshift up" }),
		m("<leader>sl", [[WinShift right]], {}, { desc = "Winshift right" }),
	},
}
