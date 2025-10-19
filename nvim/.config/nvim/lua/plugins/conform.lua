return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = function()
		local util = require("conform.util")
		return {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				vue = { "prettierd" },
				json = { "prettierd" },
				markdown = { "prettierd" },
				yaml = { "prettierd" },
			},
			formatters = {
				prettierd = {
					-- run from project root so it finds your .prettierrc / package.json
					cwd = util.root_file({
						".prettierrc",
						".prettierrc.json",
						".prettierrc.yml",
						".prettierrc.yaml",
						".prettierrc.js",
						".prettierrc.cjs",
						"prettier.config.js",
						"prettier.config.cjs",
						"package.json",
						".git",
					}),
					-- do NOT set PRETTIERD_LOCAL_PRETTIER_ONLY unless you’re 100% sure
					-- a local prettier is installed. We already installed it in step 1.
				},
			},
			format_on_save = { lsp_fallback = false, timeout_ms = 3000 },
		}
	end,
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = false, lsp_fallback = false })
			end,
			desc = "Format file",
		},
	},
}
