-- module variable and administration
local lu = {
	moduleInterface = {
		suite  = 'Link utilities',
		serial = '2023-12-09',
		item   = 65228027
	}
}

-- module import
local li = require( 'Module:Link utilities/i18n' )
-- require( 'strict' )

-- split separate items like numbers
function lu.splitItems( s, delimiters, defaultDelimiter )
	defaultDelimiter = defaultDelimiter or ','

	-- wrap delimiters with zero marks
	s = mw.ustring.gsub( s, defaultDelimiter, '\0%1\0' );

	-- substitude delimiters
	for i, delimiter in ipairs( delimiters ) do
		s = mw.ustring.gsub( s, delimiter, '\0%1\0' );
		-- remove zero marks from inside parentheses ()
		s =	mw.ustring.gsub( s, '%b'.. li.texts.parentheses,
			function( t ) return t:gsub( '%z', '' ) end )
		-- replace delimeters by the default delimiter
		s = mw.ustring.gsub( s, '\0' .. delimiter .. '\0', '\0' .. defaultDelimiter .. '\0' );
	end

	-- results to an array
	s = mw.text.split( s, '\0' .. defaultDelimiter .. '\0' )
	for i = #s, 1, -1 do
		s[ i ] = mw.text.trim( s[ i ] )
		if s[ i ] == '' then 
			table.remove( s, i )
		end
	end
	return s
end

-- extract comment written in parentheses
-- remove spaces between value like phone numbers and comment
function lu.extractComment( s )
	local comment = ''
	if s:find( '(', 1, true ) then
		local t = mw.ustring.gsub( s, '^.*(%b' .. li.texts.parentheses .. ')$', '%1' )
		if t ~= s then
			comment = t
			s = mw.ustring.gsub( s, '[%s%c]*%b' .. li.texts.parentheses .. '$', '' )
		end
	end
	return s, comment
end

return lu