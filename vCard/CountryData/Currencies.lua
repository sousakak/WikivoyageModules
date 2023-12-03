--[[
	Currency properties table
	Use only quotation marks for delimiters!
	iso: ISO 4217 code
	add: additional currency identifiers
	mul: multiplier if not 1
	f  : formatter
]]--

return {
	moduleInterface = {
		suite  = 'CountryData',
		sub    = 'Currencies',
		serial = '2022-06-29',
		item   = 65455847
	},

	currencies = {
		default  = "%s&#x202F;unit",

		Q1983857 = { iso = "ABA", add = "Аҧ" },
		Q200294  = { iso = "AED", add = "DH" },
		Q199471  = { iso = "AFN", add = "؋" },
		Q125999  = { iso = "ALL", add = "L, q" },
		Q130498  = { iso = "AMD", add = "֏" },
		Q522701  = { iso = "ANG", add = "NAƒ" },
		Q737779  = { iso = "ANG", add = "CMg, ƒ" },   -- proposed
		Q200337  = { iso = "AOA", add = "Kz" },
		Q199578  = { iso = "ARS", add = "$", f = "%s&#x202F;AR$" },        -- former ARP
		Q259502  = { iso = "AUD", add = "A$, c", f = "%s&#x202F;AU$" },
		Q232270  = { iso = "AWG", add = "ƒ" },
		Q483725  = { iso = "AZN", add = "m." },
		Q179620  = { iso = "BAM", add = "KM" },
		Q194351  = { iso = "BBD", add = "Bds$" },
		Q194453  = { iso = "BDT", add = "Tk" },
		Q172540  = { iso = "BGN", add = "лв" },
		Q201871  = { iso = "BHD", add = "BD" },
		Q238007  = { iso = "BIF", add = "FBu" },
		Q210478  = { iso = "BMD", add = "BD$" },
		Q206319  = { iso = "BND", add = "B$" },
		Q200737  = { iso = "BOB", add = "Bs." },
		Q173117  = { iso = "BRL", add = "R$" },
		Q194339  = { iso = "BSD", add = "B$" },
		Q201799  = { iso = "BTN", add = "Nu., Ch." },
		Q186794  = { iso = "BWP", add = "P" },
		Q160680  = { iso = "BYN", add = "Br" },
		Q275112  = { iso = "BZD", add = "BZ$" },
		Q1104069 = { iso = "CAD", add = "Can$, ¢", f = "%s&#x202F;CA$" },
		Q4734    = { iso = "CDF", add = "CF" },
		Q25344   = { iso = "CHF", add = "SFr", f = "%s&#x202F;SFr" },
		Q507737  = { iso = "CKD", add = "CK$" },
		Q200050  = { iso = "CLP", add = "CLP$" },
		Q39099   = { iso = "CNY", add = "¥, RMB¥", f = "%s&#x202F;¥" },
		Q244819  = { iso = "COP", add = "COL$" },
		Q242915  = { iso = "CRC", add = "₡" },
		Q731350  = { iso = "CUC", add = "CUC$" },
		Q201505  = { iso = "CUP", add = "$MN" },
		Q4591    = { iso = "CVE", add = "$, CV$" },
		Q131016  = { iso = "CZK", add = "Kč, h" },
		Q4594    = { iso = "DJF", add = "Fdj" },
		Q25417   = { iso = "DKK", add = "kr" },
		Q242922  = { iso = "DOP", add = "RD$" },
		Q199674  = { iso = "DZD", add = "DA" },
		Q199462  = { iso = "EGP", add = "LE, pt.", f = "LE&#x202F;%s" },
		Q2094914 = { iso = "EHP", add = "Pta, Pts" },
		Q171503  = { iso = "ERN", add = "Nfk" },
		Q206243  = { iso = "ETB", add = "Br" },
		Q4916    = { iso = "EUR", add = "€, c, ct", f = "%s&#x202F;€" },
		Q2377701 = { iso = "EUR", add = "€, c, ct", mul = 0.01, f = "%s&#x202F;€" }, -- Euro cent
		Q4592    = { iso = "FJD", add = "FJ$" },
		Q330044  = { iso = "FKP", add = "FK£" },
		Q191068  = { iso = "FOK", add = "kr" },       -- Färöer islands
		Q25224   = { iso = "GBP", add = "£, p", f = "%s&#x202F;£" },
		Q4608    = { iso = "GEL", add = "₾" },
		Q255792  = { iso = "GGP" },
		Q183530  = { iso = "GHS", add = "GH₵" },
		Q41429   = { iso = "GIP", add = "£" },
		Q202885  = { iso = "GMD", add = "D" },
		Q213311  = { iso = "GNF", add = "FG" },
		Q207396  = { iso = "GTQ", add = "Q" },
		Q213005  = { iso = "GYD", add = "G$" },
		Q31015   = { iso = "HKD", add = "HK$", f = "%s&#x202F;HK$" },
		Q4719    = { iso = "HNL", add = "L" },
		Q26360   = { iso = "HRK", add = "kn, lp" },
		Q203955  = { iso = "HTG", add = "G" },
		Q47190   = { iso = "HUF", add = "Ft", f = "%s&#x202F;Ft" },
		Q41588   = { iso = "IDR", add = "Rp" },
		Q131309  = { iso = "ILS", add = "₪" },
		Q27614   = { iso = "IMP" },
		Q80524   = { iso = "INR", add = "₹", f = "%s&#x202F;₹" },
		Q193094  = { iso = "IQD", add = "د.ع" },
		Q188608  = { iso = "IRR", add = "﷼" },
		Q131473  = { iso = "ISK", add = "kr" },
		Q270744  = { iso = "JEP" },
		Q209792  = { iso = "JMD", add = "J$" },
		Q203722  = { iso = "JOD", add = "JD" },
		Q8146    = { iso = "JPY", add = "¥", f = "%s&#x202F;¥" },
		Q202882  = { iso = "KES", add = "Ksh" },
		Q35881   = { iso = "KGS", add = "сом" },
		Q204737  = { iso = "KHR", add = "៛" },
		Q1049963 = { iso = "KID", add = "KI$" },
		Q267264  = { iso = "KMF", add = "CF" },
		Q106720  = { iso = "KPW", add = "₩" },
		Q202040  = { iso = "KRW", add = "₩" },
		Q193098  = { iso = "KWD", add = "K.D." },
		Q319885  = { iso = "KYD", add = "CI$" },
		Q173751  = { iso = "KZT", add = "₸" },
		Q200055  = { iso = "LAK", add = "₭" },
		Q201880  = { iso = "LBP", add = "LL" },
		Q4596    = { iso = "LKR", add = "SLRs" },
		Q242988  = { iso = "LRD", add = "L$" },
		Q208039  = { iso = "LSL", add = "M" },
		Q190699  = { iso = "LYD", add = "LD" },
		Q200192  = { iso = "MAD", add = "DH" },
		Q181129  = { iso = "MDL", add = "lei" },
		Q4584    = { iso = "MGA", add = "Ar" },
		Q177875  = { iso = "MKD", add = "DEN" },
		Q201875  = { iso = "MMK", add = "K" },
		Q183435  = { iso = "MNT", add = "₮" },
		Q241214  = { iso = "MOP", add = "MOP$" },
		Q207024  = { iso = "MRO", add = "UM" },
		Q212967  = { iso = "MUR", add = "₨" },
		Q206600  = { iso = "MVR", add = "Rf." },
		Q211694  = { iso = "MWK", add = "MK" },
		Q4730    = { iso = "MXN", add = "Mex$, ¢" },
		Q163712  = { iso = "MYR", add = "RM", f = "%s&#x202F;RM" },
		Q200753  = { iso = "MZN", add = "MT" },
		Q202462  = { iso = "NAD", add = "N$" },
		Q203567  = { iso = "NGN", add = "₦" },
		Q207312  = { iso = "NIO", add = "C$" },
		Q94418   = { iso = "NKD", add = "Dram" },
		Q132643  = { iso = "NOK", add = "kr" },
		Q202895  = { iso = "NPR", add = "N₨" },
		Q4165057 = { iso = "NUD", add = "NU$" },
		Q1472704 = { iso = "NZD", add = "NZ$, c", f = "%s&#x202F;NZ$" },
		Q272290  = { iso = "OMR", add = "ر.ع." },
		Q210472  = { iso = "PAB", add = "B/." },
		Q204656  = { iso = "PEN", add = "S/." },
		Q200759  = { iso = "PGK", add = "K" },
		Q17193   = { iso = "PHP", add = "₱" },
		Q188289  = { iso = "PKR", add = "₨" },
		Q123213  = { iso = "PLN", add = "zł, gr" },
		Q4165058 = { iso = "PND", add = "PN$" },
		Q200979  = { iso = "PRB", add = "RUP" },
		Q207514  = { iso = "PYG", add = "₲" },
		Q206386  = { iso = "QAR", add = "QR" },
		Q131645  = { iso = "RON", add = "lei" },
		Q172524  = { iso = "RSD", add = "din." },
		Q41044   = { iso = "RUB", add = "₽" },
		Q4741    = { iso = "RWF", add = "FRw" },
		Q199857  = { iso = "SAR", add = "SR." },
		Q4597    = { iso = "SBD", add = "SI$" },
		Q4595    = { iso = "SCR", add = "SRe" },
		Q271206  = { iso = "SDG", add = "ج.س." },
		Q122922  = { iso = "SEK", add = "kr" },
		Q190951  = { iso = "SGD", add = "S$", f = "%s&#x202F;S$" },
		Q374453  = { iso = "SHP", add = "£" },
		Q4587    = { iso = "SLL", add = "Le" },
		Q4603    = { iso = "SOS", add = "Sh.So." },
		Q737384  = { iso = "SQS" },
		Q202036  = { iso = "SRD", add = "SR$" },
		Q244366  = { iso = "SSP" },
		Q193712  = { iso = "STN", add = "₡, Db" },    -- former STD
		Q829043  = { iso = "SVC", add = "₡" },
		Q240468  = { iso = "SYP", add = "LS" },
		Q4823    = { iso = "SZL", add = "E" },
		Q177882  = { iso = "THB", add = "฿", f = "%s&#x202F;฿" },
		Q199886  = { iso = "TJS", add = "SM" },
		Q572213  = { iso = "TLD" },                   -- only coins
		Q486637  = { iso = "TMT", add = "T" },
		Q4602    = { iso = "TND", add = "DT" },
		Q4613    = { iso = "TOP", add = "T$, ¢" },
		Q172872  = { iso = "TRY", add = "₺" },
		Q242890  = { iso = "TTD", add = "TT$" },
		Q4406    = { iso = "TVD", add = "$T, TV$" },
		Q208526  = { iso = "TWD", add = "NT$" },
		Q4589    = { iso = "TZS", add = "TSh" },
		Q81893   = { iso = "UAH", add = "₴" },
		Q4598    = { iso = "UGX", add = "Ush" },
		Q4917    = { iso = "USD", add = "$, ¢", f = "%s&#x202F;$" },
		Q209272  = { iso = "UYU", add = "$U" },
		Q487888  = { iso = "UZS", add = "So'm" },
		Q56349362= { iso = "VES", add = "Bs." },      -- former VEF
		Q192090  = { iso = "VND", add = "₫", f = "%s&#x202F;₫" },
		Q207523  = { iso = "VUV", add = "VT" },
		Q4588    = { iso = "WST", add = "WS$" },
		Q847739  = { iso = "XAF", add = "FCFA" },
		Q26365   = { iso = "XCD", add = "EC$" },
		Q861690  = { iso = "XOF", add = "CFA, c" },
		Q214393  = { iso = "XPF", add = "CPF" },
		Q1148329 = { iso = "XSU", add = "Sucre" },
		Q240512  = { iso = "YER", add = "﷼" },
		Q181907  = { iso = "ZAR", add = "R, c", f = "%s&#x202F;R" },
		Q21596813= { iso = "ZMW", add = "ZK" },
		Q73408   = { iso = "ZWL", add = "Z$" }
	},

	isoToQid = {
		ABA = "Q1983857",
		AED = "Q200294",
		AFN = "Q199471",
		ALL = "Q125999",
		AMD = "Q130498",
		ANG = "Q522701",
		ANG = "Q737779",
		AOA = "Q200337",
		ARS = "Q199578",
		AUD = "Q259502",
		AWG = "Q232270",
		AZN = "Q483725",
		BAM = "Q179620",
		BBD = "Q194351",
		BDT = "Q194453",
		BGN = "Q172540",
		BHD = "Q201871",
		BIF = "Q238007",
		BMD = "Q210478",
		BND = "Q206319",
		BOB = "Q200737",
		BRL = "Q173117",
		BSD = "Q194339",
		BTN = "Q201799",
		BWP = "Q186794",
		BYN = "Q160680",
		BZD = "Q275112",
		CAD = "Q1104069",
		CDF = "Q4734",
		CHF = "Q25344",
		CKD = "Q507737",
		CLP = "Q200050",
		CNY = "Q39099",
		COP = "Q244819",
		CRC = "Q242915",
		CUC = "Q731350",
		CUP = "Q201505",
		CVE = "Q4591",
		CZK = "Q131016",
		DJF = "Q4594",
		DKK = "Q25417",
		DOP = "Q242922",
		DZD = "Q199674",
		EGP = "Q199462",
		EHP = "Q2094914",
		ERN = "Q171503",
		ETB = "Q206243",
		EUR = "Q4916",
		FJD = "Q4592",
		FKP = "Q330044",
		FOK = "Q191068",
		GBP = "Q25224",
		GEL = "Q4608",
		GGP = "Q255792",
		GHS = "Q183530",
		GIP = "Q41429",
		GMD = "Q202885",
		GNF = "Q213311",
		GTQ = "Q207396",
		GYD = "Q213005",
		HKD = "Q31015",
		HNL = "Q4719",
		HRK = "Q26360",
		HTG = "Q203955",
		HUF = "Q47190",
		IDR = "Q41588",
		ILS = "Q131309",
		IMP = "Q27614",
		INR = "Q80524",
		IQD = "Q193094",
		IRR = "Q188608",
		ISK = "Q131473",
		JEP = "Q270744",
		JMD = "Q209792",
		JOD = "Q203722",
		JPY = "Q8146",
		KES = "Q202882",
		KGS = "Q35881",
		KHR = "Q204737",
		KID = "Q1049963",
		KMF = "Q267264",
		KPW = "Q106720",
		KRW = "Q202040",
		KWD = "Q193098",
		KYD = "Q319885",
		KZT = "Q173751",
		LAK = "Q200055",
		LBP = "Q201880",
		LKR = "Q4596",
		LRD = "Q242988",
		LSL = "Q208039",
		LYD = "Q190699",
		MAD = "Q200192",
		MDL = "Q181129",
		MGA = "Q4584",
		MKD = "Q177875",
		MMK = "Q201875",
		MNT = "Q183435",
		MOP = "Q241214",
		MRO = "Q207024",
		MUR = "Q212967",
		MVR = "Q206600",
		MWK = "Q211694",
		MXN = "Q4730",
		MYR = "Q163712",
		MZN = "Q200753",
		NAD = "Q202462",
		NGN = "Q203567",
		NIO = "Q207312",
		NKD = "Q94418",
		NOK = "Q132643",
		NPR = "Q202895",
		NUD = "Q4165057",
		NZD = "Q1472704",
		OMR = "Q272290",
		PAB = "Q210472",
		PEN = "Q204656",
		PGK = "Q200759",
		PHP = "Q17193",
		PKR = "Q188289",
		PLN = "Q123213",
		PND = "Q4165058",
		PRB = "Q200979",
		PYG = "Q207514",
		QAR = "Q206386",
		RON = "Q131645",
		RSD = "Q172524",
		RUB = "Q41044",
		RWF = "Q4741",
		SAR = "Q199857",
		SBD = "Q4597",
		SCR = "Q4595",
		SDG = "Q271206",
		SEK = "Q122922",
		SGD = "Q190951",
		SHP = "Q374453",
		SLL = "Q4587",
		SOS = "Q4603",
		SQS = "Q737384",
		SRD = "Q202036",
		SSP = "Q244366",
		STN = "Q193712",
		SVC = "Q829043",
		SYP = "Q240468",
		SZL = "Q4823",
		THB = "Q177882",
		TJS = "Q199886",
		TLD = "Q572213",
		TMT = "Q486637",
		TND = "Q4602",
		TOP = "Q4613",
		TRY = "Q172872",
		TTD = "Q242890",
		TVD = "Q4406",
		TWD = "Q208526",
		TZS = "Q4589",
		UAH = "Q81893",
		UGX = "Q4598",
		USD = "Q4917",
		UYU = "Q209272",
		UZS = "Q487888",
		VES = "Q56349362",
		VND = "Q192090",
		VUV = "Q207523",
		WST = "Q4588",
		XAF = "Q847739",
		XCD = "Q26365",
		XOF = "Q861690",
		XPF = "Q214393",
		XSU = "Q1148329",
		YER = "Q240512",
		ZAR = "Q181907",
		ZMW = "Q21596813",
		ZWL = "Q73408"
	}
}