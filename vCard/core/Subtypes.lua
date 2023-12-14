-- empty strings should be filled with icons
-- please use only quotation marks instead of apostrophs for JSON export

return {
	-- administration
	moduleInterface = {
		suite  = 'vCard',
		sub    = 'Subtypes',
		serial = '2023-10-12',
		item   = 65455756
	},

	firstGroup = 2,            -- first group to display
	fromWDGroupNumber = 98,    -- group number for Q... types from Wikidata
	fromTypesGroupNumber = 99, -- group number for types from types table

	-- subtype conversion
	
	convert = {
		-- hotelstars = { "1", "2", "3", "4", "5" }, -- hotel stars codes
		michelin   = { "michelin1", "michelin2", "michelin3" }
	},

	-- type list

	f = {
		-- classification, rating. Group 1 is usually not displayed
		
		budget     = { g = 1, wd =          "", n = "お手頃" },
		midrange   = { g = 1, wd =          "", n = "中級店" },
		upmarket   = { g = 1, wd =          "", n = "高級店" },

		-- hotel rating
        --[[
		hotelstars = { g = 2, wd =  "Q2976556", n = "Hotel-Stern[e]" }, -- see: convert
        ]]

		-- Upto now it seems that there is no font containing the left black half star
		-- (u+2BE8): ⯨. That's why now the ½ workaround. 

        --[[
		["1"]      = { g = 2, wd ="Q110772650", sortkey =  "01*", n = "★", t = "1-Stern-Bewertung" },  -- tourist
		["1h"]     = { g = 2, wd ="Q110932985", sortkey = "01*5", n = "★½", t = "1,5-Sterne-Bewertung" }, -- superior tourist (tourist plus)
		["1s"]     = { g = 2, wd ="Q109726413", sortkey = "01*S", n = "★S", t = "1-Stern-Superior-Bewertung" }, -- superior tourist (tourist plus)
		["2"]      = { g = 2, wd ="Q110772651", sortkey =  "02*", n = "★★", t = "2-Sterne-Bewertung" }, -- standard
		["2h"]     = { g = 2, wd ="Q110932986", sortkey = "02*5", n = "★★½", t = "2,5-Sterne-Bewertung" }, -- superior standard
		["2s"]     = { g = 2, wd ="Q109726348", sortkey = "02*S", n = "★★S", t = "2-Sterne-Superior-Bewertung" }, -- superior standard
		["3"]      = { g = 2, wd ="Q110772652", sortkey =  "03*", n = "★★★", t = "3-Sterne-Bewertung" },  -- comfort
		["3h"]     = { g = 2, wd ="Q110932987", sortkey = "03*5", n = "★★★½", t = "3,5-Sterne-Bewertung" },  -- superior comfort
		["3s"]     = { g = 2, wd ="Q109726284", sortkey = "03*S", n = "★★★S", t = "3-Sterne-Superior-Bewertung" }, -- superior comfort
		["4"]      = { g = 2, wd ={ "Q110772653", "Q99309708" }, sortkey =  "04*", n = "★★★★", t = "4-Sterne-Bewertung" },  -- first class
		["4h"]     = { g = 2, wd ="Q110932988", sortkey = "04*5", n = "★★★★½", t = "4,5-Sterne-Bewertung" }, -- superior first class
		["4s"]     = { g = 2, wd ="Q109726210", sortkey = "04*S", n = "★★★★S", t = "4-Sterne-Superior-Bewertung" }, -- superior first class
		["5"]      = { g = 2, wd ={ "Q109248725", "Q109248724" }, sortkey =  "05*", n = "★★★★★", t = "5-Sterne-Bewertung" },  -- luxury
		["5s"]     = { g = 2, wd ="Q109726138", sortkey = "05*S", n = "★★★★★S", t = "5-Sterne-Superior-Bewertung" }, -- superior luxury
        ]]

		-- Michelin awards to restaurant chefs
		michelin   = { g = 2, wd = "Q20824563", n = "ミシュラン" },

		michelin1  = { g = 2, wd =          "", n = "ミシュラン1つ星", f = "Etoile Michelin-1.svg", c = 1 },
		michelin2  = { g = 2, wd =          "", n = "ミシュラン2つ星", f = "Etoile Michelin-1.svg", c = 2 },
		michelin3  = { g = 2, wd =          "", n = "ミシュラン3つ星", f = "Etoile Michelin-1.svg", c = 3 },

		-- subtypes from subtype parameter in types table

		bnb        = { g = 3, wd =   "Q367914", n = "B&B" },
		boarding_house = { g = 3, wd = { "Q1558858", "Q1065252" }, n = "下宿" },
		hotel_garni= { g = 3, wd =  "Q1631103", n = "ホテル・ガルニ" },

		-- general facilities

		accessible = { g = 4, wd =   "Q808926", n = "バリアフリー" }, -- barrier-free, for handicapped people
		ai         = { g = 4, wd =  "Q1281666", n = "全て込み" },
		basement_garage = { g = 4, wd =  "Q2431970", n = "地下駐車場" },
		car_park   = { g = 4, wd = "Q13218805", n = "駐車場" },
		free_wlan  = { g = 4, wd =  "Q1543615", n = "無料Wi-Fi" },
		garage     = { g = 4, wd =    "Q22733", n = "車庫" },
		induction_loop = { g = 4, wd =  "Q2163913", n = "無線誘導システム" },
		internet_access = { g = 4, wd = "Q1472399", n = "インターネットアクセス" }, -- unknown type or both lan and wlan
		lan        = { g = 4, wd =    "Q11381", n = "LAN" },
		lgbt       = { g = 4, wd =    "Q17884", n = "LGBT", f = "Gay flag.svg" }, -- including gay
		nobreakfast= { g = 4, wd ="Q106041208", n = "朝食なし" },
		nowheelchair = { g = 4, wd = "Q24192069", n = "車いす利用不可", f = "Wheelchair-red3.png" },
		nowlan     = { g = 4, wd =  "Q1814990", n = "Wi-Fiなし" }, -- no
		paid_wlan  = { g = 4, wd = "Q24202480", n = "有料Wi-Fi" },
		parking    = { g = 4, wd =  "Q6501349", n = "駐車場" },
		tactile_graphic = { g = 4, wd =  "Q7674130", n = "触地図" },
		valet_parking = { g = 4, wd =  "Q1423019", n = "バレットパーキング" },
		withbreakfast = { g = 4, wd ="Q106041297", n = "朝食付き" },
		wheelchair = { g = 4, wd = "Q24192067", n = "車いす対応", f = "Wheelchair-green3.png" },
		wheelchair_available = { g = 4, wd =   "Q191931", n = "車いす利用可" },
		wheelchair_with_help = { g = 4, wd = "Q24192068", n = "介助者がいれば車いす対応", f = "Wheelchair-yellow3.png" },
		wheelchair_partially = { g = 4, wd = "Q63731120", n = "一部車いす対応" },
		wheelchair_partially_with_help = { g = 4, wd = "Q63731151", n = "介助者がいれば一部車いす対応" },
		wlan       = { g = 4, wd =  "Q6452715", n = "Wi-Fi" }, -- yes

		-- hotel facilities

		adult_pool = { g = 5, wd =          "", n = "大人用プール" },
		airport_transfer_service = { g = 5, wd ="Q110012299", n = "空港送迎サービス" },
		atm        = { g = 5, wd =    "Q81235", n = "ATM" },
		ballroom   = { g = 5, wd =   "Q805353", n = "大宴会場" },
		babysitter = { g = 5, wd = "Q45181247", n = "ベビーシッター" },
		bank       = { g = 5, wd =    "Q22687", n = "銀行" },
		banquet_room = { g = 5, wd = "Q85833489", n = "宴会場" },
		bar        = { g = 5, wd =   "Q187456", n = "バー" },
		beach      = { g = 5, wd =    "Q40080", n = "ビーチ" },
		bed        = { g = 5, wd =    "Q42177", n = "ベッド" },
		bicycle_stand = { g = 5, wd =  "Q1392526", n = "駐輪場" },
		bike_rental= { g = 5, wd = "Q10611118", n = "レンタサイクル" },
		business   = { g = 5, wd =   "Q203180", n = "事業部" }, -- Geschäftsbereich
		buy        = { g = 5, wd =  "Q1369832", n = "お店" },
		cafe       = { g = 5, wd =    "Q30022", n = "カフェ" },
		casino     = { g = 5, wd =   "Q133215", n = "カジノ" },
		cinema     = { g = 5, wd =    "Q41253", n = "映画館" },
		cloakroom  = { g = 5, wd =   "Q965173", n = "洋服戸棚" },
		conference = { g = 5, wd = { "Q625994", "Q1207465" }, n = "会議室" },
		currency_exchange = { g = 5, wd =  "Q2002539", n = "両替" },
		dance_hall = { g = 5, wd ="Q121085156", n = "舞踏会場" },
		diving     = { g = 5, wd =   "Q179643", n = "ダイビングセンター" },
		family_room= { g = 5, wd =  "Q5433389", n = "ファミリー・ルーム" },
		fitness_center = { g = 5, wd = { "Q1065656", "Q30750411" }, n = "フィットネススタジオ" }, -- including gym, healthclub
		games_room = { g = 5, wd =          "", n = "遊び部屋" },
		garden     = { g = 5, wd =  "Q1107656", n = "庭園" },
		golf       = { g = 5, wd = { "Q5377", "Q1048525", "Q3177122" }, n = "ゴルフ場" },
		gymnasium  = { g = 5, wd = { "Q14092", "Q203609", "Q121085159" }, n = "体育館" },
		indoorpool = { g = 5, wd =   "Q357380", n = "屋内プール" },
		kidsclub   = { g = 5, wd = "Q16255832", n = "キッズクラブ" },
		kiting     = { g = 5, wd =   "Q219554", n = "カイトサーフィン" },
		library    = { g = 5, wd =     "Q7075", n = "図書館" },
		lift       = { g = 5, wd =   "Q132911", n = "エレベーター" },
		lobby      = { g = 5, wd =    "Q31948", n = "ロビー" },
		luggage_storage = { g = 5, wd = { "Q1195470", "Q21996814" }, n = "荷物預り所" },
		money_exchange_machine = { g = 5, wd = "Q25632829", n = "両替機" },
		meeting    = { g = 5, wd =  "Q3469909", n = "会議室" }, -- meeting rooms
		minigolf   = { g = 5, wd =   "Q754796", n = "パターゴルフ" },
		nightclub  = { g = 5, wd =   "Q622425", n = "ナイトクラブ" },
		playground = { g = 5, wd = "Q11875349", n = "遊び場" },
		pool       = { g = 5, wd = { "Q1501", "Q118559330" }, n = "プール" },
		reception  = { g = 5, wd =  "Q2794937", alias = "service_counter", n = "受付" },
		restaurant = { g = 5, wd =    "Q11707", n = "レストラン" },
		roof_garden= { g = 5, wd =  "Q1156696", n = "屋上庭園, 屋上テラス" },
		room       = { g = 5, wd =   "Q180516", n = "部屋" },
		sauna      = { g = 5, wd =    "Q57036", n = "サウナ" },
		socket_near_bed = { g = 5, wd ="Q110073378", n = "ベッド横のコンセント" },
		shop       = { g = 5, wd =   "Q213441", n = "店" },
		souvenir_shop = { g = 5, wd =   "Q865693", n = "お土産屋" },
		spa        = { g = 5, wd =  "Q1341387", alias = "wellness_center", n = "ウェルネスセンター, スパ" },
		sports     = { g = 5, wd =      "Q349", n = "スポーツ" },
		suite      = { g = 5, wd =  "Q1367530", n = "スイートルーム" },
		surfing    = { g = 5, wd =  "Q1324499", n = "サーフィン" },
		tennis     = { g = 5, wd =      "Q847", n = "テニス" },
		tennis_court = { g = 5, wd = "Q741118", n = "テニスコート" },
		theater    = { g = 5, wd =    "Q24354", n = "劇場" },
		warm_water = { g = 5, wd =  "Q1419245", n = "熱湯" },
		wave_pool  = { g = 5, wd =   "Q827349", n = "流れるプール" },

		-- non-hotel facilities

		audioguide = { g = 5, wd =   "Q758877", n = "音声ガイド" },
		cctv       = { g = 5, wd =   "Q242256", n = "閉回路テレビ" },
		communal_bunks = { g = 5, wd =  "Q1628935", n = "マットレスルーム, 共同寝所" },
		educational_workshop = { g = 5, wd ="Q113484895", n = "勉強会場" },
		guidebook  = { g = 5, wd =   "Q223638", n = "旅行ガイドブック" },
		lecture_hall = { g = 5, wd =   "Q253275", n = "講堂" },
		lighting   = { g = 5, wd =   "Q210064", n = "照明" },
		museum_shop= { g = 5, wd =  "Q2922607", n = "ミュージアムショップ" },
		organ      = { g = 5, wd =     "Q1444", n = "オルガン" },
		rest_area  = { g = 5, wd = { "Q47520603", "Q785979" }, alias = "picnic_site", n = "休憩所, ピクニック場" }, -- why do these exist together?
		reading_room = { g = 5, wd =  "Q1753764", n = "読書室" },
		shakedown  = { g = 5, wd = "Q40415224", n = "臨時キャンプ" },
		winter_room= { g = 5, wd =   "Q382899", n = "冬季専用部屋" },

		-- services in hotels etc.

		["24-hour_reception"] = { g = 6, wd =          "", n = "24時間対応" },
		accessible_toilet = { g = 6, wd =  "Q2775009", n = "バリアフリーのトイレ" },
		airport_shuttle   = { g = 6, wd =          "", n = "空港シャトル" },
		airport_terminal  = { g = 6, wd =   "Q849706", n = "空港ターミナル" },
		airport_transportation = { g = 6, wd =          "", n = "空港の輸送システム" },
		animation         = { g = 6, wd =   "Q547762", n = "子供向けアニメーター" },
		baby_change       = { g = 6, wd =  "Q2567605", n = "おむつ交換室" },
		babysitting       = { g = 6, wd =   "Q797990", n = "ベビーシッター" },
		beauty_service    = { g = 6, wd = "Q30303305", n = "美容サービス" },
		bicycle           = { g = 6, wd =    "Q11442", n = "自転車" },
		breakfast         = { g = 6, wd =    "Q80973", n = "朝食" },
		breakfast_buffet  = { g = 6, wd =          "", n = "ビュッフェの朝食" },
		breakfast_included= { g = 6, wd =          "", n = "朝食込み" },
		bus_stop          = { g = 6, wd =   "Q953806", n = "バス停" },
		car_hire          = { g = 6, wd =   "Q291240", n = "レンタカー" },
		changing_table    = { g = 6, wd =  "Q1780834", n = "おむつ交換台" },
		concierge         = { g = 6, wd =  "Q2664461", n = "コンシェルジュ" },
		discotheque       = { g = 6, wd =  "Q1228895", n = "ディスコ" },
		dry_cleaning      = { g = 6, wd =   "Q878156", n = "乾燥洗濯" },
		entertainment     = { g = 6, wd =   "Q173799", n = "娯楽" },
		free_parking      = { g = 6, wd =          "", n = "無料駐車場" },
		gate              = { g = 6, wd =   "Q247739", n = "搭乗ゲート" },
		hairdresser       = { g = 6, wd = { "Q55187", "Q95856773", "Q3062512" }, n = "美容院" },
		laundry           = { g = 6, wd = { "Q267734", "Q7223085", "Q12893467", "Q57261433" }, n = "ランドリー" },
		live_music        = { g = 6, wd ="Q100348587", n = "音楽ライブ" },
		massage           = { g = 6, wd =   "Q179415", n = "マッサージ" },
		multilingual_staff= { g = 6, wd =    "Q30081", n = "他言語対応スタッフ" },
		newspaper         = { g = 6, wd =    "Q11032", n = "新聞" },
		post_office       = { g = 6, wd =    "Q35054", n = "郵便局" },
		public_toilet     = { g = 6, wd = { "Q813966", "Q3472280" }, n = "公衆トイレ" },
		railroad_police   = { g = 6, wd =  "Q1930355", n = "鉄道警察隊" },
		room_service      = { g = 6, wd =  "Q2048970", n = "ルームサービス" },
		selflaundry       = { g = 6, wd =  "Q1143034", n = "コインランドリー" },
		shuttle_bus       = { g = 6, wd =  "Q1368498", n = "シャトルバス" },
		taxicab_stand     = { g = 6, wd =  { "Q82650", "Q1395196" }, n = "タクシー乗り場" },
		ticket_machine    = { g = 6, wd =   "Q657345", n = "自動券売機" },
		ticket_office     = { g = 6, wd = "Q56845288", n = "チケット売り場" },
		toilet            = { g = 6, wd =     "Q7857", n = "トイレ" },
		wc                = { g = 6, wd =  "Q7813355", n = "トイレ" },
		workshop          = { g = 6, wd =   "Q656720", n = "工房" },

		-- room facilities

		ac         = { g = 7, wd =   "Q173725", n = "Klimaanlage[n]" },
		air_condition = { g = 5, wd =  "Q1265533", n = "Klimaanlage[n]" },
		balcony    = { g = 7, wd =   "Q170552", n = "Balkon[e]" },
		bathroom   = { g = 7, wd =   "Q190771", n = "Badezimmer[]" },
		bathtub    = { g = 7, wd =   "Q152095", n = "Badewanne[n]" },
		bottle_warmer = { g = 7, wd = "Q56711128", n = "Flaschenwärmer[]" },
		coffeemaker= { g = 7, wd =   "Q211841", n = "Kaffeemaschine[n]" },
		commonbath = { g = 7, wd =          "", n = "Gemeinschaftsb[ä|a]d[er]" }, -- Gemeinschaftsbad
		fan        = { g = 7, wd =  "Q6498398", n = "Ventilator[en]" },
		fridge     = { g = 7, wd =    "Q37828", n = "Kühlschr[ä|a]nk[e]" },
		grab_rail  = { g = 7, wd =          "", n = "Haltegriff[e]" },
		hairdryer  = { g = 7, wd =    "Q15004", n = "Fön[e]" },
		jacuzzi    = { g = 7, wd =  "Q1936429", n = "Whirlpool[s]" }, -- incl. hot tub
		kitchen    = { g = 7, wd =    "Q43164", n = "Küche[n]" }, -- usable for guest, usually in the room
		minibar    = { g = 7, wd =  "Q1191522", n = "Minibar[s]" },
		phone      = { g = 7, wd =    "Q11035", n = "Telefon[e]" },
		safe       = { g = 7, wd =   "Q471898", n = "Safe[s]" },
		shower     = { g = 7, wd =     "Q7863", n = "Dusche[n]" },
		terrace    = { g = 7, wd =   "Q641406", n = "Terrasse[n]" },
		tv         = { g = 7, wd =     "Q8075", n = "Fernseher[], TV" },

		-- cuisine by ethnicity

		african    = { g = 8, wd =   "Q386284", n = "afrikanische Küche" },
		american   = { g = 8, wd =    "Q40578", n = "amerikanische Küche" },
		arab       = { g = 8, wd =   "Q623970", n = "arabische Küche" },
		argentinian= { g = 8, wd =   "Q579500", n = "argentische Küche" },
		asian      = { g = 8, wd =   "Q728206", n = "asiatische Küche" },
		australian = { g = 8, wd =   "Q783010", n = "australische Küche" },
		balkan     = { g = 8, wd =   "Q805060", n = "Balkan-Küche" },
		basque     = { g = 8, wd =   "Q521179", n = "baskische Küche" },
		bavarian   = { g = 8, wd =   "Q458851", n = "bayerische Küche" },
		bolivian   = { g = 8, wd =  "Q3006895", n = "bolivianische Küche" },
		brazilian  = { g = 8, wd =   "Q614394", n = "brasilianische Küche" },
		burmese    = { g = 8, wd =  "Q1187275", n = "burmesische Küche" },
		californian= { g = 8, wd =  "Q1026802", n = "kalifornische Küche" },
		cambodian  = { g = 8, wd =   "Q139430", n = "kambodschanische Küche" },
		cantonese  = { g = 8, wd =  "Q1154790", n = "kantonesische Küche" },
		caribbean  = { g = 8, wd =  "Q1729345", n = "karibische Küche" },
		chinese    = { g = 8, wd = "Q10876842", n = "chinesische Küche" },
		croatian   = { g = 8, wd =  "Q1789628", n = "kroatische Küche" },
		cypriot    = { g = 8, wd =   "Q245932", n = "zyprische Küche" },
		czech      = { g = 8, wd =   "Q871595", n = "tschechische Küche" },
		danish     = { g = 8, wd =  "Q1196267", n = "dänische Küche" },
		egyptian   = { g = 8, wd =  "Q1346230", n = "ägyptische Küche" },
		english    = { g = 8, wd =  "Q1261477", n = "englische Küche" },
		ethiopian  = { g = 8, wd =   "Q257508", n = "äthiopische Küche" },
		european   = { g = 8, wd =   "Q579316", n = "europäische Küche" },
		french     = { g = 8, wd =     "Q6661", n = "französische Küche" },
		fucha_ryori= { g = 8, wd = "Q10286142", n = "Fucha Ryōri" },
		georgian   = { g = 8, wd =  "Q1199026", n = "georgische Küche" },
		german     = { g = 8, wd =    "Q47629", n = "deutsche Küche" },
		greek      = { g = 8, wd =   "Q744027", n = "griechische Küche" },
		home_style = { g = 8, wd =   "Q881929", n = "gutbürgerliche Küche" },
		hunan      = { g = 8, wd =  "Q1156889", n = "Hunan-Küche" },
		hungarian  = { g = 8, wd =   "Q264327", n = "ungarische Küche" },
		indian     = { g = 8, wd =   "Q192087", n = "indische Küche" },
		international = { g = 8, wd = "Q99522230", n = "internationale Küche" },
		iranian    = { g = 8, wd =  "Q1342397", n = "iranische Küche" },
		irish      = { g = 8, wd =  "Q1068545", n = "irische Küche" },
		italian    = { g = 8, wd =   "Q192786", n = "italienische Küche" },
		japanese   = { g = 8, wd =   "Q234138", n = "japanische Küche" },
		korean     = { g = 8, wd =   "Q647500", n = "koreanische Küche" },
		latin_american = { g = 8, wd =  "Q2707196", n = "lateinamerikanische Küche" },
		lebanese   = { g = 8, wd =   "Q929239", n = "libanesische Küche" },
		levantine  = { g = 8, wd =   "Q765174", n = "levantinische Küche" },
		malaysian  = { g = 8, wd =   "Q772247", n = "malaysische Küche" },
		medieval   = { g = 8, wd =    "Q10886", n = "Mittelalterküche" },
		mediterranean = { g = 8, wd =   "Q934309", n = "Mittelmeerküche" },
		mexican    = { g = 8, wd =   "Q207965", n = "mexikanische Küche" },
		national   = { g = 8, wd =  "Q1968435", n = "Nationalküche" },
		nepalese   = { g = 8, wd =  "Q1194855", n = "nepalesische Küche" },
		new_nordic = { g = 8, wd =  "Q3345199", n = "New Nordic Cuisine" },
		nubian     = { g = 8, wd ="Q113827054", n = "nubische Küche" },
		oriental   = { g = 8, wd =  "Q1547037", n = "orientalische Küche" },
		pakistani  = { g = 8, wd =  "Q1089120", n = "pakistanische Küche" },
		peruvian   = { g = 8, wd =   "Q749847", n = "peruanische Küche" },
		polish     = { g = 8, wd =   "Q756020", n = "polnische Küche" },
		portuguese = { g = 8, wd =   "Q180817", n = "portugiesische Küche" },
		regional   = { g = 8, wd =    "Q94951", n = "Regionalküche" },
		rhenish    = { g = 8, wd =  "Q2147761", n = "rheinische Küche" },
		russian    = { g = 8, wd =    "Q12505", n = "russische Küche" },
		shandong   = { g = 8, wd =  "Q1038209", n = "Shandong-Küche" },
		sichuan    = { g = 8, wd =   "Q691365", n = "Sichuan-Küche" },
		south_indian= { g = 8, wd =  "Q3595152", n = "südindische Küche" },
		spanish    = { g = 8, wd =   "Q622512", n = "spanische Küche" },
		swiss      = { g = 8, wd =    "Q13497", n = "schweizerische Küche" },
		swabian    = { g = 8, wd =   "Q880365", n = "schwäbische Küche" },
		thai       = { g = 8, wd =   "Q841984", n = "thailändische Küche" },
		thuringian = { g = 8, wd =   "Q187477", n = "Thüringer Küche" },
		turkish    = { g = 8, wd =   "Q654493", n = "türkische Küche" },
		ukranian   = { g = 8, wd =  "Q1503789", n = "ukrainische Küche" },
		vietnamese = { g = 8, wd =   "Q826059", n = "vietnamesische Küche" },
		western    = { g = 8, wd = "Q16143746", n = "westliche Küche" },
		westphalian= { g = 8, wd =  "Q2565249", n = "westfälische Küche" },

		-- cuisine by type of food

		bagel      = { g = 9, wd =   "Q272502", n = "Bagel" },
		barbecue   = { g = 9, wd =   "Q461696", n = "Barbecue, BBQ" },
		bougatsa   = { g = 9, wd =   "Q895009", n = "Bougatsa" },
		burger     = { g = 9, wd =     "Q6663", n = "Burger" },
		cake       = { g = 9, wd =    "Q13276", n = "Kuchen" },
		casserole  = { g = 9, wd =  "Q7724780", n = "Kasserolle" },
		chicken    = { g = 9, wd =   "Q864693", n = "Hühnchen" },
		crepe      = { g = 9, wd =    "Q12200", n = "Crêpe" },
		couscous   = { g = 9, wd =    "Q76605", n = "Couscous" },
		curry      = { g = 9, wd =   "Q164606", n = "Curry" },
		dessert    = { g = 9, wd =   "Q182940", n = "Dessert, Nachspeise" },
		donut      = { g = 9, wd =   "Q192783", n = "Donut" },
		empanada   = { g = 9, wd =   "Q747457", n = "Empanada" },
		fish_and_chips = { g = 9, wd =   "Q203925", n = "Fish and Chips" },
		fried_food = { g = 9, wd =   "Q300472", n = "Braten" },
		friture    = { g = 9, wd =   "Q854618", n = "Frittieren" },
		grill      = { g = 9, wd =   "Q853185", n = "Grill" },
		gyros      = { g = 9, wd =   "Q681596", n = "Gyros" },
		ice_cream  = { g = 9, wd =    "Q13233", n = "Eis, Speiseeis" },
		kebab      = { g = 9, wd =   "Q179010", n = "Kebab" },
		noodle     = { g = 9, wd =   "Q192874", n = "Nudeln" },
		pancake    = { g = 9, wd =    "Q44541", n = "Pfannkuchen, Eierkuchen" },
		pasta      = { g = 9, wd =      "Q178", n = "Pasta" },
		pie        = { g = 9, wd = "Q13360264", n = "Pie" },
		pizza      = { g = 9, wd =      "Q177", n = "Pizza" },
		salad      = { g = 9, wd =     "Q9266", n = "Salat" },
		sandwich   = { g = 9, wd =    "Q28803", n = "Sandwich" },
		sausage    = { g = 9, wd =   "Q131419", n = "Wurst, Würstchen" },
		seafood    = { g = 9, wd =   "Q192935", n = "Meeresfrüchte, Fisch" },
		soup       = { g = 9, wd =    "Q41415", n = "Suppe" },
		steakhouse = { g = 9, wd =  "Q3109696", n = "Steakhaus" },
		sushi      = { g = 9, wd =    "Q46383", n = "Sushi" },
		tapas      = { g = 9, wd =   "Q220964", n = "Tapa, Tapas" },
		vegan      = { g = 9, wd = { "Q181138", "Q20669090" }, n = "vegan" },
		vegetarian = { g = 9, wd = { "Q83364", "Q638022" }, n = "vegetarisch" },
		wild_game  = { g = 9, wd =   "Q223930", n = "Wild" },

		-- drinks

		alcoholic  = { g = 10, wd =      "Q154", n = "alkoholische Getränke" },
		beer       = { g = 10, wd =       "Q44", n = "Bier" },
		cocktails  = { g = 10, wd =   "Q134768", n = "Cocktails" },
		["non-alcoholic"] = { g = 10, wd =  "Q2647467", n = "alkoholfreie Getränke" },
		noalcoholic= { g = 10, wd = "Q67426650", n = "keine alkoholischen Getränke" },
		wine       = { g = 10, wd =      "Q282", n = "Wine" },

		-- services in restaurants

		beer_garden   = { g = 11, wd =   "Q857909", n = "Biergarten" },
		bowling_alley = { g = 11, wd = "Q27106471", n = "Bowlingbahn[en]" },
		delivery      = { g = 11, wd = { "Q2334804", "Q1824143" }, n = "Lieferung, Freihauslieferung" },
		drive_in      = { g = 11, wd = "Q14253958", n = "Drive-in" },
		drive_through = { g = 11, wd = "Q14253958", n = "Drive-through" }, -- including drive-thru
		outdoor_seating = { g = 11, wd = "Q98642678", n = "Sitzplätze im Freien" },
		reservation   = { g = 11, wd = { "Q2145615", "Q7673285" }, n = "Reservierung" },
		self_service  = { g = 11, wd =  "Q1369310", n = "Selbstbedienung" },
		table_service = { g = 11, wd ="Q100805023", n = "mit Bedienung" },
		takeaway      = { g = 11, wd =   "Q154383", n = "zum Mitnehmen" }, -- including "take-out", "to-go", and "carry-out"

		-- activity policies (P5023)

		-- photography
		noflash       = { g = 12, wd = "Q51728726", n = "ohne Blitz" },
		nophotos      = { g = 12, wd = "Q51728721", n = "Fotografieren verboten" },
		nosticks      = { g = 12, wd = "Q53540617", n = "Selfie-Sticks verboten" },
		notripod      = { g = 12, wd ="Q108583523", n = "ohne Stativ" },
		novideo       = { g = 12, wd = "Q66361451", n = "Videografieren verboten" },
		permit_for_commercial_photography = { g = 12, wd ="Q113756144", n = "Erlaubnis für gewerbsmäßige Fotografie erforderlich" },
		photos_allowed= { g = 12, wd = "Q51728733", n = "Fotografieren erlaubt" },

		-- general policies
		animals       = { g = 13, wd ="Q105100898", n = "Tiere erlaubt" },
		bags_prohibited = { g = 13, wd ="Q113773766", n = "große Taschen verboten" },
		cats          = { g = 13, wd ="Q105100905", n = "Katzen erlaubt" },
		companion_dogs= { g = 13, wd ="Q116343464", n = "Begleithunde erlaubt" },
		dogs          = { g = 13, wd ="Q105100922", n = "Hunde erlaubt" },
		drinking_ban  = { g = 13, wd ="Q111986775", n = "Trinkverbot" },
		eating_ban    = { g = 13, wd ="Q116343890", n = "Essensverbot" },
		face_mask_mandatory = { g = 13, wd = "Q97933005", n = "Gesichtsmaske vorgeschrieben" },
		leashed_dogs  = { g = 13, wd = "Q66361287", n = "Hunde an der Leine" },
		noanimals     = { g = 13, wd ="Q105094093", n = "Tiere verboten" },
		nocats        = { g = 13, wd ="Q105094244", n = "Katzen verboten" },
		nodogs        = { g = 13, wd ="Q105094236", n = "Hunde verboten" },
		nohighheels   = { g = 13, wd ="Q123013492", n = "Stöckelschuhe verboten" },
		nokids        = { g = 13, wd = "Q24861437", n = "keine Kinder" },
		noloudly      = { g = 13, wd ="Q111986810", n = "lautes Sprechen verboten" },
		nonsmoking    = { g = 13, wd =          "", n = "Nichtraucher" },
		nopets        = { g = 13, wd = "Q66361297", n = "Haustiere verboten" },
		notouch       = { g = 13, wd = "Q66361307", n = "Berühren verboten" },
		pets          = { g = 13, wd = "Q66361299", n = "Haustiere erlaubt" },
		smoking       = { g = 13, wd = "Q18809854", n = "Raucher" },
		smoking_ban   = { g = 13, wd =   "Q751734", n = "Rauchverbot" },
		smoking_separated= { g = 13, wd ="Q110090224", n = "Rauchen an abgetrennten Plätzen" },

		-- dress codes:
		smart_casual  = { g = 13, wd =  "Q7544032", n = "Smart casual" },

		-- difficulties (routes etc.)

		novice        = { g = 14, wd =          "", n = "Anfänger" },
		easy          = { g = 14, wd =          "", n = "einfach" },
		intermediate  = { g = 14, wd =          "", n = "mittel" },
		advanced      = { g = 14, wd =          "", n = "Fortgeschrittene" },
		expert        = { g = 14, wd =          "", n = "Erfahrener" },
		freeride      = { g = 14, wd =          "", n = "Freeride" },
		extreme       = { g = 14, wd =          "", n = "extrem" },
	},

	-- group meanings
	
	g = {
		["1"]	= "Preisklasse",
		["2"]	= "Klassifikation",
		["3"]	= "Hoteltyp",
		["4"]	= "allgemeine Ausstattung",
		["5"]	= "Hotelausstattung",
		["6"]	= "Hoteldienstleistungen",
		["7"]	= "Raumausstattung",
		["8"]	= "Speisen nach Herkunft",
		["9"]	= "Speisen nach Art",
		["10"]	= "Getränke",
		["11"]	= "Restaurantdienstleistungen",
		["12"]	= "Verhaltensanweisungen Fotografie",
		["13"]	= "Verhaltensanweisungen",
		["14"]	= "Schwierigkeitsgrade"
	},

	exclude = { -- do not translate
		Q1031873 = "aircraft catapult",
		Q573970  = "apron",
		Q104123038 = "bilingual street name sign",
		Q918324  = "control tower",
		Q192375  = "hangar",
		Q464020  = "instrument landing system",
		Q1061299 = "jet bridge",
		Q774583  = "solar panel",
		Q5191724 = "steeple",
		Q35473   = "window"
	}
}