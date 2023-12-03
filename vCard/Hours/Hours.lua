-- getting opening hours from Wikidata

-- module variable and administration
local hr = {
	moduleInterface = {
		suite  = 'Hours',
		serial = '2022-10-22',
		item   = 99600452
	},
	labelTable = nil
}

-- module import
-- require( 'strict' )
local hi = require( 'Module:Hours/i18n' )
local wu = require( 'Module:Wikidata utilities' )

-- local variables
local categIds    = {}
local showOptions = {}

local function isSet( s )
	return s and s ~= ''
end

-- insert a value into a table only if it is set
local function tableInsert( tab, value )
	if isSet( value ) then
		table.insert( tab, value )
	end
end

-- value count for any variable
local function getCount( tab )
	return type( tab ) == 'table' and #tab or 0
end

local function getLabelFromTables( id )
	local label = hi.dateIds[ id ]
	if not label and hr.labelTable then
		label = hr.labelTable[ id ]
	end
	return label
end

-- getting normalized time hh:dd
local function getNormalizedTime( s )
	local count
	s, count = mw.ustring.gsub( s, hi.texts.timePattern, '%1:%2' )
	return ( count > 0 ) and s or nil
end

function hr.formatTime( s )
	local t = getNormalizedTime( s )
	if not t then
		return s
	end

	local formatStr = hi.texts.formatTime
	t = mw.text.split( t, ':', true )
	if #t == 1 then
		t[ 2 ] = '00'
	end
	if hi.options.hour12 then
		local isAM = true
		local n = tonumber( t[ 1 ] )
		if n > 12 then
			isAM = false
			t[ 1 ] = '' .. ( n - 12 )
		end
		formatStr = isAM and hi.texts.formatAM or hi.texts.formatPM
	end
	s = mw.ustring.format( formatStr, mw.text.trim( t[ 1 ] ),
		mw.text.trim( t[ 2 ] ) )
	if hi.options.leadingZero then
		s = s:gsub( '^(%d):', '0%1:' )
	else
		s = s:gsub( '^0(%d):', '%1:' )
	end
	if hi.options.removeZeros then
		s = s:gsub( '^(%d%d?):00', '%1' )
	end
	return s
end

-- getting label for a qualifier id
-- to save computing time firstly the id will fetched from Hours/i18n table
-- if available, otherwise from Wikidata
local function getLabelFromId( id, wikilang, fallbackLang )
	if not isSet( id ) then
		return ''
	end

	-- from table
	local label = getLabelFromTables( id )

	-- from Wikidata
	if not label and mw.wikibase.isValidEntityId( id ) then
		label = wu.getLabel( id, wikilang )
		if not label and isSet( fallbackLang ) then
			label = wu.getLabel( id, fallbackLang )
			if label then
				categIds.fallbackLabel = ''
			end
		end
		if label then
			categIds.labelFromWikidata = ''
		end
	end

	-- abbreviate labels
	if isSet( label ) then
		for i, abbr in ipairs( hi.abbr ) do
			label = mw.ustring.gsub( label, abbr.f, abbr.a )
		end
		label = mw.ustring.gsub( label, '​', '' ) -- zero-width space
	end

	-- additional time formatting
	if isSet( label ) then
		if hi.months then
			for full, short in pairs( hi.months ) do
				label = mw.ustring.gsub( label, full, short )
			end
		end
		label = hr.formatTime( label )
	end
	return label or ''
end

local function abbreviateTimeStr( s, all, pattern, repl )
	if not isSet( s ) or not isSet( pattern ) or not repl then
        return s or ''
	end
	if all then
		s = mw.ustring.gsub( s, pattern, repl )
	else
		local matchPattern = mw.ustring.gsub( pattern, '%(%%d%)', '' )
		local first, stop = mw.ustring.find( s, pattern )
		if first then
			local second = mw.ustring.find( s, pattern, stop + 1 )
			if second and mw.ustring.match( s, matchPattern ) ==
				mw.ustring.match( s, matchPattern, stop + 1 ) then
        		s = mw.ustring.gsub( s, pattern, repl, 1 )
        	end
    	end
    end
    return s
end

-- getting time period string
-- i:  position in from and to arrays
-- id: label for P3035 value
local function getTimePeriod( from, to, i, id )
	local result = ''
	if id and ( id == getLabelFromTables( hi.times.daily )
		or id == getLabelFromTables( hi.times.is24_7 ) )
		and from and to and from[ i ] == getLabelFromTables( hi.times.Jan1 ) and
		to[ i ] == getLabelFromTables( hi.times.Dec31 ) then
		return ''
	end
	if from and isSet( from[ i ] ) and to and isSet( to[ i ] ) then
		result = mw.ustring.format( hi.texts.fromTo, from[ i ], to[ i ] )
		if isSet( hi.texts.hourPattern ) then
			result = abbreviateTimeStr( result, hi.texts.hourReplAll,
				hi.texts.hourPattern, hi.texts.hourRepl )
		end
	elseif from and isSet( from[ i ] ) then
		result = mw.ustring.format( hi.texts.from, from[ i ] )
	elseif to and isSet( to[ i ] ) then
		result = mw.ustring.format( hi.texts.to, to[ i ] )
	end
	return result
end

-- collecting all maintenance categories
function hr.getCategories( formatStr )
	local result = wu.getCategories( formatStr )
	for k, v in pairs( categIds ) do
		result = result .. ( hi.categories[ k ] or hi.categories.unknownError )
	end
	if showOptions.demo then
		-- remove category links
		result = result:gsub( '%[%[[^%[]*%]%]', '' )
	end
	return result
end

-- getting a string with listed days at which an establishment is closed
local function getClosed( arr )
	return ( arr and #arr > 0 ) and mw.ustring.format( hi.texts.closed or '%s', 
		table.concat( arr, hi.texts.separator ) ) or ''
end

-- converting day range from Mo, Tu, We to Mo–We, and so on
local function getRange( arr, minPos, maxPos )
	if maxPos > 0 and minPos > 0 and maxPos > minPos then
		arr[ minPos ] = mw.ustring.format( hi.texts.fromTo, arr[ minPos ],
			arr[ maxPos ] )
		for i = maxPos, minPos + 1, -1 do
			table.remove( arr, i )
		end
	end
end

-- looking for day ranges like Mo, Tu, We and so on and converting them
local function convertDayRange( arr )
	local count = #arr
	local minPos = 0
	local maxPos = 0
	local value, valueMin
	while count > 0 do
		value = hi.weekdays[ arr[ count ] ]
		if not value then
			getRange( arr, minPos, maxPos )
			maxPos = 0
		elseif maxPos == 0 then
			maxPos = count
			valueMin = value
		elseif maxPos > 0 and value == valueMin - 1 then
			minPos = count
			valueMin = value
		else
			getRange( arr, minPos, maxPos )
			maxPos = 0
		end
		count = count - 1
	end
	getRange( arr, minPos, maxPos )
end

-- concating non-empty strings
local function concatStrings( sep, str1, str2 )
	local tab = {}
	tableInsert( tab, str1 )
	tableInsert( tab, str2 )
	return table.concat( tab, sep )
end

-- add comment if not yet exists
local function addComment( tab, value )
	if not isSet( value ) then
		return
	elseif #tab == 0 then
		table.insert( tab, value )
	else
		for i = 1, #tab, 1 do
			if tab[ i ] == value then
				break
			end
			if i == #tab then
				table.insert( tab, value )
			end
		end
	end
end

-- main function for usage in Lua modules
-- entity: entity id or entity table
-- wikilang: content language of the wiki
-- fallbackLang: optional additional language for fallback
-- formatStr: optional format string for property categories
-- show: table of show options (addCategories, msg, nomsg) or nil
-- lastedit: dat of last edit. If false no date will be fetched
-- labelTabel: additional table with Q-id label pairs
function hr.getHoursFromWikidata( entity, wikilang, fallbackLang, formatStr,
	show, lastEdit, labelTable )

	-- collecting days at which an establishment is closed
	local closeDays = {}
	local closeDaysHelper = {}
	local function mergeDays( days )
		if not days or #days == 0 then
			return
		end
		for i, day in ipairs( days ) do
			if not closeDaysHelper[ day ] then
				table.insert( closeDays, day )
				closeDaysHelper[ day ] = ''
			end
		end
	end
	local function clearDays()
		closeDays = {}
		closeDaysHelper = {}
	end

	-- adding additional properties if an additional Q-id table is given
	hr.labelTable = labelTable

	-- preparing show options
	showOptions = show or {}
	showOptions.addCategories = hi.options.addCategories
	if showOptions.msg then
		showOptions.addCategories = true
	elseif showOptions.nomsg then
		showOptions.addCategories = false
	end

	-- format string for property categories
	if not isSet( formatStr ) then
		formatStr = hi.categories.properties
	end

	-- 1st step: getting statements for P3025: open days
	local statements = wu.getValuesWithQualifiers( entity, hi.wd.opened, nil,
		hi.wd.all, hi.wd.retrieved, nil, getLabelFromId, wikilang, fallbackLang )
	lastEdit = wu.getLastedit( lastEdit, statements )

	-- converting statements to human-readable strings
	local result = {}
	local comments, s
	local is24_7 = getLabelFromTables( hi.times.is24_7 )

	for i, statement in ipairs( statements ) do
		-- opening times
		local times = {}
		local count = math.max( getCount( statement[ hi.wd.hourOpen ] ),
			getCount( statement[ hi.wd.hourClosed ] ) )
		if count > 0 then
			for j = 1, count, 1 do
				s = getTimePeriod( statement[ hi.wd.hourOpen ],
					statement[ hi.wd.hourClosed ], j )
				if isSet( s ) then
					table.insert( times, s )
				elseif statement.value ~= is24_7 then
					categIds.withoutTime = ''
				end
			end
		elseif statement.value ~= is24_7 then
			categIds.withoutTime = ''
		end
		s = table.concat( times, hi.texts.separator )

		-- comments
		comments = {}
		count = math.max( getCount( statement[ hi.wd.dayOpen ] ),
			getCount( statement[ hi.wd.dayClosed ] ) )
		for j = 1, count, 1 do
			addComment( comments,
				getTimePeriod( statement[ hi.wd.dayOpen ],
					statement[ hi.wd.dayClosed ], j, statement.value ) )
		end
		for j, key in ipairs( hi.wd.comments ) do
			if statement[ key ] then
				addComment( comments, table.concat( statement[ key ],
					hi.texts.separator ) )
			end
		end

		-- concating times and comments
		times = {}
		tableInsert( times, s )
		s = table.concat( comments, hi.texts.separator )
		if isSet( s ) then
			table.insert( times, mw.ustring.format( hi.texts.comment, s ) )
		end

		local item = {}
		tableInsert( item, table.concat( times, hi.texts.joiner ) )

		-- close statements (P3026) as qualifiers for open days property (P3025)
		mergeDays( statement[ hi.wd.closed ] )
		if not hi.options.clusterClosed and ( i == #statements or
			statements[ i ].value ~= statements[ i + 1 ].value ) then
			convertDayRange( closeDays )
			tableInsert( item, getClosed( closeDays ) )
			clearDays()
		end
		s = table.concat( item, hi.texts.separator )
	
		-- copying each statement to result table
		if statement.sort2 == 1 then
			tableInsert( result, { value = { statement.value }, times = s } )
		elseif s ~= '' then
			result[ #result ].times = concatStrings( hi.texts.separator,
				result[ #result ].times, s )
		end
	end

	-- checking for duplicates
	for i = #result, 2, -1 do
		if result[ i ].times == result[ i - 1 ].times then
			for j, value in ipairs( result[ i ].value ) do
				table.insert( result[ i - 1 ].value, value )
			end
			table.remove( result, i )
		end
	end

	-- converting day range
	for i = 1, #result, 1 do
		local arr = result[ i ].value
		convertDayRange( arr )
		result[ i ] = concatStrings( hi.texts.joiner,
			table.concat( arr, hi.texts.separator ), result[ i ].times )
	end

	-- 2nd step: getting separated close statements (P3026)
	local statements = wu.getValuesWithQualifiers( entity, hi.wd.closed, nil,
		hi.wd.commentsForClosed, hi.wd.retrieved, nil, getLabelFromId, wikilang,
		fallbackLang )
	if #statements > 0 then
		lastEdit = wu.getLastedit( lastEdit, statements )

		-- getting closed values
		local closed = {}	
		for i, statement in ipairs( statements ) do
			local closedDate = {}
			table.insert( closedDate, statement.value )

			-- getting comments
			comments = {}
			for j, key in ipairs( hi.wd.commentsForClosed ) do
				if statement[ key ] then
					addComment( comments, table.concat( statement[ key ],
						hi.texts.separator ) )
				end
			end
			s = table.concat( comments, hi.texts.separator )
			if isSet( s ) then
				table.insert( closedDate, mw.ustring.format( hi.texts.comment, s ) )
			end

			table.insert( closed, table.concat( closedDate, hi.texts.joiner ) )
		end
		mergeDays( closed )
	end
	convertDayRange( closeDays )
	tableInsert( result, getClosed( closeDays ) )

	-- 3rd step: adding additional statements
	local statements = wu.getValuesWithQualifiers( entity, hi.wd.stateOfUse,
		nil, {}, hi.wd.retrieved, nil, getLabelFromId, wikilang, fallbackLang )
	if #statements > 0 then
		lastEdit = wu.getLastedit( lastEdit, statements )
		for i, statement in ipairs( statements ) do
			tableInsert( result, statement.value )
		end
	end

	-- merging all statements
	local result = table.concat( result, hi.texts.delimiter )

	-- adding maintenance categories
	if result ~= '' then
		categIds.fromWikidata = ''
		if showOptions.addCategories then
			result = result .. hr.getCategories( formatStr )
		end
	end
	return result, lastEdit
end

-- invoke helper functions
-- splitting show parameters
local function splitAndCheck( s )
	local arr = {}
	local err = {}
	if isSet( s ) then
		for i, v in ipairs( mw.text.split( s, ',', true ) ) do
			v = mw.text.trim( v )
			if not hi.show[ v ] then
				table.insert( err, v )
			else
				arr[ v ] = ''
			end
		end
	end
	return arr, err
end

-- check if pareameters are valid
local function checkParameters( args )
	local err = {}
	if not args and type( args ) ~= 'table' then
		return err
	end
	for k, v in pairs( args ) do
		if not hi.params[ k ] then
			table.insert( err, k )
		end
	end
	return err
end

-- formating and concating error strings
local function getErrorStr( arr, formatStr )
	return #arr == 0 and '' or
		mw.ustring.format( formatStr, table.concat( arr, ', ' ) )
end

-- main function for template #invoke calls
-- id: Q id of an establishment
-- format: output format like 'opened at %s'
-- fallback: fallback language if labels are not available in content language
function hr.getHours( frame )
    local args = frame.args
    args.id = mw.text.trim( args.id or '' )
    if not isSet( args.id ) or not mw.wikibase.isValidEntityId( args.id ) then
        return hi.categories.invalidId
    end
    if not isSet( args.format ) then
    	args.format = hi.texts.format
    else
	    local s, count = args.format:gsub( '%%s', '%%s' )
    	if count ~= 1 then
        	args.format = hi.texts.format
    	end
    end
    args.fallback = args.fallback or ''
    local wikilang = mw.getContentLanguage():getCode()

	local paramErr = checkParameters( args )
	local show, showErr = splitAndCheck( args.show )

    local result, lastEdit = hr.getHoursFromWikidata( args.id, wikilang,
    	args.fallback, '', show, false, nil )
    if result ~= '' then
    	result = mw.ustring.format( args.format, result )
    end
    return result .. getErrorStr( paramErr, hi.categories.unknownParams )
    	.. getErrorStr( showErr, hi.categories.unknownShowOptions )
end

return hr