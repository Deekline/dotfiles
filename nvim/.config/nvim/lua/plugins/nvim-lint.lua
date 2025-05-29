return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		-- Configure linters
		lint.linters_by_ft = {
			vue = { "eslint" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			lua = { "stylua" },
		}
		-- Create a custom eslint linter that handles the "Brand mcom used" output
		lint.linters.eslint = vim.tbl_deep_extend("force", lint.linters.eslint, {
			args = {
				"--format",
				"json",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
				"--resolve-plugins-relative-to",
				"/Users/myemets/.nvm/versions/node/v18.20.5/lib/node_modules/@core/vue-cli",
			},
			parser = function(output, bufnr, cwd)
				-- Remove the "Brand mcom used" line and any other non-JSON content
				local json_start = output:find("%[")
				if json_start then
					local clean_output = output:sub(json_start)
					-- Use the original eslint parser with cleaned output
					return require("lint.linters.eslint").parser(clean_output, bufnr, cwd)
				else
					-- If no JSON found, return empty diagnostics
					return {}
				end
			end,
		})
		-- Set up autocommands
		vim.api.nvim_create_autocmd({
			"BufEnter", -- When entering a buffer
			"BufWritePost", -- After saving (to catch any remaining issues after formatting)
			"InsertLeave", -- When leaving insert mode (i → n)
			"TextChanged", -- When text changes in normal mode (x, dd, etc.)
			"TextChangedI", -- When text changes in insert mode (typing)
		}, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
		-- Manual linting keymap
		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting" })
	end,
}
