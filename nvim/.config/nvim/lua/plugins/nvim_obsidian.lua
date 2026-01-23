local obsidian_key_defs = {
	-- key suffix, Obsidian sub command, description
	{ "b", "backlinks", "[b]acklinks" },
	{ "d", "dailies", "[d]ailies" },
	{ "j", "today", "[j]in tian (today)" },
	{ "l", "links", "[l]inks" },
	{ "m", "tomorrow", "[m]ing tian (tomorrow)" },
	{ "r", "rename", "[r]ename" },
	{ "t", "tags", "[t]ags" },
	{ "o", "open", "[o]pen" },
	{ "w", "workspace", "[w]orkspace" },
	{ "z", "yesterday", "[z]uo tian (yesterday)" },
}
local obsidian_keys = {}
for _, def in ipairs(obsidian_key_defs) do
	table.insert(obsidian_keys, {
		"<Localleader>o" .. def[1],
		"<Cmd>Obsidian " .. def[2] .. "<CR>",
		desc = "[o]bsidian " .. def[3],
		ft = "markdown",
	})
end

return {

	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"saghen/blink.cmp",
		},
		opts = {
			workspaces = {
				{
					name = "Deekline",
					path = "/Users/myemets/Library/Mobile Documents/iCloud~md~obsidian/Documents/Deekline",
				},
			},

			notes_subdir = "inbox",
			new_notes_location = "notes_subdir",
			frontmatter = { enabled = false },

			completion = {
				nvim_cmp = false,
				blink = true,
				min_chars = 0,
			},
			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				substitutions = {},
			},

			keys = obsidian_keys,

			attachments = {
				img_folder = "Attachemnts/",
			},
			ui = {
				enable = false,
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons", "saghen/blink.cmp" },
		opts = {
			file_types = { "markdown", "codecompanion", "quarto" },
			-- WARN: completion via blink potentially impairs other LSP completions!
			completions = { lsp = { enabled = true } },
			win_options = { conceallevel = { rendered = 2 } },
		},
	},

	--	{
	--		"iamcco/markdown-preview.nvim",
	--		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	--		build = function()
	--			vim.fn["mkdp#util#install"]()
	--		end,
	--		init = function()
	--			vim.g.mkdp_filetypes = { "markdown" }
	--		end,
	--		ft = { "markdown" },
	--	},
}
