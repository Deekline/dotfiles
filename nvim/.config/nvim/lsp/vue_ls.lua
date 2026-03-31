return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	init_options = {
		vue = {
			hybridMode = true,
		},
	},
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
			if #clients == 0 then
				vim.notify("Could not find vtsls client, vue_ls will not work properly.", vim.log.levels.WARN)
				return
			end
			local ts_client = clients[1]
			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward",
				command = "typescript.tsserverRequest",
				arguments = { command, payload },
			}, { bufnr = context.bufnr }, function(_, r)
				local response = r and r.body
				client:notify("tsserver/response", { { id, response } })
			end)
		end
	end,
}
