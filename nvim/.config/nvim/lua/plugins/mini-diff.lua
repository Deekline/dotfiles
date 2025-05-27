return {
	"echasnovski/mini.diff",
	event = "VeryLazy",
	keys = {
		{
			"<leader>go",
			function()
				require("mini.diff").toggle_overlay(0)
			end,
			desc = "Toggle mini.diff overlay",
		},
	},
	opts = {
		view = {
			style = "sign",
			signs = {
				add = "▎",
				change = "▎",
				delete = "",
			},
		},
	},
	config = function(_, opts)
		require("mini.diff").setup(opts)

		-- Remove background colors from git signs
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				-- Green for added lines (no background)
				vim.api.nvim_set_hl(0, "MiniDiffSignAdd", {
					fg = "#98C379", -- Green color
					bg = "NONE", -- No background
					bold = true,
				})

				-- Blue for changed lines (no background)
				vim.api.nvim_set_hl(0, "MiniDiffSignChange", {
					fg = "#61AFEF", -- Blue color
					bg = "NONE", -- No background
					bold = true,
				})

				-- Red for deleted lines (no background)
				vim.api.nvim_set_hl(0, "MiniDiffSignDelete", {
					fg = "#E06C75", -- Red color
					bg = "NONE", -- No background
					bold = true,
				})
			end,
		})

		-- Apply the highlight immediately (for current colorscheme)
		vim.api.nvim_set_hl(0, "MiniDiffSignAdd", {
			fg = "#98C379", -- Green
			bg = "NONE",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniDiffSignChange", {
			fg = "#61AFEF", -- Blue
			bg = "NONE",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniDiffSignDelete", {
			fg = "#E06C75", -- Red
			bg = "NONE",
			bold = true,
		})
	end,
}
