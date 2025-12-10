-- Function to get TypeScript SDK path (prefer local, fallback to global)
local function get_typescript_sdk()
	local local_sdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
	if vim.fn.isdirectory(local_sdk) == 1 then
		return local_sdk
	end

	-- Try global installation
	local global_root = vim.fn.system("npm root -g"):gsub("\n", ""):gsub("\r", "")
	local global_sdk = global_root .. "/typescript/lib"
	if vim.fn.isdirectory(global_sdk) == 1 then
		return global_sdk
	end

	-- If both fail, return nil to let vue-language-server find it automatically
	return nil
end

local function get_capabilities()
	-- blink.cmp is lazy-loaded on LspAttach; add core completion bits even if it's not available yet
	local base = vim.lsp.protocol.make_client_capabilities()
	-- ensure snippet/resolve support so Vue/TS completions work
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

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	on_init = function(client)
		-- Forward tsserver requests to an actual TS server (ts-ls / vtsls / typescript-tools)
		local retries = 0

		local function typescript_handler(_, result, context)
			local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })[1]
				or vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })[1]
				or vim.lsp.get_clients({ bufnr = context.bufnr, name = "typescript-tools" })[1]

			if not ts_client then
				if retries <= 10 then
					retries = retries + 1
					vim.defer_fn(function()
						typescript_handler(_, result, context)
					end, 100)
				else
					vim.notify(
						"vue_ls: could not find ts_ls, vtsls, or typescript-tools to handle TS features",
						vim.log.levels.ERROR
					)
				end
				return
			end

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward",
				command = "typescript.tsserverRequest",
				arguments = { command, payload },
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r and r.body } }
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify("tsserver/response", response_data)
			end)
		end

		client.handlers["tsserver/request"] = typescript_handler
	end,
	init_options = {
		vue = {
			hybridMode = false, -- Disable for inlay hints support
		},
		-- Only set typescript config if we have a valid TypeScript installation
		--		typescript = get_typescript_sdk()
		--				and {
		--					tsdk = get_typescript_sdk(),
		--					inlayHints = {
		--						enumMemberValues = { enabled = true },
		--						functionLikeReturnTypes = { enabled = true },
		--						propertyDeclarationTypes = { enabled = true },
		--						parameterNames = {
		--							enabled = "all", -- "none" | "literals" | "all"
		--							suppressWhenArgumentMatchesName = true,
		--						},
		--						variableTypes = {
		--							enabled = true,
		--							suppressWhenTypeMatchesName = true,
		--						},
		--					},
		--				}
		--			or nil,
	},
	settings = {
		typescript = {
			inlayHints = {
				enumMemberValues = {
					enabled = true,
				},
				functionLikeReturnTypes = {
					enabled = true,
				},
				propertyDeclarationTypes = {
					enabled = true,
				},
				parameterTypes = {
					enabled = true,
					suppressWhenArgumentMatchesName = true,
				},
				variableTypes = {
					enabled = true,
				},
			},
		},
	},
	capabilities = get_capabilities(),
}
