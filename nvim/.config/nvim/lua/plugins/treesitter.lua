local config = function()
	local opts = {
		install_dir = vim.fn.stdpath("data") .. "/site",
		ensure_installed = {
			"angular",
			"awk",
			"bash",
			"c",
			"cpp",
			"css",
			"csv",
			"dockerfile",
			"fish",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"html",
			"http",
			"javascript",
			"jq",
			"json",
			"jsonc",
			"lua",
			"luap",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"ruby",
			"scheme",
			"scss",
			"sql",
			"toml",
			"typescript",
			"vim",
			"vimdoc",
			"vue",
			"yaml",
			"tsx",
		},
		highlight = {
			enable = true,
		},
		matchup = {
			enable = true,
		},
		{
			context_commentstring = {
				enable = true,
				enable_autocmd = true,
			},
		},
		textobjects = {
			lsp_interop = {
				enable = true,
				border = "rounded",
				floating_preview_opts = {},
			},
			move = {
				enable = true,
				set_jumps = true,
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@call.outer",
					["ic"] = "@call.inner",
					["aC"] = "@class.outer",
					["iC"] = "@class.inner",
					["ib"] = "@parameter.inner",
					["ab"] = "@parameter.outer",
					["iB"] = "@block.inner",
					["aB"] = "@block.outer",
					["id"] = "@block.inner",
					["ad"] = "@block.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["ia"] = "@attribute.inner",
					["aa"] = "@attribute.outer",
				},
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				node_incremental = "v",
				node_decremental = "V",
				init_selection = "<C-y>",
			},
		},
	}


  require("nvim-treesitter").setup(opts)

	-- nvim-treesitter v1 removed the highlight module; start treesitter manually per buffer
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	})

	vim.treesitter.language.register("markdown", "octo")
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = config,
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-treesitter/nvim-treesitter-context",
			{
				"bennypowers/template-literal-comments.nvim",
				-- `opts = true` calls setup() unguarded; nvim-treesitter being
				-- `lazy = false` means this dependency can get eager-loaded *and*
				-- loaded again via its own `ft` trigger, calling setup() twice.
				-- Its setup() registers a treesitter directive without
				-- `force = true`, so the second call errors. pcall it away.
				config = function()
					pcall(require("template-literal-comments").setup)
				end,
				ft = {
					"javascript",
					"typescript",
				},
				enabled = true,
			},
		},
	},
}
