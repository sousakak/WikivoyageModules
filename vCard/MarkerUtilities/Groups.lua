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
	showAll = "Maske,Track,Aktivität,Anderes,Anreise,Ausgehen,Aussicht,Besiedelt," ..
		"Fehler,Gebiet,Gesundheit,Kaufen,Küche,Natur,Religion,Sehenswert,Unterkunft," ..
		"aquamarinblau,cosmos,gold,hellgrün,orange,pflaumenblau,rot,silber,violett",

	groups = {
		["error"]   = { color = "#FF00FF", is = "system", label = "Fehler", alias = "magenta" },
		mask        = { color = "#FF00FF", is = "system", label = "Maske" },
		track       = { color = "#FF00FF", is = "system", label = "Track" },

		area        = { color = "#800000", label = "Gebiet", default = "region", alias = "maroon" },
		buy         = { color = "#008080", label = "Kaufen", default = "shop", alias = "teal" },
		["do"]      = { color = "#808080", label = "Aktivität", default = "sports", alias = "grey", withEvents = "1" },
		drink       = { color = "#2F4F4F", label = "Ausgehen", default = "bar", alias = "darkslategray" },
		eat         = { color = "#D2691E", label = "Küche", default = "restaurant", alias = "chocolate" },
		go          = { color = "#A52A2A", label = "Anreise", default = "station", alias = "brown" },
		health      = { color = "#DC143C", label = "Gesundheit", default = "hospital", alias = "crimson" },
		nature      = { color = "#228B22", label = "Natur", default = "landscape", alias = "forestgreen" },
		other       = { color = "#808000", label = "Anderes", default = "office", alias = "olive" },
		populated   = { color = "#0000FF", label = "Besiedelt", default = "town", alias = "blue" },
		religion    = { color = "#DAA520", label = "Religion", default = "church", alias = "goldenrod", inverse = "1" },
		see         = { color = "#4682B4", label = "Sehenswert", default = "monument", alias = "steelblue" },
		sleep       = { color = "#000080", label = "Unterkunft", default = "hotel", alias = "navy" },
		view        = { color = "#4169E1", label = "Aussicht", default = "viewpoint", alias = "royalblue" },

		-- please do not use colors already used for additional groups listed above

		cosmos      = { color = "#FFCFCF", is = "color", label = "cosmos", inverse = "1" }, -- instead of former type target, FFCCCC
		gold        = { color = "#FFD700", is = "color", label = "gold", inverse = "1" },
		lime        = { color = "#BFFF00", is = "color", label = "hellgrün", inverse = "1" },
		mediumaquamarine = { color = "#66CDAA", is = "color", label = "aquamarinblau" },
		orange      = { color = "#FFA500", is = "color", label = "orange", inverse = "1" },
		plum        = { color = "#DDA0DD", is = "color", label = "pflaumenblau" },
		purple      = { color = "#800080", is = "color", label = "violett" },
		red         = { color = "#FF0000", is = "color", label = "rot" },
		silver      = { color = "#C0C0C0", is = "color", label = "silber", inverse = "1" }
	}
}