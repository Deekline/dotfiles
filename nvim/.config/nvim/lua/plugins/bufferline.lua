return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional but nice
	keys = {
		{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
	},
	opts = {
		options = {
			close_command = function(n)
				vim.api.nvim_buf_delete(n, { force = false })
			end,
			right_mouse_command = function(n)
				vim.api.nvim_buf_delete(n, { force = false })
			end,

			diagnostics = "nvim_lsp",
			always_show_bufferline = false,

			diagnostics_indicator = function(_, _, diag)
				local icons = { error = " ", warning = " " } -- requires a Nerd Font for best look
				local ret = (diag.error and diag.error > 0 and (icons.error .. diag.error .. " ") or "")
					.. (diag.warning and diag.warning > 0 and (icons.warning .. diag.warning) or "")
				return ret
			end,
		},
	},

	config = function(_, opts)
		require("bufferline").setup(opts)

		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.cmd.redrawtabline()
			end,
		})
	end,
}
