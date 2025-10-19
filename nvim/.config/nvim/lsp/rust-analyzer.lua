return {
	cmd = { "rust-analyzer" },
	root_markers = { "Cargo.lock" },
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
        allTargets = true,
        features = "all",
        extraArgs = { "--tests" },
			},
			diagnostics = {
				enable = true,
        experimental = { enable = true },

			},
		},
	},
	-- capabilities = vim.tbl_deep_extend(
	--     "force",
	--     {},
	--     vim.lsp.protocol.make_client_capabilities(),
	--     blink.get_lsp_capabilities(),
	--     {
	--         fileOperations = {
	--             didRename = true,
	--             willRename = true,
	--         },
	--     }
	-- ),
}
