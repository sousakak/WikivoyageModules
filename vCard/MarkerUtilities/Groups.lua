--[[
	Returning an array with group properties.
	Please use only quotation marks instead of apostrophs for JSON export.
	Please do not specify empty strings: let the parameter undefined.

	Dependencies:
	- MediaWiki:ListingInfo.js, makiIcons array
--]]

return {
	-- administration
	moduleInterface = {
		suite  = "Marker utilities",
		sub    = "groups",
		serial = "2023-05-06",
		item   = 65445315
	},

	-- Default mapframe/maplink show parameter
	-- also to set in MediaWiki:MapTools.js: defaultShow
	showAll = "エラー,マスク,トラック," ..
        "地域,買う,する,飲む,食べる,行く,健康を維持する,自然,その他,都市,信仰する,観る,泊まる,眺める," ..
		"珊瑚色,黄金色,若草色,翡翠色,蜜柑色,菖蒲色,葡萄色,赤色,銀色",

	groups = {
		["error"]   = { color = "#FF00FF", is = "system", label = "エラー", alias = "magenta" },
		mask        = { color = "#FF00FF", is = "system", label = "マスク" },
		track       = { color = "#FF00FF", is = "system", label = "トラック" },

		area        = { color = "#800000", label = "地域", default = "region", alias = "maroon" },
		buy         = { color = "#008080", label = "買う", default = "shop", alias = "teal" },
		["do"]      = { color = "#808080", label = "する", default = "sports", alias = "grey", withEvents = "1" },
		drink       = { color = "#2F4F4F", label = "飲む", default = "bar", alias = "darkslategray" },
		eat         = { color = "#D2691E", label = "食べる", default = "restaurant", alias = "chocolate" },
		go          = { color = "#A52A2A", label = "行く", default = "station", alias = "brown" },
		health      = { color = "#DC143C", label = "健康を維持する", default = "hospital", alias = "crimson" },
		nature      = { color = "#228B22", label = "自然", default = "landscape", alias = "forestgreen" },
		other       = { color = "#808000", label = "その他", default = "office", alias = "olive" },
		populated   = { color = "#0000FF", label = "都市", default = "town", alias = "blue" },
		religion    = { color = "#DAA520", label = "信仰する", default = "church", alias = "goldenrod", inverse = "1" },
		see         = { color = "#4682B4", label = "観る", default = "monument", alias = "steelblue" },
		sleep       = { color = "#000080", label = "泊まる", default = "hotel", alias = "navy" },
		view        = { color = "#4169E1", label = "眺める", default = "viewpoint", alias = "royalblue" },

		-- please do not use colors already used for additional groups listed above

		cosmos      = { color = "#FFCFCF", is = "color", label = "珊瑚色", inverse = "1" }, -- instead of former type target, FFCCCC
		gold        = { color = "#FFD700", is = "color", label = "黄金色", inverse = "1" },
		lime        = { color = "#BFFF00", is = "color", label = "若草色", inverse = "1" },
		mediumaquamarine = { color = "#66CDAA", is = "color", label = "翡翠色" },
		orange      = { color = "#FFA500", is = "color", label = "蜜柑色", inverse = "1" },
		plum        = { color = "#DDA0DD", is = "color", label = "菖蒲色" },
		purple      = { color = "#800080", is = "color", label = "葡萄色" },
		red         = { color = "#FF0000", is = "color", label = "赤色" },
		silver      = { color = "#C0C0C0", is = "color", label = "銀色", inverse = "1" }
	}
}