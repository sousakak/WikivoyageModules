
local p = {}
local getArgs = require( 'Module:Arguments' ).getArgs
local title = require( 'Module:BASICPAGENAME' ).BASICPAGENAME

/* i18n */
local i18n = {
    css = '駅一覧/styles.css',
    header_num = "駅番号",
    header_name = "駅名",
    header_tfr = "乗り換え路線",
    header_spot = "周辺のスポット",
    unexpected_value = "列目のデータが不正です"
}

local function split(str, div)
    if div == nil then return {str} end

    local result = {} ;
    local i = 1
    for unit in string.gmatch( str, '([^' .. div .. ']+)' ) do
        result[i] = unit
        i = i + 1
    end

    return result
end

function p.main(frame)
    local args = getArgs(frame)

    local wikitext = mw.html.create()
        :wikitext( frame:extensionTag{ name = 'templatestyles', args = {src = i18n.css} } ):done()
        :tag( "table" ):addClass( "wikitable voy-stalist" )
            :tag( "tr" )
                :tag( "th" )
                    :attr( "colspan", 4 )
                    :addClass( "wikitable voy-stalist-title" )
                    :css( "border-bottom-color", args.color )
                    :wikitext( args.title or title )
                    :done()
                :done()
            :tag( "tr" )
                :tag( "th" ):wikitext( i18n.header_num ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_name ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_tfr ):addClass( "wikitable voy-stalist-header" ):done()
                :tag( "th" ):wikitext( i18n.header_spot ):addClass( "wikitable voy-stalist-header" ):done()
                :done()
            for i = 1, args[i] ~= nil do
                local datas = split(args[i], ",")
                if datas[4] == nil then
                    error( i .. i18n.unexpected_value )
                end
                wikitext = wikitext:tag( "tr" )
                    :tag( "td" ):wikitext( datas[1] ):done()
                    :tag( "td" ):wikitext( datas[2] ):done()
                    :tag( "td" ):wikitext( datas[3] ):done()
                    :tag( "td" ):wikitext( datas[4] ):done()
                    :done()
            end
        wikitext = wikitext:done()
    return wikitext
end

return p
