-- module variable and administration
local lm = {
	moduleInterface =  {
		suite  = 'LinkMail',
		serial = '2023-12-08',
		item   = 65157414
	}
}

-- module import
-- require( 'strict' )
local li = require( 'Module:Link utilities/i18n' )
local lu = require( 'Module:Link utilities' )

-- check single email address
function lm._isEmail( s )
	local result = 2

	if s == nil or type( s ) ~= 'string' or #s > 254 or s:find( '%s' ) or
		s:find( '%.%.' ) or s:find( '%.@' ) or s:find( '@[%.%-]' ) or
		s:find( '%-%.' ) or s:find( '%.%-' ) or s:match( '^%.' ) then
		return 0
	end
	local repl, at = s:gsub( '@', '@' )
    if at ~= 1 then
    	return 0
    end

	at = s:find( '@' )
	local user = s:sub( 1, at - 1 )
	local domain = s:sub( at + 1, #s )
    if not user or not domain or #user > 64 or #domain > 253 then
    	return 0
    end

	-- handle user part
	if not mw.ustring.match( user, "^[%w!#&'/=_`{|}~%^%$%%%+%-%*%.%?]+$" ) then
		return 0
	end
	if not user:match( "^[%w!#&'/=_`{|}~%^%$%%%+%-%*%.%?]+$" ) then
		result = 1
	end

	-- handle domain part
	if not mw.ustring.match( domain, '^[%w%.%-]+%.%a%a+$' ) then
		return 0
	end
	if not domain:match( '^[%w%.%-]+%.%a%a+$' ) then
		result = 1
	end

	-- not yet analysed: texts in quotes in user part
	-- added on demand

	return result
end

function lm._linkMail( m, isDemo, ignoreUnicode )
	m = mw.text.trim( m )
	if m == '' then
		return ''
	end
	local catPrefix = '[[Category:'
	if isDemo then
		catPrefix = ' [[:Category:'
	end

	local comment = ''
	m, comment = lu.extractComment( m )

	m = m:gsub( 'mailto:', '' )
	local isEmail = lm._isEmail( m )
	local t
	if isEmail > 0 then
		t = '<span class="plainlinks nourlexpansion">[mailto:' .. m .. ' ' .. m .. ']</span>'
		if isEmail == 1 and not ignoreUnicode then
			t = t .. catPrefix .. li.categories.nonASCII
		end
	else
		t = m .. catPrefix .. li.categories.invalidMail
	end
	if comment ~= '' then
		t = t .. ' ' .. comment
	end
	return t
end

function lm.linkMailSet( args )
	args.email = args.email or args[ 1 ] or ''
	if args.email == '' then
		return ''
	end

	local ns     = mw.title.getCurrentTitle().namespace
	local isDemo = ns == 10 or ns == 828

	-- split separate email
	local items = lu.splitItems( args.email, li.delimiters )
		
	-- analyse emails
	local result = ''
	local i = 0
	local s
	for j, item in ipairs( items ) do
		s = lm._linkMail( item, isDemo, args.ignoreUnicode )
		if s ~= '' then
			if result == '' then
				result = s
			else
				if i == li.addMail then
					result = result .. '<span class="listing-add-contact">'
				end
				result = result .. li.texts.comma .. s
			end
			i = i + 1
		end
	end
	if i > li.addMail then
		result = result .. '</span>'
	end
	return result
end

-- #invoke call
function lm.linkMails( frame )
	return lm.linkMailSet( frame.args )
end

-- template call
function lm.linkMailsTemplate( frame )
	return lm.linkMailSet( frame:getParent().args )
end

return lm