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
    property_hasPart = 'P527',
    property_locatedStations = { 'P559', 'P527' },
    property_nextSta = 'P197',
    property_partOf = 'P361',
    type_station = 'Q55488',
    err_invalidEntity = ''
}

local wu = require( 'Module:Wikidata utilities' )

-- utility functions
local function isValidProperty(str) return (not not string.match(str, "^[Pp]%d+$")) end

local function contains( tbl, item )
    for _, v in pairs( tbl ) do
        if type( item ) == 'table' then
            for _, i in ipairs( item ) do
                if i == item then return i == item end
            end
        else
            if v == item then return true end
        end
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
        if invalid then error( i18n.err_invalidEntity ) end
    end
    
    ---@param p string Wikidata ID 
    ---@return string|number
    function obj:getProperty( p )
        if not isValidProperty( p ) then return end
        if self.entity[p] == nil then
            self.entity[p] = mw.wikibase.getAllStatements( self.id, p )
        end
        return self.entity[p]
    end

    ---@return string The name of this station.
    function obj:getName()
        ---@private Do not refer to this property directly
        self._name = self._name or wu.getLabel(self.id)
        return self._name
    end

    ---@return string The name of the article to which the item of the station is connected
    function obj:getSitelink()
        ---@private Do not refer to this property directly
        self._link = self._link or wu.getSitelink( self.id, mw.site.wikiId )
        return obj._link
    end

    ---@return string Wikitext of a link to the station
    function obj:getLinkText()
        ---@private Do not refer to this property directly
        if self._linkText then return self._linkText end
        local sitelink = self:getSitelink()
        local name = self:getName()
        local title = mw.title.getCurrentTitle().fullText
        if sitelink == title then return "'''" .. sitelink .. "'''" end
        if name == sitelink then
            return "[[" .. sitelink .."]]"
        else
            return "[[" .. sitelink .. "|" .. name .. "]]"
        end
    end

    -- return Route instance
    return obj
end

function tu.TrainStation( id, option )
    ---@class TrainsStation
    ---@field entity table
    ---@field id string
    ---@field children table
    ---@field parent table
    local obj = tu.Station( id, option )

    -- initialization
    local invalid do
        -- Process the station items, which are categorized by operating company,
        -- so that they can be handled.
        obj.children, obj.parent = {}, {}

        local children = obj:getProperty( i18n.property_hasPart )
        local parent = obj:getProperty( i18n.property_partOf )
        if children[1] ~= nil then
            for i, v in ipairs(children) do
                local childID = v.mainsnak.datavalue.value.id
                if contains( wu.getIds( childID, 'P31', 10), i18n.type_station ) then
                    table.insert(obj.children, childID)
                end
            end
        elseif parent[1] ~= nil then
            obj.parent = { parent[1].mainsnak.datavalue.value.id }
        end
    end

    ---@param p string Wikidata ID 
    ---@return string|number
    function obj:getProperty( p )
        if not isValidProperty( p ) then return end
        if self.entity[p] == nil then
            self.entity[p] = mw.wikibase.getAllStatements( self.id, p )
        end
        return self.entity[p]
    end

    ---@return string The name of this station.
    function obj:getName()
        ---@private Do not refer to this property directly
        self._name = self._name or (
            self.parent[1] ~= nil
            and wu.getLabel(self.parent[1])
            or wu.getLabel(self.id)
        )
        return self._name
    end

    ---@return string The name of the article to which the item of the station is connected
    function obj:getSitelink()
        ---@private Do not refer to this property directly
        self._link = self._link or (
            self.parent[1] ~= nil
            and wu.getSitelink( self.parent[1], mw.site.wikiId )
            or wu.getSitelink( self.id, mw.site.wikiId )
        )
        return obj._link
    end

    return obj
end

function tu.Route( id, option )
    ---@class Route
    ---@field entity table
    ---@field id string
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        obj.entity = {}
        if invalid then error( i18n.err_invalidEntity ) end
    end
    
    ---@param p string Wikidata ID 
    ---@return string|number
    function obj:getProperty( p )
        if not isValidProperty( p ) then return end
        if self.entity[p] == nil then
            self.entity[p] = mw.wikibase.getAllStatements( self.id, p )
        end
        return self.entity[p]
    end

    ---@return string The name of this route.
    function obj:getName()
        ---@private Do not refer to this property directly
        self._name = self._name or wu.getLabel(self.id)
        return self._name
    end

    ---@return string The name of the article to which the item of the route is connected
    function obj:getSitelink()
        ---@private Do not refer to this property directly
        self._link = self._link or wu.getSitelink( self.id, mw.site.wikiId )
        return obj._link
    end

    ---@return string Wikitext of a link to the route
    function obj:getLinkText()
        ---@private Do not refer to this property directly
        if self._linkText then return self._linkText end
        local sitelink = self:getSitelink()
        local name = self:getName()
        local title = mw.title.getCurrentTitle().fullText
        if sitelink == title then return "'''" .. sitelink .. "'''" end
        if name == sitelink then
            return "[[" .. sitelink .."]]"
        else
            return "[[" .. sitelink .. "|" .. name .. "]]"
        end
    end

    -- return Route instance
    return obj
end

function tu.Train( id, option )

    ---@class Train
    ---@field entity table
    ---@field stations TrainStation[]
    ---@field id string
    local obj = tu.Route( id, option )

    -- initialization
    do
    end

    local initStaId
    if next(obj:getProperty( i18n.property_locatedStations[1] )) then
        initStaId = obj:getProperty( i18n.property_locatedStations[1] )[1].mainsnak.datavalue.value.id
    elseif next(obj:getProperty( i18n.property_locatedStations[2] )) then
        initStaId = obj:getProperty( i18n.property_locatedStations[2] )[1].mainsnak.datavalue.value.id
    end
    local initSta = tu.TrainStation(
        initStaId
    ) -- ex. Q801695
    local staIds = { initStaId }
    obj.stations = { initSta }

    ---@param stas TrainStation[]
    ---@return TrainStation[]
    local function getStations( stas )
        local nextStas = stas[#stas]:getProperty( i18n.property_nextSta ) or {}
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
mw.logObject(Yama.entity)

--return tu