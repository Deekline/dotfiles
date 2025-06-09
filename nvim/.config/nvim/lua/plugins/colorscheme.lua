--return {
--	"rebelot/kanagawa.nvim",
--	config = function()
--		require("kanagawa").setup({
--			compile = true,
--			transparent = true,
--			overrides = function(colors)
--				local theme = colors.theme
--				local makeDiagnosticColor = function(color)
--					local c = require("kanagawa.lib.color")
--					return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
--				end
--
--				return {
--					NormalFloat = { bg = "none" },
--					FloatBorder = { bg = "none" },
--					FloatTitle = { bg = "none" },
--					SignColumn = { bg = "NONE" },
--					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
--					-- Popular plugins that open floats will link to NormalFloat by default;
--					-- set their background accordingly if you wish to keep them dark and borderless
--					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
--					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
--					LineNr = { bg = "NONE" },
--					CursorLineNr = { bg = "NONE" }, -- Treesitter context transparency
--					TreesitterContext = { bg = "NONE" },
--					TreesitterContextLineNumber = { bg = "NONE" },
--					TreesitterContextSeparator = { bg = "NONE" },
--				}
--			end,
--		})
--		vim.cmd("colorscheme kanagawa")
--		vim.cmd("highlight TelescopeBorder guibg=none")
--		vim.cmd("highlight TelescopeTitle guibg=none")
--	end,
--	build = function()
--		vim.cmd("KanagawaCompile")
--	end,
--}
return {
	"olimorris/onedarkpro.nvim",
	priority = 1000, -- Ensure it loads first
	config = function()
		require("onedarkpro").setup({
			-- Theme variant
			theme = "onedark", -- Use the standard onedark variant

			-- Transparency and options
			options = {
				cursorline = false,
				transparency = true,
				terminal_colors = true,
				lualine_transparency = true,
				highlight_inactive_windows = false,
			},

			-- Custom color overrides for more pastel look
			colors = {
				-- Make syntax colors more pastel/muted
				red = "#E06C75", -- Softer red (default: #e86671)
				green = "#98C379", -- Softer green (default: #98c379)
				yellow = "#E5C07B", -- Softer yellow (default: #e5c07b)
				blue = "#61AFEF", -- Softer blue (default: #61afef)
				purple = "#C678DD", -- Softer purple (default: #c678dd)
				cyan = "#56B6C2", -- Softer cyan (default: #56b6c2)
				orange = "#D19A66", -- Softer orange (default: #d19a66)

				-- UI colors - make them more muted
				comment = "#7C7C7C", -- Lighter, more muted comments
				gray = "#9CA3AF", -- Softer gray
			},

			-- Style configurations - reduce intensity
			styles = {
				types = "NONE",
				methods = "NONE",
				numbers = "NONE",
				strings = "NONE",
				comments = "italic",
				keywords = "NONE",
				constants = "NONE",
				functions = "NONE",
				operators = "NONE",
				variables = "NONE",
				parameters = "NONE",
				conditionals = "NONE",
				virtual_text = "NONE",
			},

			-- Custom highlights (equivalent to your Kanagawa overrides)
			highlights = {
				-- Float and border transparency
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE" },
				FloatTitle = { bg = "NONE" },

				-- Sign column transparency
				SignColumn = { bg = "NONE" },

				-- Line numbers transparency
				LineNr = { bg = "NONE" },
				CursorLineNr = { bg = "NONE" },

				-- Plugin-specific highlights (using transparent background)
				MasonNormal = { bg = "NONE" },
				LazyNormal = { bg = "NONE" },

				-- Treesitter context transparency
				TreesitterContext = { bg = "NONE" },
				TreesitterContextLineNumber = { bg = "NONE" },
				TreesitterContextSeparator = { bg = "NONE" },

				-- Telescope transparency
				TelescopeBorder = { bg = "NONE" },
				TelescopeTitle = { bg = "NONE" },
				TelescopeNormal = { bg = "NONE" },
				TelescopePreviewNormal = { bg = "NONE" },
				TelescopePromptNormal = { bg = "NONE" },
				TelescopeResultsNormal = { bg = "NONE" },

				-- Additional transparency for common UI elements
				Pmenu = { bg = "NONE" },
				PmenuSel = { bg = "NONE" },
				PmenuSbar = { bg = "NONE" },
				PmenuThumb = { bg = "NONE" },
			},
		})

		-- Load the colorscheme
		vim.cmd("colorscheme onedark")
	end,
}
