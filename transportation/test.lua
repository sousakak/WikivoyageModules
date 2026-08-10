-- module variable and administration
local tu = {
    moduleInterface = {
        suite  = 'TransportationUtilities',
        serial = '2026-08-10',
        item   = 0
    }
}

local i18n = {
    property_connectingTrain = { 'P1192', 'P81' },
    property_district = 'P131',
    property_nextSta = 'P197',
    err_invalidEntity = ''
}

local wu = require( 'Module:Wikidata utilities' )

-- utility functions
local function contains( tbl, item )
    for _, v in pairs( tbl ) do
        if v == item then return true end
    end
    return false
end

-- Generate Station class
---@note: These can be improved in aspect of performance
---      This did not use metatable due to the performance reason
function tu.Station( id, option )
    local option = option or {}

    ---@class Station
    ---@field entity table
    ---@field id string
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        obj.entity = {}
        if option.property ~= nil then
            for _, v in ipairs(option.property) do
                local p = i18n[ 'property_' .. v ] or (mw.wikibase.entityExists(v) and v or nil)
                obj.entity[p] = mw.wikibase.getBestStatements( obj.id, p )
            end
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
    end

    return obj
end

---@class Route
---@field entity table
---@field id string
function tu.Route( id, option )
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        _, obj.entity, invalid = wu.getEntity( obj.id )
        if invalid then error( i18n.err_invalidEntity ) end
    end

    -- return Route instance
    return obj
end

---@class Train
---@field entity table
---@field stations Station[]
---@field id string
function tu.Train( id, option )
    local obj = tu.Route( id, option )

    -- initialization
    do
    end

    local initStaId
    if next(obj.entity:getBestStatements( 'P527' )) then
        initStaId = obj.entity:getBestStatements( 'P527' )[1].mainsnak.datavalue.value.id
    elseif next(obj.entity:getBestStatements( 'P559' )) then
        initStaId = obj.entity:getBestStatements( 'P559' )[1].mainsnak.datavalue.value.id
    end
    local initSta = tu.TrainStation(
        initStaId
    ) -- ex. Q801695
    local staIds = { initStaId }
    obj.stations = { initSta }

    local function getStations( stas )
        local nextStas = stas[#stas].entity.claims[ i18n.property_nextSta ] or {}
        local finished = true

        for _, nextSta in ipairs(nextStas) do
            local q = nextSta.qualifiers or {}
            if q[ i18n.property_connectingTrain[1] ] ~= nil then
                if q[ i18n.property_connectingTrain[1] ][1].datavalue.value.id == obj.id then
                    local id = nextSta.mainsnak.datavalue.value.id
                    if #stas == 1 or not contains(staIds, id) then
                        table.insert(staIds, id)
                        table.insert(stas, tu.TrainStation(id))
                        finished = false
                        break
                    end
                end
            elseif q[ i18n.property_connectingTrain[2] ] ~= nil then
                if q[ i18n.property_connectingTrain[2] ][1].datavalue.value.id == obj.id then
                    local id = nextSta.mainsnak.datavalue.value.id
                    if #stas == 1 or not contains(staIds, id) then
                        table.insert(staIds, id)
                        table.insert(stas, tu.TrainStation(id))
                        finished = false
                        break
                    end
                end
            end
        end

        if finished then return stas else return getStations( stas ) end
    end

    obj.stations = getStations(obj.stations)

    return obj
end

local Yama = tu.Train("Q1197028")

local keys = {}
for k, v in pairs(Yama.stations) do
    mw.log(v.id)
    table.insert(keys, k)
end
mw.logObject(keys)
mw.logObject(Yama.entity)

--return tu