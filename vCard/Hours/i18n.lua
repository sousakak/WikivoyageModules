-- This module contains wiki-language specific strings to translate.

return {
	-- administration
	moduleInterface = {
		suite  = "Hours",
		sub    = "Hours/i18n",
		serial = "2023-01-11",
		item   = 99744685
	},

	-- invoke call parameters
	params = {
		fallback = "",
		format   = "",
		id       = "",
		show     = ""
	},

	-- invoke-call show options
	show = {
		demo  = "",
		msg   = "",
		nomsg = ""
	},

	-- Wikidata property identifiers
	wd = {
		validInPeriod     = "P1264",
		opened            = "P3025",
		closed            = "P3026",
		dayOpen           = "P3027",
		dayClosed         = "P3028",
		natureOfStatement = "P5102",
		stateOfUse        = "P5817",
		hourOpen          = "P8626",
		hourClosed        = "P8627",
		retrieved         = "P813",

		appliesToJurisdiction = "P1001",
		appliesToPart     = "P518",
		appliesToPeople   = "P6001",
		occupation        = "P106",
		of                = "P642",
		use               = "P366",

		all               = { "P3026", "P3027", "P3028", "P8626", "P8627",
		                      "P1264", "P5102", "P5817",
		                      "P366", "P518", "P642", "P1001", "P6001", "P106" },
		comments          = { "P1264", "P5102", "P5817",
		                      "P366", "P518", "P642", "P1001", "P6001", "P106" },
		commentsForClosed = { "P5102", "P5817",
		                      "P366", "P518", "P642", "P1001", "P6001", "P106" }
	},

	-- abbreviations for month names
	months = {
		[ "1月" ]   = "1月",
		[ "2月" ]   = "2月",
		[ "3月" ]   = "3月",
		[ "4月" ]   = "4月",
		[ "5月" ]   = "5月",
		[ "6月" ]   = "6月",
		[ "7月" ]   = "7月",
		[ "8月" ]   = "8月",
		[ "9月" ]   = "9月",
		[ "10月" ]  = "10月",
		[ "11月" ]  = "11月",
		[ "12月" ]  = "12月"
	},

	weekdays = {
		[ "月" ] = 1,
		[ "火" ] = 2,
		[ "水" ] = 3,
		[ "木" ] = 4,
		[ "金" ] = 5,
		[ "土" ] = 6,
		[ "日" ] = 7
	},

	-- several strings
	texts = {
		closed      = "閉店：%s",
		format      = "営業：%s",

        -- punctuation
		parentheses = "(%s)",
		space       = " ",  -- for instance between days and times
		comma       = "、", -- several dates
		semicolon   = "；", -- several statesments

		from        = "%sから",
		fromTo      = "%s-%s",
		to          = "%sまで",

		-- formatting of a single time
		timePattern = "^(%d%d?)[.:：時](%d%d?)分?%s*$", -- for German wiki
		formatTime  = "%s:%s",                      -- or "%s:%s Uhr" etc.
		formatAM    = "午前%s:%s",
		formatPM    = "午後%s:%s",

		-- formatting of a time range
		hourReplAll = true, -- (formally) replace all occurrences
		hourPattern = "",   -- empty if no replacement is requested
		hourRepl    = "",

	--	hourReplAll = false,               -- replace only first occurrence
	--	hourPattern = "(%d)%s+[aApP][mM]", -- empty if no replacement is requested
	--	hourRepl    = "%1",
	},

	options = {
		addCategories = false,
		clusterClosed = true,  -- cluster all closing dates at the end
		hour12        = false, -- 12 or 24 hours mode
		leadingZero   = false, -- add or remove zero for hours
		removeZeros   = false  -- remove zeros :00 for full hours
	},

	-- Category names
	categories = {
		fallbackLabel      = "[[Category:VCard:英語表記の営業時間]] <span class=\"listing-check-recommended\" style=\"display:none;\">英語表記の営業時間</span>",
		hoursFromWikidata  = "[[Category:VCard:ウィキデータ由来の営業時間]]",
		invalidId          = "[[Category:Hours:無効なウィキデータID]] <span class=\"error\">無効なウィキデータID</span>",
		hoursLabelFromWikidata = "[[Category:VCard:ウィキデータ由来の営業時間ラベル]] <span class=\"listing-check-recommended\" style=\"display:none;\">ウィキデータ由来の営業時間ラベル</span>",
		properties         = "[[Category:プロパティ%sを使用しているページ]]",
		unknownError       = "[[Category:VCard:誤差のある開業時間]] <span class=\"listing-check-recommended\" style=\"display:none;\">誤差のある開業時間</span>",
		unknownParams      = "[[Category:Hours:不明なパラメータ]] <span class=\"error\">不明なパラメータ：%s</span>",
		unknownShowOptions = "[[Category:Hours:不明なshowの値]] <span class=\"error\">showの値が不明です：%s</span>",
		withoutTime        = "[[Category:VCard:時間のない営業時間]] <span class=\"listing-check-recommended\" style=\"display:none;\">時間のない営業時間</span>",
	},

	-- time to id conversion
	times = {
		daily  = "Q26214163",
		Dec31  = "Q2912",
		is24_7 = "Q1571749",
		Jan1   = "Q2150"
	},

	-- several abbreviations
	abbr = {
		{ f = "月曜日", a = "月" },
		{ f = "火曜日", a = "火" },
		{ f = "水曜日", a = "水" },
		{ f = "木曜日", a = "木" },
		{ f = "金曜日", a = "金" },
		{ f = "土曜日", a = "土" },
		{ f = "日曜日", a = "日" },
		{ f = "第一", a = "第一" },
		{ f = "第二", a = "第二" },
		{ f = "第三", a = "第三" },
		{ f = "第四", a = "第四" },
		{ f = "第五", a = "第五" }
	},

	-- selections of date labels to prevent fetching from Wikidata
	dateIds = {
		-- Table contains common values only and is used for reduction of
		-- computing time. Others will be taken from Wikidata labels.

		-- days

		Q105       = "月",
		Q127       = "火",
		Q128       = "水",
		Q129       = "木",
		Q130       = "金",
		Q131       = "土",
		Q132       = "日",
		Q211391    = "週末",
		           -- use Q99528581 instead of Q211391 because it is culturally dependent
		Q26214163  = "全曜日", -- do not remove this item because it is used in Lua script
		Q100274304 = "月火",
		Q116445783 = "月火木",
		Q118773943 = "月火木金",
		Q104786164 = "月火水",
		Q104057082 = "月火水木",
		Q97120402  = "月火水木金",
		Q21282379  = "月火水木金土",
		Q100320771 = "火水木",
		Q100157387 = "火水木金",
		Q100148056 = "火水木金土",
		Q99731947  = "火水木金土日",
		Q100427721 = "水木",
		Q99714084  = "水木金",
		Q100148065 = "水木金",
		Q118773278 = "水金",
		Q31689308  = "水木金土",
		Q116328326 = "水土",
		Q65681627  = "水木金土日",
		Q100332183 = "水木金土日",
		Q99731117  = "水木金土日月",
		Q106538987 = "木金",
		Q106541052 = "木金土",
		Q100274433 = "木金土日",
		Q100427930 = "金土",
		Q100451849 = "金土日",
		Q102268431 = "土日月火水",
		Q101766385 = "土日月火水木",
		Q99528581  = "土日",
		Q106538981 = "日月",
		Q111127796 = "日月火水",
		Q100587968 = "日月火水木",
		Q112703547 = "日月火水木金",
		Q1571749   = "24時間営業", -- do not remove this item because it is used in Lua script

		Q819073	   = "平日",
		Q1445650   = "祝日",
		Q1197685   = "公休",
		Q2174956   = "休日",
		Q12779928  = "業務日",
		Q116213    = "バカンス",

		-- Zero-width spaces are used to keep the week-day terms
		Q14915111  = "イースターの52日前",
		Q15834118  = "Weiberfastnacht",
		Q2245828   = "Nelkensams​tag",
		Q1241858   = "チューリップの日曜日",
		Q2085192   = "赦罪の主日",
		Q153134    = "薔薇の月曜日",
		Q4845365   = "パンケーキ・デイ",
		Q123542    = "灰の水曜日",
		Q153308    = "バラの主日",
		Q2033651   = "受難の主日",
		Q42236     = "聖枝祭",
		Q106333    = "聖木曜日",
		Q40317     = "聖金曜日",
		Q186206    = "聖土曜日b",
		Q21196     = "復活祭",
		Q1512337   = "イースターの日曜日",
		Q209663    = "イースターの月曜日",
		Q14795170  = "イースターの翌日",
		Q14916781  = "イースターの翌々日",
		Q51638     = "昇天の祝日",
		Q39864     = "ペンテコステ",
		Q2512993   = "ウィットマンデー",
		Q14795386  = "イースターの51日後",
		Q152395    = "聖体の祝日",
		Q2304773   = "収穫祭",
		Q2913791   = "感謝祭",
		Q19809     = "クリスマス",

		Q1622041   = "ハイシーズン",
		Q99932986  = "ローシーズン",
		Q1777301   = "標準時",
		Q36669     = "サマータイム",
		Q107376657 = "1～3月",
		Q107376740 = "3～10月",
		Q121914265 = "3～11月",
		Q100157218 = "4～10月",
		Q107376636 = "4～12月",
		Q107359921 = "5～10月",
		Q121815816 = "5～9月",
		Q107376754 = "11～2月",
		Q100157227 = "11～3月",
		Q100158023 = "12月24日～1月1日",
		
		Q1312      = "春",
		Q1313      = "夏",
		Q1314      = "秋",
		Q1311      = "冬",

		Q100320775 = "第一週末",
		Q23034736  = "第一月曜日",
		Q51119351  = "第二月曜日",
		Q51119371  = "第三月曜日",
		Q51119385  = "第四月曜日",
		Q51119411  = "第五月曜日",
		Q51120546  = "最終月曜日",
		Q51119344  = "第一金曜日",
		Q51119363  = "第二金曜日",
		Q51119381  = "第三金曜日",
		Q51119398  = "第四金曜日",
		Q51119425  = "第五金曜日",
		Q51120563  = "最終金曜日",
		Q51119345  = "第一土曜日",
		Q51119367  = "第二土曜日",
		Q51119382  = "第三土曜日",
		Q51119402  = "第四土曜日",
		Q51119427  = "第五土曜日",
		Q51120565  = "最終土曜日",
		Q51119350  = "第一日曜日",
		Q51119369  = "第二日曜日",
		Q51119383  = "第三日曜日",
		Q51119404  = "第四日曜日",
		Q51119429  = "第五日曜日",
		Q51120567  = "最終日曜日",

		Q108       = "1月",
		Q2150      = "1月1日", -- do not remove this item because it is used in Lua script
		Q196627    = "1月1日",
		Q2221      = "1月6日",
		Q2289      = "1月31日",
		Q109       = "2月",
		Q2312      = "2月1日",
		Q2362      = "2月28日",
		Q2364      = "2月29日",
		Q110       = "3月",
		Q2393      = "3月1日",
		Q2457      = "3月27日",
		Q2458      = "3月28日",
		Q2461      = "3月31日",
		Q118       = "4月",
		Q2510      = "4月1日",
		Q2536      = "4月30日",
		Q119       = "5月",
		Q2544      = "5月1日",
		Q47499     = "5月1日",
		Q2591      = "5月31日",
		Q120       = "6月",
		Q2625      = "6月1日",
		Q2657      = "6月30日",
		Q121       = "7月",
		Q2700      = "7月1日",
		Q2715      = "7月31日",
		Q122       = "8月",
		Q2788      = "8月1日",
		Q2774      = "8月15日",
		Q162691    = "8月15日", -- Assumption of Mary
		Q2830      = "8月31日",
		Q123       = "9月",
		Q2859      = "9月1日",
		Q2881      = "9月31日",
		Q124       = "10月",
		Q2913      = "10月1日",
		Q2931      = "10月3日",
		Q157582    = "10月3日", -- German Unity Day
		Q2949      = "10月31日",
		Q153093    = "10月31日", -- Reformation Day
		Q125       = "11月",
		Q2997      = "11月1日",
		Q3015      = "11月30日",
		Q126       = "12月",
		Q2297      = "12月1日",
		Q2705      = "12月24日",
		Q106010    = "12月24日",
		Q2745      = "12月25日",
		Q2703710   = "12月25日", -- Christmas Day
		Q2761      = "12月26日",
		Q15113728  = "12月26日",
        Q2862      = "12月29日",
		Q2901      = "12月30日",
		Q2912      = "12月31日", -- do not remove this item because it is used in Lua script
		Q11269     = "12月31日",

		-- points of time

		Q573       = "日",
		Q575       = "夜",
		Q7722      = "朝",
		Q986787    = "午前",
		Q283102    = "午後",
		Q7725      = "夕方",
		Q193294    = "日の出",
		Q166564    = "日没",

		Q36402     = "0:00",
		Q55812411  = "0:00",
		Q55449532  = "0:30",
		Q41618001  = "1:00",
		Q55517345  = "1:00",
		Q55518450  = "1:30",
		Q41618006  = "2:00",
		Q55521280  = "2:00",
		Q55524996  = "2:30",
		Q41618076  = "3:00",
		Q55527754  = "3:00",
		Q55560170  = "3:30",
		Q41618081  = "4:00",
		Q55810628  = "4:00",
		Q55810646  = "4:15",
		Q55811293  = "4:30",
		Q55811308  = "4:45",
		Q41618165  = "5:00",
		Q55810695  = "5:00",
		Q55810711  = "5:15",
		Q55811314  = "5:30",
		Q55811331  = "5:45",
		Q41618168  = "6:00",
		Q55810762  = "6:00",
		Q55810778  = "6:15",
		Q55810795  = "6:30",
		Q55811354  = "6:45",
		Q41618172  = "7:00",
		Q55811431  = "7:00",
		Q55810845  = "7:15",
		Q55810863  = "7:30",
		Q55811437  = "7:45",
		Q41618176  = "8:00",
		Q55811455  = "8:00",
		Q55810913  = "8:15",
		Q55810929  = "8:30",
		Q55812499  = "8:45",
		Q41618181  = "9:00",
		Q55811413  = "9:00",
		Q55811478  = "9:15",
		Q55810994  = "9:30",
		Q55811012  = "9:45",
		Q41618185  = "10:00",
		Q55811483  = "10:00",
		Q55811062  = "10:30",
		Q41618189  = "11:00",
		Q55811097  = "11:00",
		Q55811133  = "11:30",
		Q168182    = "12:00",
		Q55812521  = "12:00",
		Q55811197  = "12:30",
		Q41618345  = "13:00",
		Q55811230  = "13:00",
		Q55812556  = "13:15",
		Q55811580  = "13:30",
		Q55811277  = "13:45",
		Q41620570  = "14:00",
		Q55811610  = "14:00",
		Q55811657  = "14:15",
		Q55811674  = "14:30",
		Q55811761  = "14:45",
		Q41620574  = "15:00",
		Q55811778  = "15:00",
		Q55811726  = "15:15",
		Q55811745  = "15:30",
		Q55811798  = "15:45",
		Q41620578  = "16:00",
		Q55812393  = "16:00",
		Q55812563  = "16:15",
		Q55811847  = "16:30",
		Q55811864  = "16:45",
		Q41620582  = "17:00",
		Q55811883  = "17:00",
		Q55812585  = "17:15",
		Q55813015  = "17:30",
		Q55811932  = "17:45",
		Q41620584  = "18:00",
		Q55811949  = "18:00",
		Q55813021  = "18:15",
		Q55813038  = "18:30",
		Q55812002  = "18:45",
		Q41620587  = "19:00",
		Q55812019  = "19:00",
		Q55812659  = "19:30",
		Q41620591  = "20:00",
		Q55812694  = "20:00",
		Q55812122  = "20:30",
		Q41620593  = "21:00",
		Q55812716  = "21:00",
		Q55812732  = "21:15",
		Q55812192  = "21:30",
		Q55812210  = "21:45",
		Q41620595  = "22:00",
		Q55813122  = "22:00",
		Q55812769  = "22:30",
		Q44529925  = "23:00",
		Q55812301  = "23:00",
		Q55813170  = "23:30",
		Q55812370  = "24:00",

		-- for P1264
		Q41662     = "ラマダン",

		-- for P5102
		Q29509043  = "公式",
		Q29509080  = "非公式",
		Q132555    = "法律上",
		Q712144    = "事実上",
		Q28962310  = "まれに",
		Q28962312  = "しばしば",
		Q18603603  = "仮説",
		Q30230067  = "可能性",
		Q53737447  = "原文ママ",
		Q18912752  = "諸説あり",
		Q28831311  = "未確認",
		Q24025284  = "時折変更有",
		Q4895105   = "暫定",
		Q18122778  = "推定",
		Q32188232  = "自己申告",
		Q1520777   = "確実",
		Q5727902   = "大体",
		Q56644435  = "高確度",

		-- for P5817
		-- empty strings are not displayed
		Q56651571  = "サービス終了",
		Q104664889 = "永久閉鎖",
		Q55570821  = "", -- "一般公開"
		Q55570340  = "非公開",
		Q55654238  = "", -- "使用中"
		Q811683    = "計画中",
		Q12377751  = "建設中",
		Q109551035 = "", -- "利用制限"
		Q63065035  = "", -- "廃止"
		Q11639308  = "退役",
		Q55653430  = "休止"
	}
}