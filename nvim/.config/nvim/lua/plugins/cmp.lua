local is_not_buftype = function()
	local bt = vim.bo.buftype
	local exclude_bt = {
		"prompt",
		"nofile",
	}
	for _, v in pairs(exclude_bt) do
		if bt == v then
			return false
		end
	end
	return true
end

local is_not_comment = function()
	local context = require("cmp.config.context")
	return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
end

local is_not_filetype = function()
	local ft = vim.bo.filetype
	local exclude_ft = {
		"neorepl",
		"neoai-input",
		"NeogitCommitMessage",
		"oil",
	}
	for _, v in pairs(exclude_ft) do
		if ft == v then
			return false
		end
	end
	return true
end

local source_mapping = {
	nvim_lsp = "[LSP]",
	nvim_lua = "[LUA]",
	luasnip = "[SNIP]",
	buffer = "[BUF]",
	path = "[PATH]",
	treesitter = "[TREE]",
}

local config = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	cmp.setup({
		enabled = function()
			return is_not_comment() and is_not_buftype() and is_not_filetype()
		end,
		preselect = cmp.PreselectMode.Item,
		keyword_length = 2,
		--		snippet = {
		--			expand = function(args)
		--				require("luasnip").lsp_expand(args.body)
		--			end,
		--		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		view = {
			entries = {
				name = "custom",
				selection_order = "near_cursor",
				follow_cursor = true,
			},
		},
		mapping = {
			["<Tab>"] = cmp.mapping(function(fallback)
				-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if not entry then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					end
					cmp.confirm()
				else
					fallback()
				end
			end, { "i", "s", "c" }),
			["<C-n>"] = cmp.mapping.select_next_item({
				behavior = cmp.ConfirmBehavior.Insert,
			}),
			["<C-p>"] = cmp.mapping.select_prev_item({
				behavior = cmp.ConfirmBehavior.Insert,
			}),
			["<C-b>"] = cmp.mapping.scroll_docs(-5),
			["<C-f>"] = cmp.mapping.scroll_docs(5),
			["<C-q>"] = cmp.mapping.abort(),
		},
		sources = cmp.config.sources({
			--			{
			--				name = "luasnip",
			--				group_index = 1,
			--				option = { use_show_condition = true },
			--				entry_filter = function()
			--					local context = require("cmp.config.context")
			--					return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
			--				end,
			--			},
			{
				name = "nvim_lsp",
				group_index = 2,
			},
			{
				name = "nvim_lua",
				group_index = 3,
			},
			{
				name = "treesitter",
				keyword_length = 4,
				group_index = 4,
			},
			{
				name = "path",
				keyword_length = 4,
				group_index = 4,
			},
			{
				name = "buffer",
				keyword_length = 3,
				group_index = 5,
				option = {
					get_bufnrs = function()
						local bufs = {}
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							bufs[vim.api.nvim_win_get_buf(win)] = true
						end
						return vim.tbl_keys(bufs)
					end,
				},
			},
			{
				name = "lazydev",
				keyword_length = 2,
				group_index = 0,
			},
		}),
		---@diagnostic disable-next-line: missing-fields
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				ellipsis_char = "...",
				menu = source_mapping,
			}),
		},
		sorting = {
			priority_weight = 2,
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
	})
end

return {
	"hrsh7th/nvim-cmp",
	config = config,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"ray-x/cmp-treesitter",
		},
	},
}
