-- Preventing expensive Wikidata calls

return {
	-- administration
	moduleInterface = {
		suite  = 'CountryData',
		sub    = 'Geography',
		serial = '2023-07-07',
		item   = 65433242
	},

	-- wiki-specific exceptions for articles with many vCard calls or topic articles
	-- to prevent data retrieval on the base of article's Wikidata qualifier id
	articles = {
   		_default = "Q183",    -- DE
   		Q24879   = "Q183",    -- Bremen
   		Q2814    = "Q183",    -- Halle (Saale)
   		Q452401  = "Q183",    -- Deutsche Fachwerkstraße
		Q1741    = "Q40",     -- Wien -> AT
		Q19386   = "Q25227",  -- ABC-Inseln -> AN
		Q5604    = "Q30",     -- Arizona/Frank Lloyd Wright -> US
		Q15112104= "Q79",     -- Hamada -> EG

		-- historic regions
		Q564882  = "Q36",     -- Dobriner Land -> PL
		Q661110  = "Q36",     -- Glatzer Ländchen
		Q178813  = "Q38",     -- Herculaneum -> IT
		Q283680  = "Q43",     -- Karkemisch -> TR
		Q672344  = "Q36",     -- Kulmer Land
		Q22880   = "Q183",    -- Kurpfalz
		Q1801987 = "Q36",     -- Lande Lauenburg und Bütow
		Q158445  = "Q183",    -- Mecklenburg-Schwerin
		Q819411  = "Q36",     -- Neumark -> PL
		Q767089  = "Q23681",  -- Salamis -> Nordzypern
		Q1294629 = "Q407199", -- Samaria -> PS
		Q151005  = "Q183",    -- Völkerschlacht
		Q159626  = "Q183",    -- Württemberg
	},

	-- continent list
	continents = {
		Q15   = "af",
		Q51   = "an",
		Q48   = "as",
		Q3960 = "au",
		Q46   = "eu",
		Q49   = "na",
		Q538  = "oc",
		Q18   = "sa"
	},

	-- countries list sorted by ISO 3166 code
	-- de-wiki: exceptions: at, ch, de, it: , show = "poi, inline"
	countries = {
		Q244165  = { cont = "as", iso_3166 = "", cc = "+37447", lang = "hy", currency = "Q130498", country = "Arzach" }, -- Bergkarabach
		Q228     = { cont = "eu", iso_3166 = "AD", cc = "+376", lang = "ca", currency = "Q4916", country = "Andorra" },
		Q878     = { cont = "as", iso_3166 = "AE", cc = "+971", lang = "ar", currency = "Q200294", country = "Vereinigte Arabische Emirate" },
		Q889     = { cont = "as", iso_3166 = "AF", cc =  "+93", lang = "ps", currency = "Q199471", country = "Afghanistan" },
		Q781     = { cont = "na", iso_3166 = "AG", cc = "+1-268", lang = "en", currency = "Q26365", country = "Antigua und Barbuda" },
		Q222     = { cont = "eu", iso_3166 = "AL", cc = "+355", lang = "sq", currency = "Q125999", country = "Albanien" },
		Q399     = { cont = "as", iso_3166 = "AM", cc = "+374", lang = "hy", currency = "Q130498", country = "Armenien" },
		Q916     = { cont = "af", iso_3166 = "AO", cc = "+244", lang = "pt", currency = "Q200337", country = "Angola" },
		Q1555938 = { cont = "an", iso_3166 = "AQ", cc = "", lang = "en", currency = "", country = "Antarktis" },
		Q21590062= { id = "Q1555938" },
		Q414     = { cont = "sa", iso_3166 = "AR", cc =  "+54", lang = "es", currency = "Q199578", country = "Argentinien" },
		Q40      = { cont = "eu", iso_3166 = "AT", cc =  "+43", lang = "de", currency = "Q4916", show = "poi, inline", country = "Österreich" },
		Q408     = { cont = "au", iso_3166 = "AU", cc =  "+61", lang = "en", currency = "Q259502", country = "Australien" },
		Q227     = { cont = "as", iso_3166 = "AZ", cc = "+994", lang = "az", currency = "Q483725", country = "Aserbaidschan" },
		Q225     = { cont = "eu", iso_3166 = "BA", cc = "+387", lang = "bs", currency = "Q179620", country = "Bosnien und Herzegowina" },
		Q244     = { cont = "na", iso_3166 = "BB", cc = "+1-246", lang = "en", currency = "Q194351", country = "Barbados" },
		Q902     = { cont = "as", iso_3166 = "BD", cc = "+880", lang = "bn", currency = "Q194453", country = "Bangladesch" },
		Q31      = { cont = "eu", iso_3166 = "BE", cc =  "+32", lang = "nl", currency = "Q4916", country = "Belgien" },
		Q965     = { cont = "af", iso_3166 = "BF", cc = "+226", lang = "fr", currency = "Q861690", country = "Burkina Faso" },
		Q219     = { cont = "eu", iso_3166 = "BG", cc = "+359", lang = "bg", currency = "Q172540", country = "Bulgarien" },
		Q398     = { cont = "as", iso_3166 = "BH", cc = "+973", lang = "ar", currency = "Q201871", country = "Bahrain" },
		Q967     = { cont = "af", iso_3166 = "BI", cc = "+257", lang = "fr", currency = "Q238007", country = "Burundi" },
		Q962     = { cont = "af", iso_3166 = "BJ", cc = "+229", lang = "fr", currency = "Q861690", country = "Benin" },
		Q921     = { cont = "as", iso_3166 = "BN", cc = "+673", lang = "ms", currency = "Q206319", country = "Brunei" },
		Q750     = { cont = "sa", iso_3166 = "BO", cc = "+591", lang = "es", currency = "Q200737", country = "Bolivien" },
		Q155     = { cont = "sa", iso_3166 = "BR", cc =  "+55", lang = "pt", currency = "Q173117", country = "Brasilien" },
		Q778     = { cont = "na", iso_3166 = "BS", cc = "+1-242", lang = "en", currency = "Q194339", country = "Bahamas" },
		Q917     = { cont = "as", iso_3166 = "BT", cc = "+975", lang = "dz", currency = "Q201799", country = "Bhutan" },
		Q963     = { cont = "af", iso_3166 = "BW", cc = "+267", lang = "en", currency = "Q186794", country = "Botsuana" },
		Q184     = { cont = "eu", iso_3166 = "BY", cc = "+375", lang = "be", currency = "Q160680", country = "Belarus" },
		Q242     = { cont = "na", iso_3166 = "BZ", cc = "+501", lang = "en", currency = "Q275112", country = "Belize" },
		Q16      = { cont = "na", iso_3166 = "CA", cc =   "+1", lang = "en", currency = "Q1104069", country = "Kanada" },
		Q974     = { cont = "af", iso_3166 = "CD", cc = "+243", lang = "fr", currency = "Q4734", country = "Demokratische Republik Kongo" },
		Q929     = { cont = "af", iso_3166 = "CF", cc = "+236", lang = "fr", currency = "Q847739", country = "Zentralafrikanische Republik" },
		Q971     = { cont = "af", iso_3166 = "CG", cc = "+242", lang = "fr", currency = "Q847739", country = "Republik Kongo" },
		Q39      = { cont = "eu", iso_3166 = "CH", cc =  "+41", lang = "de", currency = "Q25344", show = "poi, inline", country = "Schweiz" },
		Q1008    = { cont = "af", iso_3166 = "CI", cc = "+225", lang = "fr", currency = "Q861690", country = "Elfenbeinküste" },
		Q26988   = { cont = "oc", iso_3166 = "CK", cc = "+682", lang = "en", currency = "Q1472704", country = "Cookinseln" },
		Q298     = { cont = "sa", iso_3166 = "CL", cc =  "+56", lang = "es", currency = "Q200050", country = "Chile" },
		Q1009    = { cont = "af", iso_3166 = "CM", cc = "+237", lang = "fr", currency = "Q847739", country = "Kamerun" },
		Q148     = { cont = "as", iso_3166 = "CN", cc =  "+86", lang = "zh", currency = "Q39099", country = "China" },
		Q739     = { cont = "sa", iso_3166 = "CO", cc =  "+57", lang = "es", currency = "Q244819", country = "Kolumbien" },
		Q800     = { cont = "na", iso_3166 = "CR", cc = "+506", lang = "es", currency = "Q242915", country = "Costa Rica" },
		Q241     = { cont = "na", iso_3166 = "CU", cc =  "+53", lang = "es", currency = "Q201505", country = "Kuba" },
		Q1011    = { cont = "af", iso_3166 = "CV", cc = "+238", lang = "pt", currency = "Q4591", country = "Kap Verde" },
		Q229     = { cont = "eu", iso_3166 = "CY", cc = "+357", lang = "el", currency = "Q4916", country = "Zypern" },
		Q213     = { cont = "eu", iso_3166 = "CZ", cc = "+420", lang = "cs", currency = "Q131016", country = "Tschechien" },
		Q183     = { cont = "eu", iso_3166 = "DE", cc =  "+49", lang = "de", currency = "Q4916", show = "poi, inline", country = "Deutschland" },
		Q977     = { cont = "af", iso_3166 = "DJ", cc = "+253", lang = "fr", currency = "Q4594", country = "Dschibuti" },
		Q35      = { cont = "eu", iso_3166 = "DK", cc =  "+45", lang = "da", currency = "Q25417", country = "Dänemark" },
		Q756617  = { id = "Q35" },
		Q784     = { cont = "na", iso_3166 = "DM", cc = "+1-767", lang = "en", currency = "Q26365", country = "Dominica" },
		Q786     = { cont = "na", iso_3166 = "DO", cc = "+1-809", lang = "es", currency = "Q242922", country = "Dominikanische Republik" },
		Q262     = { cont = "af", iso_3166 = "DZ", cc = "+213", lang = "fr", currency = "Q199674", country = "Algerien" },
		Q736     = { cont = "sa", iso_3166 = "EC", cc = "+593", lang = "es", currency = "Q4917", country = "Ecuador" },
		Q191     = { cont = "eu", iso_3166 = "EE", cc = "+372", lang = "et", currency = "Q4916", country = "Estland" },
		Q79      = { cont = "af", iso_3166 = "EG", cc =  "+20", lang = "ar", currency = "Q199462", phoneDigits = 4, show = "all", country = "Ägypten" },
		Q6250    = { cont = "af", iso_3166 = "EH", cc = "+212", lang = "ar", currency = "Q200192", country = "Westsahara" },
		Q40362   = { id = "Q6250" },
		Q986     = { cont = "af", iso_3166 = "ER", cc = "+291", lang = "ti", currency = "Q171503", country = "Eritrea" },
		Q29      = { cont = "eu", iso_3166 = "ES", cc =  "+34", lang = "es", currency = "Q4916", country = "Spanien" },
		Q115     = { cont = "af", iso_3166 = "ET", cc = "+251", lang = "am", currency = "Q206243", show = "all", country = "Äthiopien" },
		Q33      = { cont = "eu", iso_3166 = "FI", cc = "+358", lang = "fi", currency = "Q4916", country = "Finnland" },
		Q712     = { cont = "oc", iso_3166 = "FJ", cc = "+679", lang = "fj", currency = "Q4592", country = "Fidschi" },
		Q702     = { cont = "oc", iso_3166 = "FM", cc = "+691", lang = "en", currency = "Q4917", country = "Mikronesien" },
		Q4628    = { cont = "eu", iso_3166 = "FO", cc = "+298", lang = "da", currency = "Q191068", country = "Färöer" },
		Q142     = { cont = "eu", iso_3166 = "FR", cc =  "+33", lang = "fr", currency = "Q4916", country = "Frankreich" },
		Q1000    = { cont = "af", iso_3166 = "GA", cc = "+241", lang = "fr", currency = "Q847739", country = "Gabun" },
		Q145     = { cont = "eu", iso_3166 = "GB", cc =  "+44", lang = "en-gb", currency = "Q25224", country = "Vereinigtes Königreich" },
		Q769     = { cont = "na", iso_3166 = "GD", cc = "+1-473", lang = "en", currency = "Q26365", country = "Grenada" },
		Q230     = { cont = "as", iso_3166 = "GE", cc = "+995", lang = "ka", currency = "Q4608", country = "Georgien" },
		Q117     = { cont = "af", iso_3166 = "GH", cc = "+233", lang = "en", currency = "Q183530", country = "Ghana" },
		Q1005    = { cont = "af", iso_3166 = "GM", cc = "+220", lang = "en", currency = "Q202885", country = "Gambia" },
		Q1006    = { cont = "af", iso_3166 = "GN", cc = "+224", lang = "fr", currency = "Q213311", country = "Guinea" },
		Q983     = { cont = "af", iso_3166 = "GQ", cc = "+240", lang = "es", currency = "Q847739", country = "Äquatorialguinea" },
		Q41      = { cont = "eu", iso_3166 = "GR", cc =  "+30", lang = "el", currency = "Q4916", country = "Griechenland" },
		Q774     = { cont = "na", iso_3166 = "GT", cc = "+502", lang = "es", currency = "Q207396", country = "Guatemala" },
		Q1007    = { cont = "af", iso_3166 = "GW", cc = "+245", lang = "pt", currency = "Q861690", country = "Guinea-Bissau" },
		Q734     = { cont = "sa", iso_3166 = "GY", cc = "+592", lang = "en", currency = "Q213005", country = "Guyana" },
		Q783     = { cont = "na", iso_3166 = "HN", cc = "+504", lang = "es", currency = "Q4719", country = "Honduras" },
		Q224     = { cont = "eu", iso_3166 = "HR", cc = "+385", lang = "hr", currency = "Q4916", country = "Kroatien" },
		Q790     = { cont = "na", iso_3166 = "HT", cc = "+509", lang = "fr", currency = "Q203955", country = "Haiti" },
		Q28      = { cont = "eu", iso_3166 = "HU", cc =  "+36", lang = "hu", currency = "Q47190", country = "Ungarn" },
		Q252     = { cont = "as", iso_3166 = "ID", cc =  "+62", lang = "id", currency = "Q41588", country = "Indonesien" },
		Q27      = { cont = "eu", iso_3166 = "IE", cc = "+353", lang = "ga", currency = "Q4916", country = "Irland" },
		Q801     = { cont = "as", iso_3166 = "IL", cc = "+972", lang = "he", currency = "Q131309", country = "Israel" },
		Q575187  = { id = "Q801" },
		Q668     = { cont = "as", iso_3166 = "IN", cc =  "+91", lang = "hi", currency = "Q80524", country = "Indien" },
		Q796     = { cont = "as", iso_3166 = "IQ", cc = "+964", lang = "ar", currency = "Q193094", country = "Irak" },
		Q794     = { cont = "as", iso_3166 = "IR", cc =  "+98", lang = "fa", currency = "Q188608", country = "Iran" },
		Q189     = { cont = "eu", iso_3166 = "IS", cc = "+354", lang = "is", currency = "Q131473", country = "Island" },
		Q38      = { cont = "eu", iso_3166 = "IT", cc =  "+39", lang = "it", currency = "Q4916", show = "poi, inline", country = "Italien" },
		Q766     = { cont = "na", iso_3166 = "JM", cc = "+1-876", lang = "en", currency = "Q209792", country = "Jamaika" },
		Q810     = { cont = "as", iso_3166 = "JO", cc = "+962", lang = "ar", currency = "Q203722", country = "Jordanien" },
		Q17      = { cont = "as", iso_3166 = "JP", cc =  "+81", lang = "ja", currency = "Q8146", country = "Japan" },
		Q114     = { cont = "af", iso_3166 = "KE", cc = "+254", lang = "sw", currency = "Q202882", country = "Kenia" },
		Q813     = { cont = "as", iso_3166 = "KG", cc = "+996", lang = "ky", currency = "Q35881", country = "Kirgisistan" },
		Q424     = { cont = "as", iso_3166 = "KH", cc = "+855", lang = "km", currency = "Q204737", country = "Kambodscha" },
		Q710     = { cont = "oc", iso_3166 = "KI", cc = "+686", lang = "en", currency = "Q1049963", country = "Kiribati" },
		Q970     = { cont = "af", iso_3166 = "KM", cc = "+269", lang = "ar", currency = "Q267264", country = "Komoren" },
		Q763     = { cont = "na", iso_3166 = "KN", cc = "+1-869", lang = "en", currency = "Q26365", country = "Saint Kitts und Nevis" },
		Q423     = { cont = "as", iso_3166 = "KP", cc = "+850", lang = "ko", currency = "Q106720", country = "Nordkorea" },
		Q884     = { cont = "as", iso_3166 = "KR", cc =  "+82", lang = "ko", currency = "Q202040", country = "Südkorea" },
		Q817     = { cont = "as", iso_3166 = "KW", cc = "+965", lang = "ar", currency = "Q193098", country = "Kuwait" },
		Q232     = { cont = "as", iso_3166 = "KZ", cc =   "+7", lang = "kk", currency = "Q173751", country = "Kasachstan" },
		Q819     = { cont = "as", iso_3166 = "LA", cc = "+856", lang = "lo", currency = "Q200055", country = "Laos" },
		Q822     = { cont = "as", iso_3166 = "LB", cc = "+961", lang = "ar", currency = "Q201880", country = "Libanon" },
		Q760     = { cont = "na", iso_3166 = "LC", cc = "+1-758", lang = "en", currency = "Q26365", country = "Saint Lucia" },
		Q347     = { cont = "eu", iso_3166 = "LI", cc = "+423", lang = "de", currency = "Q25344", country = "Liechtenstein" },
		Q854     = { cont = "as", iso_3166 = "LK", cc =  "+94", lang = "si", currency = "Q4596", country = "Sri Lanka" },
		Q1014    = { cont = "af", iso_3166 = "LR", cc = "+231", lang = "en", currency = "Q242988", country = "Liberia" },
		Q1013    = { cont = "af", iso_3166 = "LS", cc = "+266", lang = "en", currency = "Q208039", country = "Lesotho" },
		Q37      = { cont = "eu", iso_3166 = "LT", cc = "+370", lang = "lt", currency = "Q4916", country = "Litauen" },
		Q32      = { cont = "eu", iso_3166 = "LU", cc = "+352", lang = "lb", currency = "Q4916", country = "Luxemburg" },
		Q211     = { cont = "eu", iso_3166 = "LV", cc = "+371", lang = "lv", currency = "Q4916", country = "Lettland" },
		Q1016    = { cont = "af", iso_3166 = "LY", cc = "+218", lang = "ar", currency = "Q190699", country = "Libyen" },
		Q1028    = { cont = "af", iso_3166 = "MA", cc = "+212", lang = "ar", currency = "Q200192", country = "Marokko" },
		Q235     = { cont = "eu", iso_3166 = "MC", cc = "+377", lang = "fr", currency = "Q4916", country = "Monaco" },
		Q217     = { cont = "eu", iso_3166 = "MD", cc = "+373", lang = "mo", currency = "Q181129", country = "Moldau" },
		Q236     = { cont = "eu", iso_3166 = "ME", cc = "+382", lang = "sr-me", currency = "Q4916", country = "Montenegro" },
		Q1019    = { cont = "af", iso_3166 = "MG", cc = "+261", lang = "mg", currency = "Q4584", country = "Madagaskar" },
		Q709     = { cont = "oc", iso_3166 = "MH", cc = "+692", lang = "en", currency = "Q4917", country = "Marshallinseln" },
		Q221     = { cont = "eu", iso_3166 = "MK", cc = "+389", lang = "mk", currency = "Q177875", country = "Nordmazedonien" },
		Q912     = { cont = "af", iso_3166 = "ML", cc = "+223", lang = "fr", currency = "Q861690", country = "Mali" },
		Q836     = { cont = "as", iso_3166 = "MM", cc =  "+95", lang = "my", currency = "Q201875", country = "Myanmar" },
		Q711     = { cont = "as", iso_3166 = "MN", cc = "+976", lang = "mn", currency = "Q183435", country = "Mongolei" },
		Q16644   = { cont = "oc", iso_3166 = "MP", cc ="+1-670", lang = "en", currency = "Q4917", country = "Nördliche Marianen" },
		Q1025    = { cont = "af", iso_3166 = "MR", cc = "+222", lang = "ar", currency = "Q207024", country = "Mauretanien" },
		Q233     = { cont = "eu", iso_3166 = "MT", cc = "+356", lang = "mt", currency = "Q4916", country = "Malta" },
		Q1027    = { cont = "af", iso_3166 = "MU", cc = "+230", lang = "en", currency = "Q212967", country = "Mauritius" },
		Q826     = { cont = "as", iso_3166 = "MV", cc = "+960", lang = "dv", currency = "Q206600", country = "Malediven" },
		Q1020    = { cont = "af", iso_3166 = "MW", cc = "+265", lang = "en", currency = "Q211694", country = "Malawi" },
		Q96      = { cont = "na", iso_3166 = "MX", cc =  "+52", lang = "es", currency = "Q4730", country = "Mexiko" },
		Q833     = { cont = "as", iso_3166 = "MY", cc =  "+60", lang = "ms", currency = "Q163712", country = "Malaysia" },
		Q1029    = { cont = "af", iso_3166 = "MZ", cc = "+222", lang = "pt", currency = "Q200753", country = "Mosambik" },
		Q1030    = { cont = "af", iso_3166 = "NA", cc = "+264", lang = "en", currency = "Q202462", country = "Namibia" },
		Q1032    = { cont = "af", iso_3166 = "NE", cc = "+227", lang = "fr", currency = "Q861690", country = "Niger" },
		Q1033    = { cont = "af", iso_3166 = "NG", cc = "+234", lang = "en", currency = "Q203567", country = "Nigeria" },
		Q811     = { cont = "na", iso_3166 = "NI", cc = "+505", lang = "es", currency = "Q207312", country = "Nicaragua" },
		Q55      = { cont = "eu", iso_3166 = "NL", cc =  "+31", lang = "nl", currency = "Q4916", country = "Niederlande" },
		Q20      = { cont = "eu", iso_3166 = "NO", cc =  "+47", lang = "no", currency = "Q132643", country = "Norwegen" },
		Q837     = { cont = "as", iso_3166 = "NP", cc = "+977", lang = "ne", currency = "Q202895", country = "Nepal" },
		Q697     = { cont = "oc", iso_3166 = "NR", cc = "+674", lang = "na", currency = "Q259502", country = "Nauru" },
		Q34020   = { cont = "oc", iso_3166 = "NU", cc = "+683", lang ="niu", currency = "Q1472704", country = "Niue" },
		Q664     = { cont = "oc", iso_3166 = "NZ", cc =  "+64", lang = "en", currency = "Q1472704", country = "Neuseeland" },
		Q23681   = { cont = "eu", iso_3166 = "", cc = "+90-392", lang = "tr", currency = "Q172872", country = "Nordzypern" },
		Q842     = { cont = "as", iso_3166 = "OM", cc = "+968", lang = "ar", currency = "Q272290", country = "Oman" },
		Q804     = { cont = "na", iso_3166 = "PA", cc = "+507", lang = "es", currency = "Q210472", country = "Panama" },
		Q419     = { cont = "sa", iso_3166 = "PE", cc =  "+51", lang = "es", currency = "Q204656", country = "Peru" },
		Q691     = { cont = "oc", iso_3166 = "PG", cc = "+675", lang = "ho", currency = "Q200759", country = "Papua-Neuguinea" },
		Q928     = { cont = "as", iso_3166 = "PH", cc =  "+63", lang = "fil", currency = "Q17193", country = "Philippinen" },
		Q843     = { cont = "as", iso_3166 = "PK", cc =  "+92", lang = "ur", currency = "Q188289", country = "Pakistan" },
		Q36      = { cont = "eu", iso_3166 = "PL", cc =  "+48", lang = "pl", currency = "Q123213", country = "Polen" },
		Q407199  = { cont = "as", iso_3166 = "PS", cc = "+970", lang = "ar", currency = "Q203722", country = "Palästina" },
		Q23792   = { id = "Q407199" },
		Q42620   = { id = "Q407199" },
		Q219060  = { id = "Q407199" },
		Q45      = { cont = "eu", iso_3166 = "PT", cc = "+351", lang = "pt", currency = "Q4916", country = "Portugal" },
		Q695     = { cont = "oc", iso_3166 = "PW", cc = "+680", lang = "en", currency = "Q4917", country = "Palau" },
		Q733     = { cont = "sa", iso_3166 = "PY", cc = "+595", lang = "es", currency = "Q207514", country = "Paraguay" },
		Q846     = { cont = "as", iso_3166 = "QA", cc = "+974", lang = "ar", currency = "Q206386", country = "Katar" },
		Q218     = { cont = "eu", iso_3166 = "RO", cc =  "+40", lang = "ro", currency = "Q131645", country = "Rumänien" },
		Q403     = { cont = "eu", iso_3166 = "RS", cc = "+381", lang = "sr", currency = "Q172524", country = "Serbien" },
		Q159     = { cont = "eu", iso_3166 = "RU", cc =   "+7", lang = "ru", currency = "Q41044", country = "Russland" },
		Q1037    = { cont = "af", iso_3166 = "RW", cc = "+250", lang = "rw", currency = "Q4741", country = "Ruanda" },
		Q851     = { cont = "as", iso_3166 = "SA", cc = "+966", lang = "ar", currency = "Q199857", country = "Saudi-Arabien" },
		Q685     = { cont = "oc", iso_3166 = "SB", cc = "+677", lang = "en", currency = "Q4597", country = "Salomonen" },
		Q1042    = { cont = "af", iso_3166 = "SC", cc = "+248", lang = "en", currency = "Q4595", country = "Seychellen" },
		Q1049    = { cont = "af", iso_3166 = "SD", cc = "+249", lang = "ar", currency = "Q271206", show = "all", country = "Sudan" },
		Q34      = { cont = "eu", iso_3166 = "SE", cc =  "+46", lang = "sv", currency = "Q122922", country = "Schweden" },
		Q334     = { cont = "as", iso_3166 = "SG", cc =  "+65", lang = "en", currency = "Q190951", country = "Singapur" },
		Q215     = { cont = "eu", iso_3166 = "SI", cc = "+386", lang = "sl", currency = "Q4916", country = "Slowenien" },
		Q214     = { cont = "eu", iso_3166 = "SK", cc = "+421", lang = "sk", currency = "Q4916", country = "Slowakei" },
		Q1044    = { cont = "af", iso_3166 = "SL", cc = "+232", lang = "en", currency = "Q122922", country = "Sierra Leone" },
		Q238     = { cont = "eu", iso_3166 = "SM", cc = "+378", lang = "it", currency = "Q4916", country = "San Marino" },
		Q1041    = { cont = "af", iso_3166 = "SN", cc = "+221", lang = "fr", currency = "Q861690", country = "Senegal" },
		Q1045    = { cont = "af", iso_3166 = "SO", cc = "+252", lang = "so", currency = "Q4603", country = "Somalia" },
		Q730     = { cont = "sa", iso_3166 = "SR", cc = "+597", lang = "nl", currency = "Q202036", country = "Suriname" },
		Q958     = { cont = "af", iso_3166 = "SS", cc = "+211", lang = "en", currency = "Q244366", country = "Südsudan" },
		Q1039    = { cont = "af", iso_3166 = "ST", cc = "+239", lang = "pt", currency = "Q193712", country = "São Tomé und Príncipe" },
		Q792     = { cont = "na", iso_3166 = "SV", cc = "+503", lang = "es", currency = "Q4917", country = "El Salvador" },
		Q858     = { cont = "as", iso_3166 = "SY", cc = "+963", lang = "ar", currency = "Q240468", country = "Syrien" },
		Q1050    = { cont = "af", iso_3166 = "SZ", cc = "+268", lang = "en", currency = "Q4823", country = "Eswatini" },
		Q657     = { cont = "af", iso_3166 = "TD", cc = "+235", lang = "ar", currency = "Q847739", country = "Tschad" },
		Q945     = { cont = "af", iso_3166 = "TG", cc = "+228", lang = "fr", currency = "Q861690", country = "Togo" },
		Q869     = { cont = "as", iso_3166 = "TH", cc =  "+66", lang = "th", currency = "Q177882", country = "Thailand" },
		Q863     = { cont = "as", iso_3166 = "TJ", cc = "+992", lang = "tg", currency = "Q199886", country = "Tadschikistan" },
		Q574     = { cont = "as", iso_3166 = "TL", cc = "+670", lang = "pt", currency = "Q4917", country = "Osttimor" },
		Q874     = { cont = "as", iso_3166 = "TM", cc = "+993", lang = "tk", currency = "Q486637", country = "Turkmenistan" },
		Q948     = { cont = "af", iso_3166 = "TN", cc = "+216", lang = "ar", currency = "Q4602", country = "Tunesien" },
		Q678     = { cont = "oc", iso_3166 = "TO", cc = "+676", lang = "to", currency = "Q4613", country = "Tonga" },
		Q43      = { cont = "eu", iso_3166 = "TR", cc =  "+90", lang = "tr", currency = "Q172872", country = "Türkei" },
		Q754     = { cont = "na", iso_3166 = "TT", cc = "+1-868", lang = "en", currency = "Q242890", country = "Trinidad und Tobago" },
		Q672     = { cont = "oc", iso_3166 = "TV", cc = "+688", lang = "tvl", currency = "Q4406", country = "Tuvalu" },
		Q865     = { cont = "as", iso_3166 = "TW", cc = "+886", lang = "zh", currency = "Q208526", country = "Taiwan" },
		Q924     = { cont = "af", iso_3166 = "TZ", cc = "+255", lang = "sw", currency = "Q4589", country = "Tansania" },
		Q907112  = { cont = "eu", iso_3166 =   "", cc = "+373", lang = "ru", currency = "Q200979", country = "Transnistrien" }, -- auch Pridnestrowien
		Q212     = { cont = "eu", iso_3166 = "UA", cc = "+380", lang = "uk", currency = "Q81893", country = "Ukraine" },
		Q1036    = { cont = "af", iso_3166 = "UG", cc = "+256", lang = "sw", currency = "Q4598", country = "Uganda" },
		Q30      = { cont = "na", iso_3166 = "US", cc =   "+1", lang = "en-us", currency = "Q4917", phoneDigits = 4, country = "Vereinigte Staaten" },
		Q77      = { cont = "sa", iso_3166 = "UY", cc = "+598", lang = "es", currency = "Q209272", country = "Uruguay" },
		Q265     = { cont = "as", iso_3166 = "UZ", cc = "+998", lang = "uz", currency = "Q487888", country = "Usbekistan" },
		Q237     = { cont = "eu", iso_3166 = "VA", cc =  "+39", lang = "it", currency = "Q4916", country = "Vatikanstadt" },
		Q757     = { cont = "na", iso_3166 = "VC", cc = "+1-784", lang = "en", currency = "Q26365", country = "Saint Vincent und die Grenadinen" },
		Q717     = { cont = "sa", iso_3166 = "VE", cc =  "+58", lang = "es", currency = "Q56349362", country = "Venezuela" },
		Q881     = { cont = "as", iso_3166 = "VN", cc =  "+84", lang = "vi", currency = "Q192090", country = "Vietnam" },
		Q686     = { cont = "oc", iso_3166 = "VU", cc = "+678", lang = "en", currency = "Q207523", country = "Vanuatu" },
		Q683     = { cont = "oc", iso_3166 = "WS", cc = "+685", lang = "sm", currency = "Q4588", country = "Samoa" },
		Q1246    = { cont = "eu", iso_3166 = "XK", cc = "+383", lang = "sq", currency = "Q4916", country = "Kosovo" },
		Q805     = { cont = "as", iso_3166 = "YE", cc = "+967", lang = "ar", currency = "Q240512", country = "Jemen" },
		Q258     = { cont = "af", iso_3166 = "ZA", cc =  "+27", lang = "en", currency = "Q181907", country = "Südafrika" },
		Q953     = { cont = "af", iso_3166 = "ZM", cc = "+260", lang = "en", currency = "Q21596813", country = "Sambia" },
		Q954     = { cont = "af", iso_3166 = "ZW", cc = "+263", lang = "en", currency = "Q4917", country = "Simbabwe" }
	},

	-- list of administrative entities usually outside of their home countries.
	-- These entities are favored over its home countries.
	adminEntities = {
		-- extraterritorial areas
		Q25228   = { cont = "na", iso_3166 =    "AI", cc = "+1-264", lang = "en", currency = "Q26365", country = "Anguilla" },
		Q25227   = { cont = "na", iso_3166 =    "AN", cc =   "+599", lang = "nl", currency = "Q4917", country = "Niederländische Antillen" },
		Q16641   = { cont = "oc", iso_3166 =    "AS", cc = "+1-684", lang = "en", currency = "Q4917", country = "Amerikanisch-Samoa" },
		Q21203   = { cont = "na", iso_3166 =    "AW", cc =   "+297", lang = "nl", currency = "Q232270", country = "Aruba" },
		Q5689    = { cont = "eu", iso_3166 =    "AX", cc ="+358-18", lang = "sv", currency = "Q4916", country = "Åland" },
		Q25362   = { cont = "na", iso_3166 =    "BL", cc =   "+590", lang = "fr", currency = "Q4916", country = "Saint-Barthélemy" },
		Q23635   = { cont = "na", iso_3166 =    "BM", cc = "+1-441", lang = "en", currency = "Q210478", country = "Bermuda" },
		Q26180   = { cont = "na", iso_3166 = "BQ-SE", cc =   "+599", lang = "nl", currency = "Q4917", country = "Niederländische Antillen" }, -- Sint Eustatius, +599-3
		Q25528   = { cont = "na", iso_3166 = "BQ-SA", cc =   "+599", lang = "nl", currency = "Q4917", country = "Niederländische Antillen" }, -- Saba, +599-4
		Q25396   = { cont = "na", iso_3166 = "BQ-BO", cc =   "+599", lang = "nl", currency = "Q4917", country = "Niederländische Antillen" }, -- Bonaire, +599-7
		Q23408   = { cont = "an", iso_3166 =    "BV", cc =       "", lang =   "", currency = "", country = "Bouvetinsel" },
		Q36004   = { cont = "oc", iso_3166 =    "CC", cc = "+61891", lang = "en", currency = "Q259502", country = "Kokosinseln" },
		Q25279   = { cont = "na", iso_3166 =    "CW", cc = "+599-9", lang = "nl", currency = "Q522701", country = "Curaçao" },
		Q31063   = { cont = "oc", iso_3166 =    "CX", cc =    "+61", lang = "en", currency = "Q259502", country = "Weihnachtsinsel" },
		Q9648    = { cont = "sa", iso_3166 =    "FK", cc =   "+500", lang = "en", currency = "Q330044", country = "Falklandinseln" },
		Q3769    = { cont = "sa", iso_3166 =    "GF", cc =   "+594", lang = "fr", currency = "Q4916", country = "Französisch-Guayana" },
		Q25230   = { cont = "eu", iso_3166 =    "GG", cc =    "+44", lang = "en-gb", currency = "Q25224", country = "Guernsey" },
		Q1410    = { cont = "eu", iso_3166 =    "GI", cc =   "+350", lang = "en", currency = "Q41429", country = "Gibraltar" },
		Q223     = { cont = "na", iso_3166 =    "GL", cc =   "+299", lang = "kl", currency = "Q25417", country = "Grönland" },
		Q695387  = { id = "Q223" }, -- Kommuneqarfik Sermersooq
		Q478813  = { id = "Q223" }, -- Kommune Kujalleq
		Q17012   = { cont = "na", iso_3166 =    "GP", cc =   "+590", lang = "fr", currency = "Q4916", country = "Guadeloupe" },
		Q35086   = { cont = "an", iso_3166 =    "GS", cc =   "+500", lang = "en", currency = "Q25224", country = "Südgeorgien und die Südlichen Sandwichinseln" },
		Q16635   = { cont = "oc", iso_3166 =    "GU", cc = "+1-671", lang = "en", currency = "Q4917", country = "Guam" },
		Q8646    = { cont = "as", iso_3166 =    "HK", cc =   "+852", lang = "zh", currency = "Q31015", country = "Hongkong" },
		Q131198  = { cont = "oc", iso_3166 =    "HM", cc =       "", lang = "en", currency = "", country = "Heard und McDonaldinseln" },
		Q9676    = { cont = "eu", iso_3166 =    "IM", cc =    "+44", lang = "en-gb", currency = "Q25224", country = "Isle of Man" },
		Q43448   = { cont = "af", iso_3166 =    "IO", cc =   "+246", lang = "en", currency = "Q25224", country = "Britisches Territorium im Indischen Ozean" },
		Q785     = { cont = "eu", iso_3166 =    "JE", cc =    "+44", lang = "en-gb", currency = "Q25224", country = "Jersey" },
		Q5785    = { cont = "na", iso_3166 =    "KY", cc = "+1-345", lang = "en", currency = "Q319885", country = "Kaymaninseln" },
		Q737765  = { id = "Q5785" }, -- Grand Cayman
		Q126125  = { cont = "na", iso_3166 =    "MF", cc =   "+590", lang = "fr", currency = "Q4916", country = "Saint-Martin" }, -- French overseas collectivity
		Q14773   = { cont = "as", iso_3166 =    "MO", cc =   "+853", lang = "zh", currency = "Q241214", country = "Macau" },
		Q17054   = { cont = "na", iso_3166 =    "MQ", cc =   "+596", lang = "fr", currency = "Q4916", country = "Martinique" },
		Q13353   = { cont = "na", iso_3166 =    "MS", cc = "+1-664", lang = "en", currency = "Q26365", country = "Montserrat" },
		Q33788   = { cont = "oc", iso_3166 =    "NC", cc =   "+687", lang = "fr", currency = "Q214393", country = "Neukaledonien" },
		Q31057   = { cont = "oc", iso_3166 =    "NF", cc =  "+6723", lang = "en", currency = "Q259502", country = "Norfolkinsel" },
		Q30971   = { cont = "oc", iso_3166 =    "PF", cc =   "+689", lang = "fr", currency = "Q214393", country = "Französisch-Polynesien" },
		Q34617   = { cont = "na", iso_3166 =    "PM", cc =   "+508", lang = "fr", currency = "Q4916", country = "Saint Pierre und Miquelon" },
		Q35672   = { cont = "oc", iso_3166 =    "PN", cc = "  +649", lang = "en", currency = "Q1472704", country = "Pitcairninseln" },
		Q1183    = { cont = "na", iso_3166 =    "PR", cc = "+1-787", lang = "es", currency = "Q4917", country = "Puerto Rico" },
		Q485112  = { cont = "af", iso_3166 =    "SO", cc =   "+252", lang = "so", currency = "Q4603", country = "Puntland" },
		Q17070   = { cont = "af", iso_3166 =    "RE", cc =   "+262", lang = "fr", currency = "Q4916", country = "Réunion" },
		Q653514  = { id = "Q17070" }, -- Arrondissement Saint-Denis
		Q47045   = { id = "Q17070" }, -- Saint-Denis
		Q316887  = { id = "Q17070" }, -- Saint-Paul
		Q612189  = { id = "Q17070" }, -- Arrondissement Saint-Paul
		Q702426  = { id = "Q17070" }, -- Arrondissement Saint-Pierre
		Q192184  = { cont = "af", iso_3166 =    "SH", cc =   "+290", lang = "en", currency = "Q374453", country = "St. Helena, Ascension und Tristan da Cunha" }, -- Sonderbehandlung Tristan da Cunha, Ascension, Gough-Insel
		Q842829  = { cont = "eu", iso_3166 =    "SJ", cc =    "+47", lang = "no", currency = "Q4916", country = "Svalbard und Jan Mayen" },
		Q34754   = { cont = "af", iso_3166 =    "SO", cc =   "+252", lang = "so", currency = "Q737384", country = "Somaliland" },
		Q26273   = { cont = "na", iso_3166 =    "SX", cc = "+1-721", lang = "nl", currency = "Q522701", country = "Niederländische Antillen" }, -- Sint Maarten
		Q18221   = { cont = "na", iso_3166 =    "TC", cc = "+1-649", lang = "en", currency = "Q4917", country = "Turks- und Caicosinseln" },
		Q129003  = { cont = "an", iso_3166 =    "TF", cc =   "+262", lang = "fr", currency = "Q4916", country = "Französische Süd- und Antarktisgebiete" },
		Q36823   = { cont = "oc", iso_3166 =    "TK", cc =   "+690", lang ="tkl", currency = "Q1472704", country = "Tokelau" },
		Q16645   = { cont = "oc", iso_3166 =    "UM", cc =       "", lang = "en", currency = "", country = "United States Minor Outlying Islands" },
		Q25305   = { cont = "na", iso_3166 =    "VG", cc = "+1-284", lang = "en", currency = "Q4917", country = "Britische Jungferninseln" },
		Q11703   = { cont = "na", iso_3166 =    "VI", cc = "+1-340", lang = "en", currency = "Q4917", country = "Amerikanische Jungferninseln" },
		Q642481  = { id = "Q11703" }, -- Saint Croix
		Q849441  = { id = "Q11703" }, -- Saint John
		Q463937  = { id = "Q11703" }, -- Saint Thomas
		Q35555   = { cont = "oc", iso_3166 =    "WF", cc =   "+681", lang = "fr", currency = "Q214393", country = "Wallis und Futuna" },
		Q17063   = { cont = "af", iso_3166 =    "YT", cc =   "+262", lang = "fr", currency = "Q4916", country = "Mayotte" },

		-- terrae nullius
		Q620634  = { cont = "af", iso_3166 =      "", cc =       "", lang = "ar", currency = "", country = "Bir Tawil" },

		-- Antarctica
		Q140948  = { cont = "an", iso_3166 =      "", cc =       "", lang = "en", currency = "", country = "Südliche Shetlandinseln" },
	}
}