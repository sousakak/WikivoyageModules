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

function p._regionlist(args)
    entity = mw.wikibase.getEntityIdForCurrentPage()
    if entity ~= nil then existWikidata = true else existWikidata = false end
    if yesno(args.mapframe) == true then
        maps = {}
        --[[
            maps = {
                lat = (string, mayn't be there),
                long = (string, mayn't be there),
                zoom = (string, default: "auto"),
                width = (string, default: ""),
                height = (string, default: "")
            }
        ]]
        if args.mapframelat ~= nil or args.mapframelong ~= nil then
            if args.mapframelat ~= nil then maps[lat] = coord(args.mapframelat, "", 6).dec else error(config.error.coordNotFound + "lat") end
            if args.mapframelong ~= nil then maps[long] = coord(args.mapframelong, "", 6).dec else error(config.error.coordNotFound + "long") end
        else if existWikidata and entity:getBestStatements('P625')[1] ~= nil then
            maps[lat] = entity:getBestStatements('P625')[1].mainsnak.datavalue.value.latitude
            maps[long] = entity:getBestStatements('P625')[1].mainsnak.datavalue.value.longitude
        end
        maps[zoom] = args.mapframezoom or "auto"
        maps[width] = args.mapframewidth or ""
        maps[height] = args.mapframeheight or ""

        if args.regionmap ~= nil then
            --
        end
    end
end

function p.regionlist(frame)
    local args = getArgs(frame)
    p._regionlist(args)
end

return p