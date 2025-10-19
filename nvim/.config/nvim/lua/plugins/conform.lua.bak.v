return {
	"stevearc/conform.nvim",
	lazy = false,
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				vue = { "eslint_d" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				lua = { "stylua" },
			},
			formatters = {
				eslint = {
					-- use your global eslint (or set to Mason path)
					command = "eslint",
					args = { "--fix-dry-run", "--stdin", "--stdin-filename", "$FILENAME" },
					stdin = true,
					-- no cwd/condition -> no ctx -> no health crash
				},
			},
			format_on_save = { lsp_fallback = true, async = false, timeout_ms = 3000 },
		})

		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({ lsp_fallback = true, async = false, timeout_ms = 3000 })
		end, { desc = "Format" })
	end,
}
