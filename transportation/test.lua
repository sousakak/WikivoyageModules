local wu = require( 'Module:Wikidata utilities' )
local obj = {
    id = 'Q693036' -- Yamanote Line
}
_, obj.entity = wu.getEntity( 'Q693036' )
obj.staList = {}
local staList = {}
local initpoint = obj.entity:getBestStatements( 'P527' )[1].mainsnak.datavalue.value.id -- ex. Q801695
table.insert( staList, initpoint )

local function findNextSta( point, r )
    pos = r and (#staList + 1) or 0
    mw.log( pos )
    local nextSta = wu.getValuesWithQualifiers( point, "P197", nil, { "P5051", "P1192" }, nil, nil )
    mw.logObject( nextSta )
    for _, v in ipairs( nextSta ) do
        mw.logObject( v )
        for _, p in ipairs( { "P5051", "P1192" } ) do
            mw.log( p )
            if v[p][1] then
                mw.logObject( v[p] )
                if v[p][1] == obj.id and not contains( staList, v[p][1] ) then
                    table.insert( staList, pos, v.value )
                    return findNextSta( v.value )
                end
            end
        end
    end
    return staList
end
findNextSta( initpoint )
findNextSta( initpoint, true )

mw.logObject( obj.taList )





























do
    local function shuffle(t)
        local s = {}
        for i = 1, #t do s[i] = t[i] end
        for i = #t, 2, -1 do
            local j = math.random(i)
            s[i], s[j] = s[j], s[i]
        end
        return s
    end

    local route = {
        "a" = {
            "b"
        },
        "b" = {
            "a",
            "c"
        },
        "c" = {
            "b", 
            "d"
        },
        "d" = {
            "c",
            "e"
        },
        "e" = {
            "d"
        }
    }
    route = shuffle(route)
end