-- CountryData module

-- module variable and administration
local cm = {
	moduleInterface = {
		suite  = 'CountryData',
		serial = '2023-07-07',
		item   = 65431301
	}
}

-- module import
-- require( 'strict' )
local cg = mw.loadData( 'Module:CountryData/Geography' )
local cu = mw.loadData( 'Module:CountryData/Currencies' ) -- additional currency symbols
local wu = require( 'Module:Wikidata utilities' )

local properties = {
	continent        = 'P30',
	country          = 'P17',
	countryCode      = 'P474',
	currency         = 'P38',
	iso3166_1        = 'P297',
	iso3166_2        = 'P300',
	iso639           = 'P218',
	locatedIn        = 'P131',
	officialLanguage = 'P37',
	partOf           = 'P361'
}

local exceptions = {
	Q145 = '^+44' -- UK
}

local currencyformatters = {}

local function isSet( arg )
	return arg and arg ~= ''
end

local function _getCountry( tab, id )
	local item = tab[ id ]
	if item and item.id then
		item = tab[ item.id ]
	end
	if not item then
		return nil
	end
	local c = {} 
	for k, v in pairs( item ) do -- item is read only
		c[ k ] = v
	end
	if c and not c.id then
		c.id = id
	end
	return c
end

local function getCountry( id )
	return _getCountry( cg.countries, id )
end

local function getAdminEntity( id )
	return _getCountry( cg.adminEntities, id )
end

local function getCountryTable( id )
	return getAdminEntity( id ) or getCountry( id ) -- nil or table
end

local function checkTable( id )
	if id == nil or id == '' then
		return nil
	end

	return getCountryTable( id ) -- nil or table
end

local function checkTableFromEntity( anEntity )
	if not anEntity then
		return nil
	end

	local id, t
	for i, prop in ipairs( { properties.locatedIn, properties.country, properties.partOf } ) do
		for j, val in ipairs( wu.getValues( anEntity, prop ) ) do
			id = val.id
			t = checkTable( id )
			if t then
				return t
			end
		end
	end

	return nil
end

function cm.getDataFromTables( vcEntity )
	-- article id
	local articleId = mw.wikibase.getEntityIdForCurrentPage()

	-- article lemma
	local t = cg.articles[ articleId ]
	if t then
		return getCountryTable( t )
	end

	if not articleId and not vcEntity then
		return nil
	end

	-- vCard entity
	if vcEntity then
		t = checkTableFromEntity( vcEntity )
		if t then
			return t
		end
	end

	-- article entity
	if articleId then
		t = checkTable( articleId ) or checkTableFromEntity( articleId )
		if t then
			return t
		end
	end

	-- not found in tables, get it now all from Wikidata
	return nil
end

-- getting data for vCard

local function _getCountryDataByIso( iso_3166 )
	for i, tab in ipairs( { 'countries', 'adminEntities' } ) do
		for id, c in pairs( cg[ tab ] ) do
			if c.iso_3166 and c.iso_3166 == iso_3166 then
				local country = {}
				for k, v in pairs( c ) do
					country[ k ] = v
        		end
				country.id = id
				return country
			end
		end
	end
	return nil
end

local function _getCountryData( vcEntity, iso_3166 )
	local t = cm.getDataFromTables( vcEntity )
	if t then
		return t
	end

	-- use template country parameter iso_3166
	if isSet( iso_3166 ) and iso_3166:match( '%a%a' ) then
		t = _getCountryDataByIso( iso_3166:upper() )
		if t then
			return t
		end
	end

	-- not found in CountryData table
	-- return default country dataset if not in main namespace
	if mw.title.getCurrentTitle().namespace ~= 0 and cg.articles[ '_default' ] then
		return getCountry( cg.articles[ '_default' ] )
	end

	-- getting data from country entity
	local country = {
		id = wu.getId( vcEntity, properties.country ),
		iso_3166 = '',
		cont = '',
		cc = '',
		lang = '',
		currency = '',
		country = '',
		show = '',
		unknownCountry = isSet( iso_3166 )
	}
	local coEntity = country.id ~= '' and mw.wikibase.getEntity( country.id )
	if coEntity then
		country.fromWD = true
		country.iso_3166 = wu.getValue( coEntity, properties.iso3166_1 ):upper()
		country.cont = cg.continents[ wu.getId( coEntity, properties.continent ) ] or ''
		country.cc = wu.getValue( coEntity, properties.countryCode ) -- country calling code
		t = wu.getId( coEntity, properties.officialLanguage )
		if t ~= '' then
			country.lang = wu.getValue( t, properties.iso639 ):lower()
		end
		country.currency = wu.getId( coEntity, properties.currency )
	end

	return country
end

-- getting county data from country calling code

function cm.getCountryFromPhones( tab )
	local country = {
		id = '',
		cont = '',
		iso_3166 = '',
		cc = '',
		lang = '',
		currency = '',
		country = '',
		show = ''
	}

	-- prepare phone numbers
	for i = #tab, 1, -1 do
		tab[ i ] = tab[ i ]:gsub( '^00', '+' )
			:gsub( '^%+%+', '+' )
			:gsub( '[^%+0-9A-Z]', '' )
		if not tab[ i ]:match( '^%+%d%d%d%d' ) then
			table.remove( tab, i )
		end
	end
	if #tab == 0 then
		return country
	end
	-- exceptions fur multiple used country calling codes
	for i = 1, #tab, 1 do
		for wdId, pattern in pairs( exceptions ) do
			if tab[ i ]:match( pattern ) then
				return getCountry( wdId )
			end
		end
	end

	-- make country calling codes table
	local ccodes = {}
	for i, cgTab in ipairs( { cg.countries, cg.adminEntities } ) do
		for key, country in pairs( cgTab ) do
			if country.cc and country.cc ~= '' then
				ccodes[ country.cc:gsub( '-', '' ) ] = key
			end
		end
	end

	-- look for country code in phone numbers
	local q
	for i, phone in ipairs( tab ) do
		phone = phone:sub( 1, 5 )
		repeat
			q = ccodes[ phone ]
			phone = phone:sub( 1, -2 )
		until phone == '' or q
		if q then
			country = getCountryTable( q )
			break
		end
	end

	return country
end

-- main getCountryData function

function cm.getCountryData( entity, phones, iso_3166 )
	local country = _getCountryData( entity, iso_3166 )
	if country.id == '' and phones and #phones > 0 then
		country = cm.getCountryFromPhones( phones )
	end

	local c = cu.currencies[ country.currency ]
	country.currency = c and c.iso or ''
	country.addCurrency = country.currency
	if c and c.add and c.add ~= '' then
		country.addCurrency = country.addCurrency
			.. ( country.addCurrency ~= '' and ', ' or '' ) .. c.add
	end
	country.unknownLanguage = true
	if country.lang ~= '' then
		country.langName = mw.language.fetchLanguageName( country.lang,
			mw.getContentLanguage():getCode() ) or ''
		if country.langName ~= '' then
			country.unknownLanguage = false
			country.isRTL = mw.getLanguage( country.lang ):isRTL()
		end
	end

	return country
end

-- getting first-order administrative-territorial entity code
function cm.getAdm1st( countryId )
	local entityId = mw.wikibase.getEntityIdForCurrentPage()
	if not entityId or not countryId or countryId == '' then
		return nil
	end
	local i = 0
	local iso3166_2 = ''
	while entityId ~= '' and not getAdminEntity( entityId )
		and not getCountry( entityId ) and i < 5 do
		iso3166_2 = wu.getValue( entityId, properties.iso3166_2 )
		if iso3166_2 ~= '' then
			return iso3166_2
		end
		-- getting next administrative territorial entity
		entityId = wu.getId( entityId, properties.locatedIn )
		i = i + 1
	end
end

function cm.getCategories( formatStr )
	return wu.getCategories( formatStr )
end

-- getting data for LinkPhone

function cm.getCountryCode()
	local t = cm.getDataFromTables( nil )
	if t then
		return t.cc, t.phoneDigits or 2
	else
		return '', 2
	end
end

-- returns a single data set from Module:CountryData/Currencies
function cm.getCurrency( key )
	return cu.currencies[ key ]
end

function cm.getCurrencyFormatter( qId )
	qId = qId:upper()
	if currencyformatters[ qId ] then
		return currencyformatters[ qId ]
	elseif qId:match( '^%a%a%a$' ) then -- ISO code
		qId = cu.isoToQid[ qId ]
	end

	local currency = cu.currencies[ qId ]
	if currency then
		local formatter, unit
		if currency.f then
			formatter = currency.f
		else
			formatter = cu.currencies.default or '%s&#x202F;unit'
			unit = currency.add and currency.add:gsub( ',.*', '' )
				or currency.iso
			formatter = formatter:gsub( 'unit', unit )
		end
		currencyformatters[ qId ] = formatter
		currencyformatters[ currency.iso ] = formatter
		return formatter
	end
	return nil
end

return cm