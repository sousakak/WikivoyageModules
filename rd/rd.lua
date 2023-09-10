local p = {}

local template = 'テンプレート:rd' -- name of the template

function p.pickup(number)
    local content = mw.title.new( template .. '/' .. tostring(number) ):getContent()
    local title = string.match( content , "{{.-|title=(.-)[\n ]-|sentences=.-}}" )
    local banner = mw.wikibase.getBestStatements(mw.wikibase.getEntityIdForTitle( title ), 'P948')[1].mainsnak.datavalue.value
    local text = string.match( content , "{{.-|sentences=(.-)[\n ]-}}" )
    return {banner, text}
end

function p._rd(frame)
    local infos = {}
	subpages = -1
	repeat
        if subpages ~= -1 then
            table.insert(infos, p.pickup(subpages))
        end
		subpages = subpages + 1 -- start from 0 (Template:rd/0)
	until mw.title.new( template .. '/' .. tostring(subpages) ):getContent() == nil
    return infos -- infos = {{banner1, text1}, {banner2, text2} ... }
end

function p.rd(frame)
    local infos = p._rd(frame)
    local images
    for i = 1, #infos do
        images = images .. infos[i][1] .. '|' .. infos[i][2] .. '\n'
        i = i + 1
    end
    local wikitext = mw.html.create():wikitext(frame:extensionTag{
        name = 'gallery',
        content = '\n' .. images,
        args = {mode = 'slideshow', caption='[[Wikivoyage:おすすめの旅行先|おすすめの旅行先]]', class='mainpage-content'}
    })
    return wikitext
end

return p
