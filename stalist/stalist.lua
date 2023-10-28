--[[

███╗░░░███╗░█████╗░██████╗░██╗░░░██╗██╗░░░░░███████╗██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░██████╗████████╗
████╗░████║██╔══██╗██╔══██╗██║░░░██║██║░░░░░██╔════╝╚═╝██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║██╔════╝╚══██╔══╝
██╔████╔██║██║░░██║██║░░██║██║░░░██║██║░░░░░█████╗░░░░░╚█████╗░░░░██║░░░███████║██║░░░░░██║╚█████╗░░░░██║░░░
██║╚██╔╝██║██║░░██║██║░░██║██║░░░██║██║░░░░░██╔══╝░░░░░░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░╚═══██╗░░░██║░░░
██║░╚═╝░██║╚█████╔╝██████╔╝╚██████╔╝███████╗███████╗██╗██████╔╝░░░██║░░░██║░░██║███████╗██║██████╔╝░░░██║░░░
╚═╝░░░░░╚═╝░╚════╝░╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝╚═════╝░░░░╚═╝░░░

	Maintainer: Tmv@ja.wikivoyage.org
	Repository: https://github.com/sousakak/WikivoyageModules/tree/master/stalist
]]
local p = {}
local getArgs = require( 'Module:Arguments' ).getArgs
local title = require( 'Module:BASICPAGENAME' ).BASICPAGENAME
local fileLink = require( 'Module:File_link' )._main

-- i18n
local i18n = {
    css = '駅一覧/styles.css',
    header_num = "駅番号",
    header_name = "駅名",
    header_tfr = "乗り換え路線",
    header_spot = "周辺のスポット",
    property_num = "P154",
    property_tfr = {"P81", "P1192"},
    unexpected_value = "列目のデータが不正です"
}

function p.main(frame)
    return p.stalist(frame)
end

function p.stalist(frame)
    local args = getArgs(frame)
    local titletext = args.title or title(frame)

    local wikitext = mw.html.create()
        :wikitext( frame:extensionTag{ name = 'templatestyles', args = {src = i18n.css} } ):done()
        :tag( "table" ):addClass( "wikitable voy-stalist" )
            :tag( "tr" )
                :tag( "th" )
                    :attr( "colspan", 4 )
                    :addClass( "wikitable voy-stalist-title" )
                    :css( "border-bottom-color", args.color )
                    :wikitext( titletext )
                    :done()
                :done()
            :tag( "tr" )
                :tag( "th" ):wikitext( i18n.header_num ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_name ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_tfr ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_spot ):addClass( "wikitable voy-stalist-header" ):done()
                :done()
    i = 1
    if args[i] ~= nil then
        while args[i] ~= nil do
            local qid = args[i]
            local item = mw.wikibase.getEntity(qid) -- this is expensive and possibly stop by $wgExpensiveParserFunctionLimit
            local value_num
            local value_tfr = ""

            if item["claims"][i18n.property_num] ~= nil then
                value_num = fileLink{
                    file    = item["claims"][i18n.property_num][1]["mainsnak"]["datavalue"]["value"],
                    size    = "50px",
                    link    = "",
                    caption = item:getLabel('ja')
                }
            else
                value_num = ""
            end
            for p = 1, #i18n.property_tfr do
            	if item["claims"][i18n.property_tfr[p]] ~= nil then
	                for value = 1, #item["claims"][i18n.property_tfr[p]] do
	                    value_tfr = value_tfr .. item["claims"][i18n.property_tfr[p]][value]["mainsnak"]["datavalue"]["value"]["id"] .. "、"
    	            end
    	        end
            end
            value_tfr = value_tfr[#value_tfr - 1] -- remove the last punctuation mark
            wikitext = wikitext:tag( "tr" )
                :tag( "td" ):wikitext( value_num ):done()
                :tag( "td" ):wikitext( item:getLabel('ja') ):done()
                :tag( "td" ):wikitext( value_tfr ):done()
                :tag( "td" ):wikitext( args["spot" .. i] ):done()
                :done()
            i = i + 1
        end
    end
    wikitext = wikitext:done()
    return wikitext
end

return p
