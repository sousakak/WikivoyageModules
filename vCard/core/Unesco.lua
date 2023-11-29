-- This module presenting a Unesco icon with a link to the related article
-- has to be adapted to the needs of the local wiki. It depends on the
-- existence of Unesco heritage articles.

-- modul variable and administration
local unesco = {
	moduleInterface  = {
		suite  = 'vCard',
		sub    = 'Unesco',
		serial = '2023-02-18',
		item   = 111232404
	}
}

-- heritage articles by continent, taken from Module:Unesco/i18n
local articles = {
	af      = '世界遺産#アフリカ', -- africa
	am      = '世界遺産#アメリカ合衆国', -- america
	as      = '世界遺産#アジア', -- asia
	au      = '世界遺産#オーストラリア', -- australia
	eu      = '世界遺産#ヨーロッパ', -- europe
	na      = '世界遺産#北アメリカ', -- north america
	oc      = '世界遺産#オセアニア', -- oceania
	sa      = '世界遺産#南アメリカ', -- south america
	default = '世界遺産',
	title   = '%sの世界遺産'
}

-- image titles by continent, taken from Module:Unesco/i18n
local titles = {
	af      = 'アフリカのユネスコ世界遺産',
	am      = 'アメリカのユネスコ世界遺産',
	as      = 'アジアのユネスコ世界遺産',
	au      = 'オーストラリアのユネスコ世界遺産',
	eu      = 'ヨーロッパのユネスコ世界遺産',
	na      = '北アメリカのユネスコ世界遺産',
	oc      = 'オセアニアのユネスコ世界遺産',
	sa      = '南アメリカのユネスコ世界遺産',
	default = 'ユネスコ世界遺産'
}

local exceptions = { -- There is not pages below on javoy, so this needs localization
	Niue           = 'ニウエの世界遺産',
	Samoa          = 'サモアの世界遺産',
	Tonga          = 'トンガの世界遺産',
	Bahamas        = 'バハマの世界遺産',
	Cookinseln     = 'クック諸島の世界遺産',
	Komoren        = 'コモロの世界遺産',
	Malediven      = 'モルディブの世界遺産',
	Marshallinseln = 'マーシャル諸島の世界遺産',
	Philippinen    = 'フィリピンの世界遺産',
	Salomonen      = 'ソロモン諸島の世界遺産',
	Seychellen     = 'セーシェル諸島の世界遺産',

	Irak           = 'イラクの世界遺産',
	Jemen          = 'イエメンの世界遺産',
	Kosovo         = 'コソボの世界遺産',
	Libanon        = 'レバノンの世界遺産',
	Sudan          = 'スーダンの世界遺産',
	['Südsudan']   = '南スーダンの世界遺産',
	Tschad         = 'チャドの世界遺産',
	['Vereinigtes Königreich'] = 'イギリスの世界遺産',

	['Föderierten Staaten von Mikronesien'] = 'ミクロネシア連邦の世界遺産',
	Niederlande    = 'オランダの世界遺産',
	['Vereinigte Staaten'] = 'アメリカの世界遺産',
	['Vereinigte Arabische Emirate'] = 'アラブ首長国連邦の世界遺産',

	['Demokratische Republik Kongo'] = 'コンゴ民主共和国の世界遺産',
	['Dominikanische Republik'] = 'ドミニカ共和国の世界遺産',
	['Elfenbeinküste'] = 'コートジボワールの世界遺産',
	Mongolei       = 'モンゴルの世界遺産',
	['Republik Kongo'] = 'コンゴ共和国の世界遺産',
	Schweiz        = 'スイスの世界遺産',
	Slowakei       = 'スロバキアの世界遺産',
	['Türkei']     = 'トルコの世界遺産',
	Ukraine        = 'ウクライナの世界遺産',
	Vatikanstadt   = 'バチカン市国の世界遺産',
	['Zentralafrikanische Republik'] = '中央アフリカの世界遺産'
}

-- create unesco image with link and title
function unesco.getUnescoInfo( countryData )
	local article = exceptions[ countryData.country ] or
		articles.title:format( countryData.country )

	if article then
		-- try to get the country article
		local title = mw.title.new( article )
		if title and title.exists then
			return article, article
		end

		-- try to get the continent article
		title = titles[ countryData.cont ]
		if title then
			article = articles[ countryData.cont ] .. '#' .. countryData.country
			return article, title
		end
	end

	return articles.default, titles.default
end

return unesco