-- module variable and administration
local tu = {
    moduleInterface = {
        suite  = 'TransportationUtilities',
        serial = '2025-09-06',
        item   = 0
    }
}

local i18n = {
    property_connectingTrain = { "P5051", "P1192" },
    err_invalidEntity = ""
}

local wu = require( 'Module:Wikidata utilities' )

-- utility functions
local function isQID(str) return (not not string.match(str, "^[Qq]%d+$")) end

local function contains( tbl, item )
    for _, v in pairs( tbl ) do
        if v == item then return true end
    end
    return false
end

-- define class-like objects
-- note: these can be improved in aspect of performance
--       don't use metatable due to the performance reason
function tu.Station( id, option )
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        if option and option.property then
            --
        else
            _, obj.entity, invalid = wu.getEntity( obj.id )
        end
        if invalid then error( i18n.err_invalidEntity ) end
    end

    -- return Route instance
    return obj
end

function tu.TrainStation( id, option )
    local obj = tu.Station( id, option )

    -- initialization
    do
        print("a")
    end

    return obj
end

function tu.Route( id, option )
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        if option and option.property then
            -- 
        else
            _, obj.entity, invalid = wu.getEntity( obj.id )
        end
        if invalid then error( i18n.err_invalidEntity ) end
    end

    -- return Route instance
    return obj
end

function tu.Train( id, option )
    local obj = tu.Route( id, option )

    -- initialization
    do
        print("a")
    end

    function obj.getStaList( obj )
        obj.staList = {}
        local staList = {}
        local initpoint = obj.entity:getBestStatements( 'P527' )[1].mainsnak.datavalue.value.id -- ex. Q801695
        table.insert( staList, initpoint )

        local function findNextSta( point, r )
            pos = r and (#staList + 1) or 0
            local nextSta = wu.getValuesWithQualifiers( point, "P197", nil, i18n.property_connectingTrain, nil, nil )
            for _, v in ipairs( nextSta ) do
                for _, p in ipairs( i18n.property_connectingTrain ) do
                    if v[p][1] then
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

        for i, v in ipairs( staList ) do
            obj.staList[i] = tu.TrainStation( v )
        end

        return obj.staList
    end

    return obj
end

return tu