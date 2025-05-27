local opts = {
	ensure_installed = {
		"angularls",
		"bashls",
		"cssls",
		"cssmodules_ls",
		"diagnosticls",
		"docker_compose_language_service",
		"dockerls",
		"emmet_ls",
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
	},
	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
