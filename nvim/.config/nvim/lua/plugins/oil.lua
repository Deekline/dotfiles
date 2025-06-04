return {
	"stevearc/oil.nvim",
	opts = {
		view_options = {
			show_hidden = true,
		},
		preview_win = {
			-- Whether the preview window is automatically updated when the cursor is moved
			update_on_cursor_moved = true,
			-- How to open the preview window "load"|"scratch"|"fast_scratch"
			preview_method = "fast_scratch",
			-- A function that returns true to disable preview on a file e.g. to avoid lag
			disable_preview = function(filename)
				return false
			end,
			-- Window-local options to use for preview window buffers
			win_options = {},
		},
	},
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } }, -- use if you prefer nvim-web-devicons
	lazy = false,
}
