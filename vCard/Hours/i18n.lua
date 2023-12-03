-- This module contains wiki-language specific strings to translate.

return {
	-- administration
	moduleInterface = {
		suite  = "Hours",
		sub    = "Hours/i18n",
		serial = "2023-11-21",
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
		Januar     = "Jan.",
		Februar    = "Feb.",
		[ "März" ] = "Mär.",
		April      = "Apr.",
		Mai        = "Mai",
		Juni       = "Jun.",
		Juli       = "Jul.",
		August     = "Aug.",
		September  = "Sep.",
		Oktober    = "Okt.",
		November   = "Nov.",
		Dezember   = "Dez."
	},

	weekdays = {
		Mo = 1,
		Di = 2,
		Mi = 3,
		Do = 4,
		Fr = 5,
		Sa = 6,
		So = 7
	},

	-- several strings
	texts = {
		closed      = "geschlossen: %s",
		format      = "Geöffnet: %s",

		comment     = "(%s)",
		joiner      = " ",  -- between days and times
		separator   = ", ", -- several dates
		delimiter   = "; ", -- several statesments

		from        = "ab %s",
		fromTo      = "%s–%s",
		to          = "bis %s",

		-- formatting of a single time
		timePattern = "^(%d%d?)[.:](%d%d?)%s*Uhr$", -- for German wiki
		formatTime  = "%s:%s",                      -- or "%s:%s Uhr" etc.
		formatAM    = "%s:%s AM",
		formatPM    = "%s:%s PM",

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
		fallbackLabel      = "[[Category:VCard: Öffnungszeit-Label in Englisch]] <span class=\"listing-check-recommended\" style=\"display:none;\">Öffnungszeit-Label in Englisch</span>",
		fromWikidata       = "[[Category:VCard: Öffnungszeit aus Wikidata]]",
		invalidId          = "[[Category:Hours: Ungültige Wikidata-Id]] <span class=\"error\">Ungültige Wikidata-Id</span>",
		labelFromWikidata  = "[[Category:VCard: Öffnungszeit-Label aus Wikidata]] <span class=\"listing-check-recommended\" style=\"display:none;\">Öffnungszeit-Label aus Wikidata</span>",
		properties         = "[[Category:Seiten, die die Wikidata-Eigenschaft %s benutzen]]",
		unknownError       = "[[Category:VCard: Öffnungszeit mit Fehler]] <span class=\"listing-check-recommended\" style=\"display:none;\">Öffnungszeit mit Fehler</span>",
		unknownParams      = "[[Category:Hours: Unbekannter Parameter]] <span class=\"error\">Parameter unbekannt: %s</span>",
		unknownShowOptions = "[[Category:Hours: Unbekannter Wert für show]] <span class=\"error\">Wert(e) für show unbekannt: %s</span>",
		withoutTime        = "[[Category:VCard: Öffnungszeit ohne Uhrzeit]] <span class=\"listing-check-recommended\" style=\"display:none;\">Öffnungszeit ohne Uhrzeit</span>",
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
		{ f = "[Mm]ontags?", a = "Mo" },
		{ f = "[Dd]ienstags?", a = "Di" },
		{ f = "[Mm]ittwochs?", a = "Mi" },
		{ f = "[Dd]onnerstags?", a = "Do" },
		{ f = "[Ff]reitags?", a = "Fr" },
		{ f = "[Ss]amstags?", a = "Sa" },
		{ f = "[Ss]onnabends?", a = "Sa" },
		{ f = "[Ss]onntags?", a = "So" },
		{ f = "[Ee]rste[rs]?", a = "1." },
		{ f = "[Zz]weite[rs]?", a = "2." },
		{ f = "[Dd]ritte[rs]?", a = "3." },
		{ f = "[Vv]ierte[rs]?", a = "4." },
		{ f = "[Ff]ünfte[rs]?", a = "5." }
	},

	-- selections of date labels to prevent fetching from Wikidata
	dateIds = {
		-- Table contains common values only and is used for reduction of
		-- computing time. Others will be taken from Wikidata labels.

		-- days

		Q105       = "Mo",
		Q127       = "Di",
		Q128       = "Mi",
		Q129       = "Do",
		Q130       = "Fr",
		Q131       = "Sa",
		Q132       = "So",
		Q211391    = "Wochenende",
		           -- use Q99528581 instead of Q211391 because it is culturally dependent
		Q26214163  = "täglich", -- do not remove this item because it is used in Lua script
		Q100274304 = "Mo–Di",
		Q116445783 = "Mo–Di, Do",
		Q118773943 = "Mo–Di, Do–Fr",
		Q104786164 = "Mo–Mi",
		Q104057082 = "Mo–Do",
		Q97120402  = "Mo–Fr",
		Q21282379  = "Mo–Sa",
		Q100320771 = "Di–Do",
		Q100157387 = "Di–Fr",
		Q100148056 = "Di–Sa",
		Q99731947  = "Di–So",
		Q100427721 = "Mi–Do",
		Q99714084  = "Mi–Fr",
		Q100148065 = "Mi–Fr",
		Q118773278 = "Mi, Fr",
		Q31689308  = "Mi–Sa",
		Q116328326 = "Mi, Sa",
		Q65681627  = "Mi–So",
		Q100332183 = "Mi–So",
		Q99731117  = "Mi–Mo",
		Q106538987 = "Do–Fr",
		Q106541052 = "Do–Sa",
		Q100274433 = "Do–So",
		Q100427930 = "Fr–Sa",
		Q100451849 = "Fr–So",
		Q102268431 = "Sa–Mi",
		Q101766385 = "Sa–Do",
		Q99528581  = "Sa–So",
		Q106538981 = "So–Mo",
		Q111127796 = "So–Mi",
		Q100587968 = "So–Do",
		Q112703547 = "So–Fr",
		Q1571749   = "24/7", -- do not remove this item because it is used in Lua script

		Q819073	   = "Werktag",
		Q1445650   = "Feiertag",
		Q1197685   = "Feiertag",
		Q2174956   = "Ruhetag",
		Q12779928  = "Arbeitstag",
		Q116213    = "Ferien",

		-- Zero-width spaces are used to keep the week-day terms
		Q14915111  = "Weiberfastnacht",
		Q15834118  = "Weiberfastnacht",
		Q2245828   = "Nelkensams​tag",
		Q1241858   = "Tulpensonn​tag",
		Q2085192   = "Tulpensonn​tag",
		Q153134    = "Rosenmon​tag",
		Q4845365   = "Fastnachtsdiens​tag",
		Q123542    = "Aschermitt​woch",
		Q153308    = "Laetare",
		Q2033651   = "Judika",
		Q42236     = "Palmsonn​tag",
		Q106333    = "Gründonners​tag",
		Q40317     = "Karfrei​tag",
		Q186206    = "Karsams​tag",
		Q21196     = "Ostern",
		Q1512337   = "Ostersonn​tag",
		Q209663    = "Ostermon​tag",
		Q14795170  = "Ostermon​tag",
		Q14916781  = "Osterdiens​tag",
		Q51638     = "Christi Himmelfahrt",
		Q39864     = "Pfingsten",
		Q2512993   = "Pfingstmon​tag",
		Q14795386  = "Pfingstdiens​tag",
		Q152395    = "Fronleichnam",
		Q2304773   = "Erntedankfest",
		Q2913791   = "Thanksgiving",
		Q19809     = "Weihnachten",

		Q1622041   = "Hochsaison",
		Q99932986  = "Nebensaison",
		Q1777301   = "Normalzeit",
		Q36669     = "Sommerzeit",
		Q107376657 = "Januar bis März",
		Q107376740 = "März bis Oktober",
		Q121914265 = "März bis November",
		Q100157218 = "April bis Oktober",
		Q107376636 = "April bis Dezember",
		Q107359921 = "Mai bis Oktober",
		Q121815816 = "Mai bis September",
		Q107376754 = "November bis Februar",
		Q100157227 = "November bis März",
		Q100158023 = "24. Dezember bis 1. Januar",
		
		Q1312      = "Frühling",
		Q1313      = "Sommer",
		Q1314      = "Herbst",
		Q1311      = "Winter",

		Q100320775 = "erstes Wochenende im Monat",
		Q23034736  = "erster Montag im Monat",
		Q51119351  = "zweiter Montag im Monat",
		Q51119371  = "dritter Montag im Monat",
		Q51119385  = "vierter Montag im Monat",
		Q51119411  = "fünfter Montag im Monat",
		Q51120546  = "letzter Montag im Monat",
		Q51119344  = "erster Freitag im Monat",
		Q51119363  = "zweiter Freitag im Monat",
		Q51119381  = "dritter Freitag im Monat",
		Q51119398  = "vierter Freitag im Monat",
		Q51119425  = "fünfter Freitag im Monat",
		Q51120563  = "letzter Freitag im Monat",
		Q51119345  = "erster Samstag im Monat",
		Q51119367  = "zweiter Samstag im Monat",
		Q51119382  = "dritter Samstag im Monat",
		Q51119402  = "vierter Samstag im Monat",
		Q51119427  = "fünfter Samstag im Monat",
		Q51120565  = "letzter Samstag im Monat",
		Q51119350  = "erster Sonntag im Monat",
		Q51119369  = "zweiter Sonntag im Monat",
		Q51119383  = "dritter Sonntag im Monat",
		Q51119404  = "vierter Sonntag im Monat",
		Q51119429  = "fünfter Sonntag im Monat",
		Q51120567  = "letzter Sonntag im Monat",

		Q108       = "Jan.",
		Q2150      = "1. Jan.", -- do not remove this item because it is used in Lua script
		Q196627    = "1. Jan.",
		Q2221      = "6. Jan.",
		Q2289      = "31. Jan.",
		Q109       = "Feb.",
		Q2312      = "1. Feb.",
		Q2362      = "28. Feb.",
		Q2364      = "29. Feb.",
		Q110       = "Mär.",
		Q2393      = "1. Mär.",
		Q2457      = "27. Mär.",
		Q2458      = "28. Mär.",
		Q2461      = "31. Mär.",
		Q118       = "Apr.",
		Q2510      = "1. Apr.",
		Q2536      = "30. Apr.",
		Q119       = "Mai",
		Q2544      = "1. Mai",
		Q47499     = "1. Mai",
		Q2591      = "31. Mai",
		Q120       = "Jun.",
		Q2625      = "1. Jun.",
		Q2657      = "30. Jun.",
		Q121       = "Jul.",
		Q2700      = "1. Jul.",
		Q2715      = "31. Jul.",
		Q122       = "Aug.",
		Q2788      = "1. Aug.",
		Q2774      = "15. Aug.",
		Q162691    = "15. Aug.", -- Assumption of Mary
		Q2830      = "31. Aug.",
		Q123       = "Sep.",
		Q2859      = "1. Sep.",
		Q2881      = "30. Sep.",
		Q124       = "Okt.",
		Q2913      = "1. Okt.",
		Q2931      = "3. Okt.",
		Q157582    = "3. Okt.", -- German Unity Day
		Q2949      = "31. Okt.",
		Q153093    = "31. Okt.", -- Reformation Day
		Q125       = "Nov.",
		Q2997      = "1. Nov.",
		Q3015      = "30. Nov.",
		Q126       = "Dez.",
		Q2297      = "1. Dez.",
		Q2705      = "24. Dez.",
		Q106010    = "24. Dez.",
		Q2745      = "25. Dez.",
		Q2703710   = "25. Dez.", -- Christmas Day
		Q2761      = "26. Dez.",
		Q15113728  = "26. Dez.",
		Q2912      = "31. Dez.", -- do not remove this item because it is used in Lua script
		Q11269     = "31. Dez.",

		-- points of time

		Q573       = "Tag",
		Q575       = "Nacht",
		Q7722      = "Morgen",
		Q986787    = "Vormittag",
		Q283102    = "Nachmittag",
		Q7725      = "Abend",
		Q193294    = "Sonnenaufgang",
		Q166564    = "Sonnenuntergang",

		Q36402     = "0:00 Uhr",
		Q55812411  = "0:00 Uhr",
		Q55449532  = "0:30 Uhr",
		Q41618001  = "1:00 Uhr",
		Q55517345  = "1:00 Uhr",
		Q55518450  = "1:30 Uhr",
		Q41618006  = "2:00 Uhr",
		Q55521280  = "2:00 Uhr",
		Q55524996  = "2:30 Uhr",
		Q41618076  = "3:00 Uhr",
		Q55527754  = "3:00 Uhr",
		Q55560170  = "3:30 Uhr",
		Q41618081  = "4:00 Uhr",
		Q55810628  = "4:00 Uhr",
		Q55810646  = "4:15 Uhr",
		Q55811293  = "4:30 Uhr",
		Q55811308  = "4:45 Uhr",
		Q41618165  = "5:00 Uhr",
		Q55810695  = "5:00 Uhr",
		Q55810711  = "5:15 Uhr",
		Q55811314  = "5:30 Uhr",
		Q55811331  = "5:45 Uhr",
		Q41618168  = "6:00 Uhr",
		Q55810762  = "6:00 Uhr",
		Q55810778  = "6:15 Uhr",
		Q55810795  = "6:30 Uhr",
		Q55811354  = "6:45 Uhr",
		Q41618172  = "7:00 Uhr",
		Q55811431  = "7:00 Uhr",
		Q55810845  = "7:15 Uhr",
		Q55810863  = "7:30 Uhr",
		Q55811437  = "7:45 Uhr",
		Q41618176  = "8:00 Uhr",
		Q55811455  = "8:00 Uhr",
		Q55810913  = "8:15 Uhr",
		Q55810929  = "8:30 Uhr",
		Q55812499  = "8:45 Uhr",
		Q41618181  = "9:00 Uhr",
		Q55811413  = "9:00 Uhr",
		Q55811478  = "9:15 Uhr",
		Q55810994  = "9:30 Uhr",
		Q55811012  = "9:45 Uhr",
		Q41618185  = "10:00 Uhr",
		Q55811483  = "10:00 Uhr",
		Q55811062  = "10:30 Uhr",
		Q41618189  = "11:00 Uhr",
		Q55811097  = "11:00 Uhr",
		Q55811133  = "11:30 Uhr",
		Q168182    = "12:00 Uhr",
		Q55812521  = "12:00 Uhr",
		Q55811197  = "12:30 Uhr",
		Q41618345  = "13:00 Uhr",
		Q55811230  = "13:00 Uhr",
		Q55812556  = "13:15 Uhr",
		Q55811580  = "13:30 Uhr",
		Q55811277  = "13:45 Uhr",
		Q41620570  = "14:00 Uhr",
		Q55811610  = "14:00 Uhr",
		Q55811657  = "14:15 Uhr",
		Q55811674  = "14:30 Uhr",
		Q55811761  = "14:45 Uhr",
		Q41620574  = "15:00 Uhr",
		Q55811778  = "15:00 Uhr",
		Q55811726  = "15:15 Uhr",
		Q55811745  = "15:30 Uhr",
		Q55811798  = "15:45 Uhr",
		Q41620578  = "16:00 Uhr",
		Q55812393  = "16:00 Uhr",
		Q55812563  = "16:15 Uhr",
		Q55811847  = "16:30 Uhr",
		Q55811864  = "16:45 Uhr",
		Q41620582  = "17:00 Uhr",
		Q55811883  = "17:00 Uhr",
		Q55812585  = "17:15 Uhr",
		Q55813015  = "17:30 Uhr",
		Q55811932  = "17:45 Uhr",
		Q41620584  = "18:00 Uhr",
		Q55811949  = "18:00 Uhr",
		Q55813021  = "18:15 Uhr",
		Q55813038  = "18:30 Uhr",
		Q55812002  = "18:45 Uhr",
		Q41620587  = "19:00 Uhr",
		Q55812019  = "19:00 Uhr",
		Q55812659  = "19:30 Uhr",
		Q41620591  = "20:00 Uhr",
		Q55812694  = "20:00 Uhr",
		Q55812122  = "20:30 Uhr",
		Q41620593  = "21:00 Uhr",
		Q55812716  = "21:00 Uhr",
		Q55812732  = "21:15 Uhr",
		Q55812192  = "21:30 Uhr",
		Q55812210  = "21:45 Uhr",
		Q41620595  = "22:00 Uhr",
		Q55813122  = "22:00 Uhr",
		Q55812769  = "22:30 Uhr",
		Q44529925  = "23:00 Uhr",
		Q55812301  = "23:00 Uhr",
		Q55813170  = "23:30 Uhr",
		Q55812370  = "24:00 Uhr",

		-- for P1264
		Q41662     = "Ramadan",

		-- for P5102
		Q29509043  = "offiziell",
		Q29509080  = "inoffiziell",
		Q132555    = "de jure",
		Q712144    = "de facto",
		Q28962310  = "kaum",
		Q28962312  = "häufig",
		Q18603603  = "möglich",
		Q30230067  = "möglich",
		Q53737447  = "ursprünglich",
		Q18912752  = "umstritten",
		Q28831311  = "unbestätigt",
		Q24025284  = "ändert sich gelegentlich",
		Q4895105   = "Interim",
		Q18122778  = "vermutlich",
		Q32188232  = "angeblich",
		Q1520777   = "gewiss",
		Q5727902   = "ungefähr",
		Q56644435  = "wahrscheinlich",

		-- for P5817
		-- empty strings are not displayed
		Q56651571  = "außer Betrieb",
		Q104664889 = "dauerhaft geschlossen",
		Q55570821  = "", -- "für die Öffentlichkeit zugänglich"
		Q55570340  = "für die Öffentlichkeit geschlossen",
		Q55654238  = "", -- "in Benutzung"
		Q811683    = "im Bau befindlich",
		Q12377751  = "im Bau befindlich",
		Q109551035 = "", -- "in eingeschränkter Benutzung"
		Q63065035  = "", -- "nicht erhalten"
		Q11639308  = "stillgelegt",
		Q55653430  = "zeitweilig geschlossen"
	}
}