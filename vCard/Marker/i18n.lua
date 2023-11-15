-- Separating code from internationalization

return {
	-- module administration
	moduleInterface  = {
		suite  = 'Marker utilities',
		sub    = 'i18n',
		serial = '2023-10-05',
		item   = 65441686
	},

	dates            = { yyyymmdd = { p = '^20[0-5]%d%-[01]?%d%-[0-3]?%d$', f = 'j. M Y' },
	                     yyyy     = { p = '^20[0-5]%d$', f = 'Y' },
	                     yy       = { p = '^[0-5]%d$', f = 'Y' },
	                     mmdd     = { p = '^[01]?%d%-[0-3]?%d$', f = 'j. M' },
	                     dd       = { p = '^[0-3]?%d%.?$', f = 'j.' },
	                     mm       = { p = '^[01]?%d%.?$', f = 'M' },
	                     lastedit = { f = 'M Y' }
	                   },
	fileExtensions   = { 'tif', 'tiff', 'gif', 'png', 'jpg', 'jpeg', 'jpe',
	                     'webp', 'xcf', 'ogg', 'ogv', 'svg', 'pdf', 'stl',
	                     'djvu', 'webm', 'mpg', 'mpeg' },
	months           = { 'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli',
	                     'August', 'September', 'Oktober', 'November', 'Dezember' },
	monthAbbr        = { 'Jan%.?', 'Feb%.?', 'Mär%.?', 'Apr%.?', 'Mai%.?', 'Jun%.?',
	                      'Jul%.?', 'Aug%.?', 'Sep%.?', 'Okt%.?', 'Nov%.?', 'Dez%.?' },

	-- Map related constants
	coordURL          = 'https://de.wikivoyage.org/w/index.php?title=Special%3AMapsources&params=',
	defaultDmsFormat  = 'f1', -- see: Module:Coordinates/i18n
	defaultSiteType   = 'type:landmark_globe:earth',
	defaultZoomLevel  = 17,
	maxZoomLevel      = 19,   -- also to set in Module:GeoData, Module:Mapshape utilities/i18n

	-- Wikidata related constants
	p31Limit          = 3, -- maximum count of P31 values to analyse
	searchLimit       = 4, -- count of levels for P31-P279 search

	-- Wikidata properties
	properties = {
		appliesToJurisdiction = 'P1001',
		appliesToPart     = 'P518',
		appliesToPeople   = 'P6001',
		capacity          = 'P1083',
		centerCoordinates = 'P5140',
		commonsCategory   = 'P373',
		coordinates       = 'P625',
		endTime           = 'P582',
		image             = 'P18',
		instanceOf        = 'P31',
		iso4217           = 'P498',
		languageOfName    = 'P407',
		mainCategory      = 'P910',
		maximumAge        = 'P4135',
		minimumAge        = 'P2899',
		nameInNativeLang  = 'P1559',
		occupation        = 'P106',
		of                = 'P642',
		officialName      = 'P1448',
		pointInTime       = 'P585',
		propertyScope     = 'P5314', -- for fees
		quantity          = 'P1114',
		retrieved         = 'P813',
		roomNumber        = 'P8733',
		startTime         = 'P580',
		streetAddress     = 'P6375',
		subclassOf        = 'P279',
		unitSymbol        = 'P5061',
		use               = 'P366',
		validInPeriod     = 'P1264'
	},

	-- Groups of Wikidata properties
	propTable = {
		contactComments = { 'P366', 'P518', 'P642', 'P1001', 'P1559', 'P106' },
		feeComments     = { 'P5314', 'P518', 'P6001', 'P1264', 'P585', 'P2899',
		                    'P4135', 'P642' },
		policyComments  = { 'P518', 'P1001', 'P6001' },
		quantity        = { 'P1114', 'P1083' }
	},

	-- Wikidata properties representing a qualifier
	qualifiers = {
		mobilePhone = 'Q17517',
		P8733       = 'Q180516',
		roomNumber  = 'Q180516'
	},

	-- Display and performance options for vCard / Listing module
	options = {
		defaultAuto     = true,  -- vCard default auto mode
		defaultShow     = 'poi',
		lasteditHours   = true,
		noStarParams    = { 'nameExtra', 'nameLocal', 'alt', 'comment' },
		noTypeMsgs      = false, -- prevents display of maintenance( typeFromWD, typeIsGroup )
		parameters      = { 'nameExtra', 'wikipedia' }, -- parameter is used
		showIata        = true,  -- possible values true, false
		showIcao        = true,
		showLocalData   = true,  -- names, addresses, directions
		showSisters     = true,  -- possible values true, false, 'atEnd'
		showUnesco      = true,
		useMobile       = true,  -- distinguish landline and mobile phones
		usePropertyCateg= true,  -- for Wikidata properties
		useTypeCateg    = true,  -- for marker types

		-- useful but not necessary function calls
		WDmediaCheck    = false, -- check file names retrieved from Wikidata
		mediaCheck      = false, -- for better performance, otherwise expensive
		                         -- mw.title.new( 'Media:' .. image ) call is used
		secondaryCoords = false, -- adding listing coordinates to article database
		                         -- using #coordinates parser function
		skipPathCheck   = false  -- for URL check, see Module:UrlCheck
	},

	-- Languages for fallbacks, except wiki language
	langs = { 'en', 'fr' }, -- array can be empty

	-- Formatting numbers: replacement patterns
	formatnum = {
		decimalPoint   = ',',
		groupSeparator = '.'
	},

	-- strings
	texts = {
		asOf           = 'Stand %s',
		from           = 'ab %s',
		fromTo         = '%s–%s',
		to             = 'bis %s',
		fromTo2        = '%s bis %s',

		-- General
		closeX         = '[[File:Close x - white.png|15px|link=|class=noviewer|Unbekanntes Marker-Symbol]]',
		comma          = '<span class="listing-comma">, ​</span>', -- zero-width space
		missingName    = 'Name fehlt',

		-- Marker
		CategoryNS     = { '[Cc]ategory', '[Kk]ategorie' },
		FileNS         = { '[Ff]ile', '[Ii]mage', '[Dd]atei', '[Bb]ild' },
		latitude       = 'Breitengrad',
		longitude      = 'Längengrad',
		tooltip        = 'Click auf den Marker öffnet die Karte direkt.',

		-- vCard / Listing module
		checkin        = 'Check-in: %s',
		checkout       = 'Check-out: %s',
		closed         = 'Geschlossen: %s',
		closedPattern  = '^[Gg]eschlossen:?%s*',
		email          = 'E-Mail: %s',
		expirationPeriod = 'now - 3 years',
		fax            = 'Fax: %s',
		hintName       = 'Name in der Landessprache %s',
		hintLatin      = 'Name in lateinischer Umschrift',
		hintAddress    = 'Anschrift in der Landessprache %s',
		hintAddress2   = 'Anschrift in %s',
		hintDirections = 'Wegbeschreibung in der Landessprache %s',
		hours          = 'Geöffnet: %s',
		iata           = '[[International Air Transport Association|IATA]]: %s',
		icao           = '[[Internationale Zivilluftfahrt-Organisation|ICAO]]: %s',
		lastedit       = 'letzte Änderung: %s',
		lasteditNone   = 'keine Angabe',
		maybeOutdated  = '(Angaben möglicherweise veraltet)[[Category:VCard: Angaben veraltet]]',
		mobile         = 'Mobil: %s',
		payment        = 'Akzeptierte Zahlungsarten: %s',
		phone          = '<abbr title="Telefon">Tel.</abbr>: %s',
		price          = 'Preis: %s',
		skype          = 'Skype: %s',
		subtype        = 'Merkmal: %s.',
		subtypes       = 'Merkmale: %s.',
		subtypeAbbr    = '<abbr title="%s">%s</abbr>',
		subtypeFile    = '[[File:%s|x14px|link=|class=noviewer listing-subtype-icon|%s]]',
		subtypeSpan    = '<span title="%s">%s</span>',
		subtypeWithCount = '%d %s',
		tollfree       = '<abbr title="Telefon">Tel.</abbr> gebührenfrei: %s'
	},

	-- namespaces without maintenance messages
	nsNoMaintenance = {
		[ 4 ]   = true,
		[ 10 ]  = true,
		[ 828 ] = true
	},

	-- format strings for mu.addMaintenance
	formats = {
		category = '[[Category:%s]]',
		error    = ' <span class="error">%s</span>',
		hint     = ' <span class="listing-check-recommended" style="display: none;">%s</span>'
	},

	-- maintenance
	maintenance = {
		-- general
		properties     = '[[Category:Seiten, die die Wikidata-Eigenschaft %s benutzen]]',
		type           = { category = 'Seiten mit dem Markertyp %s' },

		urlWithIP      = { category = 'URL enthält IP-Adresse', hint = 'URL enthält IP-Adresse' },
		wrongUrl       = { category = 'URL ist ungültig', err = 'URL ist ungültig' },

		commonscat     = { category = 'VCard: Parameter commonscat benutzt' },
		commonscatWD   = { category = 'VCard: Parameter commonscat zusammen mit Wikidata benutzt' },
		currencyTooltip= { category = 'VCard: Währungstooltips eingesetzt' },
		dmsCoordinate  = { category = 'VCard: DMS-Koordinate', hint = 'DMS-Koordinate' },
		duplicateAliases = { category = 'VCard: Doppelte Aliase', err = 'Doppelte Aliase: %s' },
		groupIsColor   = { category = 'VCard: Gruppe ist Farbbezeichnung', hint = 'Gruppe ist Farbbezeichnung' },
		groupUsed      = { category = 'VCard: Parameter group benutzt' },
		illegalCtrls   = { category = 'VCard: Parameter mit unerlaubten Steuerzeichen', err = 'Parameter mit unerlaubten Steuerzeichen' },
		urlIsSocialMedia = { category = 'VCard: URL stammt von Social-Media-Dienst', err = 'URL stammt von Social-Media-Dienst' },
		labelFromWD    = { category = 'VCard: Label aus Wikidata', hint = 'Label aus Wikidata' },
		linkToOtherWV  = { category = 'VCard: Anderes Wikivoyage verlinkt' },
		localNameFromWD = { category = 'VCard: Lokaler Name aus Wikidata bezogen' },
		malformedName  = { category = 'VCard: Fehlerhafter Name', err = 'Fehlerhafter Name' },
		missingImg     = { category = 'VCard: Datei existiert nicht', err = 'Nicht vorhandenes Bild: %s' },
		missingNameMsg = { category = 'VCard: Ohne Namen', err = 'Name fehlt' },
		missingType    = { category = 'VCard: Typ fehlt', err = 'Fehlender Typ' },
		nameFromWD     = { category = 'VCard: Name aus Wikidata bezogen', err = 'Name aus Wikidata bezogen' },
		nameWithStar   = { category = 'VCard: Name enthält Stern', err = 'Name enthält Stern' },
		outdated       = { category = 'VCard: Ereignis veraltet', err = 'Ereignis veraltet' },
		parameterUsed  = { category = 'VCard: Parameter %s benutzt' },
		deleteShowCopy = { category = 'VCard: show=copy gelöscht', hint = 'show=copy gelöscht' },
		showPoiUsed    = { category = 'VCard: show=poi benutzt' },
		typeFromWDchain= { category = 'VCard: Typ aus Wikidata-Kette bezogen', hint = 'Typ aus Wikidata bezogen' },
		typeIsGroup    = { category = 'VCard: Typ ist Gruppenbezeichnung', hint = 'Typ ist Gruppenbezeichnung' },
		typeIsColor    = { category = 'VCard: Typ ist Farbbezeichnung', hint = 'Typ ist Farbbezeichnung' },
		unknownCountry = { category = 'VCard: Unbekannter Ländercode', err = 'Unbekannter Ländercode' },
		unknownGroup   = { category = 'VCard: Unbekannte Gruppe', err = 'Unbekannte Gruppe' },
		unknownLanguage= { category = 'VCard: Unbekannte Landessprache', hint = 'Unbekannte Landessprache' },
		unknownParam   = { category = 'VCard: Unbekannte Parameter', err = 'Unbekannter Parameter: %s' },
		unknownParams  = { category = 'VCard: Unbekannte Parameter', err = 'Unbekannte Parameter: %s' },
		unknownPropertyLanguage= { category = 'VCard: Unbekannte Sprache für Eigenschaft', hint = 'Unbekannte Sprache für Eigenschaft' },
		unknownStatus  = { category = 'VCard: Unbekannter Status', err = 'Unbekannter Status' },
		unknownType    = { category = 'VCard: Unbekannter Typ', err = 'Unbekannter Typ' },
		wikidata       = { category = 'VCard: Einsatz von Wikidata' },
		wrongCoord     = { category = 'VCard: Fehlerhafte Koordinate', err = 'Fehlerhafte Koordinate' },
		wrongImgName   = { category = 'VCard: Fehlerhafter Mediendateiname', err = 'Fehlerhafter Mediendateiname' },
		wrongQualifier = { category = 'VCard: Fehlerhafter Wikidata-Qualifikator', err = 'Fehlerhafter Wikidata-Qualifikator' },

		-- Marker module
		missingCoord   = { category = 'Marker: Ohne Koordinaten', err = 'Länge und/oder Breite fehlt' },
		numberUsed     = { category = 'Marker: Nummer manuell vergeben' },
		showNoneUsed   = { category = 'Marker: show=none benutzt' },
		unknownIcon    = { category = 'Marker: Unbekanntes Symbol' },

		-- vCard / Listing module
		commentFromWD  = { category = 'VCard: Kommentare aus Wikidata' },
		countryFromWD  = { category = 'VCard: Länderdaten aus Wikidata' },
		descrDiv       = { category = 'VCard: Beschreibung im div-Tag' },
		inlineSelected = { category = 'VCard: show=inline gesetzt' },
		missingCoordVc = { category = 'VCard: Ohne Koordinaten' },
		paymentUsed    = { category = 'VCard: Zahlungsarten spezifiziert' },
		socialUrlUsed  = { category = 'VCard: Social-Media-URL verwendet', hint = '%s-URL verwendet' },
		unitFromWD     = { category = 'VCard: Einheit aus Wikidata', hint = 'Einheit aus Wikidata' },
		unknownLabel   = { category = 'VCard: Unbekanntes Label oder Id' },
		unknownMAKI    = { category = 'VCard: Unbekanntes MAKI-Symbol', hint = 'Unbekanntes MAKI-Symbol' },
		unknownShow    = { category = 'VCard: Unbekannter Wert für show', err = 'Wert(e) für show unbekannt: %s' },
		unknownSubtype = { category = 'VCard: Unbekannter Wert für subtype', err = 'Wert(e) für subtype unbekannt: %s' },
		unknownUnit    = { category = 'VCard: Unbekannte Einheit', hint = 'Unbekannte Einheit' },
		unknowWDfeatures = { category = 'VCard: Unbekannte Wikidata-Merkmale', hint = 'Unbekannte Wikidata-Merkmale' },
		wrongDate      = { category = 'VCard: Fehlerhaftes Datum', err = 'Fehlerhaftes Datum' },
		wrongSocialId  = { category = 'VCard: Fehlerhafte Social-Media-Id', err = 'Fehlerhafte %s-Id' },
		wrongSocialUrl = { category = 'VCard: Fehlerhafte Social-Media-URL', err = 'Fehlerhafte %s-URL' }
	},

	iconTitles = {
		commons    = '%s im Medienverzeichnis Wikimedia Commons',
		facebook   = '%s auf Facebook',
		flickr     = '%s auf Flickr',
		instagram  = '%s auf Instagram',
		internet   = 'Website dieser Einrichtung',
		rss        = 'RSS-Web-Feed dieser Einrichtung',
		tiktok     = '%s auf TikTok',
		twitter    = '%s auf X (Twitter)',
		wikidata   = '%s (%s) in der Datenbank Wikidata',
		wikipedia  = '%s in der Enzyklopädie Wikipedia',
		wikivoyage = '%s im Reiseführer Wikivoyage in einer anderen Sprache',
		youtube    = '%s auf YouTube'
	},

	-- social media services
	services = {
		{ key = 'facebook',  url = 'https://www.facebook.com/%s', pattern = { '^[-.%d%w]+$', '^[^%z\1-,/:-?\91-\94{-~]+/[1-9]%d+$' } },
		{ key = 'flickr',    url = 'https://www.flickr.com/photos/%s', pattern = '^%d%d%d%d%d+@N%d%d$' },
		{ key = 'instagram', url = 'https://www.instagram.com/%s/', pattern = { '^[0-9a-z_][0-9a-z._]+[0-9a-z_]$', '^explore/locations/%d+$' } },
		{ key = 'tiktok',    url = 'https://www.tiktok.com/@%s', pattern = '^[0-9A-Za-z_][0-9A-Za-z_.]+$' },
		{ key = 'twitter',   url = 'https://twitter.com/%s', pattern = '^[0-9A-Za-z_]+$' },
		{ key = 'youtube',   url = 'https://www.youtube.com/channel/%s', pattern = '^UC[-_0-9A-Za-z]+[AQgw]$' }
	},

	-- status symbols
	statuses = {
		none    = { alias = "class-0", label = "Ohne Einstufung" },
		stub    = { alias = "class-1", label = "Stub" },
		outline = { alias = "class-2", label = "Artikelentwurf" },
		usable  = { alias = "class-3", label = "Brauchbarer Artikel" },
		guide   = { alias = "class-4", label = "Vollständiger Artikel" },
		star    = { alias = "class-5", label = "Empfehlenswerter Artikel" },
		
		['top-hotel']  = { label = "Top-Hotel" },
		['top-restaurant']  = { label = "Top-Restaurant" },
		['top-sight']  = { label = "Top-Sehenswürdigkeit" },
		recommendation = { label = "Empfehlung" }
	},

	-- Marker name styles
	nameStyles = {
		italic  = 'font-weight: normal; font-style: italic;',
		kursiv  = 'font-weight: normal; font-style: italic;', -- de: kursiv = italic
		normal  = 'font-weight: normal; font-style: normal;',
		station = 'font-weight: normal; white-space: nowrap; background: #f4f4f4; border: 1px solid #ddd; padding-left: 2px; padding-right: 2px;'
	},

	-- yes/no variants
	yesno = {
		y    = 'y',
		yes  = 'y',
		j    = 'y',
		ja   = 'y',
		n    = 'n',
		no   = 'n',
		nein = 'n'
	},

	-- List of currencies without conversion tooltips
	noCurrencyConversion = {
		EUR = 1
	},

	-- Language-dependent sorting substitutes
	substitutes = {
		{ l = 'ä', as = 'a' },
		{ l = 'ö', as = 'o' },
		{ l = 'ü', as = 'u' },
		{ l = 'ß', as = 'ss' }
	}
}
