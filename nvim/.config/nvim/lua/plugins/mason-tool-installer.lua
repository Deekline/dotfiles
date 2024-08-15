local opts = {
	auto_update = true,
	run_on_start = true,
	ensure_installed = {
		-- "beautysh",
		"codespell",
		-- "cspell",
		-- "editorconfig-checker",
		{ "eslint_d", version = "v13.1.2" },
		-- "hadolint",
		-- "jsonlint",
		-- "luacheck",
		-- "markdownlint",
		-- "misspell",
		-- "oxlint",
		"prettierd",
		-- "shellcheck",
		-- "shellharden",
		-- "shfmt",
		"stylua",
		-- "yamlfmt",
	},
}

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = opts,
	cmd = "MasonToolsUpdate",
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
