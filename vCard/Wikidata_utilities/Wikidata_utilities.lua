-- Wikidata convenience utilities

-- documentation
local WikidataUtilities = {
	suite  = 'WikidataUtilities',
	serial = '2023-06-13',
	item   = 65439025
}

-- i18n
local wd = {
	version   = 'P348',
	retrieved = 'P813',

	gregorianCalendar = { -- calendar models
		Q12138   = 1, -- Gregorian
		Q1985727 = 1  -- proleptic Gregorian
	},

	redirectBadges = {
		Q70894304 = 1, -- intentional sitelink
		Q70893996 = 1  -- redirect sitelink
	}
}

-- module variable and administration
local wu = {
	moduleInterface = WikidataUtilities
}

-- table storing property ids used
local catTable = {
	P0 = ''
}

local function isSet( arg )
	return arg and arg ~= ''
end

function wu.getEntity( id )
	local wrongQualifier = false
	local entity
	
	if not isSet( id ) then
		return '', entity, wrongQualifier
	end
	if mw.wikibase.isValidEntityId( id ) then
		-- expensive function call
		-- redirect ids marked false, too
		entity = mw.wikibase.getEntity( id )
	end
	if not entity then
		id = ''
		wrongQualifier = true
	end

	return id, entity, wrongQualifier
end

function wu.getEntityId( id )
	local wrongQualifier = false
	local entity
	
	if not isSet( id ) then
		id = ''
	elseif mw.wikibase.isValidEntityId( id ) and mw.wikibase.entityExists( id ) then
		-- expensive function call
		-- redirect ids marked false, too
		entity = id
	else
		id = ''
		wrongQualifier = true
	end

	return id, entity, wrongQualifier
end

function wu.getLabel( entity, lang, noFallback )
	if not isSet( entity ) then
		return nil
	end
	local tp = type( entity )
	if tp == 'string' and mw.wikibase.isValidEntityId( entity ) then
		return isSet( lang ) and mw.wikibase.getLabelByLang( entity, lang )
			or ( not noFallback and mw.wikibase.getLabel( entity ) )
	elseif tp == 'table' and entity.labels then -- really a wikidata entity?
		return isSet( lang ) and entity:getLabel( lang )
			or ( not noFallback and entity:getLabel() )
	end
	return nil
end

function wu.getAliases( entity, lang )
	if type( entity ) == 'string' then -- is Q id
		entity = mw.wikibase.getEntity( entity )
	end
	if not lang then
		lang = mw.getContentLanguage():getCode()
	end
	local aliases = {}
	if entity and entity.aliases and entity.aliases[ lang ] then
		for i, alias in ipairs( entity.aliases[ lang ] ) do
			table.insert( aliases, alias.value )
		end
	end
	return aliases
end

function wu.getSitelink( entity, globalSiteId )
	if not isSet( entity ) then
		return nil
	end
	if type( entity ) == 'string' then -- entity is id
		return mw.wikibase.getSitelink( entity, globalSiteId )
	elseif entity and entity.labels then
		return entity:getSitelink( globalSiteId )
	end
	return nil
end

local function getSitelinkTable( entity, globalSiteId )
	if not isSet( entity ) or not isSet( globalSiteId ) then
		return nil
	elseif type( entity ) == 'string' then -- entity is id
		entity = mw.wikibase.getEntity( entity )
	end
	if entity and entity.sitelinks then
		return entity.sitelinks[ globalSiteId ]
	end
	return nil
end

-- getting sitelink title exclunding redirects
function wu.getFilteredSitelink( entity, globalSiteId )
	local t = getSitelinkTable( entity, globalSiteId )
	if not t or not t.title then
		return nil
	end
	for i = 1, #t.badges do
		if wd.redirectBadges[ t.badges[ i ] ] then
			return nil
		end
	end
	return t.title
end

-- convert from url to Q id
local function getUnitId( unit )
	if isSet( unit ) and type( unit ) == 'string' then
		return unit:gsub( 'https?://www.wikidata.org/entity/', '' )
	end
	return ''
end

local function getBestStatements( entity, p )
	local tp = type( entity )
	if tp == 'string' and mw.wikibase.isValidEntityId( entity ) then
		return mw.wikibase.getBestStatements( entity, p )
	elseif tp == 'table' and entity.labels then
		return entity:getBestStatements( p )
	end
	return {}
end

local function getStatements( entity, p, count )
	local ar = {}
	if not ( isSet( entity ) and isSet( p ) ) then
		return ar
	end

	local statements = getBestStatements( entity, p )
	count = math.min( count or #statements, #statements )
	if count <= 0 then
		return ar
	end

	local i = 0
	repeat
		i = i + 1
		if statements[ i ].mainsnak.snaktype == 'value' then
			if statements[ i ].mainsnak.datatype == 'quantity' then
				statements[ i ].mainsnak.datavalue.value.amount =
					statements[ i ].mainsnak.datavalue.value.amount:gsub( '^+', '' )
				statements[ i ].mainsnak.datavalue.value.unit = getUnitId(
					statements[ i ].mainsnak.datavalue.value.unit )
			end
			table.insert( ar, statements[ i ] )
		end
	until i >= #statements or #ar >= count

	return ar
end

function wu.getValue( entity, p )
	local statements = getStatements( entity, p, 1 )
	if #statements > 0 then
		catTable[ p ] = ''
		return statements[ 1 ].mainsnak.datavalue.value
	end
	return ''
end

function wu.getId( entity, p )
	local value = ''
	local statements = getStatements( entity, p, 1 )
	if #statements > 0 then
		value = statements[ 1 ].mainsnak.datavalue.value
		value = value.id or ''
		if value ~= '' then
			catTable[ p ] = ''
		end
	end
	return value
end

function wu.getValues( entity, p, count )
	local statements = getStatements( entity, p, count )
	if #statements > 0 then
		for i = 1, #statements, 1 do
			statements[ i ] = statements[ i ].mainsnak.datavalue.value
		end
		catTable[ p ] = ''
	end
	return statements
end

function wu.getIds( entity, p, count )
	local statements = getStatements( entity, p, count )
	if #statements > 0 then
		for i = #statements, 1, -1 do
			statements[ i ] = statements[ i ].mainsnak.datavalue.value.id
			if not statements[ i ] then
				table.remove( statements, i )
			end
		end
		if #statements > 0 then
			catTable[ p ] = ''
		end
	end
	return statements
end

function wu.getValuesByLang( entity, p, count, lang )
	local ar = {}
	local statements = getStatements( entity, p )
	if #statements > 0 then
		local value
		for i = 1, #statements, 1 do
			value = statements[ i ].mainsnak.datavalue.value
			if value.language and lang == value.language then
				table.insert( ar, value.text )
			end
			if count and #ar >= count then
				break
			end
		end
	end
	if #ar > 0 then
		catTable[ p ] = ''
	end
	return ar
end	

-- get values array for monolingual text
function wu.getMonolingualValues( entity, p )
	local result = {}
	local statements = getStatements( entity, p, nil )
	if #statements > 0 and statements[ 1 ].mainsnak.datatype == 'monolingualtext' then
		local hyphen, lng, value
		catTable[ p ] = ''
		for i = 1, #statements, 1 do
			value = statements[ i ].mainsnak.datavalue.value
			lng = value.language
			hyphen = lng:find( '-' )
			if hyphen then
				lng = lng:sub( 1, hyphen - 1 )
			end
			if not result[ lng ] then
				result[ lng ] = value.text
			end
		end
	end
	return result
end

function wu.getValuesByQualifier( entity, p, qualifierP, defaultId )
	local result = {}
	if not isSet( qualifierP ) then
		return result
	elseif type( defaultId ) ~= 'string' or defaultId == '' then
		defaultId = 'unknown'
	end

	local statements = getStatements( entity, p, nil )
	if #statements > 0 then
		catTable[ p ] = ''
		local id, statement, value
		for i = 1, #statements do
			statement = statements[ i ]
			-- defaultId is used if a qualifier is missing
			id = defaultId
			value = statement.mainsnak.datavalue.value
			if statement.qualifiers and statement.qualifiers[ qualifierP ] then
				for j, qualifier in ipairs( statement.qualifiers[ qualifierP ] ) do
					if qualifier.snaktype == 'value' then
						id = qualifier.datavalue.value.id
						if id then
							catTable[ qualifierP ] = ''
							break
						end
					end
				end
			end
			result[ id ] = value
		end
	end
	return result
end

local function analyzeDatavalue( datavalue, labelFct, ... )
	local v = datavalue.value
	local t = datavalue.type
	if type( v ) == 'table' then
		-- items which can be reduced to a string
		if t == 'wikibase-entityid' then
			v = v.id
			if type( labelFct ) == 'function' then
				v = labelFct( v, ... )
			end
		elseif t == 'quantity' then
			v.amount = v.amount:gsub( '^+', '' )
			if tonumber( v.amount ) == 0 then
				v.amount = '0'
			end
			if v.unit == '1' then
				v = tonumber( v.amount ) or 1
			else
				v.unit = getUnitId( v.unit )
			end
		elseif t == 'time' then
			v.calendarmodel = getUnitId( v.calendarmodel )
			if wd.gregorianCalendar[ v.calendarmodel ] then -- is gregorian calendar?
				v = v.time
			end
		end
	end
	return v, t
end

-- for qualifiers, references
--  { item1, item2, ... } : using named qualifiers/references
--  {} : using no qualifiers/references
--  nil : using all qualifiers/references
function wu.getValuesWithQualifiers( entity, p, values, qualifiers, references,
	count, labelFct, ... )
	local array, qual
	local function toQualifierTable( tab, key, qualTab, labelFct, ... )
		local v
		if not tab[ key ] then
			tab[ key ] = {}
		end
		for i = 1, #qualTab do
			qual = qualTab[ i ]
			if qual.snaktype == 'value' then
				v, tab[ key .. '-type' ] =
					analyzeDatavalue( qual.datavalue, labelFct, ... )
				table.insert( tab[ key ], v )
			end
		end
		if #tab[ key ] == 0 then
			tab[ key ] = nil
			tab[ key .. '-type' ] = nil
		else
			catTable[ key ] = ''
		end
	end
	local function hasValue( tab, val )
		for i = 1, #tab do
			if tab[ i ] == val then
				return true
			end
		end
		return false
	end

	local results = {}
	local statements = getStatements( entity, p, count )
	if #statements == 0 then
		return results
	end
	local i, v
	if type( values ) == 'table' and #values > 0 then
		for i = #statements, 1, -1 do
			v = statements[ i ].mainsnak.datavalue.value
			if type( v ) ~= 'string' then
				v = v.id
			end
			if not isSet( v ) or not hasValue( values, v ) then
				table.remove( statements, i )
			end
		end
		if #statements == 0 then
			return results
		end
	end
	catTable[ p ] = ''

	if type( qualifiers ) == 'string' then
		qualifiers = { qualifiers }
	end
	if type( references ) == 'string' then
		references = { references }
	end

	local key, reference, statement
	for i = 1, #statements do
		statement = statements[ i ]
		array = { value = analyzeDatavalue( statement.mainsnak.datavalue, labelFct, ... ),
			[ 'value-type' ] = statement.mainsnak.datavalue.type }

		if statement.qualifiers then
			if not qualifiers then -- all qualifier properties
				for key, qualTab in pairs( statement.qualifiers ) do
					toQualifierTable( array, key, qualTab, labelFct, ... )
				end
			else -- table of selected qualifier properties
				for j = 1, #qualifiers do
					key = qualifiers[ j ]
					if statement.qualifiers[ key ] then
						toQualifierTable( array, key, statement.qualifiers[ key ], labelFct, ... )
					end
				end
			end
		end

		array.references = {}
		if statement.references then
			for k = 1, #statement.references do
				reference = statement.references[ k ]
				if reference and reference.snaks then
					table.insert( array.references, {} )
					if not references then -- all references
						for key, refTab in pairs( reference.snaks ) do
							toQualifierTable( array.references[ #array.references ],
								key, refTab )
						end
					else -- table of selected references
						for j = 1, #references do
							key = references[ j ]
							if reference.snaks[ key ] then
								toQualifierTable( array.references[ #array.references ],
									key, reference.snaks[ key ] )
							end
						end
					end
				end
			end
		end

		table.insert( results, array )
	end

	-- clustering statements with identical value
	local helper = {}
	local sort1 = 0
	local mult = false
	local result
	for i = 1, #results do
		result = results[ i ]
		if helper[ result.value ] then
			helper[ result.value ].sort2 = helper[ result.value ].sort2 + 1
			mult = true
		else
			sort1 = sort1 + 1
			helper[ result.value ] = { sort1 = sort1, sort2 = 1 }
		end
		result.sort1 = helper[ result.value ].sort1
		result.sort2 = helper[ result.value ].sort2
	end
	if sort1 > 1 and mult and #results > 2 then
		table.sort( results,
			function( a, b )
				return a.sort1 < b.sort1 or 
					( a.sort1 == b.sort1 and a.sort2 < b.sort2 )
			end
		)
	end

	return results
end

-- extract date from time
function wu.getDateFromTime( t )
	local model = '' -- is Gregorian
	if type( t ) == 'table' then
		model = t.calendarmodel
		t = t.time
	end
	t = t:gsub( '^[%+%-]([-%d]*)T.*$', '%1' )
	return t, model
end

-- get lastEdit from reference retrieve date
function wu.getLastedit( lastEdit, statements )
	local isBoolean = type( lastEdit ) == 'boolean'
	if isBoolean and lastEdit == false then
		return lastEdit
	end
	local le = ''
	for i, statement in ipairs( statements ) do
		if statement.references then
			for j, reference in ipairs( statement.references ) do
				if reference[ wd.retrieved ] then
					for k, retrieved in ipairs( reference[ wd.retrieved ] ) do
						retrieved = wu.getDateFromTime( retrieved )
						if retrieved > le then
							le = retrieved
						end
					end
				end
			end
		end
	end
	if isBoolean then
		return ( le ~= '' ) and le or lastEdit
	else
		return ( le > lastEdit ) and le or lastEdit
	end
end

-- maintenance utilities
function wu.getCategories( formatStr )
	if not isSet( formatStr ) then
		formatStr = '[[Category:%s]]'
	end

	catTable.P0 = nil
	local result = ''
	for key, value in pairs( catTable ) do
		result = result .. formatStr:format( key )
	end
	return result
end

return wu