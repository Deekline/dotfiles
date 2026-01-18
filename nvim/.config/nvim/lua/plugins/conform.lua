return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- Web development
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				-- Use the "*" filetype to run formatters on all filetypes
				["*"] = { "trim_whitespace" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},

			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" }, -- 2 spaces indentation
				},
			},
		})

		-- Keybindings
		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({
				lsp_format = "fallback",
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
