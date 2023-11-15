--[[
	Functions library for Marker and vCard modules
	In non-Wikivoyage projects, sister-project links functions have to be adapted.
]]--

-- require( 'strict' )
local cd = require( 'Module:Coordinates' )
local mg = require( 'Module:Marker utilities/Groups' )
local mi = require( 'Module:Marker utilities/i18n' )
local mm -- MAKI icons
local mt = require( 'Module:Marker utilities/Types' )   -- types to groups like drink, eat, go, see, sleep, ...
local uc -- URL check
local wu = require( 'Module:Wikidata utilities' )

-- module variable and administration
local mu = {
	moduleInterface = {
		serial = '2023-10-06',
		item   = 58187612
	},
	comma = mi.texts.comma
}

local colorAdjust = { ['-webkit-print-color-adjust'] = 'exact', ['color-adjust'] = 'exact',
	['print-color-adjust'] = 'exact' }

-- maintenance tools
function mu.initMaintenance( name )
	mu.invalidParams    = {}   -- table of unknown parameters
	mu.duplicateAliases = {}   -- table of duplicate parameter aliases
	mu.maintenance      = {}   -- table of error strings
	mu.maintenanceIds   = {}   -- table of error-string ids

	mu.typeAliases      = nil  -- table for type aliases. Create on demand
	mu.groupAliases     = nil  -- table for group aliases
end

local function contains( new )
	for i = 1, #mu.maintenance do
		if mu.maintenance[ i ] == new then
			return true
		end
	end
	return false
end

function mu.addMaintenance( key, value )
	local s = key -- fallback
	local tab = mi.maintenance[ key ]
	if tab then
		mu.maintenanceIds[ key ] = '1'
		s = mi.formats.category:format( tab.category ) ..
			( tab.err and mi.formats.error:format( tab.err ) or '' ) ..
			( tab.hint and mi.formats.hint:format( tab.hint ) or '' )
	end
	s = value and mw.ustring.format( s, value ) or s

	if not contains( s ) then
		table.insert( mu.maintenance, s )
	end
end

function mu.getMaintenance()
	if #mu.invalidParams == 1 then
		mu.addMaintenance( 'unknownParam', mu.invalidParams[ 1 ] )
	elseif #mu.invalidParams > 1 then
		mu.addMaintenance( 'unknownParams', table.concat( mu.invalidParams, ', ' ) )
	end
	if #mu.duplicateAliases > 0 then
		mu.addMaintenance( 'duplicateAliases',	table.concat( mu.duplicateAliases, ', ' ) )
	end
	return table.concat( mu.maintenance, '' )
end

function mu.getCategories( formatStr )
	return wu.getCategories( formatStr )
end

-- general-use functions
function mu.isSet( arg )
	return arg and arg ~= ''
end

function mu.convertForSort( s )
	s = mw.ustring.lower( s )
	for i, obj in ipairs( mi.substitutes ) do
		s = mw.ustring.gsub( s, obj.l, obj.as )
	end
	return s
end

-- replacing decimal separator and inserting group separators
function mu.formatNumber( num )
	if mu.isSet( mi.formatnum.decimalPoint ) and mi.formatnum.decimalPoint ~= '.' then
		num = num:gsub( '%.', mi.formatnum.decimalPoint )
	end

	if mu.isSet( mi.formatnum.groupSeparator ) then
		local count
		repeat
			num, count = num:gsub( '^([-+]?%d+)(%d%d%d)',
				'%1%' .. mi.formatnum.groupSeparator .. '%2' ) 
		until count == 0
	end
    return num
end

function mu.tableInsert( tab, value )
	if mu.isSet( value ) then
		table.insert( tab, value )
	end
end

-- splitting string s at sep, removing empty substrings
-- sep is a single character separator but no magic pattern character
function mu.textSplit( s, sep )
	local result = {}
	for str in s:gmatch( '([^' .. sep .. ']+)' ) do
		mu.tableInsert( result, mw.text.trim( str ) )
	end
	return result
end

local function encodeSpaces( s )
	s = s:gsub( '[_%s]+', '_' )
	return s
end

-- Splitting comma separated lists to a table and converting items
function mu.split( s )
	local arr = {}
	if not mu.isSet( s ) then
		return arr
	end
	for i, str in ipairs( mu.textSplit( s, ',' ) ) do
		arr[ encodeSpaces( str:lower() ) ] = 1
	end
	return arr
end

function mu.makeSpan( s, class, isBdi, attr, css )
	return tostring( mw.html.create( isBdi and 'bdi' or 'span' )
		:addClass( class )
		:attr( attr or {} )
		:css( css or {} )
		:wikitext( s )
	)
end

-- bdi and bdo tags are not working properly on all browsers. Adding marks
-- (lrm, rlm) is maybe the only way for a correct output
function mu.languageSpan( s, titleHint, page, country, addClass )
	if not mu.isSet( s ) then
		return ''
	end

	local bdi = mw.html.create( 'bdi' )
		:addClass( addClass )
		:wikitext( s )
	local c = country.lang
	if c == '' or c == page.lang then
		return tostring( bdi )
	end

	local dir
	local fStr = '%s'
	if country.isRTL and not page.isRTL then
		dir = 'rtl'
		fStr = '&rlm;%s&lrm;'
	elseif not country.isRTL and page.isRTL then
		dir = 'ltr'
		fStr = '&lrm;%s&rlm;'
	end	

	return fStr:format( tostring( bdi
		:addClass( 'voy-lang voy-lang-' .. c )
		:attr( { title = mw.ustring.format( titleHint , country.langName ),
			lang = c, dir = dir } )
	) )
end

function mu.addWdClass( isFromWikidata )
	return isFromWikidata and ' voy-wikidata-content' or ''
end

function mu.getAliases( tab, key )
	local result = {}
	if not tab then
		return result
	end
	local v
	for k, tb in pairs( tab ) do
		v = tb[ key ]
		if v then
			if type( v ) == 'table' then
				for i = 1, #v do
					result[ v[ i ] ] = k
				end
			else
				result[ v ] = k
			end
		end
	end
	return result
end

function mu.yesno( val )
	return mi.yesno[ mw.ustring.lower( val ) ]
end

-- check functions

-- args: template arguments consisting of argument name as key and a value
-- validKeys: table with argument name as key used by the script and
--    a string or a table of strings for argument names used by the local wiki
function mu.checkArguments( templateArgs, validKeys )
	local args = {}
	if not templateArgs or not validKeys or not next( validKeys ) then
		return args
	end

	local keys = {} -- list of wiki-dependent parameter names
	for key, params in pairs( validKeys ) do
		if type( params ) == 'string' then
			keys[ params ] = key
		else
			for i = 1, #params do
				keys[ params[ i ] ] = key
			end
		end
	end
	
	local targetKey
	for key, arg in pairs( templateArgs ) do
		targetKey = keys[ key ]
		if targetKey then
			if args[ targetKey ] then -- prevents duplicates
				table.insert( mu.duplicateAliases, "''" .. key .. "''" )
			else
				args[ targetKey ] = arg
			end
		else
			table.insert( mu.invalidParams, "''" .. key .. "''" )
		end
	end
	return args
end

local function removeNS( s, nsTable )
	if not s:find( ':', 1, true ) then
		return s
	end

	local t = s
	for i = 1, #nsTable do
		t = mw.ustring.gsub( t, '^' .. nsTable[ i ] .. ':', '' )
		if s ~= t then
			return t
		end
	end
	return t
end

function mu.checkCommonsCategory( args )
	-- remove namespace from category
	if type( args.commonscat ) == 'string' and args.commonscat ~= '' then
		args.commonscat = removeNS( args.commonscat, mi.texts.CategoryNS )
		if args.commonscat ~= '' then
			mu.addMaintenance( 'commonscat' )
		end
	end
end

-- checking coordinates
function mu.checkCoordinates( args )
	local function clearCoordinates()
		args.lat = ''
		args.long = ''
	end

	local t
	if type( args.lat ) == 'boolean' or type( args.long ) == 'boolean' then
		clearCoordinates()
	end
	if args.lat == '' and args.long == '' then
		return
	elseif args.lat ~= '' and args.long == '' then
		t = args.lat:find( ',', 1, true )
		if t then
			args.long = mw.text.trim( args.lat:sub( t + 1, #args.lat ) )
			args.lat = mw.text.trim( args.lat:sub( 1, t - 1 ) )
		end
	end
	if args.lat == '' or args.long == '' then
		clearCoordinates()
		mu.addMaintenance( 'wrongCoord' )
		return
	end

	local dms = false
	t = tonumber( args.lat )
	if t then
		args.lat = math.abs( t ) <= 90 and t or ''
	else
		t = cd.toDec( args.lat, 'lat', 6 )
		args.lat = t.error == 0 and t.dec or ''
		dms = args.lat ~= ''
	end

	if args.lat ~= '' then
		t = tonumber( args.long )
		if t then
			args.long = ( t > -180 and t <= 180 ) and t or ''
		else
			t = cd.toDec( args.long, 'long', 6 )
			args.long = t.error == 0 and t.dec or ''
			dms = dms or args.long ~= ''
		end
	end

	if args.lat == '' or args.long == '' then
		clearCoordinates()
		mu.addMaintenance( 'wrongCoord' )
	elseif dms then
		mu.addMaintenance( 'dmsCoordinate' )
	end
end

-- image check
function mu.checkImage( args, entity )
	if type( args.image ) == 'boolean' or args.image == '' then
		return
	end

	-- formal checks
	if args.image:find( '^https?:' ) then
		args.image = ''
	else
		-- remove namespace
		args.image = removeNS( args.image, mi.texts.FileNS )
		local extensionExists = false
		local im = args.image:lower()
		for i = 1, #mi.fileExtensions do
			if im:find( '%.' .. mi.fileExtensions[ i ] .. '$' ) then
				extensionExists = true
				break
			end
		end
		if not extensionExists then
			args.image = ''
		end
	end
	if args.image == '' then
		mu.addMaintenance( 'wrongImgName' )
		return
	end

	local alreadyChecked = false
	if mi.options.mediaCheck and args.image ~= '' then
		if not mi.options.WDmediaCheck and entity then
			-- check if image is stored in Wikidata
			local imgs = wu.getValues( entity, mi.properties.image, nil )
			for i = 1, #imgs do
				if imgs[ i ] == args.image then
					alreadyChecked = true
					break
				end
			end
		end
		if not alreadyChecked then
			-- expensive function call
			local title = mw.title.new( 'Media:' .. args.image )
			if not title or not title.exists then
				mu.addMaintenance( 'missingImg', args.image )
				args.image = ''
			end
		end
	end
end

function mu.checkStatus( args )
	args.statusTable = {}
	local hash = {}
	if mu.isSet( args.status ) then
		local statusAliases = mu.getAliases( mi.statuses, 'alias' )
		for i, t in ipairs( mu.textSplit( args.status, ',' ) ) do
			t = encodeSpaces( t:lower() )
			t = statusAliases[ t ] or t
			if mi.statuses[ t ] then
				if not hash[ t ] then
					table.insert( args.statusTable, t )
					hash[ t ] = 'x'
				end
			else
				mu.addMaintenance( 'unknownStatus' )
			end
		end
	end
end

-- groups translation for map legend into Wiki language
local function translateGroup( group )
	if not mu.isSet( group ) then
		group = mt.types.error.group
	end
	local t = mg.groups[ group ]
	if t then
		t = t.map or t.label or t.alias or group
		if type( t ) == 'table' then
			t = t[ 1 ]
		end
		return t
	end
	return group
end

local function getTypeFromTypeAliases( aType )
	if not mu.typeAliases then
		mu.typeAliases = mu.getAliases( mt.types, 'alias' )
	end
	return mu.typeAliases[ aType ]
end

local function getGroupFromGroupAliases( group )
	if not mu.groupAliases then
		mu.groupAliases = mu.getAliases( mg.groups, 'alias' )
	end
	return mu.groupAliases[ group ]
end

-- getting marker type and group
function mu.checkTypeAndGroup( args )
	local s, t
	args.typeTable = {}
	args.subtypeTable = {}
	if mu.isSet( args.group ) then
		mu.addMaintenance( 'groupUsed' )
		s = mg.groups[ args.group ]
		if not s then
			s = getGroupFromGroupAliases( args.group )
			if s then
				args.group = s
				s = mg.groups[ args.group ]
			end
		end
		if not s then			
			mu.addMaintenance( 'unknownGroup' )
			args.group = ''
		elseif s.is and s.is == 'color' then
			mu.addMaintenance( 'groupIsColor' )
			if mi.options.useTypeCateg then
				mu.addMaintenance( 'type', args.group )
			end
		end
	end
	if not mu.isSet( args.type ) then
		args.type = mt.types.error.group
		if args.group == '' then
			args.group = mt.types.error.group
		end
		mu.addMaintenance( 'missingType' )
	elseif args.type == mt.types.error.group then
		if args.group == '' then
			args.group = mt.types.error.group
		end
		mu.addMaintenance( 'unknownType' )
	else
		-- split seperate types and analyse them
		for i, t in ipairs( mu.textSplit( args.type, ',' ) ) do
			-- try to find the type t in types or groups
			t = encodeSpaces( t:lower() )
			if not mt.types[ t ] then
				t = getTypeFromTypeAliases( t ) or getGroupFromGroupAliases( t ) or t
			end

			s = mg.groups[ t ]
			if s then -- type is a group itself
				if s.is and s.is == 'color' then
					mu.addMaintenance( 'typeIsColor' )
				elseif not mi.options.noTypeMsgs then
					mu.addMaintenance( 'typeIsGroup' )
				end
				if args.group == '' then
					args.group = t
				end
			else
				s = mt.types[ t ]
				if s then
					if args.group == '' then
						args.group = s.group
					end
					if mu.isSet( s.subtype ) then
						table.insert( args.subtypeTable, t )
					end
				else
					mu.addMaintenance( 'unknownType' )
					args.group = mt.types.error.group
				end
			end
			table.insert( args.typeTable, t )
		end
		args.type = table.concat( args.typeTable, ',' )
	end
	args.groupTranslated = translateGroup( args.group )
	mu.getColor( args )
end

local function isUrl( url )
	uc = uc or require( 'Module:UrlCheck' )
	return uc.isUrl( url, mi.options.skipPathCheck )
end

-- url check in args
function mu.checkUrl( args )
	if not mu.isSet( args.url ) then
		return
	end

	local c = isUrl( args.url ) -- getting result code
	if c > 2 then
		mu.addMaintenance( 'wrongUrl' )
		args.url = ''
	elseif c == 2 then -- URL contains IP address
		mu.addMaintenance( 'urlWithIP' )
	else
		for i = 1, #mi.services do
			if args.url:find( mi.services[ i ].key .. '.com', 1, true ) then
				mu.addMaintenance( 'urlIsSocialMedia' )
				args.url = ''
			end
		end
	end
end

-- type and group functions
-- getting a set of parameters for a given type
function mu.getTypeParams( aType )
	return mt.types[ aType ]
end

function mu.idToType( id )
	if not mu.types then
		mu.types = mu.getAliases( mt.types, 'wd' ) -- Q id to type table
	end
	return mu.types[ id ]
end

function mu.getTypeLabel( id )
	if not mu.isSet( id ) then
		return ''
	end
	if id:match( '^Q%d+$' ) then
		id = mu.idToType( id )
		if not id then
			return ''
		end
	end

	local at, t
	id = id:gsub( '[_%s]+', '_' )
	t = mt.types[ id ]
	if not t then
		t = getTypeFromTypeAliases( id )
		t = t and mt.types[ t ]
	end
	if t then
		t = t.label or id
		at = t:find( ',' )
		if at then
			t = t:sub( 1, at - 1 )
		end
	else
		t = id:gsub( '_', ' ' )
	end
	return t
end

function mu.typeExists( aType )
	return mt.types[ aType ] and aType or getTypeFromTypeAliases( aType )
end

-- check if the specified group can have events
function mu.groupWithEvents( group )
	return mg.groups[ group ] and mg.groups[ group ].withEvents
end

-- getting color from group in args
function mu.getColor( args )
	local c = mg.groups[ args.group ] or mg.groups[ 'error' ]
	args.color = c.color
	args.inverse = c.inverse
end

-- Splitting comma separated lists to a table of key items
-- checking items with allowed key values of validValues table
local function splitAndCheck( s, validValues )
	local values = {}
	if not validValues then
		return values, ''
	end

	local errors = {}
	for item, v in pairs( mu.split( s ) ) do
		-- value check
		if validValues[ item ] then
			values[ item ] = 1
		else
			table.insert( errors, item )
		end
	end
	return values, table.concat( errors, ', ' )
end

local function setCopyMarker( args, show )
	if show.copy and ( mu.isSet( args.copyMarker ) or not mu.isSet( args.wikidata ) ) then
		show.copy = nil
		mu.addMaintenance( 'deleteShowCopy' )
	end
	if show.copy then
		args.copyMarker = args.wikidata
	end
	if mu.isSet( args.copyMarker ) then
		show.symbol = nil
	end
end

-- treatment of social media services if Wikidata is available
local function setSocialMedia( args, value )
	for i, service in ipairs( mi.services ) do
		args[ service.key ] = value
	end
end

function mu.getShow( default, args, validValues )
	local show = mu.split( default )
	local add, err = splitAndCheck( args.show, validValues )
	if err ~= '' then
		mu.addMaintenance( 'unknownShow', err )
	end
	if add.none or add.coord or add.poi or add.all then
		show.all   = nil -- overwriting defaults
		show.coord = nil
		show.poi   = nil
	end
	for key, value in pairs( add ) do
		show[ key ] = value
	end
	if show.none then
		show.none  = nil
		show.all   = nil
		show.coord = nil
		show.poi   = nil
	end
	if show.all then
		show.all   = nil
		show.coord = ''
		show.poi   = ''
	end
	if show.noname then
		show.noname = nil
		show.name = nil
	end
	setCopyMarker( args, show )
	if args.wikidata ~= '' then
		if show.socialmedia then
			setSocialMedia( args, 'y' )
		elseif show.nosocialmedia then
			setSocialMedia( args, 'n' )
		end
	end

	return show
end

local function replaceWithSpace( s, pattern )
	s = s:find( pattern ) and s:gsub( pattern, ' ' ) or s
	return s
end

-- removing line breaks and controls from parameter strings
function mu.removeCtrls( s, onlyInline )
	local descrDiv = false -- div tag instead of span tag for description needed?

	-- remove controls from tags before test
	s = s:gsub( '(<[^>]+>)', function( t )
			return replaceWithSpace( t, '[%z\1-\31]' )
		end )

	local t = replaceWithSpace( s, '</br%s*>' )
	if onlyInline then
		t = replaceWithSpace( t, '<br[^/>]*/*>' )
		t = replaceWithSpace( t, '</*p[^/>]*/*>' )
		t = replaceWithSpace( t, '[%z\1-\31]' )
		-- not %c because \127 is used for Mediawiki tags (strip markers `UNIQ)
	else
		t = replaceWithSpace( t, '[%z\1-\9\11\12\14-\31]' )
		descrDiv = t:find( '[\10\13]' ) or t:find( '<br[^/>]*/*>' ) or
			t:find( '<p[^/>]*>' )
	end
	if t ~= s then
		mu.addMaintenance( 'illegalCtrls' )
	end

	-- remove LTR and RTL marks
	t = mw.ustring.gsub( t, '[‎‏]+', '' )

	if descrDiv then
		mu.addMaintenance( 'descrDiv' )
		-- unify line breaks to Linux mode
		t = t:gsub( '\13\10', '\10' ):gsub( '\13', '\10' )
		-- replace line breaks by <br> in block mode
		t = t:gsub( '([^>%]\10])\10+([^<%[\10])', '%1<br class="listing-next-paragraph" />%2' )
	end

	return replaceWithSpace( t, '%s%s+' ), descrDiv
end

-- fetch data from Wikidata
function mu.getCoordinatesFromWikidata( args, fromWikidata, entity )
	if not entity or ( args.lat ~= '' and args.long ~= '' ) then
		return
	end

	-- center coordinates from Wikidata
	local c = wu.getValue( entity, mi.properties.centerCoordinates )
	if c == '' then
		-- coordinates from Wikidata
		c = wu.getValue( entity, mi.properties.coordinates )
	end
	if c ~= '' then
		args.lat = c.latitude
		args.long = c.longitude
		fromWikidata.lat = true
	end
end

local function _typeSearch( p31 )
	-- p31: array of Wikidata values
	if not p31 or #p31 == 0 then
		return ''
	end

	local firstStep = true

	local function compareLabels( ar )
		if not ar then
			return nil
		elseif type( ar ) == 'string' then
			ar = { ar }
		end
		for i, value in ipairs( ar ) do
			if mu.isSet( value ) then
				value = mw.ustring.lower( encodeSpaces( value ) )
				if mt.types[ value ] then
					return value
				end
			end
		end
		return nil
	end

	local function compareIds( ar )
		local id, t
		for i = 1, #ar do
			id = ar[ i ].id
			-- md: indexed array of q id - types relations
			t = mu.idToType( id )
			if t then
				return t
			end

			-- checking English label and aliases
			t = compareLabels( mw.wikibase.getLabelByLang( id, 'en' ) )
				or compareLabels( wu.getAliases( id, 'en' ) )
			if t then
				if firstStep and not mi.options.noTypeMsgs then
					firstStep = false
					mu.addMaintenance( 'typeFromWDchain' )
				end
				return t
			end
		end
		return nil
	end

	local aType = compareIds( p31 ) -- check p31 ids first, maybe step 2 is not nessary
	if aType then
		return aType
	end

	-- now functions becomes expensive because of multiple wu.getValues calls
	local id, ids
	firstStep = false
	for i = 1, #p31 do -- step 2: analyse P279 chains of first ids
		id = p31[ i ].id -- start id
		local j = 0
		repeat
			ids = wu.getValues( id, mi.properties.subclassOf, nil )
			if #ids > 0 then
				aType = compareIds( ids )
				if aType then
					if not mi.options.noTypeMsgs then
						mu.addMaintenance( 'typeFromWDchain' )
					end
					return aType
				end
				id = ids[ 1 ].id
			end
			j = j + 1

		-- limit: maximum levels to analyse
		until j >= mi.searchLimit or #ids == 0
	end

	return ''
end

function mu.typeSearch( p31, entity )
	if p31 and #p31 == 0 then
		p31 = wu.getValues( entity, mi.properties.subclassOf, mi.p31Limit )
	end
	return _typeSearch( p31 )
end

function mu.getCommonsCategory( args, entity )
	-- getting commonscat from commonswiki sitelink before P373
	-- because sitelink is checked by Wikidata
	if type( args.commonscat ) == 'boolean' then
		args.commonscat = ''
	end

	local t = wu.getSitelink( entity, 'commonswiki' ) or ''
	if t:match( '^Category:.+$' ) then
		t = t:gsub( '^[Cc]ategory:', '' )
	else
		t = wu.getValue( entity, mi.properties.commonsCategory )
		if t == '' then
			local id = wu.getId( entity, mi.properties.mainCategory )
			if id ~= '' then
				t = wu.getSitelink( id, 'commonswiki' ) or ''
				t = t:gsub( '^[Cc]ategory:', '' )
			end
		end
	end
	if t ~= '' and args.commonscat ~= '' then
		mu.addMaintenance( 'commonscatWD' )
	end
	if args.commonscat == '' then
		args.commonscat = t
	end
end

local function getLangTable( wikiLang, localLang )
	local langs = { wikiLang }
	for i, lang in ipairs( mi.langs ) do
		table.insert( langs, lang )
	end
	if mu.isSet( localLang ) and localLang ~= wikiLang then
		table.insert( langs, localLang )
	end
	return langs
end

-- getting names from Wikidata
function mu.getNamesFromWikidata( args, fromWikidata, page, country, entity )
	-- getting official names
	local officialNames =
		wu.getMonolingualValues( entity, mi.properties.officialName )

	if type( args.name ) == 'boolean' or args.name == '' then
		args.name = ''
		local langs = getLangTable( page.lang )
		for i, lang in ipairs( langs ) do
			args.name = officialNames[ lang ]
			if args.name then
				break
			end
		end
		-- if failed then get labels
		if not mu.isSet( args.name ) then
			for i, lang in ipairs( langs ) do
				args.name = wu.getLabel( entity, lang, true )
				if args.name then
					break
				end
			end
			args.name = args.name or ''
		end
		if args.name ~= '' then
			mu.addMaintenance( 'nameFromWD' )
			fromWikidata.name = true
		end
	end

	-- get local name if no name is available
	if args.name == '' and
		not ( type( args.nameLocal ) == 'string' and args.nameLocal ~= '' ) then
		args.nameLocal = true
	-- no local name if country and wiki language are identical
	elseif args.nameLocal == true and page.lang == country.lang then
		args.nameLocal = ''	
	end

	if args.nameLocal == true then
		args.nameLocal = officialNames[ country.lang ] or ''
		if args.nameLocal == '' then
			args.nameLocal = wu.getLabel( entity, country.lang, true ) or ''
		end
		if args.name == '' and args.nameLocal ~= '' then
			args.name = args.nameLocal
			args.nameLocal = ''
			mu.addMaintenance( 'nameFromWD' )
			fromWikidata.name = true
		end
		if args.name:lower() == args.nameLocal:lower() then
			args.nameLocal = ''
		end
		fromWikidata.nameLocal = args.nameLocal ~= ''
		if fromWikidata.nameLocal then
			mu.addMaintenance( 'localNameFromWD' )
		end
	end
end

-- getting link to Wikivoyage
function mu.getArticleLink( args, entity, page )
	local title = wu.getFilteredSitelink( entity, page.lang .. page.globalProject )
	if title and title ~= page.text then
		args.wikiPage = title
	end
end

-- marker functions
-- returns a single data set from Module:Marker utilities/Maki icons
function mu.getMaki( key )
	mm = mm or require( 'Module:Marker utilities/Maki icons' )
	key = key:lower():gsub( '[_%s]+', '-' )
	return mm.icons[ key ]
end

function mu.getMakiIconId( key )
	if not mu.isSet( key ) then
		return nil
	end
	key = key:lower():gsub( '[_%s]+', '-' )
	if mu.getMaki( key ) then
		return key
	end
	key = mt.types[ key ] and mt.types[ key ].icon
	if key and mu.getMaki( key ) then
		return key
	end
	return nil
end

function mu.addIconToMarker( args )
	local formatStr = args.inverse and '[[File:Maki7-%s.svg|x14px|link=|class=noviewer]]'
		or '[[File:Maki7-%s-white.svg|x14px|link=|class=noviewer]]'
	args.text = formatStr:format( args.symbol )
end

-- making marker symbol
function mu.makeMarkerSymbol( args, title, frame )
	local inverseClass = args.inverse and ' listing-map-inverse' or ''

	if mu.isSet( args.copyMarker ) then
		local copyClass = 'listing-map plainlinks printNoLink voy-copy-marker'
			.. inverseClass
		return tostring( mw.html.create( 'span' )
			:addClass( copyClass )
			:css( colorAdjust )
			-- display will be replaced by [[MediaWiki:Gadget-GeneralChanges.js]] script
			:css( { display = 'none' } )
			:attr( { ['data-copy-marker-attribute'] = args.copyMarker:match( 'Q%d+' )
				and 'data-wikidata' or 'data-name', title = mi.texts.tooltip,
				['data-copy-marker-content'] = args.copyMarker } )
		)
	end
	
	local lon = tonumber( args.long )
	local lat = tonumber( args.lat )
    local tagArgs = {
        zoom = tonumber( args.zoom ),
        latitude = lat,
        longitude = lon,
        show = mg.showAll,
    }
	if mu.isSet( args.text ) then
		tagArgs.text = args.text
		tagArgs.class = 'no-icon'
	end
	if mu.isSet( args.mapGroup ) then
		tagArgs.group = args.mapGroup
		tagArgs.show = args.mapGroup
	else
		tagArgs.group = args.groupTranslated
	end
	if mu.isSet( args.image ) then
		tagArgs.description = '[[File:' .. args.image .. '|100x100px|' .. title .. ']]'
	end

	local geoJson = {
		type = 'Feature',
		geometry = {
			type = 'Point',
			coordinates = { lon, lat }
		},
		properties = {
			title = title,
			description = tagArgs.description,
			['marker-symbol'] = args.symbol,
			['marker-color'] = args.color,
			['marker-size'] = 'medium',
		}
	}

	return tostring( mw.html.create( 'span' )
		:addClass( 'listing-map plainlinks printNoLink' .. inverseClass )
		:attr( 'title', mi.texts.tooltip )
		:css( colorAdjust )
		:css( 'background-color', args.color )
		-- frame:extensionTag is expensive
		:wikitext( frame:extensionTag( 'maplink', mw.text.jsonEncode( geoJson ), tagArgs ) )
	)
end

-- icon functions
function mu.makeStatusIcons( args )
	local result = ''
	for i, v in ipairs( args.statusTable ) do
		result = result .. mu.makeSpan( ' ', 'listing-status listing-status-' .. v,
			false, { title = mi.statuses[ v ].label }, colorAdjust )
	end
	return result
end

function mu.addLinkIcon( classes, link, title, text, addSpace )
	local span = mu.makeSpan( ' ', nil, false, { title = title, ['data-icon'] = text },
		colorAdjust ) -- space to keep the span tag
	local lFormat = ( link:find( '^https?://' ) or link:find( '^//' ) )
		and '[%s %s]' or '[[%s|%s]]'
	local iconLink = mw.ustring.format( lFormat, link, span )
	if addSpace then
		iconLink = mu.makeSpan( ' ', 'listing-icon-with-space', true ) .. iconLink
	end
	return mu.makeSpan( iconLink, 'listing-icon ' .. classes )
end

-- adding linked sister icons
local function addSisterIcons( icons, sisters, name, id )
	local icon, link
	for i, key in ipairs( { 'wikivoyage', 'wikipedia', 'commons', 'wikidata' } ) do
		if mu.isSet( sisters[ key ] ) then
			icon = mu.addLinkIcon( 'listing-sister-icon listing-sister-' .. key, sisters[ key ],
				mw.ustring.format( mi.iconTitles[ key ], name, id ), key,
				key == 'wikidata' ) -- add leading space
			table.insert( icons, icon )
		end
	end

	-- return true if only Wikidata icon
	return mu.isSet( sisters.wikidata ) and #icons == 1
end

-- getting sister project links
local function getWikiLink( langArray, wiki, entity, wikilang )
	local prefix = wiki == 'wiki' and 'w:' or 'voy:'
	local link
	for i, lang in ipairs( langArray ) do
		if lang ~= '' then
			link = wu.getFilteredSitelink( entity, lang .. wiki )
			if link then
				prefix = prefix .. ( lang ~= wikilang and ( lang .. ':' ) or '' )
				return prefix .. link
			end
		end
	end
	return ''
end

-- adding Wikimedia sister project icons
function mu.makeSisterIcons( icons, args, page, country, entity )
	local sisters = {
		commons    = '', -- link to Commons category
		wikidata   = '', -- link to Wikidata
		wikipedia  = '', -- link to Wikipedia
		wikivoyage = ''  -- link to another branch, usually en, as a sister link
	}

	if mu.isSet( args.wikipedia ) then
		sisters.wikipedia = 'w:' .. args.wikipedia
	end
	if mu.isSet( args.wikidata ) then
		local langs = getLangTable( page.lang, country.lang )

		if sisters.wikipedia == '' then
			sisters.wikipedia = getWikiLink( langs, 'wiki', entity, page.lang )
		end
		if args.wikiPage == '' then
			table.remove( langs, 1 ) -- exclude page.lang
			sisters.wikivoyage = getWikiLink( langs, page.globalProject, entity, page.lang )
			if sisters.wikivoyage ~= '' then
				mu.addMaintenance( 'linkToOtherWV' )
			end
		end
		sisters.wikidata = 'd:' .. args.wikidata
	end
	if args.commonscat ~= '' then
		sisters.commons = 'c:Category:' .. args.commonscat
	end

	return addSisterIcons( icons, sisters, args.givenName.name, args.wikidata )
end

-- creating social media icons including value check
function mu.makeSocial( icons, args, fromWikidata, name )
	local domain, span, t

	for i, service in ipairs( mi.services ) do
		-- check values first
		t = args[ service.key ] or ''
		domain = service.url:gsub( 'com/.*', 'com/' )
		if t ~= '' then
			if t:match( '^http' ) then
				if not t:find( 'https', 1, true ) then
					t = t:gsub( '^http', 'https' )
					mu.addMaintenance( 'wrongSocialUrl', service.key )
				end
				if isUrl( t ) > 1 or
					not t:match( '^' .. domain .. '.+$' ) then
					t = ''
					mu.addMaintenance( 'wrongSocialUrl', service.key )
				end
				if t ~= '' and not fromWikidata[ service.key ] then
					mu.addMaintenance( 'socialUrlUsed', service.key )
				end
			else
				local match = false
				local sp = service.pattern
				if type( sp ) == 'string' then
					sp = { sp }
				end
				for i = 1, #sp do
					if mw.ustring.match( t, sp[ i ] ) then
						match = true
						break
					end
				end
				if not match then
					t = ''
					mu.addMaintenance( 'wrongSocialId', service.key )
				end
			end
		end
		args[ service.key ] = t

		-- create symbol link
		if t ~= '' then
			if not t:find( domain, 1, true ) then
				t = mw.ustring.format( service.url, t )				
			end

			span = mu.addLinkIcon( 'listing-social-media listing-social-media-' ..
				service.key .. mu.addWdClass( fromWikidata[ service.key ] ), t,
				mw.ustring.format( mi.iconTitles[ service.key ], name ), service.key )
			table.insert( icons, span )
		end
	end
end

-- output functions
local function removeStars( args )
	for i, param in ipairs( mi.options.noStarParams ) do
		if mu.isSet( args[ param ] ) and args[ param ]:find( '*', 1, true ) then
			args[ param ] = args[ param ]:gsub( '%*+', '' )
			args[ param ] = mw.text.trim( args[ param ] )
			mu.addMaintenance( 'nameWithStar' )
		end
	end
end

-- getting name table with linked and unlinked names
local function getName( name, pageTitle )
	local r = {
		all = '', -- name or linked name
		name = '', -- only name
		pageTitle = '', -- if pageTitle ~= '' name is already linked
	}
	if type( name ) ~= 'string' or name == '' then
		return r
	end

	local s
	local t, c = mw.ustring.gsub( name, '^(.*)%[%[(.*)%]%](.*)$', '%2' )
	if c > 0 then -- is / contains [[...]]
		t = mw.text.trim( t )
		r.all = '[[' .. t .. ']]'
		s, c = mw.ustring.gsub( t, '^(.*)|(.*)$', '%2' )
		if c > 0 then -- is [[...|...]]
			r.name = mw.text.trim( s )
			r.pageTitle = mw.ustring.gsub( t, '^(.*)|(.*)$', '%1' )
			r.pageTitle = mw.text.trim( r.pageTitle )
		else
			r.name = t
			r.pageTitle = t
		end
	else
		r.name = name
		r.all = name
		if pageTitle ~= '' then
			r.pageTitle = pageTitle
			r.all = '[[' .. pageTitle .. '|' .. name .. ']]'
		end
	end
	removeStars( r, { 'name', 'all' } )
	return r
end

-- create givenName, displayName tables
function mu.prepareNames( args )
	local function simplifyString( s, length )
		s = mw.ustring.sub( s, 1, length )
		s = mw.ustring.gsub( s, "[%.'" .. '"“”„‟«»‘’‚‛‹›]', '' )
		s = mw.ustring.gsub( s, '[‐‑‒–—―]', ' ' )
		return mw.ustring.lower( s )
	end

	local function removeDuplicate( value1, key2 )
		if not mu.isSet( value1 ) or not mu.isSet( args[ key2 ] ) then
			return
		end
		local minLen = math.min( mw.ustring.len( value1 ), mw.ustring.len( args[ key2 ] ) )
		if simplifyString( value1, minLen ) == simplifyString( args[ key2 ], minLen ) then
			args[ key2 ] = ''
		end
	end

	-- use local name if name is not given
	if args.name == '' and args.nameLocal ~= '' then
		args.name = args.nameLocal
		args.nameLocal = ''
	end
	if args.name == args.nameMap then
		args.nameMap = ''
	end
	-- missing name
	if args.name == '' then
		args.name = mi.texts.missingName
		mu.addMaintenance( 'missingNameMsg' )
	end
	-- names shall not contain tags or template calls
	if args.name:find( '<', 1, true ) or args.name:find( '{{', 1, true ) or
		args.nameMap:find( '<', 1, true ) or args.nameMap:find( '{{', 1, true ) or
		args.nameLocal:find( '<', 1, true ) or args.nameLocal:find( '{{', 1, true ) then
		mu.addMaintenance( 'malformedName' )
	end
	removeStars( args )
	-- handling linked names like [[article|text]]
	args.displayName = getName( args.name, args.wikiPage )
	if mu.isSet( args.nameMap ) then
		args.givenName = getName( args.nameMap, args.wikiPage )
	else
		args.givenName = args.displayName
	end

	-- remove identical names
	removeDuplicate( args.givenName.name, 'nameLocal' )
	removeDuplicate( args.givenName.name, 'alt' )
	removeDuplicate( args.givenName.name, 'comment' )
	removeDuplicate( args.nameLocal, 'alt' )
	removeDuplicate( args.alt, 'comment' )
	removeDuplicate( args.directions, 'directionsLocal' )
	removeDuplicate( args.address, 'addressLocal' )
end

local function _makeAirport( code, args )
	local span = mu.makeSpan( args[ code ],
		'listing-' .. code .. '-code' .. mu.addWdClass( true ) )
	return mu.makeSpan( mw.ustring.format( mi.texts[ code ], span ),
		'listing-airport listing-' .. code )
end

local function makeAirport( args, show )
	if show.noairport then
		return ''
	else
		local t = args.type:gsub( ',.*$', '' ) -- only first type
		if mt.types[ t ] and not mt.types[ t ].useIATA then
			return ''
		end
	end

	if mu.isSet( args.iata ) then
		return _makeAirport( 'iata', args )
	elseif mu.isSet( args.icao ) then
		return _makeAirport( 'icao', args )
	else
		return ''
	end
end

-- creating a list of nick names etc.
local function makeNameAffix( args, page, country, addClass, show )
	local result = {}
	if mi.options.showLocalData then
		if mu.isSet( args.nameLocal ) then
			table.insert( result, 
				mu.languageSpan( args.nameLocal, mi.texts.hintName, page, country,
					'listing-name-local' .. addClass ) )
		end
		if mu.isSet( args.nameLatin ) then
			table.insert( result, mu.makeSpan( args.nameLatin,
				'listing-name-latin', false, { title = mi.texts.hintLatin,
					lang = mu.isSet( country.lang ) and ( country.lang .. '-Latn' ) or nil } ) )
		end
	end
	for i, key in ipairs( { 'alt', 'comment' } ) do
		if mu.isSet( args[ key ] ) then
			table.insert( result, mu.makeSpan( args[ key ], 'listing-' .. key ) )
		end
	end
	mu.tableInsert( result, makeAirport( args, show ) )
	if #result == 0 then
		return ''
	end
	return ' ' .. mu.makeSpan( '(' .. table.concat( result, mu.comma ) .. ')',
		'p-nickname nickname listing-add-names' )
end

-- replace brackets in names
local function replaceBrackets( s )
	s = s:gsub( '%[', '&#x005B;' ):gsub( '%]', '&#x005D;' )
	return s
end

-- creating (linked) name and its affix
function mu.makeName( result, args, show, page, country, nameClass, localClass )
	local s, t

	if mu.isSet( args.url ) and args.displayName.pageTitle == '' then
		s = '[' .. args.url .. ' '
			.. replaceBrackets( args.displayName.name ) .. ']'
	else
		s = args.displayName.all
	end
	if mu.isSet( args.nameExtra ) then
		s = s .. ' ' .. args.nameExtra
	end

	if s ~= '' then
		t = mw.uri.anchorEncode( args.givenName.name ):gsub( '&amp;', '&' )
			:gsub( '&#039;', "'" )
		table.insert( result, mu.makeSpan( s,
			'p-name fn org listing-name' .. nameClass, true,
			{ id = 'vCard_' .. t, style = args.styles } ) )
	end

	if mu.isSet( args.url ) and args.displayName.pageTitle ~= '' then
		-- both article and web links
		table.insert( result, mu.addLinkIcon( 'listing-url', args.url,
			mi.iconTitles.internet, 'internet' ) )
	end

	mu.tableInsert( result,	makeNameAffix( args, page, country, localClass,
		show ) )
end

-- getting DMS coordinates
function mu.dmsCoordinates( lat, long, name, fromWD, extraParams, noBrackets )
	local function coordSpan( title, text )
		return mu.makeSpan( text, 'coordStyle', false, { title = title } )
	end

	local dec
	local latDMS, dec, latMs = cd.getDMSString( lat, 4, 'lat', '', '', mi.defaultDmsFormat )
	local longDMS, dec, longMs = cd.getDMSString( long, 4, 'long', '', '', mi.defaultDmsFormat )

	local r = '[' .. mi.coordURL .. latMs .. '_' .. longMs .. '_' ..
		mw.uri.encode( extraParams ) .. '&locname=' .. mw.uri.encode( name ) ..
		' ' .. coordSpan( mi.texts.latitude, latDMS ) ..
		' ' .. coordSpan( mi.texts.longitude, longDMS ) .. ']'
	r = noBrackets and r or ( '(' .. r .. ')' )
	return mu.makeSpan( r, 'listing-dms-coordinates printNoLink plainlinks'
		.. mu.addWdClass( fromWD ) )
end

-- prepare value s for data attribute and replace all entities by characters
local function data( s )
	return mu.isSet( s ) and mw.text.decode( s, true ) or nil
end

-- adding wrapper and microformats
function mu.makeWrapper( result, args, page, country, show, list, aClass, frame )
	local wrapper = mw.html.create( show.inline and 'span' or 'div' )
		:addClass( 'vcard h-card ' .. aClass )
	if args.noGpx then
		wrapper:addClass( 'listing-no-gpx' )
	end
	if show.outdent and not show.inline then
		wrapper:addClass( 'listing-outdent' )
	end
	if show.inlineSelected then
		wrapper:addClass( 'listing-inline' )
	end
	if mu.isSet( args.copyMarker ) or not show.poi then
		wrapper:addClass( 'voy-without-marker' )
	end
	if #args.statusTable > 0 then
		wrapper:addClass( 'listing-with-status' )
	end
	for id, v in pairs( mu.maintenanceIds ) do
		wrapper:addClass( 'listing-maintenance-' .. id )
	end
	if args.givenName.name ~= mi.texts.missingName then
		wrapper:attr( 'data-name', data( args.givenName.name ) )
	end
	if mu.isSet( args.wikidata ) then
		wrapper:attr( 'id', 'vCard_' .. args.wikidata )
	end
	wrapper:attr( 'data-location', data( page.subpageText ) )
		:attr( 'data-location-qid', page.entityId )
		:attr( 'data-wikilang', page.lang )
		:attr( 'data-country', data( country.iso_3166 ) )
		:attr( 'data-country-name', data( country.country ) )
		:attr( 'data-lang', data( country.lang ) )
		:attr( 'data-lang-name', data( country.langName ) )
		:attr( 'data-country-calling-code', data( country.cc ) )
		:attr( 'data-trunk-prefix', data( country.trunkPrefix ) )
		:attr( 'data-dir', data( country.isRTL and 'rtl' or 'ltr' ) )
		:attr( 'data-wiki-dir', data( page.isRTL and 'rtl' or 'ltr' ) )
		:attr( 'data-currency', data( country.addCurrency ) )
	local arg
	for key, value in pairs( list ) do
		arg = args[ key ]:gsub( '<[^<>]*>', '' ) -- remove html tags
		wrapper:attr( value, data( arg ) )
	end
	if not show.noCoord then
		wrapper:node( mw.html.create( 'span' )
			:addClass( 'p-geo geo listing-coordinates' )
			:css( 'display', 'none' )
			:node( mw.html.create( 'span' )
				:addClass( 'p-latitude latitude' )
				:wikitext( args.lat )
			)
			:node( mw.html.create( 'span' )
				:addClass( 'p-longitude longitude' )
				:wikitext( args.long )
			)	
		)
	end
	if not show.name then
		wrapper:node( mw.html.create( 'span' )
			:addClass( 'p-name fn org listing-name' )
			:css( 'display', 'none' )
			:wikitext( args.givenName.name )
		)
	end

	wrapper = tostring( wrapper:wikitext( result ) )

	-- adding coordinates to Mediawiki database
	-- frame:callParserFunction is expensive
	if not show.noCoord and mi.options.secondaryCoords then
		wrapper = wrapper .. frame:callParserFunction{ name = '#coordinates',
			args = { args.lat, args.long, country.extra, name = args.givenName.name } }
	end

	return wrapper
end

function mu.getPageData()
	local page = mw.title.getCurrentTitle()
	page.langObj = mw.getContentLanguage()
	page.lang = page.langObj:getCode()
	page.langName = mw.language.fetchLanguageName( page.lang, page.lang )
	page.isRTL = page.langObj:isRTL()
	page.entityId = mw.wikibase.getEntityIdForCurrentPage() -- can be nil
	page.siteName = mw.site.siteName
	page.globalProject = page.siteName:lower()
	if page.globalProject == 'wikipedia' then
		page.globalProject = 'wiki'
	end

	return page
end

return mu