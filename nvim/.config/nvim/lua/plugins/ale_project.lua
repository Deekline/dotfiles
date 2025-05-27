
return {
	"dense-analysis/ale",
	lazy = false,
	config = function()
		local g = vim.g
		g.ale_ruby_rubocop_auto_correct_all = 1
		g.ale_set_highlights = 0
		g.ale_disable = 0

		-- Configure linters
		g.ale_linters = {
			lua = { "stylua" },
			vue = { "volar", "eslint" },
		}

		g.ale_fixers = {
			vue = { "eslint" },
			javascript = { "eslint" },
			typescript = { "eslint" },
		}

		g.ale_javascript_eslint_executable = "eslint_d"
		g.ale_javascript_eslint_options =
			"--stdin --stdin-filename %s --format json --resolve-plugins-relative-to /Users/myemets/.nvm/versions/node/v18.20.5/lib/node_modules/@core/vue-cli"

		-- Configure eslint_d for fixing
		g.ale_javascript_eslint_use_global = 1
		g.ale_vue_eslint_executable = "eslint_d"
		g.ale_vue_eslint_options =
			"--resolve-plugins-relative-to /Users/myemets/.nvm/versions/node/v18.20.5/lib/node_modules/@core/vue-cli"

		g.ale_fix_on_save = 1

		-- Define ALE linters by filetype
		vim.cmd([[
			 autocmd BufEnter *.vue let b:ale_linters = ['eslint', 'volar']
			autocmd BufEnter *.vue let b:ale_fixers = ['eslint']
		]])

		-- Enable ALE globally
		vim.cmd("ALEEnable")
	end,
}
