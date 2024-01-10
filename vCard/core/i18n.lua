-- This module contains wiki-language specific strings to translate.
-- First table contains the arguments' parameter names, the second
-- one data name for the wrapping listing tag.

-- The following table is used for template's parameter localization.
-- The item value like 'address-lang' is the parameter name used in the template.
-- The key/index is used by the Marker module. Use value strings for localization.

return {
	-- administration
	moduleInterface = {
		suite  = 'vCard',
		sub    = 'i18n',
		serial = '2024-01-10',
		item   = 65455749
	},

	p = {
		address         = 'address',
		addressLang     = 'address-lang',
		addressLocal    = 'address-local',
		alt             = 'alt',
		auto            = 'auto',
		before          = 'before',
		checkin         = 'checkin',
		checkout        = 'checkout',
		comment         = 'comment',
		commonscat      = { 'commons', 'commonscat' },
		copyMarker      = { 'copy-marker', 'marker-copy' },
		country         = 'country',
		description     = { 'description', 'content' },
		directions      = 'directions',
		directionsLocal = 'directions-local',
		email           = 'email',
--		facebook        = 'facebook',
		fax             = 'fax',
--		flickr          = 'flickr',
		group           = 'group',
		hours           = 'hours',
		image           = 'image',
--		instagram       = 'instagram',
		lastedit        = 'lastedit',
		lat             = { 'lat', 'latitude', 'coord' },
		long            = { 'long', 'lon', 'longitude' },
		mapGroup        = 'map-group',
		mobile          = 'mobile',
		name            = 'name',
--		nameExtra       = 'name-extra',
		nameLatin       = 'name-latin',
		nameLocal       = 'name-local',
		nameMap         = 'name-map',
		payment         = 'payment',
		phone           = 'phone',
		price           = 'price',
		show            = 'show',
--		skype           = 'skype',
		status          = 'status',
		styles          = 'styles',
		subtype         = { 'subtype', 'subtypes' },
--		tiktok          = 'tiktok',
		tollfree        = 'tollfree',
--		twitter         = { 'twitter', 'x' },
		type            = { 'type', 'types' },
		url             = 'url',
		wikidata        = 'wikidata',
		wikipedia       = 'wikipedia', -- deprecated, but removed comment as it is used in Listing in javoy
--		youtube         = 'youtube',
		zoom            = 'zoom',

		date            = 'date', -- for events
		month           = 'month',
		year            = 'year',
		endDate         = 'enddate',
		endMonth        = 'endmonth',
		endYear         = 'endyear',
		frequency       = 'frequency',
		location        = 'location'
	},

	-- additional vCard options
	options = {
		defaultAuto   = true,  -- vCard default auto mode
		defaultShow   = 'poi',
		lasteditHours = true,
		p31Limit      = 3,
		showIata      = true,  -- possible values true, false
		showIcao      = true,
		showUnesco    = true,
		useMobile     = true   -- distinguish landline and mobile phones
	}
}