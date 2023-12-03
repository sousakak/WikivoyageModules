-- module variable and administration
local vc = {
	moduleInterface = {
		suite  = 'vCard',
		serial = '2023-11-25',
		item   = 58187507
	},
	
	-- table containing parameters fetched from Wikidata
	fromWD = {},
}

-- module import
-- require( 'strict' )
local mi = require( 'Module:Marker utilities/i18n' )
local mu = require( 'Module:Marker utilities' )
local vp = require( 'Module:VCard/Params' ) -- parameter lists
local vi = require( 'Module:VCard/i18n' ) -- parameter translations
local vq = mw.loadData( 'Module:VCard/Qualifiers' ) -- comment tables

local cm = require( 'Module:CountryData' )
local er -- modules will be loaded later if needed
local hi
local hr
local lg
local lp = require( 'Module:LinkPhone' )
local wu = require( 'Module:Wikidata utilities' )

local function addWdClass( key )
	return mu.addWdClass( vc.fromWD[ key ] )
end

local function forceFetchFromWikidata( tab )
	for key, value in pairs( tab ) do
		vp.ParMap[ key ] = true
	end
end

-- copying frameArgs parameters to args = vp.ParMap parameters
local function copyParameters( args, show )
	local t, value

	vp.ParMap.wikidata = args.wikidata

	-- force getting data from Wikidata for missing parameters
	show.inlineDescription = true -- description with div or span tag
	if vp.ParMap.auto == true then
		forceFetchFromWikidata( vp.ParWD )
		forceFetchFromWikidata( vp.ParWDAdd )
	end

	-- copying args parameters to vp.ParMap parameters
	for key, v in pairs( vi.p ) do
		value = args[ key ]

		if value then
			value, t =
				mu.removeCtrls( value, show.inline or key ~= 'description' )
			if t then
				show.inlineDescription = false
			end

			if key ~= 'auto' and key ~= 'show' and key ~= 'wikidata' then
				if value == '' then
					value = 'y'
				end
				t = mu.yesno( value )
				if t then
					if vp.ParMap.wikidata ~= '' then
						vp.ParMap[ key ] = t == 'y'
					else
						vp.ParMap[ key ] = ''
					end
				else
					vp.ParMap[ key ] = value
				end
			end
		end
	end

	-- force fetching data from Wikidata if empty
	for key, value in ipairs( { 'name', 'type' } ) do
		if type( vp.ParMap[ value ] ) == 'boolean' or vp.ParMap[ value ] == '' then
			vp.ParMap[ value ] = true
		end
	end

	if mu.isSet( vp.ParMap.styles ) then
		vp.ParMap.styles = mi.nameStyles[ vp.ParMap.styles:lower() ] or vp.ParMap.styles
	else
		vp.ParMap.styles = nil
	end

	return vp.ParMap
end

local function initialParametersCheck( frame )
	local country, entity, param, show, t, v, wrongQualifier
	local frameArgs = mu.checkArguments( frame:getParent().args, vi.p )

	frameArgs.wikidata, entity, wrongQualifier = wu.getEntity( frameArgs.wikidata or '' )
	if wrongQualifier then
		mu.addMaintenance( 'wrongQualifier' )
	end
	if mu.isSet( frameArgs.wikidata ) then
		mu.addMaintenance( 'wikidata' )
		v = mu.yesno( frameArgs.auto or '' )
		if v then
			vp.ParMap.auto = v == 'y'
		else
			vp.ParMap.auto = mi.options.defaultAuto
		end
	else
		vp.ParMap.auto = false
	end

	-- making phone number table
	t = {}
	for i, key in ipairs( vp.phones ) do
		mu.tableInsert( t, frameArgs[ key ] )
	end
	-- getting country-specific technical parameters
	country = cm.getCountryData( entity, t, frameArgs.country )
	if country.fromWD then
		mu.addMaintenance( 'countryFromWD' )
	end
	if country.unknownCountry then
		mu.addMaintenance( 'unknownCountry' )
	end
	if country.cc ~= '' then
		country.trunkPrefix = lp.getTrunkPrefix( country.cc )
	end
	country.extra = mi.defaultSiteType
	if mu.isSet( country.iso_3166 ) then
		country.extra = country.extra .. '_region:' .. country.iso_3166
		-- country-specific default show
	end
	if mu.isSet( country.show ) then
		vp.ParMap.show = country.show
	end

	v = frameArgs.show
	-- handling args table and frameArgs.show
	show = mu.getShow( vp.ParMap.show, frameArgs, vp.show )
	if v and v:find( 'inline', 1, true ) then
		show.inlineSelected = true
		mu.addMaintenance( 'inlineSelected' )
	end
	if v and v:find( 'poi', 1, true ) then
		mu.addMaintenance( 'showPoiUsed' )
	end
	show.name = true

	-- copying frameArgs parameters to args = vp.ParMap parameters
	local args = copyParameters( frameArgs, show )
	-- checking coordinates and converting DMS to decimal coordinates if necessary
	mu.checkCoordinates( args )
	-- remove namespace from category
	mu.checkCommonsCategory( args )
	for i, param in ipairs( mi.options.parameters ) do
		if mu.isSet( args[ param ] ) then
			mu.addMaintenance( 'parameterUsed', param )
		end
	end

	args.subtypeAdd = not show.nosubtype and not show.nowdsubtype

	if type( args.lastedit ) == 'string' and args.lastedit ~= ''
		and not args.lastedit:match( mi.dates.yyyymmdd.p ) then
		mu.addMaintenance( 'wrongDate' )
		args.lastedit = ''
	end

	return args, entity, show, country
end

local function getQuantity( value, formatter, page )
	local a, f, u, unit, unitId
	if type( value ) == 'number' then
		return tostring( value )
	elseif value.amount == '0' then
		return '0'
	else
		a = mu.formatNumber( value.amount )
		u = ''
		unitId = value.unit
		unit = cm.getCurrency( unitId )
		if mu.isSet( unit ) then
			if unit.mul then
				a = mu.formatNumber( string.format( '%.2f', -- 2 decimal places
					tonumber( value.amount ) * unit.mul ) )
			end
			if not mi.noCurrencyConversion[ unit.iso ] then
				er = er or require( 'Module:Exchange rate' )
				unit = er.getWrapper( a, unit.iso, '', 2, cm.getCurrencyFormatter )
				mu.addMaintenance( 'currencyTooltip' )
			else
				unit = mu.makeSpan( cm.getCurrencyFormatter( unitId ),
					'voy-currency voy-currency-' .. unit.iso:lower() )
			end
		else
			unit = vq.labels[ unitId ]
		end
		if unit and unit:find( '%s', 1, true ) then
			a = mw.ustring.format( unit, a )
		elseif unit then
			u = unit
		elseif mw.wikibase.isValidEntityId( unitId ) then
			-- currency code
			u = wu.getValue( unitId, mi.properties.iso4217 )
			if u == '' then
				-- unit symbol
				u = wu.getValuesByLang( unitId, mi.properties.unitSymbol, 1,
					page.lang )
				u = u[ 1 ] or ''
			end
			if u ~= '' then
				mu.addMaintenance( 'unitFromWD' )
			else
				u = unitId
				mu.addMaintenance( 'unknownUnit' )
			end
		end
		if a ~= '' and u ~= '' and formatter ~= '' and
			formatter:find( '$1', 1, true ) and formatter:find( '$2', 1, true ) then
			a = mw.ustring.gsub( f, '($1)', a )
			a = mw.ustring.gsub( a, '($2)', u )
		else
			a = ( u ~= '' ) and a .. '&nbsp;' .. u or a
		end
	end
	return a
end

local function getHourModules()
	if not hr then
		hi = require( 'Module:Hours/i18n' )
		hr = require( 'Module:Hours' )
	end
end

local function getLabel( id )
	local label = id
	local tables = { vq.labels }
	if hi then
		table.insert( tables, hi.dateIds )
	end
	if type( id ) == 'string' and id:match( '^Q%d+$' ) then
		for i, tab in ipairs( tables ) do
			if type( tab[ id ] ) == 'string' then
				label = tab[ id ]
				break
			end
		end
		if label == '' then
			return label
		elseif label == id then
			label = mu.getTypeLabel( id )
		end
		if label == '' or label == id then
			label = wu.getLabel( id ) or ''
			if label == '' then
				mu.addMaintenance( 'unknownLabel' )
			else
				mu.addMaintenance( 'labelFromWD' )
			end
		end
	end
	return label
end

-- getting comments for contacts and prizes from Wikidata using tables
local function getComments( statement, properties, page )
	local comments = {}
	local isMobilephone = false
	local minAge, maxAge
	for i, property in ipairs( properties ) do
		local pType = property .. '-type'
		if statement[ property ] then
			if property == mi.properties.minimumAge then
				minAge = getQuantity( statement[ property ][ 1 ], '', page )
			elseif property == mi.properties.maximumAge then
				maxAge = getQuantity( statement[ property ][ 1 ], '', page )
			end

			for j, id in ipairs( statement[ property ] ) do
				if statement[ pType ] == 'monolingualtext' then
					id = id.text
				elseif statement[ pType ] == 'time' then
					id = wu.getDateFromTime( id )
					id = mw.ustring.format( mi.texts.asOf, id )
				elseif type( id ) == 'table' then
					id = ''
				end
				if id == mi.qualifiers.mobilePhone then
					isMobilephone = true
				else
					mu.tableInsert( comments, getLabel( id ) )
				end
			end
		end
	end

	if minAge and maxAge then
		mu.tableInsert( comments, mw.ustring.format( mi.texts.fromTo,
			minAge:gsub( '(%d+).*', '%1' ), maxAge ) )
	elseif minAge then
		mu.tableInsert( comments, mw.ustring.format( mi.texts.from, minAge ) )
	elseif maxAge then
		mu.tableInsert( comments, mw.ustring.format( mi.texts.to, maxAge ) )
	end

	if #comments > 0 then
		mu.addMaintenance( 'commentFromWD' )
		return table.concat( comments, ', ' ), isMobilephone
	else
		return '', isMobilephone
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

local function getLngProperty( lng, p )
	if not mu.isSet( lng ) then
		return ''
	end

	lg = lg or require( 'Module:Languages' )
	local item = lg.lngProps[ lng ]
	if not item then
		local hyphen = lng:find( '-', 1, true )
		if hyphen and hyphen > 1 then
			item = lg.lngProps[ lng:sub( 1, hyphen - 1 ) ]
		end
	end
	if item then
		item = item[ p ]
	end

	return item or ( p == 'c' and 0 or '' )
end

local function removeStringDuplicates( ar )
	local hash = {}
	local result = {}
	local val

	for i = 1, #ar do
		val = ar[ i ]
		if not hash[ val ] then
			table.insert( result, val )
			hash[ val ] = 1
		end
	end
	return result
end

local function removeTableDuplicates( ar )
	local hash = {}
	local result = {}
	local hashVal

	for i, tab in ipairs( ar ) do
		hashVal = tab.value .. '#' .. tab.comment
		if not hash[ hashVal ] then
			table.insert( result, tab )
			hash[ hashVal ] = 1
		end
	end
	return result
end

local function mergeComments( ar )
	if #ar > 1 then
		for i = #ar, 2, -1 do
			for j = 1, i - 1, 1 do
				if ar[ i ].value == ar[ j ].value and ar[ i ].comment ~= ''
					and ar[ j ].comment ~= '' then
					ar[ j ].comment = ar[ j ].comment .. '; ' .. ar[ i ].comment
					table.remove( ar, i )
					break
				end
			end
		end
	end
end

local function convertTableWithComment( ar )
	for i = 1, #ar, 1 do
		if ar[ i ].comment == '' then
			ar[ i ] = ar[ i ].value
		else
			ar[ i ] = ar[ i ].value .. ' ('.. ar[ i ].comment .. ')'
		end
	end
end

--[[
properties are defined in Module:vCard/Params

p property or set of properties
f formatter string
c maximum count of results, default = 1
m concat mode (if c > 1), default concat with ', '
v value type,
	empty: string value (i.e. default type),
	id:    string value of an id like Q1234567  
	idl:   string value of the label of an id like Q1234567
	il:    language-dependent string value
	iq:    string value with qualifier ids
	au:    quantity consisting of amount and unit
	pau:   quantity consisting of amount (for P8733)
	vq:    string or table value with qualifiers ids and references
l = true: language dependent
l = wiki / local: monolingual text by wiki or local language
le = true: use date for lastedit parameter
--]]

-- function returns an array in any case
local function getWikidataValues( args, propDef, entity, page, country )
	local r = ''
	local ar = {}
	local a, i, isMobilephone, id, q, t, u, w

	-- setting defaults
	propDef.v = propDef.v or ''
	propDef.f = propDef.f or ''
	propDef.c = propDef.c or 1

	-- getting value arrays
	if propDef.l == 'wiki' then
		ar = wu.getValuesByLang( entity, propDef.p, propDef.c, page.lang )
	elseif propDef.l == 'local' then
		ar = wu.getValuesByLang( entity, propDef.p, propDef.c, country.lang )
	elseif propDef.l == true and propDef.c == 1 then
		id = getLngProperty( country.lang, 'q' )
		if id == '' then
			country.unknownLanguage = true
		else
			-- language of work or name
			a = wu.getValuesByQualifier( entity, propDef.p, mi.properties.languageOfName, id )
			if next( a ) then
				i = a[ getLngProperty( page.lang, 'q' ) ] -- item in page.lang
					or a[ id ] -- item in country lang
					or a[ next( a, nil ) ] -- first item
				ar = { i }
			end
		end
	elseif propDef.v == 'iq' or propDef.v == 'iqp' then
		q = propDef.v == 'iq' and mi.propTable.quantity or
			mi.propTable.policyComments
		ar = wu.getValuesWithQualifiers( entity, propDef.p, propDef.q, q,
			{ mi.properties.retrieved }, propDef.c )
		if propDef.le then
			args.lastedit = wu.getLastedit( args.lastedit, ar )
		end
	elseif propDef.v == 'au' or propDef.v == 'vq' then
		q = propDef.v == 'au' and mi.propTable.feeComments or
			mi.propTable.contactComments
		ar = wu.getValuesWithQualifiers( entity, propDef.p, nil, q,
			{ mi.properties.retrieved }, propDef.c )
		-- maybe a change of nil to a properties table is useful
		if propDef.le then
			args.lastedit = wu.getLastedit( args.lastedit, ar )
		end
	else
		ar = wu.getValues( entity, propDef.p, propDef.c )
	end
	if #ar == 0 and propDef.p ~= mi.properties.instanceOf then
		return ar
	elseif propDef.p == mi.properties.instanceOf then -- instance of
		return { mu.typeSearch( ar, entity ) }
	end

	for i = #ar, 1, -1 do
		-- amount with unit (for fees)
		if propDef.v == 'au' then
			a = getQuantity( ar[ i ].value, propDef.f, page )
			if a == '0' then
				a = vq.labels.gratis
			end
			u, isMobilephone = getComments( ar[ i ], mi.propTable.feeComments, page )
			ar[ i ] = { value = a, comment = u }

		-- for number of rooms P8733
		elseif propDef.v == 'pau' then
			if ar[ i ].unit == '1' then
				a = tonumber( ar[ i ].amount ) or 0
			else
				a = 0
			end
			ar[ i ] = {}
			ar[ i ][ mi.properties.quantity ] = { a }
			ar[ i ][ mi.properties.quantity .. '-type' ] = 'quantity'
			ar[ i ].value = mi.qualifiers.roomNumber
			ar[ i ]['value-type'] = 'wikibase-entityid'

		-- qualifier ids (for subtypes)
		elseif propDef.v == 'iq' or propDef.v == 'iqp' then
			if ar[ i ][ 'value-type' ] ~= 'wikibase-entityid' then
				table.remove( ar, i )
			end
			if propDef.v == 'iqp' then
				ar[ i ].policyComment, isMobilephone =
					getComments( ar[ i ], mi.propTable.policyComments, page )
			end

		-- strings with qualifiers (for contacts)
		elseif propDef.v == 'vq' then
			if ar[ i ][ 'value-type' ] ~= 'string' then
				table.remove( ar, i )
			else
				u, isMobilephone =
					getComments( ar[ i ], mi.propTable.contactComments, page )
				if mi.options.useMobile and propDef.t then
					if ( isMobilephone and propDef.t == 'mobile' ) or
						( not isMobilephone and propDef.t == 'landline' ) then
						ar[ i ] = { value = ar[ i ].value, comment = u }
					else
						table.remove( ar, i )
					end
				else
					ar[ i ] = { value = ar[ i ].value, comment = u }
				end
			end

		-- value, monolingual text, identifier
		else
			if propDef.v == 'id' then
				ar[ i ] = ar[ i ].id
			elseif propDef.v == 'idl' then
				getHourModules()
				ar[ i ] = hr.formatTime( getLabel( ar[ i ].id ) )
			end
			if ar[ i ] ~= '' and propDef.f ~= '' then
				ar[ i ] = mw.ustring.format( propDef.f, ar[ i ] )
			end
		end
		if propDef.v == 'au' or propDef.v == 'vq' then
			if ar[ i ] and ar[ i ].value == '' then
				table.remove( ar, i )
			end
		else
			if ar[ i ] == '' then
				table.remove( ar, i )
			end
		end
	end

	-- cleanup
	if propDef.v == 'au' or propDef.v == 'vq' then
		ar = removeTableDuplicates( ar )
		mergeComments( ar )
		convertTableWithComment( ar )
	else
		ar = removeStringDuplicates( ar )
	end

	return ar
end

local function getWikidataItem( args, parWDitem, entity, page, country )
	local arr = {}
	local subArr

	local function singleProperty( propDef )
		if #arr == 0 then
			arr = getWikidataValues( args, propDef, entity, page, country )
		else
			subArr = getWikidataValues( args, propDef, entity, page, country )
			for i = 1, #subArr, 1 do -- move to arr
				table.insert( arr, subArr[ i ] )
			end
		end
	end

	local p = parWDitem
	if not p then
		return ''
	end

	p.c = p.c or 1 -- count
	local tp = type( p.p )
	if tp == 'string' then
		singleProperty( p )
	elseif tp == 'table' then
		for key, sngl in ipairs( p.p ) do
			if type( sngl ) == 'table' then
				singleProperty( sngl )
			end
		end
	end

	if #arr > p.c then
		for i = #arr, p.c + 1, -1 do -- delete supernumerary values
			table.remove( arr, i )
		end
	end
	if p.m == 'no' then
		return arr
	else
		return table.concat( arr, p.m or ', ' )
	end
end

local function getAddressesFromWikidata( args, page, country, entity )
	local addresses = {}
	local t, u, w, weight

	-- getting addresses from Wikidata but only if necessary
	if args.address == true or args.addressLocal == true then
		-- P6375: address
		addresses = wu.getMonolingualValues( entity, mi.properties.streetAddress )
		if next( addresses ) then -- sometimes addresses contain <br> tag(s)
			for key, value in pairs( addresses ) do
				addresses[ key ] = value:gsub( '</*br%s*/*>', ' ' )
			end
		else
			return
		end
	else
		return
	end

	if args.address == true then
		args.address = addresses[ page.lang ]
		-- select address if the same writing system is used
		if not args.address then
			weight = -1
			u = getLngProperty( page.lang, 'w' ) -- writing entity id
			for key, value in pairs( addresses ) do
				-- same writing entity id as page.lang
				w = getLngProperty( key, 'w' )
				if w == '' then
					country.unknownPropertyLanguage = true
				else
					if key and w == u then -- same writing entity id
						w = getLngProperty( key, 'c' ) -- getting language weight
						if w > weight then -- compare language weight
							args.address = value
							args.addressLang = key
							weight = w
						end
					end
				end
			end
		end
		if not args.address then
			for i, lng in ipairs( mi.langs ) do
				if addresses[ lng ] then
					args.address = addresses[ lng ]
					args.addressLang = lng
					break
				end
			end
		end
		if not args.address then
			args.address = ''
			args.addressLang = ''
		end
		vc.fromWD.address = args.address ~= ''
	end

	-- removing county name from the end of address
	-- same with county name in county language and English
	if type( args.address ) == 'string' then
		args.address = mw.ustring.gsub( args.address,
			'[.,;]*%s*' .. country.country .. '$', '' )
	end

	t = true
	for i, lng in ipairs( mi.langs ) do
		if country.lang == lng then
			t = false
		end
	end
	if t and args.addressLocal == true
		and country.lang ~= page.lang then
		if country.lang ~= '' then
			args.addressLocal = addresses[ country.lang ] or ''
		else
			-- unknown language, maybe missing in Module:Languages
			args.addressLocal = addresses.unknown or ''
		end
		vc.fromWD.addressLocal = args.addressLocal ~= ''
	end
end

local function getDataFromWikidata( args, page, country, entity )
	if args.wikidata == '' then
		return
	end

	-- except local data if wiki language == country language
	if page.lang == country.lang then
		for key, value in ipairs( { 'nameLocal', 'addressLocal', 'directionsLocal' } ) do
			if type( args[ value ] ) == 'boolean' then
				args[ value ] = ''
			end
		end
	end

	mu.getNamesFromWikidata( args, vc.fromWD, page, country, entity )

	getAddressesFromWikidata( args, page, country, entity )
	if args.hours == true then
		local lastEdit
		getHourModules()
		args.hours, lastEdit = hr.getHoursFromWikidata( entity, page.lang,
			mi.langs[ 1 ] or '', mi.maintenance.properties, nil, args.lastedit,
			vq.labels )
		vc.fromWD.hours = args.hours ~= ''
		if mi.options.lasteditHours then
			args.lastedit = lastEdit
		end
	end

	for key, value in pairs( vp.ParWD ) do
		if args[ key ] == true then
			args[ key ] =
				getWikidataItem( args, vp.ParWD[ key ], entity, page, country )
			vc.fromWD[ key ] = args[ key ] ~= ''
		end
	end

	mu.getArticleLink( args, entity, page )
	mu.getCommonsCategory( args, entity )
	mu.getCoordinatesFromWikidata( args, vc.fromWD, entity )
end

local function finalParametersCheck( args, show, page, country, defaultType, entity )
	-- remove boolean values from parameters to have only strings
	for key, value in pairs( args ) do
		if type( args[ key ] ) == 'boolean' then
			args[ key ] = ''
		end
	end
	-- image check
	if not vc.fromWD.image or mi.options.WDmediaCheck then 
		mu.checkImage( args, entity )
	end

	-- adding names, url, nick names, comment and airport code
	mu.checkUrl( args )

	-- create givenName, displayName tables
	mu.prepareNames( args )

	-- analysing addressLocal vs address
	if args.addressLang and args.addressLang == country.lang then
		args.addressLocal = ''
	end
	if args.addressLocal ~= '' and args.address == '' then
		args.address =
			mu.languageSpan( args.addressLocal, mi.texts.hintAddress, page, country )
		args.addressLocal = ''
		vc.fromWD.address = vc.fromWD.addressLocal
	end

	show.noCoord = args.lat == '' or args.long == ''
	if show.noCoord then
		show.coord = nil
		show.poi   = nil
		mu.addMaintenance( 'missingCoordVc' )
	end

	-- getting Marker type, group, and color
	if not mu.isSet( args.type ) and mu.isSet( defaultType ) then
		args.type = defaultType
	end
	mu.checkTypeAndGroup( args )
	if mi.options.useTypeCateg and args.typeTable then
		for i, aType in ipairs( args.typeTable ) do
			mu.addMaintenance( 'type', aType )
		end
	end

	mu.checkStatus( args )

	args.zoom = math.floor( tonumber( args.zoom ) or mi.defaultZoomLevel )
	if args.zoom < 0 or args.zoom > mi.maxZoomLevel then
		args.zoom = mi.defaultZoomLevel
	end

	args.commonscat = args.commonscat:gsub( ' ', '_' )

	if mu.isSet( args.description ) and mw.ustring.match( args.description, '[%w_€$]$' ) then
		args.description = args.description .. '.'
	end
end

local function formatText( args, results, key, class )
	if not mu.isSet( args[ key ] ) then
		return
	end

	local r
	local textKey = key
	if key == 'hours' then
		args[ key ], r = mw.ustring.gsub( args[ key ],
			mi.texts.closedPattern, '' )
		textKey = ( r > 0 ) and 'closed' or key
	end
	r = mw.ustring.format( mi.texts[ textKey ], args[ key ] )
	r =	mw.ustring.gsub( r, '^%a', mw.ustring.upper )
	r = r .. ( r:sub( -1 ) == '.' and '' or '.' )

	table.insert( results, mu.makeSpan( r, class .. addWdClass( key ) ) )
end

local function formatPhone( args, key, country )
	if not mu.isSet( args[ key ] ) then
		return ''
	end
	
	local class
	local pArgs = {
		phone = args[ key ],
		cc = country.cc,
		isFax = false,
		isTollfree = false,
		format = false
	}
	if vc.fromWD[ key ] then
		pArgs.format = true
		pArgs.size = country.phoneDigits or 2
	end

	if key == 'fax' then
		class = 'p-tel-fax fax listing-fax' .. addWdClass( key )
		pArgs.isFax = true
	else
		class = 'p-tel tel listing-phone' .. addWdClass( key )
		if key == 'phone' then
			class = class .. ' listing-landline'
		elseif key == 'tollfree' then
			class = class .. ' listing-tollfree'
			pArgs.isTollfree = true
		elseif key == 'mobile' then
			class = class .. ' listing-mobile'
		end
	end
	return mw.ustring.format( mi.texts[ key ],
		mu.makeSpan( lp.linkPhoneNumbers( pArgs ), class ) )
end

local function makeIcons( args, page, country, entity, show )
	local name = args.givenName.name
	local icons = {}
	local onlyWikidata = mi.options.showSisters and not show.nositelinks and
		mu.makeSisterIcons( icons, args, page, country, entity )
	mu.makeSocial( icons, args, vc.fromWD, name )
	if #icons > 0 then
		return ( onlyWikidata and '' or ' ' ) .. table.concat( icons, '' )
	else
		return ''
	end
end

local function formatDate( aDate, aFormat )
	return mw.getContentLanguage():formatDate( aFormat, aDate, true )
end

local function removePeriods( s )
	-- closing (span) tags between full stops
	return s:gsub( '%.+(</[%l<>/]+>)%.+', '%1.' )
		:gsub( '%.%.+', '.' )
end

local function makeMarkerProperties( args, show )
	if show.symbol then
		args.symbol = mu.getMakiIconId( args.typeTable[ 1 ] )
		if args.symbol then
			mu.addIconToMarker( args )
		end
		if not mu.isSet( args.text ) then
			args.symbol = ''
			mu.addMaintenance( 'unknownMAKI' )
		end
	end
	if not mu.isSet( args.symbol ) then
		args.symbol = '-number-' .. args.group
	end
end

local function makeMarkerAndName( args, show, page, country, frame )
	local result = {}

	if args.before ~= '' then
		table.insert( result, mu.makeSpan( args.before, 'listing-before' ) )
	end
	-- adding status icons
	mu.tableInsert( result, mu.makeStatusIcons( args ) )

	-- adding POI marker
	if show.poi or mu.isSet( args.copyMarker ) then
		makeMarkerProperties( args, show )
		table.insert( result, mu.makeMarkerSymbol( args, args.givenName.all, frame ) )
	end
	
	mu.makeName( result, args, show, page, country, addWdClass( 'name' ),
		addWdClass( 'nameLocal' ) )

	return table.concat( result, ' ' )
end

local function makeEvent( args, page )
	local isEvent = false
	local s = {}
	local count = 0 -- counts from-to statements
	local startMonth -- month of start date
	local today = page.langObj:formatDate( 'Y-m-d', 'now', true )
	local todayYear = today:sub( 1, 4 )  -- yyyy
	local todayMonth = today:sub( 6, 7 ) -- mm
	local lastDate = ''
	local lastYear = ''
	local useYMD -- both dates are yyyy-mm-dd

	local function makePeriod( beginP, endP )
		if beginP == endP then
			endP = ''
		end
		if mu.isSet( beginP ) and mu.isSet( endP ) then
			count = count + 1
			return mw.ustring.format( mi.texts.fromTo2, beginP, endP )
		elseif mu.isSet( beginP ) then
			return beginP
		else
			return endP
		end
	end

	local function analyseDate( d, m, y )
		local success, c, t

		if useYMD then
			success, t = pcall( formatDate, d, mi.dates.yyyymmdd.f )
			success, c = pcall( formatDate, d, 'Y-m-d' )
			if success then
				lastDate = c > lastDate and c or lastDate
				d = t
			end
			return d, nil
		end

		if d:match( mi.dates.yyyymmdd.p ) then
			y = d:sub( 1, 4 )
			d = d:sub( 6 )
		end
		if mu.isSet( y ) then
			if y:match( mi.dates.yy.p ) then
				y = ( '2000' ):sub( -#y ) .. y
			elseif not y:match( mi.dates.yyyy.p ) then
				y = nil
			end
			lastYear = y > lastYear and y or lastYear
		end
		if mu.isSet( d ) and mu.isSet( m ) and d:match( mi.dates.dd.p ) and
			not m:match( mi.dates.mm.p ) then
			-- try to convert month to number string
			success, t = pcall( formatDate, m, 'm' )
			if success then
				m = t
			else
				for i = 1, 12, 1 do
					if m == mi.months[ i ] or mw.ustring.match( m, mi.monthAbbr[ i ] ) then
						m = '' .. i
						break
					end
				end
			end
		end
		if mu.isSet( d ) and mu.isSet( m ) and d:match( mi.dates.dd.p ) and
			m:match( mi.dates.mm.p ) then
			d = m:gsub( '%.+$', '' ) .. '-' .. d:gsub( '%.+$', '' )
			m = nil
		elseif mu.isSet( d ) and not mu.isSet( m ) and d:match( mi.dates.dd.p ) then
			d = ( startMonth or todayMonth ) .. '-' .. d:gsub( '%.+$', '' )
		end
		if mu.isSet( d ) then
			if d:match( mi.dates.mmdd.p ) then
				startMonth = d:gsub( '%-%d+', '' )
				m = nil
				c = ( y or todayYear ) .. '-' .. d
				success, t = pcall( formatDate, c, mi.dates.mmdd.f )
				if success then
					d = t
				end
			elseif d:match( mi.dates.dd.p ) and not mu.isSet( m ) and startMonth then
				c = ( y or todayYear ) .. '-' .. startMonth .. '-' .. d
				success, t = pcall( formatDate, c, mi.dates.mmdd.f )
				if success then
					d = t
				end
			end
		end
		if mu.isSet( m ) then
			d = ( mu.isSet( d ) and ( d .. ' ' ) or '' ) .. m
		end
		return d, y
	end

	if not mu.groupWithEvents( args.group ) then
		return ''
	end
	for i, param in ipairs( { 'date', 'month', 'year', 'endDate', 'endMonth',
		'endYear', 'frequency', 'location' } ) do
		if mu.isSet( args[ param ] ) then
			isEvent = true
			break
		end
	end
	if not isEvent then
		return ''
	end

	if mu.isSet( args.frequency ) then
		table.insert( s, mu.makeSpan( args.frequency, 'listing-frequency' ) )
	else
		if args.date:match( mi.dates.yyyymmdd.p ) and
			args.endDate:match( mi.dates.yyyymmdd.p ) then
			useYMD = true
			if args.date > args.endDate then
				args.date, args.endDate = args.endDate, args.date
			end
		end
		args.date, args.year
			= analyseDate( args.date, args.month, args.year )
		args.endDate, args.endYear
			= analyseDate( args.endDate, args.endMonth, args.endYear )

		local d = {}
		mu.tableInsert( d, makePeriod( args.date, args.endDate ) )
		mu.tableInsert( d, makePeriod( args.year, args.endYear ) )
		mu.tableInsert( s, mu.makeSpan( table.concat( d, count > 1 and ', ' or ' ' ),
			'listing-date' ) )

		if ( lastYear ~= '' and lastYear < todayYear ) or 
			( lastDate ~= '' and lastDate < today ) then
			mu.addMaintenance( 'outdated' )
		end
	end
	
	if mu.isSet( args.location ) then
		local locations = mu.textSplit( args.location, ',' )
		for i, location in ipairs( locations ) do
			if location ~= page.subpageText and location ~= page.text
				and mw.title.new( location, '' ).exists then
				location = mu.makeSpan( '[[' .. location .. ']]', 'listing-location' )
			end
			table.insert( s, location )	
		end
	end

	s = table.concat( s, ', ' )
	return ( s ~= '' and ': ' or '' ) .. s
end

local function makeAddressAndDirections( args, page, country )
	local r = ''
	local t

	if mu.isSet( args.address ) then
		if mu.isSet( args.addressLang ) then
			t = mw.language.fetchLanguageName( args.addressLang, page.lang )
			if mu.isSet( t ) then
				t = mw.ustring.format( mi.texts.hintAddress2, t )
			else
				country.unknownPropertyLanguage = true
				t = nil
			end
		end

		r = ', ' .. mu.makeSpan( args.address,
			'p-adr adr listing-address' .. addWdClass( 'address' ), true,
			{ title = t, lang = args.addressLang } )
	end
	if mi.options.showLocalData and mu.isSet( args.addressLocal ) then
		r = r .. mu.comma .. mu.languageSpan( args.addressLocal, mi.texts.hintAddress,
			page, country, 'listing-address-local' .. addWdClass( 'addressLocal' )	)
	end

	t = {}
	if mu.isSet( args.directions ) then
		table.insert( t, mu.makeSpan( args.directions,
			'listing-directions' .. addWdClass( 'directions' ) ) )
	end
	if mi.options.showLocalData and mu.isSet( args.directionsLocal ) then
		table.insert( t, mu.languageSpan( args.directionsLocal,
			mi.texts.hintDirections, page, country,
			'listing-directions-local' .. addWdClass( 'directionsLocal' ) ) )
	end
	if #t == 0 then
		return r
	end
	return r .. ' ' .. mu.makeSpan( '(' .. table.concat( t, mu.comma ) .. ')',
		'listing-add-address' )
end

local function makeContacts( args, country )
	local t = {}
	local s = ''

	mu.tableInsert( t, formatPhone( args, 'phone', country ) )
	mu.tableInsert( t, formatPhone( args, 'tollfree', country ) )
	mu.tableInsert( t, formatPhone( args, 'mobile', country ) )
	mu.tableInsert( t, formatPhone( args, 'fax', country ) )
	if args.email ~= '' then
		local lm = require( 'Module:LinkMail' )
		s = mu.makeSpan( lm.linkMailSet( { email = args.email, ignoreUnicode = 1 } ),
			'u-email email listing-email' .. addWdClass( 'email' ) )
		mu.tableInsert( t, mw.ustring.format( mi.texts.email, s ) )
	end
	if args.skype ~= '' then
		local ls = require( 'Module:LinkSkype' )
		s = mu.makeSpan( ls.linkSkypeSet( { skype = args.skype } ),
			'listing-skype' .. addWdClass( 'skype' ) )
		mu.tableInsert( t, mw.ustring.format( mi.texts.skype, s ) )
	end

	s = table.concat( t, ', ' )
	if s ~= '' then
		s = '. ' .. mw.ustring.gsub( s, '^%a', mw.ustring.upper )
	end
	return s
end

-- checking subtypes
local function checkSubtypes( args, subtypesTable )
	if not mu.isSet( args.subtype ) then
		return {}
	end

	local function aliasToSubtype( alias )
		if not vc.subtypeAliases then -- alias to subtype table
			vc.subtypeAliases = mu.getAliases( subtypesTable, 'alias' )
		end
		return vc.subtypeAliases[ alias ]
	end

	local function subtypeExists( subtype )
		return subtypesTable[ subtype ] and subtype or aliasToSubtype( subtype )
	end

	local subtypes = {}
	local invalidSubtypes = {}
	local at, count, invalidCount, item
	for subtype, v in pairs( mu.split( args.subtype ) ) do
		invalidCount = false
		count = ''
		item = subtype
		-- split item from count
		at = item:find( ':', 1, true )
		if at then
			count = tonumber( item:sub( at + 1, #item ) ) or ''
			item = mw.text.trim( item:sub( 1, at - 1 ) )
			if count == '' then
				invalidCount = true -- ':' without count or not a number
			else
				count = math.floor( count )
				if count < 2 then
					count = ''
				end
			end
		end
		item = subtypeExists( item ) or mu.typeExists( item )
		if item then
			subtypes[ item ] = count
		end
		if invalidCount or not item then
			table.insert( invalidSubtypes, subtype )
		end
	end
	if #invalidSubtypes > 0 then
		mu.addMaintenance( 'unknownSubtype', table.concat( invalidSubtypes, ', ' ) )
	end
	return subtypes
end

-- making subtypes string
local function makeFeatures( args, tab, show )
	vc.fromWD.subtypeAdd = not show.nowdsubtype and
		type( args.subtypeAdd ) == 'table' and #args.subtypeAdd > 0
	if show.nosubtype or not ( vc.fromWD.subtypeAdd or mu.isSet( args.subtype )
		or #args.subtypeTable > 0 ) then
		return
	end

	local vs = require( 'Module:VCard/Subtypes' )
	local function getSubtypeParams( subtype )
		local r = vs.f[ subtype ] or mu.getTypeParams( subtype )
		if not r.n then
			r.n = r.label or subtype
		end
		r.g = r.g or vs.fromTypesGroupNumber
		return r
	end

	local subtypes = checkSubtypes( args, vs.f )

	-- merging subtypeAdd (from Wikidata) to manually entered subtypes
	local unknowWDfeatures = false
	local count, label, p, t
	if vc.fromWD.subtypeAdd then
		-- making translation table from Wikidata ids to feature types
		local subtypeIds = mu.getAliases( vs.f, 'wd' )

		-- adding type if Wikidata id (wd.value) is known
		-- indexed array prevents multiple identical types
		for i, wd in ipairs( args.subtypeAdd ) do
			t = subtypeIds[ wd.value ] or mu.idToType( wd.value )
			if not t then
				-- maybe instance or subclass of wd.value are known
				local p31ids = wu.getIds( wd.value, mi.properties.instanceOf )
				local p279ids = wu.getIds( wd.value, mi.properties.subclassOf )
				-- merging both arrays
				for i = 1, #p279ids, 1 do
				    table.insert( p31ids, p279ids[ i ] )
				end
				for i = 1, #p31ids, 1 do
					t = subtypeIds[ p31ids[ i ] ] or mu.idToType( p31ids[ i ] )
					if t then
						break
					end
				end
			end
			-- subtype from WD is not known
			if not t and not vs.exclude[ wd.value ] then
				unknowWDfeatures = true

				-- try to add a new subtype Q... to vs.f subtypes table
				label = wu.getLabel( wd.value )
				if label then
					vs.f[ wd.value ] = {
						n = label,
						wd = wd.value,
						g = vs.fromWDGroupNumber
					}
					t = wd.value
				end
			end
			-- add known subtype
			if t then
				subtypes[ t ] = {
					c = ( wd[ mi.properties.quantity ]
						and wd[ mi.properties.quantity ][ 1 ] )
						or ( wd[ mi.properties.capacity ] and
						wd[ mi.properties.capacity ][ 1 ] ) or '',
					p = wd.policyComment
				}
			end
		end
	end
	if unknowWDfeatures then
		mu.addMaintenance( 'unknowWDfeatures' )
	end
    if next( subtypes ) == nil and #args.subtypeTable == 0 then
        return
    end

	-- replace selected subtypes
	for subtype, count in pairs( subtypes ) do
		if vs.convert[ subtype ] then
			if type( count ) == 'table' then
				p = count.p
				count = count.c
			end
			t = vs.convert[ subtype ][ count ] or vs.convert[ subtype ][ 1 ]
			subtypes[ t ] = { p = p }
			subtypes[ subtype ] = nil
		end
	end

	-- make subtypes table sortable
	local s = {};
	for subtype, count in pairs( subtypes ) do
		if type( count ) == 'table' then
			table.insert( s, { t = subtype, c = count.c, p = count.p } )
		else
			table.insert( s, { t = subtype, c = count } )
		end
	end
	-- add subtypes from types table
	if args.subtypeTable then
		for i, subtype in ipairs( args.subtypeTable ) do
			table.insert( s, { t = subtype, c = 1 } )
		end
	end

	-- sorting subtypes
	-- by subtype group and then alphabetically by name
	table.sort( s,
		function( a, b )
			local at = getSubtypeParams( a.t )
			local bt = getSubtypeParams( b.t )
			local na = mu.convertForSort( at.n )
			local nb = mu.convertForSort( bt.n )
			return ( at.g < bt.g ) or ( at.g == bt.g and na < nb )
		end
	)

	-- make text and data output
	local data = {} -- for data-subtype attribute in wrapper tag
	if #s > 0 then
		local r = {};
		local subtype, f, u, u_n, v
		for i = 1, #s do
			subtype = s[ i ]

			-- for data-subtype="..." in wrapper tag
			u = subtype.t .. ',' .. tostring( i )
			if type( subtype.c ) == 'number' and subtype.c > 1 then
				u = u .. ',' .. subtype.c
			end
			table.insert( data, u )

			u = getSubtypeParams( subtype.t )
			if u.g >= vs.firstGroup then
				u_n = u.n
				if not mu.isSet( u_n ) then
					u_n = subtype.t 
				end
				u_n = u_n:gsub( '[,;/].*$', '' )
				count = ( type( subtype.c ) == 'number' ) and subtype.c or 1
				if count > 1 and u_n:find( '%[[^%[%]]*%]' ) then
					v = mw.ustring.format( mi.texts.subtypeWithCount, subtype.c,
						u_n:gsub( '%[([^%[%]]*)|([^%[%]]*)%]', '%1' )
							:gsub( '%[([^%[%]]*)%]', '%1' ) )
				else
					v = u_n:gsub( '%[([^%[%]]*)|([^%[%]]*)%]', '%2' )
						:gsub( '%[([^%[%]]*)%]', '' )
				end
				if mu.isSet( u.t ) then -- string tooltip
					v = mw.ustring.format( mi.texts.subtypeSpan, u.t, v )
				elseif mu.isSet( u.f ) then -- icons
					f = mw.ustring.format( mi.texts.subtypeFile, u.f, v )
					if u.c then
						f = mw.ustring.rep( f, u.c )
					end
					v = mw.ustring.format( mi.texts.subtypeAbbr, v, f )
				end
				-- adding policy comment
				if subtype.p and subtype.p ~= '' then
					v = v .. ' (' .. subtype.p .. ')'
				end
			end
			table.insert( r, v )
		end
		if #r > 0 then
			r = #r == 1 and mw.ustring.format( mi.texts.subtype, r[ 1 ] )
				or mw.ustring.format( mi.texts.subtypes, table.concat( r, ', ' ) )
			if r ~= '' then
				table.insert( tab, mu.makeSpan( r, 
					'listing-subtype' .. addWdClass( 'subtypeAdd' ) ) )
			end
		end
	end

	-- subtype contains now the value for wrapper tag
	args.subtype = table.concat( data, ';' )
end

local function makePayment( args, results )
	if not mu.isSet( args.payment ) then
		return
	end

	local t
	local class = 'p-note note listing-payment'
	if type( args.payment ) == 'table' then
		local vr = mw.loadData( 'Module:VCard/Cards')
		for i = #args.payment, 1, -1 do -- remove unknown items
			t = args.payment[ i ]
			if vr.cards[ t ] then
				args.payment[ i ] = vr.cards[ t ]
			else
				table.remove( args.payment, i )
			end
		end
		class = class .. mu.addWdClass( #args.payment > 0 )
		args.payment = table.concat( args.payment, ', ' )
	else
		mu.addMaintenance( 'paymentUsed' )
	end
	formatText( args, results, 'payment', class )
end

local function wrapDescription( args, tab, isInline, addText )
	local text = args.description .. ( addText or '' )
	if args.description ~= '' then
		table.insert( tab, tostring( mw.html.create( isInline and 'span' or 'div' )
			:addClass( 'p-note note listing-content' )
			:wikitext( text ) )
		)
	end
end

local function makeMetadata( args )
	local outdated = false
	local s, success, u
	local t = args.lastedit
	if t ~='' then
		success, t = pcall( formatDate, t, mi.dates.lastedit.f )
		if not success then
			mu.addMaintenance( 'wrongDate' )
			t = ''
		else
			success, s = pcall( formatDate, args.lastedit, 'U' ) -- UNIX seconds
			success, u = pcall( formatDate, mi.texts.expirationPeriod, 'U' )
			if s < u then
				t = t .. ' ' .. mi.texts.maybeOutdated
				outdated = true
			end
		end
	end

	local tag = mw.html.create( 'span' )
		:attr( 'class', 'listing-metadata listing-metadata-items' )
		-- add node to save the parent tag
		:node( mw.html.create( 'span' )
			:addClass( 'listing-metadata-item listing-lastedit' )
			:addClass( outdated and 'listing-outdated' or nil )
			:addClass( t == '' and 'listing-item-dummy' or nil )
			:wikitext( mw.ustring.format( mi.texts.lastedit,
				t == '' and mi.texts.lasteditNone or t ) )
		)
	return tostring( tag )
end

-- making description, coordinates, and meta data
local function makeDescription( args, show, page, country, entity )
	local results = {}

	-- inline description
	if show.inlineDescription then
		wrapDescription( args, results, true )
	end

	-- adding features
	makeFeatures( args, results, show )

	-- practicalities
	formatText( args, results, 'hours', 'p-note note listing-hours' )
	formatText( args, results, 'checkin', 'listing-checkin' )
	formatText( args, results, 'checkout', 'listing-checkout' )
	formatText( args, results, 'price', 'p-note note listing-price' )
	makePayment( args, results )

	-- adding Unesco symbol
	if args.unesco ~= '' and mi.options.showUnesco then
		local uLink, uTitle = require( 'Module:VCard/Unesco' ).getUnescoInfo( country )
		table.insert( results, mu.addLinkIcon( 'listing-unesco voy-symbol-unesco',
			uLink, uTitle, 'unesco' ) )
	end

	local noContent = #results == 0

	-- adding DMS coordinates
	if show.coord then
		table.insert( results, mu.dmsCoordinates( args.lat, args.long,
			args.givenName.name, vc.fromWD.lat, country.extra ) )
	end
	if mi.options.showSisters == 'atEnd' then
		table.insert( results, makeIcons( args, page, country, entity, show ) )
	end

	local metaData = makeMetadata( args )

	-- adding description in block mode
	local description
	if args.description ~= '' and not show.inlineDescription then
		-- last edit will be inserted at the end of the div tag
		wrapDescription( args, results, false, metaData )
		noContent = false
		description = table.concat( results, ' ' )
		if description ~= '' then
			description = ' ' .. description
		end
	else
		description = table.concat( results, ' ' )
		if description ~= '' then
			description = ' ' .. description
		end
		description = description .. metaData
	end

	return removePeriods( description ), noContent
end

local function makeMaintenance( page )
	if mi.nsNoMaintenance[ page.namespace ] then
		return ''
	end
	
	local r = mu.getMaintenance()
	if mi.options.usePropertyCateg then
		local m = mi.maintenance.properties -- format string
		r = r .. wu.getCategories( m ) .. mu.getCategories( m )
			.. cm.getCategories( m )
		if hr then
			r = r .. hr.getCategories( m )
		end
	end
	return r
end

-- vCard main function
function vc.vCard( frame )
	mu.initMaintenance()
	local page = mu.getPageData()

	-- getting location (vCard/listing) entity, show options and country data
	local args, vcEntity, show, country = initialParametersCheck( frame )

	-- associated Wikivoyage page of the location in current Wikivoyage branch
	-- possibly modified by mu.getArticleLink()
	args.wikiPage = ''

	-- getting data from Wikidata
	getDataFromWikidata( args, page, country, vcEntity )

	-- final check
	local defaultType = frame.args.type
	finalParametersCheck( args, show, page, country, defaultType, vcEntity )

	-- making output
	-- leading part for marker mode: only location names and comment

	-- saving address
	args.addressOrig = args.address

	-- creating text parts
	-- leading part (marker and names)
	local leading = makeMarkerAndName( args, show, page, country, frame )
		.. makeEvent( args, page )

	-- additional parts for vCard mode
	local contacts = '' -- all contacts

	-- get address and directions
	local address = makeAddressAndDirections( args, page, country )

	-- get all contact information
	local contacts = makeContacts( args, country )
	contacts = removePeriods( address .. contacts )
	
	-- making description, coordinates, and meta data
	local description, noContent =
		makeDescription( args, show, page, country, vcEntity )

	local r = leading
	local icons = ''
	if contacts == '' and noContent then
		show.inline = true
		r = r .. makeIcons( args, page, country, vcEntity, show ) .. description
	else
		if type( mi.options.showSisters ) == 'boolean' then
			-- could also be 'atEnd', then part of body
			icons = makeIcons( args, page, country, vcEntity, show )
		end
		r = removePeriods( r .. contacts .. icons ..
			( show.noperiod and '' or '. ' ) .. description )
			:gsub( '%)(</span>)%s*(<span [^>]*>)%(', '%1; %2' )
	end
	-- prevents line break before punctuation mark
	r = r:gsub( '</span>([,;.:!?])', '%1</span>' )

	-- error handling and maintenance, not in template and module namespaces
	if country.unknownLanguage then
		mu.addMaintenance( 'unknownLanguage' )
	end
	if country.unknownPropertyLanguage then
		mu.addMaintenance( 'unknownPropertyLanguage' )
	end
	r = r .. makeMaintenance( page )

	-- wrapping tag
	args.address = args.addressOrig
	return mu.makeWrapper( r, args, page, country, show, vp.vcardData, 'vCard', frame )
end

return vc