local command = vim.api.nvim_create_user_command
local map = vim.keymap.set
local acmd = vim.api.nvim_create_autocmd

command("PersistenceLoad", function()
	require("persistence").load()
end, {})

acmd("FileType", {
	pattern = "oil",
	callback = function()
		map("n", "q", "<cmd>lua require('oil').close()<cr>", { buffer = true })
	end,
})
