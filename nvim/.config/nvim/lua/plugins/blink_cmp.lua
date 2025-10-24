local function link(name, target)
	vim.api.nvim_set_hl(0, name, { link = target })
end

return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts = {
		keymap = {
			preset = "super-tab",
			["<C-n>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
			use_nvim_cmp_as_default = true,
		},

		signature = { enabled = true },

		completion = {
			documentation = { auto_show = true },
			ghost_text = {
				enabled = false,
				show_with_menu = false,
			},
			menu = {
				border = "rounded",
				auto_show = true,
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind", "source_name" },
					},
					components = {
						kind_icon = {
							highlight = function(ctx)
								return { { group = ctx.kind_hl, priority = 2001 } }
							end,
						},
					},
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)

		link("BlinkCmpMenuSelection", "CursorLine") -- selected item
		vim.api.nvim_create_autocmd("ColorScheme", { callback = ensure_selection_hl })
	end,

	opts_extend = { "sources.default" },
}
