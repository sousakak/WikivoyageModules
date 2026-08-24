--[[

░██████╗████████╗░█████╗░██╗░░░░░██╗░██████╗████████╗
██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║██╔════╝╚══██╔══╝
╚█████╗░░░░██║░░░███████║██║░░░░░██║╚█████╗░░░░██║░░░
░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░╚═══██╗░░░██║░░░
██████╔╝░░░██║░░░██║░░██║███████╗██║██████╔╝░░░██║░░░
╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░

	Maintainer: Tmv@ja.wikivoyage.org
	Repository: https://github.com/sousakak/WikivoyageModules/tree/master/transportation

    ----------

    features: 
        main    (func) : same as "stalist"

        stalist (func) : create a list of stations in the train route.
            title               (args) : The title of the table (Default: `{{BASICPAGENAME}}`)
            wikidata            (args) : Wikidata ID of the route (Default: Wikidata ID for the current page)
            color               (args) : Color of the bottom border of the title (Default: `rgb(200, 204, 209)`)
            1, 2, ...           (args) : Set Wikidata id of each stations and this can also contains a customized image
                                            and name of the station if needed. These args must be in order,
                                            and don't remove "Q" in the initial.
            image1, image2, ... (args) : Optional. Retrieved from Wikidata by default
            name1, name2, ...   (args) : Optional. Retrieved from Wikidata by default
            tfr1, tfr2, ...     (args) : Optional. Retrieved from Wikidata by default
            spot1, spot2 ...    (args) : Spots around the station; watch out for the order
]]
local p = {
    moduleInterface = {
		suite  = 'Stalist',
		serial = '2026-08-24',
		item   = 58187507
	}
}
local getArgs = require( 'Module:Arguments' ).getArgs
local BASICPAGENAME = require( 'Module:BASICPAGENAME' ).BASICPAGENAME
local tu = require( 'Module:Transportation utilities' )
local wu = require( 'Module:Wikidata utilities' )

--[[ i18n ]]--
local i18n = {
    css = '駅一覧/styles.css',
    header_num = "駅番号",
    header_name = "駅名",
    header_tfr = "乗り換え路線",
    header_spot = "周辺のスポット",
    property_num = "P154",
    property_tfr = {"P81", "P1192"},
    property_filter = "P642",
    err_nowditem = "ウィキデータIDが指定されていません",
    err_wrongid = "$1番目のウィキデータIDが不正です"
}

--[[ utility functions ]]--
---@param tbl table
---@param item *
---@return boolean
local function contains( tbl, item )
    for _, v in pairs( tbl ) do
        if type( item ) == 'table' then
            for _, i in ipairs( item ) do
                if i == item then return i == item end
            end
        else
            if v == item then return true end
        end
    end
    return false
end

--[[ main functions ]]--
function p.main(frame)
    return p.stalist(frame)
end

function p.stalist(frame)
    local args = getArgs(frame)
    local title = args.title or BASICPAGENAME
    local route = tu.Train(mw.wikibase.getEntityIdForCurrentPage())

    local wikitext = mw.html.create()
        :wikitext( frame:extensionTag{ name = 'templatestyles', args = {src = i18n.css} } ):done()
        :tag( "table" ):addClass( "wikitable voy-stalist" )
            :tag( "tr" ):addClass( "voy-stalist-row" )
                :tag( "th" )
                    :attr( "colspan", 4 )
                    :addClass( "wikitable voy-stalist-title" )
                    :css( "border-bottom-color", args.color )
                    :wikitext( title )
                    :done()
                :done()
            :tag( "tr" ):addClass( "voy-stalist-row" )
                :tag( "th" ):wikitext( i18n.header_name ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_tfr ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_spot ):addClass( "wikitable voy-stalist-header" ):done()
                :done()
    if args[1] ~= nil then
        local i = 1
        while args[i] ~= nil do
            --[[ define vars ]]--
            local qid = (mw.wikibase.isValidEntityId(args[i]) and args[i])
                        or error(string.gsub(i18n.err_wrongid, "$1", i)) -- Wikidata id
            local sta = tu.TrainStation( qid )
            local staname = args["name" .. i] or sta:getName()
            local function checkLine(statement) return statement["qualifiers"][i18n.property_filter][1]["datavalue"]["value"]["id"] end
            local criterion = args.wikidata or route.id
            local value_tfr = args["tfr" .. i] or ""
            local tfr_table = {}

            --[[ get data from Wikidata ]]--
            if value_tfr == "" then
                for p = 1, #i18n.property_tfr do
                    local statements = sta:getValues( i18n.property_tfr[p], 3 )
                    if statements[1] ~= nil then
                        for j = 1, #statements do
                            local tfr_id = statements[j]["mainsnak"]["datavalue"]["value"]["id"]
                            local tfr_text
                            if tfr_id ~= criterion and not contains( tfr_table, tfr_id ) then
                                value_tfr = value_tfr .. wu.getLabel( tfr_id ) .. "、"
                                table.insert( tfr_table, tfr_id )
                            end
                        end
                    end
                end
                if value_tfr then value_tfr = mw.ustring.sub(value_tfr, 1, mw.ustring.len(value_tfr) - 1) end -- remove the last punctuation mark
            end
            wikitext = wikitext:tag( "tr" ):addClass( "voy-stalist-unit voy-stalist-row" )
                :tag( "td" ):wikitext( staname ):done()
                :tag( "td" ):wikitext( value_tfr ):done()
                :tag( "td" ):wikitext( args["spot" .. i] ):done()
                :done()
            i = i + 1
        end
    else
        for i, sta in route.stations do
            wikitext = wikitext:tag( "tr" ):addClass( "voy-stalist-unit voy-stalist-row" )
                :tag( "td" ):wikitext( sta:getLinkText() ):done()
                :tag( "td" ):wikitext( args["tfr" .. i] ):done()
                :tag( "td" ):wikitext( args["spot" .. i] ):done()
                :done()
        end
    end
    wikitext = wikitext:done()
    return wikitext
end

return p
