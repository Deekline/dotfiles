return {
	"echasnovski/mini.indentscope",
	version = "*", -- Use latest stable version
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		symbol = "│", -- You can also use: "▏", "┊", "┆", "¦", "︙"
		options = {
			border = "both",
			indent_at_cursor = true,
			try_as_border = true,
		},
		mappings = {
			object_scope = "ii",
			object_scope_with_border = "ai",
			goto_top = "[i",
			goto_bottom = "]i",
		},
	},
	config = function(_, opts)
		require("mini.indentscope").setup(opts)
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
					fg = "#61AFEF", -- Blue color
					-- fg = "#98C379", -- Green color
					-- fg = "#E5C07B", -- Yellow color
					-- fg = "#C678DD", -- Purple color
					-- fg = "#E06C75", -- Red color
					-- fg = "#56B6C2", -- Cyan color
					bold = true,
				})
			end,
		})
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
			fg = "#61AFEF", -- Blue color - change this to your preferred color
			bold = true,
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
