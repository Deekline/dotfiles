return {
	"stevearc/conform.nvim",
	lazy = false,
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				vue = { "eslint_d" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
			},

			-- Configure eslint_d (which supports fixing via stdin)
			formatters = {
				eslint_d = {
					command = "eslint_d",
					args = {
						"--fix-to-stdout",
						"--stdin",
						"--stdin-filename",
						"$FILENAME",
						"--resolve-plugins-relative-to",
						"/Users/myemets/.nvm/versions/node/v18.20.5/lib/node_modules/@core/vue-cli",
					},
					stdin = true,
				},
			},

			-- Format on save
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
		})

		-- Manual formatting keymap
		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			})
		end, { desc = "Format file or range" })
	end,
}
