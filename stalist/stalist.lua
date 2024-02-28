--[[

░██████╗████████╗░█████╗░██╗░░░░░██╗░██████╗████████╗
██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║██╔════╝╚══██╔══╝
╚█████╗░░░░██║░░░███████║██║░░░░░██║╚█████╗░░░░██║░░░
░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░╚═══██╗░░░██║░░░
██████╔╝░░░██║░░░██║░░██║███████╗██║██████╔╝░░░██║░░░
╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░

	Maintainer: Tmv@ja.wikivoyage.org
	Repository: https://github.com/sousakak/WikivoyageModules/tree/master/stalist

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
            spot1, spot2 ...    (args) : Spots around the station; watch out for the order
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

local function split(str, ts)
    if ts == nil then return {} end
    local table = {}
    i = 1
    for piece in string.gmatch(str, '([^' .. ts .. ']+)') do
        table[i] = piece
        i = i + 1
    end
    return table
end

--[[ main functions ]]--
function p.main(frame)
    return p.stalist(frame)
end

function p.stalist(frame)
    local args = getArgs(frame)
    local titletext = args.title or mw.title.getCurrentTitle().text

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
        local qid = string.match(args[i], "^[Qq]%d+$") or error(string.gsub(i18n.err_wrongid, "$1", i)) -- Wikidata id
        local item = mw.wikibase.getEntity(qid) -- this is expensive
        local staimage = args["image" .. i] or nil
        local staname = args["name" .. i] or item:getLabel('ja')
        local value_num
        local function checkLine(statement) return statement["qualifiers"][i18n.property_filter][1]["datavalue"]["value"]["id"] end
        local criterion = args.wikidata or mw.wikibase.getEntityIdForCurrentPage()
        local value_tfr = ""
        local tfr_table = {}

        --[[ get data from Wikidata ]]--
        if staimage ~= nil then
            value_num = fileLink {
                file    = staimage,
                size    = "50px",
                link    = "",
                caption = staname
            }
            break
        elseif item:getBestStatements(i18n.property_num) ~= nil then
            for f = 1, tableLength(item:getBestStatements(i18n.property_num)) do -- check the each value of the logo image
                local err, value = pcall( -- if the value has P642 in its qualifiers: (true, value); if not: (false, error message)
                    checkLine,
                    item:getBestStatements(i18n.property_num)[f]
                )
                if err and value == criterion then
                    value_num = fileLink {
                        file    = item:getBestStatements(i18n.property_num)[f]["mainsnak"]["datavalue"]["value"],
                        size    = "50px",
                        link    = "",
                        caption = staname
                    }
                    break
                elseif #item:getBestStatements(i18n.property_num) == 1 then
                    value_num = fileLink {
                        file    = item:getBestStatements(i18n.property_num)[1]["mainsnak"]["datavalue"]["value"],
                        size    = "50px",
                        link    = "",
                        caption = staname
                    }
                    break
                end
            end
        else
            value_num = ""
        end
        local tfr_num = 0
        for p = 1, tableLength(i18n.property_tfr) do
            if item:getBestStatements(i18n.property_tfr[p]) ~= nil then
                for value = 1, tableLength(item:getBestStatements(i18n.property_tfr[p])) do
                    local tfr_id = item:getBestStatements(i18n.property_tfr[p])[value]["mainsnak"]["datavalue"]["value"]["id"]
                    local tfr_text
                    if tfr_id ~= criterion then
                        if tfr_table[tfr_id] ~= nil then
                            tfr_text = tfr_table[tfr_id]
                        else
                            tfr_text = mw.wikibase.getEntity(tfr_id):getLabel( mw.language.getContentLanguage():getCode() )
                            tfr_table[tfr_id] = tfr_text
                        end
                        value_tfr = value_tfr .. tfr_text .. "、"
                    end
                end
            end
            tfr_num = p
        end
        if value_tfr then value_tfr = mw.ustring.sub(value_tfr, 1, mw.ustring.len(value_tfr) - 1) end -- remove the last punctuation mark
        wikitext = wikitext:tag( "tr" ):addClass( "voy-stalist-unit voy-stalist-row" )
            :tag( "td" ):wikitext( value_num ):done()
            :tag( "td" ):wikitext( staname ):done()
            :tag( "td" ):wikitext( value_tfr ):done()
            :tag( "td" ):wikitext( args["spot" .. i] ):done()
            :done()
        i = i + 1
    end
    wikitext = wikitext:done()
    return wikitext
end

return p
