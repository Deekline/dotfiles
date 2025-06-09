local fns = require("config/functions")
local m = fns.lazy_map

return {
	"CKolkey/ts-node-action",
	opts = {},
	keys = {
		m("<leader>i", [[lua require("ts-node-action").node_action()]], {}, { desc = "TS node action" }),
	},
}
