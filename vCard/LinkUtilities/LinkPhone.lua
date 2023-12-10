-- module variable and administration
local lp = {
	moduleInterface = {
		suite  = 'LinkPhone',
		serial = '2023-12-09',
		item   = 16354802
	}
}

-- module import
-- require( 'strict' )
local li = require( 'Module:Link utilities/i18n' )
local ln = require( 'Module:Link utilities/Phone numbers' )
local lu = require( 'Module:Link utilities' )

local function formatNumber( number, size )
	if not ln.options.formattingWikidata then
		return number
	end

	local pos, first, last, newLast, country, localCode, i

	number = number:gsub( '-', ' ' )
	i, pos = number:find( '.* ' ) -- find last space
	if size > 0 and pos then
		first = number:sub( 1, pos )
		last = number:sub( pos + 1, #number )
		newLast = ''
		if tonumber( last ) then -- inserting additional spaces
			while ( #last > size + 1 ) do
				if newLast == '' then
					newLast = last:sub( -size )
				else
					newLast = last:sub( -size ) .. ' ' .. newLast
				end
				last = last:sub( 1, #last - size )
			end
			if newLast ~= '' then
				last = last .. ' ' .. newLast
			end
		end
		pos, i = first:find( ' ' )
		if ln.options.addZeros and pos and ( pos ~= #first ) then
			country = first:sub( 1, pos - 1 )
			localCode = first:sub( pos + 1, #first )
			if not ln.noZero[ country ] then
				localCode = localCode:gsub( '[%(%)]', '' )
				if localCode:sub( 1, 1 ) == '0' then
					localCode = '(0)' .. localCode:sub( 2, #localCode ) 
				else
					localCode = '(0)' .. localCode
				end
				first = country .. ' ' .. localCode
			end
		end
		number = first .. last
	end
	return number
end

-- look for phone-number patterns which are valid local numbers
local function checkNumberMatch( key, number )
	local ar = ln.exceptions[ key ]
	if not ar then
		return false
	end
	for i = 1, #ar, 1 do
		if number:find( ar[ i ] ) then
			return true
		end
	end
	return false
end

local function extractExtension( number )
	local ext = ''
	local t
	for i, extension in ipairs( ln.extensions ) do
		t = mw.ustring.gsub( number, '^.*(' .. extension .. ')$', '%1' )
		if t ~= number then
			ext = t:gsub( '%s*=', ' ' ) -- RFC 3966
			number = mw.ustring.gsub( number, '[%s%c]*(' .. extension .. ')$', '' )
			break
		end
	end
	return number, ext
end

-- handle a single phone number s
function lp.linkPhoneNumber( s, args, isDemo )
	local number = mw.text.trim( s )
	if number == '' then
		return ''
	end
	local catPrefix = isDemo and ' [[:Category:' or '[[Category:'

	local ext = ''
	local extraCats = ''
	local comment, t
	args.cc = args.cc:gsub( '%-', '' )

	number, comment = lu.extractComment( number )
	number, ext = extractExtension( number )

	-- normalize country calling code
	number = number:gsub( '^00+', '+' )
		:gsub( '^%+%++', '+' )

	-- add country calling code, remove lead zero
	if args.cc ~= '' then
		if ln.options.withCountryCode and number:sub( 1, 1 ) ~= '+' then
			number = args.cc .. ' ' .. number
		end
		if ln.options.preventLeadZero and not ln.noZero[ args.cc ] then
			number = number:gsub( '^(%' .. args.cc .. '%s+)%(+0%)+', '%1' )
				:gsub( '%(+', '' ):gsub( '%)+', '' )
		end
	end

	-- formatting phone numbers retrieved from Wikidata
	if args.format then
		number = formatNumber( number, args.size )
	end

	if ln.options.addZeros and not ln.zeroExceptions[ args.cc ] and not number:find( '^00' ) then
		number = number:gsub( '^0', '(0)' )
	end
	if ln.options.addZeros and args.cc ~= '' and not ln.zeroExceptions[ args.cc ] then
		number = number:gsub( '^(%' .. args.cc .. ')( *)0', '%1%2(0)' )
	end

	-- plain is number for link
	local plain = number
	-- check if slashes are used
	if plain:find( '/', 1, true ) then
		extraCats = catPrefix .. li.categories.withSlash
	end

	-- remove delimiters -.()/' and spaces
	-- including thin space
	plain = mw.ustring.gsub( plain, "[  '/%.%-%)]", '' )
	local exception = false

	-- handling country code including ++49, 0049 etc.
	if plain:sub( 1, 1 ) == '+' then
		plain = plain:gsub( '%(0', '' ) -- zero in parenthesis
			:gsub( '%(', '' )
	else
		plain = plain:gsub( '%(0', '0' )
		if comment ~= '' and checkNumberMatch( 'service', comment ) then
			exception = true
			number = number:gsub( '[%(%)]', '' )
		elseif args.isTollfree and checkNumberMatch( 'tollfree', plain ) then
			exception = true
			number = number:gsub( '[%(%)]', '' )
		elseif checkNumberMatch( args.cc, plain ) then
			exception = true
		elseif args.cc ~= '' then
			if ln.noZero[ args.cc ] then
				plain = args.cc .. plain:gsub( '^%(', '' )
			elseif plain:sub( 1, 1 ) == '0' then
				plain = args.cc .. plain:gsub( '^0', '' )
			else
				return s .. catPrefix .. li.categories.invalid
			end
		else
			return s .. catPrefix .. li.categories.noCC
		end
	end

	-- minimum 5 characters including country code
	if not exception and #plain < 5 then
		return s .. catPrefix .. li.categories.invalid
	end

	-- lower case letters for numbers are not allowed
	if plain:find( '%l' ) then
		return s .. catPrefix .. li.categories.invalid
	elseif plain:find( '%u' ) then
		-- substitude letters
		local letters = { '', '[A-C]', '[D-F]', '[G-I]', '[J-L]', '[M-O]',
			'[P-S]', '[T-V]', '[W-Z]' }
		for i = 2, 9 do
			plain = plain:gsub( letters[ i ], '' .. i )
		end
	end

	-- remove zero from local area code
	if args.cc ~= '' and not ln.zeroExceptions[ args.cc ] then
		plain = plain:gsub( args.cc .. '0', args.cc )
	end

	-- final test
	if not exception and not plain:match( '^%+%d+$' ) then
		return s .. catPrefix .. li.categories.invalid
	end

	-- assemble number, link, ext, comment, and categories
	t = '<span data-phone="' .. plain .. '" class="listing-phone-number'
	if not args.isFax then
		t = t .. ' plainlinks nourlexpansion'
		number = ( '[tel:%s %s]' ):format( plain, number )
	end
	if exception then
		t = t .. ' listing-phone-exception" title="' .. li.categories.onlyDomestic
	end
	t = t .. '">' .. number .. '</span>'

	return t .. ( ext ~= '' and ( ' ' .. ext ) or '' ) ..
		( comment ~= '' and ( ' ' .. comment ) or '' ) .. extraCats
end

function lp.linkPhoneNumbers( args )
	local addNum = li.addNum
	if args.isFax then
		addNum = li.addNumFax
	end
	args.cc = args.cc:gsub( '^00', '+' ):gsub( '^%+%++', '+' )

	local ns     = mw.title.getCurrentTitle().namespace
	local isDemo = ns == 10 or ns == 828

	-- split separate numbers
	local items = lu.splitItems( args.phone, li.delimiters )

	-- analyse phone numbers
	local result = ''
	local i = 0
	local s
	for j, item in ipairs( items ) do
		s = lp.linkPhoneNumber( item, args, isDemo )
		if s ~= '' then
			if result == '' then
				result = s
			else
				if i == addNum then
					result = result .. '<span class="listing-add-contact">'
				end
				result = result .. li.texts.comma .. s
			end
			i = i + 1
		end
	end
	if i > addNum then
		result = result .. '</span>'
	end
	return result;
end

function lp.getTrunkPrefix( cc )
	return ln.noZero[ cc ] and '' or '0'
end

return lp