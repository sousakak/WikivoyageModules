-- module variable and administration
local tu = {
    moduleInterface = {
        suite  = 'TransportationUtilities',
        serial = '2026-08-12',
        item   = 0
    }
}

local i18n = {
    property_connectingTrain = { 'P1192', 'P81' },
    property_hasPart = 'P527',
    property_locatedStations = { 'P559', 'P527' },
    property_nextSta = 'P197',
    property_partOf = 'P361',
    type_station = 'Q55488'
}

local cd = require( 'Module:Coordinates' )
local wu = require( 'Module:Wikidata utilities' )

--[[
    Utility Functions
]]
---@param str string
---@return boolean
local function isValidProperty(str) return (not not string.match(str, "^[Pp]%d+$")) end

---@param tbl table
---@param item *
---@return boolean
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

---@param coord number[]|string[]
---@return number[]
local function toDec( coord, prec )
    prec = prec or 6
    local lat, latE = cd.toDec( coord[1], '', prec )
    local long, longE = cd.toDec( coord[2], '', prec )
    if latE + longE ~= 0 then error("Invalid coordinate: " .. coord) end
    return { lat, long }
end

--[[
    Main Functions
]]

-- Generate Station class
---@note: These can be improved in aspect of performance
---      This did not use metatable due to the performance reason
function tu.Station( id, option )
    option = option or {}

    ---@class Station
    ---@field entity table
    ---@field id string
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        obj.entity = {}
        if invalid then error( "Invalid entity" ) end
    end

    ---@param p string Wikidata ID 
    ---@return table
    function obj:getProperty( p )
        if not isValidProperty( p ) then return end
        if self.entity[p] == nil then
            self.entity[p] = mw.wikibase.getAllStatements( self.id, p )
        end
        return self.entity[p]
    end

    --This is a shortcut for getProperty() to get next stations
    ---@return table List of next stations.
    function obj:getNextStation()
        return self:getProperty( i18n.property_nextSta ) or {}
    end

    --This is a shortcut for getProperty() to get name
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

    ---@param fallback string The fallback string used when sitelink not exist
    ---@return string Wikitext of a link to the route
    function obj:getLinkText(fallback)
        if self._linkText then return self._linkText end
        local sitelink = self:getSitelink()
        local name = self:getName()
        local title = mw.title.getCurrentTitle().fullText
        if not sitelink then
            self._linkText = string.gsub(fallback, '$1', sitelink) or sitelink
        elseif sitelink == title then
            self._linkText = "'''" .. sitelink .. "'''"
        elseif name == sitelink then
            self._linkText = "[[" .. sitelink .."]]"
        else
            self._linkText = "[[" .. sitelink .. "|" .. name .. "]]"
        end
        return self._linkText
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
    ---@param item number Property of which item should be retrieved from.
    ---                     1: The item of obj.id itself (Default)
    ---                     2: Parent
    ---                     3: All children
    ---                     4: Both parent and all children
    ---@return table
    function obj:getProperty( p, item )
        item = item or 1
        if not isValidProperty( p ) then return end
        if self.entity[p] ~= nil then return self.entity[p] end
        if item == 1 then
            self.entity[p] = mw.wikibase.getAllStatements( self.id, p )
        elseif item == 2 then
            self.entity[p] = mw.wikibase.getAllStatements( self.parent[1], p )
        elseif item == 3 then
            local value = {}
            for _, child in ipairs( obj.children ) do
                local r = mw.wikibase.getAllStatements( child, p )
                for _, v in ipairs( r ) do table.insert( value, v ) end
            end
            if value[1] ~= nil then self.entity[p] = value end
        elseif item == 4 then
            local value = {}
            -- Add values of the child items
            for _, child in ipairs( obj.children ) do
                local r = mw.wikibase.getAllStatements( child, p )
                for _, v in ipairs( r ) do table.insert( value, v ) end
            end
            -- Add values of the parent item
            do
                local r = mw.wikibase.getAllStatements( self.parent[1], p )
                for _, v in ipairs( r ) do table.insert( value, v ) end
            end
            if value[1] ~= nil then self.entity[p] = value end
        else
            error( "Invalid item number specified: " .. item )
        end
        return self.entity[p]
    end

    --This is a shortcut for getProperty() to get name
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

    ---@return string The name of the article to which the item of the station is connected.
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
    option = option or {}

    ---@class Route
    ---@field entity table
    ---@field id string
    local obj = {}

    -- initialization
    local invalid do
        obj.id = id or mw.wikibase.getEntityIdForCurrentPage()
        obj.entity = {}
        if invalid then error( "Invalid entity" ) end
    end

    ---@param p string Wikidata ID 
    ---@return table
    function obj:getProperty( p )
        if not isValidProperty( p ) then return end
        if self.entity[p] == nil then
            self.entity[p] = mw.wikibase.getAllStatements( self.id, p )
        end
        return self.entity[p]
    end

    --This is a shortcut for getProperty() to get name
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


    ---@param fallback string The fallback string used when sitelink not exist
    ---@return string Wikitext of a link to the route
    function obj:getLinkText(fallback)
        if self._linkText then return self._linkText end
        local sitelink = self:getSitelink()
        local name = self:getName()
        local title = mw.title.getCurrentTitle().fullText
        if not sitelink then
            self._linkText = string.gsub(fallback, '$1', sitelink) or sitelink
        elseif sitelink == title then
            self._linkText = "'''" .. sitelink .. "'''"
        elseif name == sitelink then
            self._linkText = "[[" .. sitelink .."]]"
        else
            self._linkText = "[[" .. sitelink .. "|" .. name .. "]]"
        end
        return self._linkText
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
            local nextStas = stas[#stas]:getNextStation() or {}
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
    end

    return obj
end

---@param from string[]|number[] Reference coordinates
---@param to string[]|number[] Coordinates to check
---@param parts number How many equal parts the direction
---                     will be divided into.
---@param adj number Azimuths are measured with 0 degrees
---                     as the center, not as the boundary.
---                     To accommodate this classification,
---                     specify an adjustment angle to be added
---                     to the angle of the coordinates being mapped.
---@return number The direction from the coordinate of `from`
---                 to the coordinate of `to`. The numbers
---                 are assigned from 1 to the number of `parts`,
---                 starting from the east and proceeding counter-clockwise.
function tu.getDirection( from, to, parts, adj )
    from = toDec( from )
    to = toDec( to )
    parts = parts or 8

    local latDiff = to[1] - from[1]
    local longDiff = to[2] - from[2]

    local coordAngle = math.atan( latDiff, longDiff )
    local angleUnit = 2 * math.pi / parts

    adj = adj or angleUnit / 2

    local targetAngle = coordAngle + adj

    for i = 1, parts do
        local fromAngle = angleUnit * ( i - 1 )
        local toAngle = angleUnit * i
        

        if fromAngle <= coordAngle and coordAngle <= toAngle then
            return i
        end
    end
    
    error("No part of direction hit to the coord")
end

return tu