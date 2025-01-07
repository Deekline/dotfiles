local u = require("util")
local ufo_u = require("util.ufo")
local m = u.lazy_map

local scale = u.screen_scale({ height = 0.65 })

local opts = {
	fold_virt_text_handler = require("util.ufo").handler,
	preview = {
		win_config = {
			maxheight = scale.height,
			winhighlight = "Normal:Folded",
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
		},
	},
	close_fold_kinds_for_ft = {
		typescript = {
			"imports",
			"comment",
		},
		vue = {},
	},
}

local lua_ufo = function(ufo_cmd)
	return [[lua require("ufo").]] .. ufo_cmd .. [[()]]
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	event = "VeryLazy",
	opts = opts,
	init = function()
		ufo_u.set_opts()
	end,
	keys = {
		m("zR", lua_ufo("openAllFolds"), {}, { desc = "Open all folds" }),
		m("zM", lua_ufo("closeAllFolds"), {}, { desc = "Close all folds" }),
		m("zr", lua_ufo("openFoldsExceptKinds"), {}, { desc = "Open Folds except kinds" }),
		m("zm", lua_ufo("closeFoldsWith"), {}, { desc = "Close folds with" }),
		m("]z", lua_ufo("goNextClosedFold"), {}, { desc = "Go next Closed Fold" }),
		m("[z", lua_ufo("goPreviousClosedFold"), {}, { desc = "Go previous closed fold" }),
		m("<leader>O", "UfoToggleFold", {}, { desc = "Fold toggle" }),
		m("\\", "FoldParagraph", {}, { desc = "Fold paragraph" }),
	},
	enabled = true,
}
