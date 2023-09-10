local p = {}

local template = "テンプレート:rd" -- name of the template

local function pickup(number)
    local content = mw.title.new( template .. '/' .. tostring(number) ).getContent()
    local title = string.match( content , "{{.-|title=(.-)[\n ]-|sentences=.-}}" )
    local banner = mw.wikibase.getBestStatements(mw.wikibase.getEntityIdForTitle( title ), 'P948')[1].mainsnak.datavalue.value
    local text = string.match( content , "{{.-|sentences=(.-)[\n ]-}}" )
    return {banner, text}
end

function p._rd(frame)
	local base = mw.title.new( template )
    local infos = {}
	local subpages = -1
	repeat
        if subpages ~= -1 then
            table.insert(infos, pickup(subpages))
        end
		subpages = subpages + 1 -- start from 0 (Template:rd/0)
	until not(mw.title.new( template .. '/' .. tostring(i) ).exists)
    return infos -- infos = {{banner1, text1}, {banner2, text2} ... }
end

function p.rd(frame)
    local infos = p._rd(frame)
    local wikitext = '<gallery mode="slideshow" caption="[[Wikivoyage:おすすめの旅行先|おすすめの旅行先]]" class="mainpage-content">'
    for i = 1, #infos do
        wkitext = wikitext .. infos[i][1] .. '|' .. infos[i][2] .. '\n'
        i = i + 1
    end
    wikitext = wikitext .. '</gallery>'
    return wikitext
end

return p
