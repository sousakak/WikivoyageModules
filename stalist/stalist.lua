--[[

███╗░░░███╗░█████╗░██████╗░██╗░░░██╗██╗░░░░░███████╗██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░██████╗████████╗
████╗░████║██╔══██╗██╔══██╗██║░░░██║██║░░░░░██╔════╝╚═╝██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║██╔════╝╚══██╔══╝
██╔████╔██║██║░░██║██║░░██║██║░░░██║██║░░░░░█████╗░░░░░╚█████╗░░░░██║░░░███████║██║░░░░░██║╚█████╗░░░░██║░░░
██║╚██╔╝██║██║░░██║██║░░██║██║░░░██║██║░░░░░██╔══╝░░░░░░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░╚═══██╗░░░██║░░░
██║░╚═╝░██║╚█████╔╝██████╔╝╚██████╔╝███████╗███████╗██╗██████╔╝░░░██║░░░██║░░██║███████╗██║██████╔╝░░░██║░░░
╚═╝░░░░░╚═╝░╚════╝░╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░

	Maintainer: Tmv@ja.wikivoyage.org
	Repository: https://github.com/sousakak/WikivoyageModules/tree/master/stalist

    ----------

    features: 
        main    (func) : same as "stalist"

        stalist (func) : create a list of stations in the train route.
            title            (args) : the title of the table (Default: `{{BASICPAGENAME}}`)
            wikidata         (args) : Wikidata ID of the route (Default: Wikidata ID for the current page)
            color            (args) : color of the bottom border of the title (Default: `rgb(200, 204, 209)`)
            1, 2, ...        (args) : set Wikidata id of each stations. These must be in order, and don't remove "Q" in the initial
            spot1, spot2 ... (args) : spots around the station; watch out for the order
]]
local p = {}
local getArgs = require( 'Module:Arguments' ).getArgs
local title = require( 'Module:BASICPAGENAME' ).BASICPAGENAME
local fileLink = require( 'Module:File_link' )._main

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
local function tableLength(tbl)
    local n = 0
    for _ in pairs (tbl) do
        n = n + 1
    end
    return n
end

--[[ main functions ]]--
function p.main(frame)
    return p.stalist(frame)
end

function p.stalist(frame)
    local args = getArgs(frame)
    local titletext = args.title or title(frame)

    local wikitext = mw.html.create()
        :wikitext( frame:extensionTag{ name = 'templatestyles', args = {src = i18n.css} } ):done()
        :tag( "table" ):addClass( "wikitable voy-stalist" )
            :tag( "tr" ):addClass( "voy-stalist-row" )
                :tag( "th" )
                    :attr( "colspan", 4 )
                    :addClass( "wikitable voy-stalist-title" )
                    :css( "border-bottom-color", args.color )
                    :wikitext( titletext )
                    :done()
                :done()
            :tag( "tr" ):addClass( "voy-stalist-row" )
                :tag( "th" ):wikitext( i18n.header_num ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_name ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_tfr ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_spot ):addClass( "wikitable voy-stalist-header" ):done()
                :done()
    assert( args[1], i18n.err_nowditem )
    i = 1
    while args[i] ~= nil do

        --[[ define vars ]]--
        local qid = string.match(args[i], "^[Qq]%d+$") or error(string.gsub(i18n.err_wrongid, "$1", i)) -- check the arg
        local item = mw.wikibase.getEntity(qid) -- this is expensive and possibly stop by $wgExpensiveParserFunctionLimit
        local value_num
        local function checkLine(statement) return statement["qualifiers"][i18n.property_filter][1]["datavalue"]["value"]["id"] end
        local criterion = args.wikidata or mw.wikibase.getEntityIdForCurrentPage()
        local value_tfr = ""

        --[[ get data from Wikidata ]]--
        if item:getBestStatements(i18n.property_num) ~= nil then
            for f = 1, tableLength(item:getBestStatements(i18n.property_num)) do -- check the each value of the logo image
                local err, value = pcall( -- if the value has P642 in its qualifiers: (true, value); if not: (false, error message)
                    checkLine,
                    item:getBestStatements(i18n.property_num)[1]
                )
                if err and value == criterion then
                    value_num = fileLink {
                        file    = item:getBestStatements(i18n.property_num)[f]["mainsnak"]["datavalue"]["value"],
                        size    = "50px",
                        link    = "",
                        caption = item:getLabel('ja')
                    }
                    break
                end
            end
        else
            value_num = ""
        end
        for p = 1, tableLength(i18n.property_tfr) do
            if item:getBestStatements(i18n.property_tfr[p]) ~= nil then
                for value = 1, tableLength(item:getBestStatements(i18n.property_tfr[p])) do
                    value_tfr = value_tfr .. item:getBestStatements(i18n.property_tfr[p])[value]["mainsnak"]["datavalue"]["value"]["id"] .. "、"
                end
            end
        end
        value_tfr = value_tfr[#value_tfr - 1] -- remove the last punctuation mark
        wikitext = wikitext:tag( "tr" ):addClass( "voy-stalist-unit voy-stalist-row" )
            :tag( "td" ):wikitext( value_num ):done()
            :tag( "td" ):wikitext( item:getLabel('ja') ):done()
            :tag( "td" ):wikitext( value_tfr ):done()
            :tag( "td" ):wikitext( args["spot" .. i] ):done()
            :done()
        i = i + 1
    end
    wikitext = wikitext:done()
    return wikitext
end

return p
