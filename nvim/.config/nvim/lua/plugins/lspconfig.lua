return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				map("gr", vim.lsp.buf.rename, "[R]e[n]ame")
				map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
				map("K", function()
					vim.lsp.buf.hover({
						border = "rounded",
						winhighlight = "Normal:LspHover,FloatBorder:LspHoverBorder",
					})
				end, "Hover with background")

				---@param client vim.lsp.Client
				---@param method vim.lsp.protocol.Method
				---@param bufnr? integer some lsp support methods only in specific files
				---@return boolean
				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client.supports_method(method, { bufnr = bufnr })
					end
				end
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if
					client
					and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local util = require("lspconfig.util")

		local _snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
		_snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true
		local snippet_capabilities = vim.tbl_extend("keep", capabilities, _snippet_capabilities)

		local function tsdk(root_dir)
			local global_ts = "/Users/myemets/.nvm/versions/node/v18.9.1/lib/node_modules/typescript/lib"
			local found_ts = ""
			if root_dir then
				found_ts = table.concat({ root_dir, "node_modules", "typescript", "lib" })
				if util.path.exists(found_ts) then
					return found_ts
				else
					return global_ts
				end
			else
				return global_ts
			end
		end

		local servers = {
			language_servers = {
				"awk_ls",
				"bashls",
				"docker_compose_language_service",
				"dockerls",
				"marksman",
				"sqlls",
				"yamlls",
				"volar",
				"gopls",
				"ts_ls",
				"cssls",
				"lua_ls",
			},
			html = {
				capabilities = snippet_capabilities,
				filetypes = { "html" },
			},
			cssls = {
				capabilities = snippet_capabilities,
				filetypes = { "scss, css" },
				settings = {
					css = { validate = true, lint = {
						unknownAtRules = "ignore",
					} },
					scss = { validate = true, lint = {
						unknownAtRules = "ignore",
					} },
					less = { validate = true, lint = {
						unknownAtRules = "ignore",
					} },
				},
			},
			cssmodules_ls = {
				filetypes = { "javascriptreact", "typescriptreact" },
			},
			ts_ls = {
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = "/Users/myemets/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
							languages = { "vue" },
						},
					},
					typescript = {
						tsdk = tsdk(),
					},
				},
				settings = {
					ts_ls = {
						configFile = "/Users/myemets/WebstormProjects/Macys/Vue/pdp/tsconfig.json",
					},
				},
			},
			volar = {
				cmd = { "vue-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "scss" },
				root_dir = util.root_pattern("package.json"),
				init_options = {
					vue = {
						hybridMode = true,
					},
					typescript = {
						tsdk = "", -- This will be set dynamically in setup
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim", "require" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
						hint = {
							enable = true,
						},
					},
				},
			},
		}

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				["volar"] = function()
					require("lspconfig").volar.setup({
						cmd = { "vue-language-server", "--stdio" },
						filetypes = { "vue" },
						root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
						capabilities = vim.tbl_deep_extend("force", {}, capabilities, servers.volar.capabilities or {}),
						init_options = {
							vue = {
								hybridMode = false,
							},
						},
						on_new_config = function(new_config, new_root_dir)
							-- Dynamically set TypeScript SDK path
							if not new_config.init_options then
								new_config.init_options = {}
							end

							if not new_config.init_options.typescript then
								new_config.init_options.typescript = {}
							end

							-- Find TypeScript SDK dynamically
							new_config.init_options.typescript.tsdk = tsdk(new_root_dir)

							-- Set jsconfig path if needed
							if not new_config.init_options.javascript then
								new_config.init_options.javascript = {}
							end

							local jsconfig_path = table.concat({ new_root_dir, "jsconfig.json" })
							if vim.uv.fs_stat(jsconfig_path) then
								new_config.init_options.javascript.jsconfig = jsconfig_path
							end
						end,
					})
				end,

				-- Default handler for other servers
				function(server_name)
					if server_name ~= "volar" then -- Skip volar as we handle it separately
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end
				end,
			},
		})
	end,
}
