local opts = {
	ensure_installed = {
		"cssls",
		"cssmodules_ls",
		"diagnosticls",
		"eslint",
		"html",
		"jsonls",
		"lua_ls",
		"marksman",
		"sqlls",
		"tsserver",
		"volar",
		"yamlls",
		"gopls",
		"ts_ls",
		"vtsls",
	},
	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
