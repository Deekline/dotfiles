local function get_typescript_sdk()
	local local_sdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
	if vim.fn.isdirectory(local_sdk) == 1 then
		return local_sdk
	end

	local mason_tsdk = vim.fn.stdpath("data")
		.. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
	if vim.fn.isdirectory(mason_tsdk) == 1 then
		return mason_tsdk
	end

	local global_root = vim.fn.system("npm root -g"):gsub("\n", ""):gsub("\r", "")
	local global_tsdk = global_root .. "/typescript/lib"
	if vim.fn.isdirectory(global_tsdk) == 1 then
		return global_tsdk
	end

	return nil
end

local function get_capabilities()
	local base = vim.lsp.protocol.make_client_capabilities()
	base.textDocument.completion.completionItem.snippetSupport = true
	base.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits", "insertTextFormat", "insertTextMode" },
	}

	local ok, blink = pcall(require, "blink.cmp")
	if ok and blink.get_lsp_capabilities then
		return vim.tbl_deep_extend("force", {}, base, blink.get_lsp_capabilities())
	end
	return base
end

local tsdk = get_typescript_sdk()

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	init_options = {
		vue = {
			hybridMode = true,
		},

		typescript = tsdk and {
			tsdk = tsdk,
		} or nil,
	},
	settings = {
		typescript = {
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				parameterTypes = { enabled = true, suppressWhenArgumentMatchesName = true },
				variableTypes = { enabled = true },
			},
		},
	},
	capabilities = get_capabilities(),
}
