--[[
    
███╗░░░███╗░█████╗░██████╗░██╗░░░██╗██╗░░░░░███████╗██╗██████╗░███████╗░██████╗░██╗░█████╗░███╗░░██╗██╗░░░░░██╗░██████╗████████╗
████╗░████║██╔══██╗██╔══██╗██║░░░██║██║░░░░░██╔════╝╚═╝██╔══██╗██╔════╝██╔════╝░██║██╔══██╗████╗░██║██║░░░░░██║██╔════╝╚══██╔══╝
██╔████╔██║██║░░██║██║░░██║██║░░░██║██║░░░░░█████╗░░░░░██████╔╝█████╗░░██║░░██╗░██║██║░░██║██╔██╗██║██║░░░░░██║╚█████╗░░░░██║░░░
██║╚██╔╝██║██║░░██║██║░░██║██║░░░██║██║░░░░░██╔══╝░░░░░██╔══██╗██╔══╝░░██║░░╚██╗██║██║░░██║██║╚████║██║░░░░░██║░╚═══██╗░░░██║░░░
██║░╚═╝░██║╚█████╔╝██████╔╝╚██████╔╝███████╗███████╗██╗██║░░██║███████╗╚██████╔╝██║╚█████╔╝██║░╚███║███████╗██║██████╔╝░░░██║░░░
╚═╝░░░░░╚═╝░╚════╝░╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝╚═╝░░╚═╝╚══════╝░╚═════╝░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░

	Maintainer: Tmv@ja.wikivoyage.org
	Repository: https://github.com/sousakak/WikivoyageModules
]]
local p = {}
local getArgs = require( 'Module:Arguments' ).getArgs
local yesno = require( 'Module:Yesno' )
local config = require( 'Module:Regionlist/i18n' )
local coord = require( 'Module:Coordinates' ).toDec

local function rowargs(args)
	local result = {}
	local pattern = "arg%d+"

	for arg in pairs(args) do
		if string.match(arg, pattern) then
			result[ #result + 1 ] = arg
		end
	end
	return result
end

function p._maps(args)
	maps = {}
	--[[
		maps = {
			lat       string: mayn't be there
			long      string: mayn't be there
			zoom      string: (default: "auto")
			width     string: (default: "")
			height    string: (default: "")
		}
	]]
	entity = mw.wikibase.getEntityIdForCurrentPage()
	staticMap = {
		--[[
			staticMap
			- A pseudo class
			- stores the static map data

			args
			- self.file mw.title: Required
			- self.size string: (default: 350px)
			- self.text string: (default: "{{BASEPAGENAME}}の地図")

			vars
			- self.name string: Name of the map. Not contain a namespace prefix.

			funcs
			- self.getWikitext: Get a wikitext which show the map on the page.
		]]
	}
	staticMap.new = function(file, size, text)
		local obj = {}
		obj.file = file
		obj.size = size or "350px"
		obj.text = text or mw.ustring.gsub(config.settings.mapDefaultDesc, "$1", mw.title.getCurrentTitle().subpageText, 1)
		obj.name = self.file.text
		obj.getWikitext = function(self)
			return "[[" + self.file.fullText + "|thumb|" + config.settings.mapAlign + "|" + self.size + "|" + self.text + "]]"
		end
	end
	if entity ~= nil then existWikidata = true else existWikidata = false end
	if yesno(args.mapframe) == true then
		if args.mapframelat ~= nil or args.mapframelong ~= nil then
			if args.mapframelat ~= nil then maps[lat] = coord(args.mapframelat, "", 6).dec else error(config.error.coordNotFound + "lat") end
			if args.mapframelong ~= nil then maps[long] = coord(args.mapframelong, "", 6).dec else error(config.error.coordNotFound + "long") end
		elseif existWikidata and entity:getBestStatements('P625')[1] ~= nil then
			maps[lat] = entity:getBestStatements('P625')[1].mainsnak.datavalue.value.latitude
			maps[long] = entity:getBestStatements('P625')[1].mainsnak.datavalue.value.longitude
		end
		maps[zoom] = args.mapframezoom or "auto"
		maps[width] = args.mapframewidth or ""
		maps[height] = args.mapframeheight or ""
	end
	if args.regionmap ~= nil then
		mapfile = mw.title.new( args.regionmap, 6 )
		if mapfile.file.exists() then
			staticImage = staticMap.new(mapfile, args.regionmapsize, args.regionmaptext)
		else
			error(config.error.mapNotFound)
		end
	end
	return maps, staticImage
end

function p._regionlist(args)
	maps, staticImage = p._maps(args)
end

function p.regionlist(frame)
	local args = getArgs(frame, {
		wrappers = 'Template:Regionlist',
		noOverwrite = true
	})
	p._regionlist(args)
end

return p