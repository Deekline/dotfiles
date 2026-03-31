local function resolve_tsdk(root_dir)
	if root_dir then
		local local_tsdk = root_dir .. "/node_modules/typescript/lib"
		if vim.fn.isdirectory(local_tsdk) == 1 then
			return local_tsdk
		end
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

local function resolve_vue_plugin(root_dir)
	local candidates = {}

	if root_dir then
		table.insert(candidates, root_dir .. "/node_modules/@vue/language-server")
	end

	table.insert(
		candidates,
		vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
	)

	for _, path in ipairs(candidates) do
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
	end

	return nil
end

local vue_plugin_path = resolve_vue_plugin(vim.fn.getcwd())
	or vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

return {
	cmd = { "vtsls", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	single_file_support = true,
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_plugin_path,
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
		typescript = {
			validate = { enable = true },
			tsserver = {
				useSyntaxServer = "auto",
				nodePath = "/Users/myemets/.nvm/versions/node/v24.14.1/bin/node",
				maxTsServerMemory = 4096,
				watchOptions = "vscode",
				enableRegionDiagnostics = true,
			},
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
	before_init = function(params, config)
		local root_dir = config.root_dir
		if not root_dir and params.rootUri then
			root_dir = vim.uri_to_fname(params.rootUri)
		end

		local tsdk = resolve_tsdk(root_dir)
		if tsdk then
			config.settings.vtsls.typescript = config.settings.vtsls.typescript or {}
			config.settings.vtsls.typescript.globalTsdk = tsdk
		end

	end,
	on_attach = function(client, bufnr)
		if vim.bo[bufnr].filetype == "vue" then
			vim.lsp.semantic_tokens.stop(bufnr, client.id)
		end
	end,
	init_options = {
		hostInfo = "neovim",
	},
}
