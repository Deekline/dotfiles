-- plugins/nvim-lint.lua
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Use project-local eslint if available; fall back to global
		local function eslint_cmd()
			local buf = vim.api.nvim_buf_get_name(0)
			local root = vim.fs.dirname(vim.fs.find({
				"eslint.config.js",
				"eslint.config.cjs",
				"eslint.config.mjs",
				"eslint.config.ts",
				"package.json",
				".git",
			}, { upward = true, path = buf })[1] or buf)
			local local_bin = root and (root .. "/node_modules/.bin/eslint") or nil
			if local_bin and vim.fn.executable(local_bin) == 1 then
				return local_bin
			end
			return "eslint"
		end

		-- Configure builtin eslint linter
		local eslint = lint.linters.eslint
		eslint.cmd = eslint_cmd
		eslint.stdin = true
		eslint.ignore_exitcode = true
		eslint.env = { ESLINT_USE_FLAT_CONFIG = "true" } -- << flat config
		eslint.args = {
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		lint.linters_by_ft = {
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" },
			typescriptreact = { "eslint" },
			vue = { "eslint" },
		}

		-- Manual commands to verify status
		vim.api.nvim_create_user_command("LintNow", function()
			lint.try_lint() -- run eslint on current buffer
		end, {})

		vim.api.nvim_create_user_command("LintStatus", function()
			local diags = vim.diagnostic.get(0)
			print(("eslint diagnostics in buffer: %d"):format(#diags))
			for _, d in ipairs(diags) do
				print(
					("[%s] %s:%d:%d %s"):format(
						(d.source or "eslint"),
						(d.code or "?"),
						(d.lnum + 1),
						(d.col + 1),
						d.message
					)
				)
			end
		end, {})

		-- (Optional) run automatically on common events
		vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
