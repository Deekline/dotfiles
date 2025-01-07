local m = require("util").lazy_map

local opts = {
	is_insert_mode = false,
}

return {
	"nvim-pack/nvim-spectre",
	opts = opts,
	cmd = "Spectre",
	keys = {
		m("<leader>sr", [[SpectreOpen]], {}, { desc = "Replace UI Open" }),
		m("<leader>sw", [[SpectreOpenWord]], {}, { desc = "Replace UI Word" }),
		m("<leader>sc", [[SpectreOpenCwd]], {}, { desc = "Replace UI cwd" }),
	},
}
