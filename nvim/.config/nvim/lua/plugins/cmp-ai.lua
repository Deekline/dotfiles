return {
	"tzachar/cmp-ai",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local cmp_ai = require("cmp_ai")
		cmp_ai.setup({
			max_lines = 100,
			provider = "Anthropic",
			provider_options = {
				model = "claude-3-7-sonnet-20250219", -- or claude-sonnet-4-20250514
				api_key = os.getenv("ANTHROPIC_API_KEY"),
			},
			notify = true,
			notify_callback = function(msg)
				vim.notify(msg, vim.log.levels.INFO)
			end,
			run_on_every_keystroke = false,
			ignored_file_types = {
				"neorepl",
				"neoai-input", 
				"NeogitCommitMessage",
				"oil",
			},
		})
	end,
}
