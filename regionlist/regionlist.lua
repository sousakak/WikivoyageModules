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
local mFileLink = require( 'Module:File_link' )
local coord = require( 'Module:Coordinates' ).toDec

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
			- self.size   string: (default: 350px)
			- self.text   string: (default: "{{BASEPAGENAME}}の地図")

			vars
            - self.file mw.title: A title object of the file page.
            - self.size   string: File size; 350px in default. Please note the type (string).
            - self.text   string: The caption text of the map. By default, this is mapDefaultDesc in i18n.
			- self.name   string: Name of the map. Not contain a namespace prefix.

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
            local wikitext = mFileLink._main(
                file = self.file.fullText,
                format = "thumb",
                location = config.settings.mapAlign,
                size = self.size,
                caption = self.text,
                class = "mw-file-element"
            )
			return wikitext
		end
        return obj
	end
	if entity ~= nil then existWikidata = true else existWikidata = false end
	if yesno(args.mapframe) == true then
		if args.mapframelat ~= nil or args.mapframelong ~= nil then
			if args.mapframelat ~= nil then maps[lat] = coord(args.mapframelat, "", 6).dec else error(config.error.coordNotFound .. "lat") end
			if args.mapframelong ~= nil then maps[long] = coord(args.mapframelong, "", 6).dec else error(config.error.coordNotFound .. "long") end
		elseif existWikidata and entity:getBestStatements('P625')[1] ~= nil then
			maps[lat] = entity:getBestStatements('P625')[1].mainsnak.datavalue.value.latitude
			maps[long] = entity:getBestStatements('P625')[1].mainsnak.datavalue.value.longitude
		end
		maps[zoom] = args.mapframezoom or "auto"
		maps[width] = args.mapframewidth or ""
		maps[height] = args.mapframeheight or ""
    else
        maps = nil
	end
	if args.regionmap ~= nil then
		mapfile = mw.title.new( args.regionmap, 6 )
		if mapfile.file.exists() then
			staticImage = staticMap.new(mapfile, args.regionmapsize, args.regionmaptext)
		else
			error(config.error.mapNotFound)
		end
    else
        staticImage = nil
	end
	return maps, staticImage
end

function p.region_to_table(args)
	local result = {}

	for i = 1, #args do
		local name, color, items, description = "region" .. tostring(i) .. "name", "region" .. tostring(i) .. "color", "region" .. tostring(i) .. "items", "region" .. tostring(i) .. "description"
		if args[name] ~= nil then
			result[i] = {
				name        = args[name],
				color       = args[color],
				items       = args[items],
				description = args[description]
			}
        else
            if args["region" .. tostring(i + 1) .. "name"] ~= nil then error(config.error.intermittentRegionNum) end
            break
        end
	end
	return result
end

function p._regionlist(args)
    local regionlist = {}

	local maps, staticImage = p._maps(args)
    local regions = p.region_to_table(args)

    if maps ~= nil then
        regionlist[dynamic] = true
        regionlist[lat] = maps.lat
        regionlist[long] = maps.long
        regionlist[mapZoom] = maps.zoom
        regionlist[mapWidth] = maps.width
        regionlist[mapHeight] = maps.height
    else
        regionlist[dynamic] = false
    end
    if staticImage ~= nil then
        regionlist[static] = true
        regionlist[mapImage] = staticImage.name
        regionlist[mapCaption] = staticImage.text
        regionlist[mapImageSize] = staticImage.size
    else
        regionlist[static] = false
    end
    -- 以下 Regionlist
end

function p.regionlist(frame)
	local args = getArgs(frame, {
		wrappers = config.settings.wrapperTemplate,
		noOverwrite = true
	})
	p._regionlist(args)
end

return p