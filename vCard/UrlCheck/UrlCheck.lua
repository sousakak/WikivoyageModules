-- module variable and administration
local uc = {
	moduleInterface = {
		suite  = 'UrlCheck',
		serial = '2023-11-02',
		item   = 40849609
	}
}

function uc.ip4( address )
	local parts = { address:match( '(%d+)%.(%d+)%.(%d+)%.(%d+)' ) }
	local value
	if #parts == 4 then
		for _, value in pairs( parts ) do
			if tonumber( value ) < 0 or tonumber( value ) > 255 then
				return false
			end
		end
		return true -- ok
	end
	return false
end

function uc.isUrl( url, skipPathCheck )
	-- return codes 0 through 2 reserved
	if not url or type( url ) ~= 'string' then
		return 3
	end

	local s = mw.text.trim( url )
	if s == '' then
		return 3
	elseif #s > 2048 then -- limitation because of search engines or IE
		return 4
	elseif s:find( '%s' ) or s:find( '%c' ) or s:match( '^%.' ) then
		return 5
	end
	
	-- https://max:muster@www.example.com:8080/index.html?p1=A&p2=B#ressource

	-- protocol
	local count
	s, count = s:gsub( '^https?://', '' )
	if count == 0 then
		s, count = s:gsub( '^//', '' )
	end
	if count == 0 then -- missing or wrong protocol
		return 6
	end

	local user = ''
	local password = ''
	local host = ''
	local port = ''
	local aPath = ''
	local topLevel = ''

	-- split path from host
	local at = s:find( '/' )
	if at then
		aPath = s:sub( at + 1, #s )
		s = s:sub( 1, at - 1 )
		if not s then
			return 7
		end
	end

	-- path check
	if not skipPathCheck and aPath ~= '' then
		if not aPath:match( "^[-A-Za-z0-9_.,~%%%+&:;#*?!'=()@/\128-\255]*$" ) then
			return 23
		end
	end

	if s:find( '%.%.' ) or s:find( '%.@' ) or s:find( '@[%.%-]' ) or s:find( '%-%.' )
		or s:find( '%.%-' ) or s:find( '%./' ) or s:find( '/%.' ) then
		return 8
	end

	-- user and password
	s, count = s:gsub( '@', '@' )
	if count > 1 then
		return 9
	elseif count == 1 then
		at = s:find( '@' )
		user = s:sub( 1, at - 1 )
		host = s:sub( at + 1, #s )
		if not user or not s then
			return 10
		end

		user, count = user:gsub( ':', ':' )
		if count > 1 then
			return 11
		elseif count == 1 then
			at = user:find( ':' )
			password = user:sub( at + 1, #user )
			user = user:sub( 1, at - 1 )
			if not user or not password then
				return 12
			elseif #user > 64 then
				return 13
			end
		end
	else
		host = s
	end
	if host == '' then
		return 14
	end

	-- host and port
	host, count = host:gsub( ':', ':' )
	if count > 1 then
		return 15
	elseif count == 1 then
		at = host:find( ':' )
		port = host:sub( at + 1, #host )
		host = host:sub( 1, at - 1 )
		if not host or not port then
			return 16
		elseif not port:match( '^[1-9]%d*$' ) or tonumber( port ) > 65535 then
			return 17
		end
	end

	-- handle host part
	if #host > 253 then
		return 18
	end

	-- getting top-level domain
	at = host:match( '^.*()%.' ) -- find last dot
	if not at then
		return 19
	end
	topLevel = host:sub( at + 1, #host )
	if not topLevel then
		return 20
	end

	-- future: check of top-level domain

	if uc.ip4( host ) then -- is ip4 address
		return 2
	elseif not mw.ustring.match( host, '^[ะ-๏%w%.%-]+%.%a%a+$' ) then
		-- Thai diacritical marks ะ (0E30) - ๏ (0E4F)
		return 22
	elseif not host:match( '^[%w%.%-]+%.%a%a+$' ) then
		return 1 -- matches domain only in UTF 8 mode
	end

	return 0
end

function uc.uriEncodePath( url )
	local at, to = url:find( '[^/]/[^/]' )
	if at then
		local domain = url:sub( 1, at + 1 )
		local aPath = url:sub( at + 2, #url )
		url = domain .. mw.uri.encode( aPath, 'PATH' )
	end
	return url
end

function uc.checkUrl( frame )
	local args  = frame.args
	local pArgs = frame:getParent().args
	args.url    = args.url or pArgs.url or ''
	args.show   = args.show or pArgs.show or ''

	local result = uc.isUrl( args.url, false )
	if args.show:lower() == 'msg' then
		local ui = mw.loadData( 'Module:UrlCheck/i18n')
		if ui[ result ] then
			return ui[ result ]
		else
			return ui.unknown
		end
	end
	return result
end

function uc.encodePath( frame )
	local args  = frame.args
	local pArgs = frame:getParent().args
	args.url    = args.url or args[ 1 ] or pArgs.url or pArgs[ 1 ] or ''
	return uc.uriEncodePath( args.url )
end

return uc