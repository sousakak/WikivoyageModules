-- This module contains the parameter tables and definitions. Do not modify this
-- module. The translated values are stored in Module:vCard/i18n.
	
-- module import
local vi = require( 'Module:VCard/i18n' ) -- additional vCard options

return {	
	-- administration
	moduleInterface =  {
		suite  = 'vCard',
		sub    = 'Params',
		serial = '2024-01-29',
		item   = 65455743
	},

	-- complete table of parameters
	-- true: get it from Wikidata in any case
	-- for parameter translations see Module:VCard/i18n
	
	ParMap = {
		address         = '',
		addressLang     = '',
		addressLocal    = '',
		agoda           = '', -- Agoda.com
		alt             = '',
		auto            = '',
		before          = '',
		booking         = '', -- Booking.com
		checkin         = '',
		checkout        = '',
		color           = '',   -- internal use
		comment         = '',
		commonscat      = '',
		content         = '',
		copyMarker      = '',
		country         = '',
		dav             = '', -- Alpenverein.de
		description     = '',
		directions      = '',
		directionsLocal = '',
		email           = '',
		expedia         = '', -- Expedia.com
		facebook        = '',
		fax             = '',
		flickr          = '',
		foursquare      = '', -- Foursquare.com
		googlemaps      = '', -- Maps.Google.com
		group           = '',
		histhotelsAm    = '', -- HistoricHotels.org
		histhotelsEu    = '', -- HistoricHotelsOfEurope.com
		histhotelsWw    = '', -- HistoricHotelsWorldwide.com
		hostelworld     = '', -- Hostelworld.com
		hotels          = '', -- Hotels.com
		hours           = '',
		iata            = vi.options.showIata,
		icao            = vi.options.showIcao,
		image           = true,
		instagram       = '',
		kayak           = '', -- Kayak.com
		lastedit        = '',
		lat             = '',
		leadingHotels   = '', -- LHW.com
        link            = '', -- unique to Japanese Wikivoyage
		long            = '',
		mapGroup        = '',
		mobile          = '',
		name            = '',
		nameExtra       = '',
		nameLatin       = '',
		nameLocal       = '',
		nameMap         = '',
		oeav            = '', -- Alpenverein.at
		payment         = '',
		phone           = '',
		preferredHotels = '', -- PreferredHotels.com
		price           = '',
		pzs             = '', -- PZS.si (Slovenia)
		recreation      = '', -- Recreation.gov
		relaisChateaux  = '', -- RelaisChateaux.com
		rss             = '', -- web feed
		sac             = '', -- SAC-CAS.ch
		show            = vi.options.defaultShow,
		skype           = '',
		skyscanner      = '', -- Skyscanner.com
		status          = '',
		styles          = '',
		subtype         = '',
		subtypeAdd      = true, -- internal use
		symbol          = '',   -- internal use
		text            = '',   -- internal use
		tiktok          = '',
		tollfree        = '',
		trip            = '', -- Trip.com
		tripadvisor     = '', -- Tripadvisor.com
		twitter         = '',
		type            = true,
		unesco          = vi.options.showUnesco,
		url             = '',
		useIcon         = '',   -- internal use
		wikidata        = '',
		wikipedia       = '',   -- deprecated
		youtube         = '',
		zoom            = '',

		date            = '',   -- for events
		month           = '',
		year            = '',
		endDate         = '',
		endMonth        = '',
		endYear         = '',
		frequency       = '',
		location        = ''
	},
	
	--[[
	Wikidata properties and definitions for vCard parameters

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
		iqp:   string value with qualifier ids, for comments in policies
		au:    quantity consisting of amount and unit
		pau:   quantity consisting of amount (for P8733)
		vq:    string or table value with qualifiers ids and references
	q table of qualifiers allowed, for value type id
	l = lang: language dependent
	    wiki / local: monolingual text by wiki or local language
	le = true: use date for lastedit parameter
	t = phone type (landline, mobile)
	--]]

	ParWD = {
		agoda        = { p = 'P6008' },
		booking      = { p = 'P3607' },
		checkin      = { p = 'P8745', v = 'idl' },
		checkout     = { p = 'P8746', v = 'idl' },
		dav          = { p = 'P5757' },
		directions   = { p = 'P2795', v = 'il', l = 'wiki' },
		directionsLocal = { p = 'P2795', v = 'il', l = 'local' },
		email        = { p =  'P968', v = 'vq', c = 5 },
		expedia      = { p = 'P5651' },
		facebook     = { p = { { p = 'P2013', f = 'https://www.facebook.com/%s' },
					     { p = 'P1997', f = 'https://www.facebook.com/pages/-/%s' },
					     { p = 'P4003', f = 'https://www.facebook.com/pages/%s' } } },
		fax          = { p = 'P2900', v = 'vq', c = 3 },
		flickr       = { p = 'P3267', f = 'https://www.flickr.com/photos/%s' },
		foursquare   = { p = 'P1968' },
		googlemaps   = { p = 'P3749' },
		histhotelsAm = { p = 'P5734' },
		histhotelsEu = { p = 'P5774' },
		histhotelsWw = { p = 'P5735' },
		hostelworld  = { p = 'P10442' },
		hotels       = { p = 'P3898' },
		iata         = { p =  'P238', c = 3 },
		icao         = { p =  'P239' },
		image        = { p = { { p =   'P18' },
		                  { p = 'P5775' } } }, -- interior image
		instagram    = { p = { { p = 'P2003', f = 'https://www.instagram.com/%s/' },
		                  { p = 'P4173', f = 'https://www.instagram.com/explore/locations/%s/' } } },
		kayak        = { p = 'P10547' },
		leadingHotels = { p = 'P5834' },
		mobile       = { p = 'P1329', v = 'vq', c = 5, t = 'mobile' },
		oeav         = { p = 'P5759' },
		payment      = { p = 'P2851', v = 'id', c = 50, m = 'no' },
		phone        = { p = 'P1329', v = 'vq', c = 5, t = 'landline' },
		preferredHotels = { p = 'P5890' },
		price        = { p = 'P2555', v = 'au', c = 10, le = true }, -- fee
		pzs          = { p = 'P5758' },
		recreation   = { p = 'P3714' },
		relaisChateaux = { p = 'P5836' },
		rss          = { p = 'P1019' },
		sac          = { p = 'P5761' },
		skype        = { p = 'P2893', f = 'skype:%s', m = '; ' },
		skyscanner   = { p = 'P10487' },
		subtypeAdd   = { p = { { p = 'P912', v = 'iq', c = 50 }, -- has facility
		                  { p = 'P166', v = 'iq', c = 5, q = { 'Q2976556', 'Q20824563' } },
		                      -- awards received (hotel rating, Michelin etc.)
		                  { p = 'P10290', v = 'iq', c = 3 }, -- hotel rating
		                  { p = 'P8733', v = 'pau' }, -- number of rooms
		                  { p = 'P2012', v = 'iq', c = 50 }, -- cuisine
		                  { p = 'P2846', v = 'iq' }, -- wheelchair
		                  { p = 'P2848', v = 'iq' }, -- WLAN
		                  { p = 'P5023', v = 'iqp', c = 10 }	}, c = 100, m = 'no' }, -- activity policies
		tiktok       = { p = 'P7085', f = 'https://www.tiktok.com/@%s' },
		trip         = { p = 'P10425' },
		tripadvisor  = { p = 'P3134' },
		twitter      = { p = 'P2002', f = 'https://twitter.com/%s' },
		unesco       = { p =  'P757' },
		url          = { p =  'P856', l = 'lang' },
		youtube      = { p = 'P2397', f = 'https://www.youtube.com/channel/%s' }
	},
	
	-- additional parameters for auto = y

	ParWDAdd = {
		address         = 1,
		addressLocal    = 1,
		directions      = 1,
		directionsLocal = 1,
		hours           = 1,
		nameLocal       = 1
	},

	-- parameters to save in vCard wrapper tag

	vcardData = {
		addressLang     = 'data-address-lang', -- language of address
		addressLocal    = 'data-address-local',
		color           = 'data-color',
		commonscat      = 'data-commonscat',
		directionsLocal = 'data-directions-local',
		group           = 'data-group',
		groupTranslated = 'data-group-translated', -- for MapTools.js
		image           = 'data-image',
		mapGroup        = 'data-map-group',
		nameLocal       = 'data-name-local',
		rss             = 'data-rss',
		subtype         = 'data-subtype',
		symbol          = 'data-symbol',
		type            = 'data-type',
		url             = 'data-url',
		wikidata        = 'data-wikidata',

		agoda           = 'data-agoda-com',
		booking         = 'data-booking-com',
		dav             = 'data-alpenverein-de',
		expedia         = 'data-expedia-com',
		foursquare      = 'data-foursquare-id',
		googlemaps      = 'data-google-maps-cid',
		histhotelsAm    = 'data-historic-hotels-america',
		histhotelsEu    = 'data-historic-hotels-europe',
		histhotelsWw    = 'data-historic-hotels-worldwide',
		hostelworld     = 'data-hostelworld-com',
		hotels          = 'data-hotels-com',
		kayak           = 'data-kayak-com',
		leadingHotels   = 'data-leading-hotels',
		oeav            = 'data-alpenverein-at',
		preferredHotels = 'data-preferred-hotels',
		pzs             = 'data-pzs-si',
		recreation      = 'data-recreation-gov',
		relaisChateaux  = 'data-relais-chateaux',
		sac             = 'data-sac-cas-ch',
		skyscanner      = 'data-skyscanner-com',
		trip            = 'data-trip-com',
		tripadvisor     = 'data-tripadvisor-com'
	},

	-- check if event
	
	checkEvent = { 'date', 'month', 'year', 'endDate', 'endMonth', 'endYear',
		'frequency', 'location' },

	-- prevent local data if wiki language == country language

	localData = { 'nameLocal', 'addressLocal', 'directionsLocal' },

	-- phone numbers for fetching country data

	phones = { 'phone', 'fax', 'mobile', 'tollfree' },

	-- possible values for show parameter

	show = {
		all           = 1,
		coord         = 1,
		copy          = 1,
		inline        = 1,
		noairport     = 1,
		none          = 1,
		noperiod      = 1,
		nositelinks   = 1,
		nosocialmedia = 1,
		nosubtype     = 1,
		nowdsubtype   = 1,
		outdent       = 1,
		poi           = 1,
		symbol        = 1,
		wikilink      = 1
	}
}