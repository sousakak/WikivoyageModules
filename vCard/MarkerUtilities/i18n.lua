-- Separating code from internationalization

return {
	-- module administration
	moduleInterface  = {
		suite  = 'Marker utilities',
		sub    = 'i18n',
		serial = '2024-01-25',
		item   = 65441686
	},

	dates            = { yyyymmdd = { p = '^20[0-5]%d%-[01]?%d%-[0-3]?%d$', f = 'j. M Y' },
	                     yyyy     = { p = '^20[0-5]%d$', f = 'Y' },
	                     yy       = { p = '^[0-5]%d$', f = 'Y' },
	                     mmdd     = { p = '^[01]?%d%-[0-3]?%d$', f = 'j. M' },
	                     dd       = { p = '^[0-3]?%d%.?$', f = 'j.' },
	                     mm       = { p = '^[01]?%d%.?$', f = 'M' },
                         lastedit = { f = 'M Y' },
	                     asOf     = { f = 'n/Y' }
	                   },
	fileExtensions   = { 'tif', 'tiff', 'gif', 'png', 'jpg', 'jpeg', 'jpe',
	                     'webp', 'xcf', 'ogg', 'ogv', 'svg', 'pdf', 'stl',
	                     'djvu', 'webm', 'mpg', 'mpeg' },
	months           = { '1月', '2月', '3月', '4月', '5月', '6月', '7月',
	                     '8月', '9月', '10月', '11月', '12月' },
	monthAbbr        = { 'Jan%.?', 'Feb%.?', 'Mär%.?', 'Apr%.?', 'Mai%.?', 'Jun%.?',
	                     'Jul%.?', 'Aug%.?', 'Sep%.?', 'Okt%.?', 'Nov%.?', 'Dez%.?' },
        --月略語なんて日本語に存在するのだろうか
	
	-- Map related constants
	map = {
        coordURL          = 'https://ja.wikivoyage.org/w/index.php?title=特別:MapSources&params=',
        defaultDmsFormat  = 'f1', -- see: Module:Coordinates/i18n
        defaultSiteType   = 'type:landmark_globe:earth',
        defaultZoomLevel  = 17,
        maxZoomLevel      = 19,   -- also to set in Module:GeoData, Module:Mapshape utilities/i18n
    }

	-- Wikidata properties
	properties = {
		appliesToJurisdiction = 'P1001',
		appliesToPart     = 'P518',
		appliesToPeople   = 'P6001',
		capacity          = 'P1083',
		centerCoordinates = 'P5140',
		commonsCategory   = 'P373',
		coordinates       = 'P625',
		endTime           = 'P582',  -- time
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
		startTime         = 'P580',  -- time, for fees
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
		                    'P4135', 'P642', 'P580' },
		policyComments  = { 'P518', 'P1001', 'P6001' },
		quantity        = { 'P1114', 'P1083' }
	},

	-- Wikidata properties representing a qualifier
	qualifiers = {
		mobilePhone = 'Q17517',
		P8733       = 'Q180516',
		roomNumber  = 'Q180516'
	},

	-- Languages for fallbacks, except wiki language
	langs = { 'en' }, -- array can be empty

    -- Display and performance options for vCard / Listing and Marker modules
	-- additional options in Module:VCard/i18n
	options = {
        normalizeValues = { 'type', 'subtype', 'show', 'status', 'symbol' },
		noStarParams    = { 'nameLocal', 'alt', 'comment' },
		noTypeMsgs      = false, -- prevents display of maintenance( typeFromWD, typeIsGroup )
		parameters      = { 'wikipedia' }, -- parameter is used
		showIcao        = true,
		showLocalData   = true,  -- names, addresses, directions
		showSisters     = true,  -- possible values true, false, 'atEnd'
        usePropertyCateg= true,  -- create maintenance categories for Wikidata properties
		useTypeCateg    = true,  -- create maintenance categories for marker types

        -- Wikidata related constants
        searchLimit     = 4,     -- count of levels for P31-P279 search

		-- useful but not necessary function calls
		WDmediaCheck    = false, -- check file names retrieved from Wikidata
		mediaCheck      = false, -- for better performance, otherwise expensive
		                         -- mw.title.new( 'Media:' .. image ) call is used
		secondaryCoords = false, -- adding listing coordinates to article database
		                         -- using #coordinates parser function
		skipPathCheck   = false  -- for URL check, see Module:UrlCheck
	},

	-- strings
	texts = {
		asOf           = '；%s時点', -- with semicolon separator
		from           = '%sから',
		fromTo         = '%s–%s',
		to             = '%sまで',
		fromTo2        = '%sから%sまで',

		-- General, i18n
		closeX         = '[[File:Close x - white.png|15px|link=|class=noviewer|不明なマーカー記号]]',
		missingName    = '名前なし',
        -- In case of CJK languages no spaces are used with punctuation
		-- Enumeration commas. listing-comma is used for alt names only
		comma          = '<span class="listing-comma">, ​</span>', -- with zero-width space
		commaSeparator = '、',
		period         = '。',
		periodSeparator= '。',
		-- Space following a punctuation mark
		space          = '　',
		parentheses    = '（%s）',
		emph           = "「%s」",

        -- Formatting numbers: replacement patterns
		decimalPoint   = '.',
		groupSeparator = '.',

		-- Anchor id
		anchor         = 'vCard_%s %s',

		-- Marker
		CategoryNS     = { '[Cc]ategory', 'カテゴリ' },
		FileNS         = { '[Ff]ile', '[Ii]mage', 'ファイル', '画像' },
		latitude       = '緯度',
		longitude      = '経度',
		tooltip        = 'マーカーをクリックして地図を直接開きます',

		-- vCard / Listing module
		checkin        = 'チェックイン：%s',
		checkout       = 'チェックアウト：%s',
		closed         = '閉店：%s',
		closedPattern  = '^閉店[:：]?%s*',
		email          = 'メール：%s',
		expirationPeriod = '今～３年',
		fax            = 'ファックス：%s',
		hintName       = '現地語の名前 %s',
		hintLatin      = 'ローマ字名',
		hintAddress    = '現地語の住所 %s',
		hintAddress2   = '%sの住所',
		hintDirections = '現地語の道順 %s',
		hours          = '営業時間：%s',
		iata           = '[[空港コード#IATA|IATA]]：%s',
		icao           = '[[空港コード#ICAO|ICAO]]：%s',
		lastedit       = '最終更新：%s',
		lasteditNone   = '未指定',
		maybeOutdated  = '（情報が古い可能性があります）[[カテゴリ:VCard:古い情報]]',
		mobile         = '携帯電話：%s',
		payment        = '支払方法：%s',
		phone          = '<abbr title="Telefon">電話番号</abbr>：%s',
		price          = '値段：%s',
--		skype          = 'Skype: %s',
		subtype        = '特徴：%s.',
		subtypes       = '特徴：%s.',
		subtypeAbbr    = '<abbr title="%s">%s</abbr>',
		subtypeFile    = '[[File:%s|x14px|link=|class=noviewer listing-subtype-icon|%s]]',
		subtypeSpan    = '<span title="%s">%s</span>',
		subtypeWithCount = '%d %s',
		tollfree       = 'フリーダイヤル：%s'
	},

	-- namespaces without maintenance messages
	nsNoMaintenance = {
		[ 4 ]   = true,
		[ 10 ]  = true,
        [ 12 ]  = true,
		[ 828 ] = true
	},

	-- format strings for mu.addMaintenance
	formats = {
		category = '[[カテゴリ:%s]]',
		error    = ' <span class="error">%s</span>',
		hint     = ' <span class="listing-check-recommended" style="display: none;">%s</span>'
	},

	-- maintenance
	maintenance = {
		-- general
		properties     = '[[カテゴリ:プロパティ%sを使用しているページ]]',
		type           = { category = '%sのマーカーを持つページ' },

		urlWithIP      = { category = 'IPアドレスを含むURL', hint = 'IPアドレスを含むURL' },
		wrongUrl       = { category = '無効なURL', err = '無効なURL' },

		commonscat     = { category = 'VCard:パラメータcommonsあり' },
		commonscatWD   = { category = 'VCard:パラメータcommonsと共存したウィキデータの情報' },
		currencyTooltip= { category = 'VCard:通貨ツールチップあり' },
		dmsCoordinate  = { category = 'VCard:度分秒形式の座標', hint = '度分秒形式の座標' },
		duplicateAliases = { category = 'VCard:重複した別名', err = '重複した別名：%s' },
		groupUsed      = { category = 'VCard:パラメータgroupあり' },
		illegalCtrls   = { category = 'VCard:不正な制御文字を含むパラメータ', err = '不正な制御文字を含むパラメータ' },
		labelFromWD    = { category = 'VCard:ウィキデータ由来のラベル', hint = 'ウィキデータ由来のラベル' },
        linkIsRedirect = { category = 'VCard: 転送ページへのリンク' },
		linkToOtherWV  = { category = 'VCard:他言語版へのリンクあり' },
		malformedName  = { category = 'VCard:誤った名前', err = '誤った名前' },
		missingImg     = { category = 'VCard:存在しないファイル', err = '存在しないファイル：%s' },
		missingNameMsg = { category = 'VCard:パラメータnameなし', err = '名前なし' },
		missingType    = { category = 'VCard:パラメータtypeなし', err = 'タイプなし' },
		nameFromWD     = { category = 'VCard:ウィキデータ由来のname', err = 'ウィキデータ由来のname' },
		nameWithStar   = { category = 'VCard:アスタリスクを含んだ名前', err = 'アスタリスクを含んだ名前' },
		outdated       = { category = 'VCard:終了したイベント', err = '終了したイベント' },
		parameterUsed  = { category = 'VCard:パラメータ%sあり' },
		deleteShowCopy = { category = 'VCard:show=copyあり', hint = 'show=copyは削除されました' },
        showInlineUsed = { category = 'VCard:show=inline' },
		showPoiUsed    = { category = 'VCard:show=poi' },
		typeFromWDchain= { category = 'VCard:ウィキデータ由来のtype', hint = 'ウィキデータ由来のtype' },
		typeIsGroup    = { category = 'VCard:グループ名が指定されたタイプ', hint = 'タイプがグループ名です' },
		typeIsColor    = { category = 'VCard:色が指定されたタイプ', hint = 'タイプが色の名前です' },
		unknownCountry = { category = 'VCard:不明な国コード', err = '国コードが不明です' },
		unknownGroup   = { category = 'VCard:不明なグループ', err = 'グループが不明です' },
		unknownLanguage= { category = 'VCard:不明な国語', hint = '不明な国語' },
		unknownParam   = { category = 'VCard:不明なパラメータ', err = '不明なパラメータ：%s' },
		unknownParams  = { category = 'VCard:不明なパラメータ', err = '不明なパラメータ：%s' },
		unknownPropertyLanguage= { category = 'VCard:不明なプロパティの言語', hint = '不明なプロパティの言語' },
		unknownStatus  = { category = 'VCard:不明なステータス', err = 'ステータスが不明です' },
		unknownType    = { category = 'VCard:不明なタイプ', err = 'タイプが不明です' },
        unusedRedirect = { category = 'VCard:未使用の転送ページへのリンク' },
		urlIsSocialMedia = { category = 'VCard:SNSから取得されたURL', err = 'SNSから取得されたURL' },
		wikidata       = { category = 'VCard:ウィキデータを使用' },
		wrongCoord     = { category = 'VCard:誤った座標', err = '誤った座標' },
		wrongImgName   = { category = 'VCard:間違ったメディアファイル名', err = 'メディアファイル名に誤りがあります' },
		wrongQualifier = { category = 'VCard:間違ったウィキデータ修飾子', err = 'ウィキデータ修飾子に誤りがあります' },

		-- Marker module
		missingCoord   = { category = 'Marker:座標なし', err = 'Länge und/oder Breite fehlt' },
		numberUsed     = { category = 'Marker:手動で割り当てられた番号' },
		unknownIcon    = { category = 'Marker:不明なアイコン' },

		-- vCard / Listing module
		countryFromWD  = { category = 'VCard:ウィキデータ由来の国コード' },
		missingCoordVc = { category = 'VCard:座標なし' },
		paymentUsed    = { category = 'VCard:パラメータpaymentあり' },
		socialUrlUsed  = { category = 'VCard:SNSのURLあり', hint = '%sのURLが使用されています' },
		unitFromWD     = { category = 'VCard:ウィキデータ由来のユニット', hint = 'ウィキデータ由来のユニット' },
		unknownLabel   = { category = 'VCard:不明なラベルまたはID' },
		unknownMAKI    = { category = 'VCard:不明なMakiアイコン', hint = '不明なMakiアイコン' },
		unknownShow    = { category = 'VCard:不明なshowの値', err = 'showの値が不明です：%s' },
		unknownSubtype = { category = 'VCard:不明なsubtypeの値', err = 'subtypeの値が不明です：%s' },
		unknownUnit    = { category = 'VCard:不明なユニット', hint = '不明なユニット' },
		unknowWDfeatures = { category = 'VCard:不明なウィキデータ機能', hint = '不明なウィキデータ機能' },
		wrongDate      = { category = 'VCard:不正な日付', err = '不正な日付' },
		wrongSocialId  = { category = 'VCard:誤ったSNSのID', err = '誤った%sのID' },
		wrongSocialUrl = { category = 'VCard:誤ったSNSのURL', err = '誤ったSNSのURL' }
	},

	iconTitles = {
		commons    = 'Wikimedia Commonsにあるメディア',
		facebook   = 'facebookで%sをみる',
		flickr     = 'Flickrで%sをみる',
		instagram  = 'Instagramで%sをみる',
		internet   = '公式ウェブサイト',
		rss        = 'RSSフィード',
		tiktok     = 'TikTokで%sをみる',
		twitter    = 'Xで%sをみる',
		wikidata   = 'ウィキデータで%s（%s）をみる',
		wikipedia  = 'ウィキペディアで%sをみる',
		wikivoyage = '他言語版で%sをみる',
		youtube    = 'YouTubeで%sをみる'
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
		none    = { alias = "class-0", label = "分類なし" },
		stub    = { alias = "class-1", label = "スタブ" },
		outline = { alias = "class-2", label = "骨格記事" },
		usable  = { alias = "class-3", label = "役立つ記事" },
		guide   = { alias = "class-4", label = "完全な記事" },
		star    = { alias = "class-5", label = "おすすめ記事" },
		
		['top-hotel']  = { label = "トップ宿泊施設" },
		['top-restaurant']  = { label = "トップ飲食店" },
		['top-sight']  = { label = "トップ観光地" },
		recommendation = { label = "おすすめ" }
	},

	-- Marker name styles
	nameStyles = {
		italic  = 'font-weight: normal; font-style: italic;',
		normal  = 'font-weight: normal; font-style: normal;',
		station = 'font-weight: normal; white-space: nowrap; background: #f4f4f4; border: 1px solid #ddd; padding-left: 2px; padding-right: 2px;'
	},

	-- yes/no variants
	yesno = {
		y    = 'y',
		yes  = 'y',
		n    = 'n',
		no   = 'n'
	},

	-- List of currencies without conversion tooltips
	noCurrencyConversion = {
		JPY = 1
	},

	-- Language-dependent sorting substitutes
	substitutes = {
		-- Japanese doesn't use Latin characters, and too many kanji to list.
	}
}
