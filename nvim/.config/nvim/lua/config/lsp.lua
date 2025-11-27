local acmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

vim.lsp.enable({
	"lua-ls",
	"gopls",
	"ts-ls",
	"rust-analyzer",
	"tailwindcss",
	"html-ls",
	"css-ls",
	"vue-ls",
	--"vtsls",
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

-- extras --
local MAX_HINT_LEN = 40 -- adjust as you like

local default_inlay_handler = vim.lsp.handlers["textDocument/inlayHint"]

vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
	if result and ctx and ctx.client_id then
		local client = vim.lsp.get_client_by_id(ctx.client_id)

		-- Only truncate for TS / Vue (adjust names to match :LspInfo)
		local truncate_for = {
			["ts-ls"] = true,
			["typescript-language-server"] = true,
			["vue-ls"] = true,
			["vue-language-server"] = true,
		}

		if client and truncate_for[client.name] then
			for _, hint in ipairs(result) do
				local label = hint.label

				-- label can be string or array of parts
				local full = ""
				if type(label) == "string" then
					full = label
				elseif type(label) == "table" then
					for _, part in ipairs(label) do
						full = full .. (part.value or "")
					end
				end

				if #full > MAX_HINT_LEN then
					local truncated = full:sub(1, MAX_HINT_LEN - 3) .. "..."

					if type(label) == "string" then
						hint.label = truncated
					else
						-- keep it simple: single part
						hint.label = { { value = truncated } }
					end
				end
			end
		end
	end

	return default_inlay_handler(err, result, ctx, config)
end

local function go_to_source()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	local client
	for _, c in ipairs(clients) do
		if
			c.name == "ts-ls"
			or c.name == "typescript-language-server"
			or c.name == "vue-ls"
			or c.name == "vue-language-server"
		then
			client = c
			break
		end
	end
	if not client then
		return
	end

	local pos = vim.api.nvim_win_get_cursor(0)

	client.request("workspace/executeCommand", {
		command = "_typescript.goToSourceDefinition",
		arguments = {
			vim.uri_from_bufnr(bufnr),
			{ line = pos[1] - 1, character = pos[2] },
		},
	}, function(_, result)
		if result and result[1] then
			vim.lsp.util.jump_to_location(result[1], "utf-8")
		end
	end, bufnr)
end

acmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local tele = require("telescope.builtin")
		map({ "n" }, "gd", tele.lsp_definitions, { buffer = ev.buffer, desc = "LSP: Go to definitions" })
		map({ "n" }, "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP reference" })
		map({ "n" }, "<leader>gs", go_to_source, { buffer = ev.buffer, desc = "Go to source" })
		map({ "n" }, "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go to Implementation" })
		map({ "n" }, "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})

local function restart_lsp(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		vim.cmd("edit")
	end, 100)
end

local function lsp_status()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("󰅚 No LSP clients attached")
		return
	end

	print("󰒋 LSP Status for buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
		print("  Root: " .. (client.config.root_dir or "N/A"))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Check capabilities
		local caps = client.server_capabilities
		local features = {}
		if caps.completionProvider then
			table.insert(features, "completion")
		end
		if caps.hoverProvider then
			table.insert(features, "hover")
		end
		if caps.definitionProvider then
			table.insert(features, "definition")
		end
		if caps.referencesProvider then
			table.insert(features, "references")
		end
		if caps.renameProvider then
			table.insert(features, "rename")
		end
		if caps.codeActionProvider then
			table.insert(features, "code_action")
		end
		if caps.documentFormattingProvider then
			table.insert(features, "formatting")
		end

		print("  Features: " .. table.concat(features, ", "))
		print("")
	end
end

command("LspStatus", lsp_status, { desc = "Show detailed LSP status" })

local function check_lsp_capabilities()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("No LSP clients attached")
		return
	end

	for _, client in ipairs(clients) do
		print("Capabilities for " .. client.name .. ":")
		local caps = client.server_capabilities

		local capability_list = {
			{ "Completion", caps.completionProvider },
			{ "Hover", caps.hoverProvider },
			{ "Signature Help", caps.signatureHelpProvider },
			{ "Go to Definition", caps.definitionProvider },
			{ "Go to Declaration", caps.declarationProvider },
			{ "Go to Implementation", caps.implementationProvider },
			{ "Go to Type Definition", caps.typeDefinitionProvider },
			{ "Find References", caps.referencesProvider },
			{ "Document Highlight", caps.documentHighlightProvider },
			{ "Document Symbol", caps.documentSymbolProvider },
			{ "Workspace Symbol", caps.workspaceSymbolProvider },
			{ "Code Action", caps.codeActionProvider },
			{ "Code Lens", caps.codeLensProvider },
			{ "Document Formatting", caps.documentFormattingProvider },
			{ "Document Range Formatting", caps.documentRangeFormattingProvider },
			{ "Rename", caps.renameProvider },
			{ "Folding Range", caps.foldingRangeProvider },
			{ "Selection Range", caps.selectionRangeProvider },
		}

		for _, cap in ipairs(capability_list) do
			local status = cap[2] and "✓" or "✗"
			print(string.format("  %s %s", status, cap[1]))
		end
		print("")
	end
end

command("LspCapabilities", check_lsp_capabilities, { desc = "Show LSP capabilities" })

local function lsp_diagnostics_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

	for _, diagnostic in ipairs(diagnostics) do
		local severity = vim.diagnostic.severity[diagnostic.severity]
		counts[severity] = counts[severity] + 1
	end

	print("󰒡 Diagnostics for current buffer:")
	print("  Errors: " .. counts.ERROR)
	print("  Warnings: " .. counts.WARN)
	print("  Info: " .. counts.INFO)
	print("  Hints: " .. counts.HINT)
	print("  Total: " .. #diagnostics)
end

command("LspDiagnostics", lsp_diagnostics_info, { desc = "Show LSP diagnostics count" })

local function lsp_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	print("═══════════════════════════════════")
	print("           LSP INFORMATION          ")
	print("═══════════════════════════════════")
	print("")

	-- Basic info
	print("󰈙 Language client log: " .. vim.lsp.get_log_path())
	print("󰈔 Detected filetype: " .. vim.bo.filetype)
	print("󰈮 Buffer: " .. bufnr)
	print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
	print("")

	if #clients == 0 then
		print("󰅚 No LSP clients attached to buffer " .. bufnr)
		print("")
		print("Possible reasons:")
		print("  • No language server installed for " .. vim.bo.filetype)
		print("  • Language server not configured")
		print("  • Not in a project root directory")
		print("  • File type not recognized")
		return
	end

	print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s", i, client.name))
		print("  ID: " .. client.id)
		print("  Root dir: " .. (client.config.root_dir or "Not set"))
		print("  Command: " .. table.concat(client.config.cmd or {}, " "))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Server status
		if client.is_stopped() then
			print("  Status: 󰅚 Stopped")
		else
			print("  Status: 󰄬 Running")
		end

		-- Workspace folders
		if client.workspace_folders and #client.workspace_folders > 0 then
			print("  Workspace folders:")
			for _, folder in ipairs(client.workspace_folders) do
				print("    • " .. folder.name)
			end
		end

		-- Attached buffers count
		local attached_buffers = {}
		for buf, _ in pairs(client.attached_buffers or {}) do
			table.insert(attached_buffers, buf)
		end
		print("  Attached buffers: " .. #attached_buffers)

		-- Key capabilities
		local caps = client.server_capabilities
		local key_features = {}
		if caps.completionProvider then
			table.insert(key_features, "completion")
		end
		if caps.hoverProvider then
			table.insert(key_features, "hover")
		end
		if caps.definitionProvider then
			table.insert(key_features, "definition")
		end
		if caps.documentFormattingProvider then
			table.insert(key_features, "formatting")
		end
		if caps.codeActionProvider then
			table.insert(key_features, "code_action")
		end

		if #key_features > 0 then
			print("  Key features: " .. table.concat(key_features, ", "))
		end

		print("")
	end

	-- Diagnostics summary
	local diagnostics = vim.diagnostic.get(bufnr)
	if #diagnostics > 0 then
		print("󰒡 Diagnostics Summary:")
		local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

		for _, diagnostic in ipairs(diagnostics) do
			local severity = vim.diagnostic.severity[diagnostic.severity]
			counts[severity] = counts[severity] + 1
		end

		print("  󰅚 Errors: " .. counts.ERROR)
		print("  󰀪 Warnings: " .. counts.WARN)
		print("  󰋽 Info: " .. counts.INFO)
		print("  󰌶 Hints: " .. counts.HINT)
		print("  Total: " .. #diagnostics)
	else
		print("󰄬 No diagnostics")
	end

	print("")
	print("Use :LspLog to view detailed logs")
	print("Use :LspCapabilities for full capability list")
end

-- Create command
command("LspInfo", lsp_info, { desc = "Show comprehensive LSP information" })

local function lsp_status_short()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		return "" -- Return empty string when no LSP
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return "󰒋 " .. table.concat(names, ",")
end

local function git_branch()
	local ok, handle = pcall(io.popen, "git branch --show-current 2>/dev/null")
	if not ok or not handle then
		return ""
	end
	local branch = handle:read("*a")
	handle:close()
	if branch and branch ~= "" then
		branch = branch:gsub("\n", "")
		return " 󰊢 " .. branch
	end
	return ""
end

local function formatter_status()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return ""
	end

	local formatters = conform.list_formatters_to_run(0)
	if #formatters == 0 then
		return ""
	end

	local formatter_names = {}
	for _, formatter in ipairs(formatters) do
		table.insert(formatter_names, formatter.name)
	end

	return "󰉿 " .. table.concat(formatter_names, ",")
end

local function linter_status()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return ""
	end

	local linters = lint.linters_by_ft[vim.bo.filetype] or {}
	if #linters == 0 then
		return ""
	end

	return "󰁨 " .. table.concat(linters, ",")
end
-- Safe wrapper functions for statusline
local function safe_git_branch()
	local ok, result = pcall(git_branch)
	return ok and result or ""
end

local function safe_lsp_status()
	local ok, result = pcall(lsp_status_short)
	return ok and result or ""
end

local function safe_formatter_status()
	local ok, result = pcall(formatter_status)
	return ok and result or ""
end

local function safe_linter_status()
	local ok, result = pcall(linter_status)
	return ok and result or ""
end

_G.git_branch = safe_git_branch
_G.lsp_status = safe_lsp_status
_G.formatter_status = safe_formatter_status
_G.linter_status = safe_linter_status

-- THEN set the statusline
vim.opt.statusline = table.concat({
	"%{v:lua.git_branch()}", -- Git branch
	"%f", -- File name
	"%m", -- Modified flag
	"%r", -- Readonly flag
	"%=", -- Right align
	"%{v:lua.linter_status()}", -- Linter status
	"%{v:lua.formatter_status()}", -- Formatter status
	"%{v:lua.lsp_status()}", -- LSP status
	" %l:%c", -- Line:Column
	" %p%%", -- Percentage through file
}, " ")
