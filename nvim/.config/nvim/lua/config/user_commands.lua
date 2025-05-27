local command = vim.api.nvim_create_user_command

command("PersistenceLoad", function()
	require("persistence").load()
end, {})
