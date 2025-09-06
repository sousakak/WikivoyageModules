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

-- define class-like objects
-- note: these could be improved in aspect of performance
--       don't use metatable due to the performance reason
function tu.Station( id, option, manual )
    local obj = {}

    -- initialization
    local valid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        if type(manual) == 'table' then
            --
        else
            _, obj.entity, invalid = wu.getEntity( obj.id )
        end
        if invalid then error( i18n.err_invalidEntity )
    end

    -- return Route instance
    return obj
end

function tu.TrainStation( id, option, manual )
    local obj = tu.Station( id, option, manual )

    -- initialization
    do
        --
    end
end

function tu.Route( id, option, manual )
    local obj = {}

    -- initialization
    local valid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        if type(manual) == 'table' then
            --
        else
            _, obj.entity, invalid = wu.getEntity( obj.id )
        end
        if invalid then error( i18n.err_invalidEntity )
    end

    -- return Route instance
    return obj
end

function tu.Train( id, option, manual )
    local obj = tu.Route( id, option, manual )

    -- initialization
    do
        -- 
    end

    function obj.getStaList( obj )
        local staList = {}
        local initpoint = obj.entity:getBestStatements( 'P527' )[1].mainsnak.datavalue.value.id -- ex. Q801695
        table.insert( staList, point )

        local function findNextSta( point, r )
            pos = r and (#staList + 1) or 0
            local nextSta = wu.getValuesWithQualifiers( point, "P197", nil, i18n.property_connectingTrain, nil, nil )
            for _, v in ipairs( nextSta ) do
                for _, p in ipairs( i18n.property_connectingTrain ) do
                    if v[p][1] then
                        if v[p][1] == obj.id and not v[p][1] in staList then
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
            staList[i] = tu.Station( v )
    end
end

return tu