-- shared internationalisation for link modules

return {
	-- documentation
	moduleInterface = {
		suite  = 'Link utilities',
		sub    = 'i18n',
		serial = '2023-01-07',
		item   = 104200158
	},

	-- maximum count of items to display in listing
	addNum    = 3,
	addNumFax = 2,
	addMail   = 2,
	addSkype  = 2,

	texts = {
		comma       = ', ',
		space       = ' ',
		parentheses = '()'
	},

	-- patterns for delimiters except ',' (en)
	delimiters      = { ' [aA][nN][dD] ', ' [oO][rR] ' },

    -- patterns for phone extensions (en)
	extensions = {
		';?[Ee][Xx][Tt]%.?[ =]+%d+', -- ext. #### (en, intl)
		                             -- including RFC 3966 syntax ";ext=####"
		'x%d+',                      -- x#### (en, intl)
	},

	-- phone number options
	options = {
		withCountryCode    = false, -- add country calling code in output in any case
		preventLeadZero    = false, -- remove lead zero from output

		-- enable formatting of phone numbers retrieved from Wikidata
		formattingWikidata = true,  -- format phone numbers retrieved from Wikidata
		addZeros           = true,  -- add trunc prefix (0)
	},

	-- Skype query parameters
	params = {
		add       = '',
		call      = '',
		chat      = '',
		sendfile  = '',
		userinfo  = '',
		voicemail = ''
	},

	-- error categories. Leading [[Category: is added in modules
	categories = {
		noCC         = '連絡先:国番号のついていない電話番号]] <span class="error">国番号のついていない電話番号</span>',
		invalid	     = '連絡先:無効な電話番号のフォーマット]] <span class="error">無効な電話番号のフォーマット</span>',
		withSlash    = '連絡先:スラッシュ付きの電話番号]] <span class="error">スラッシュ付きの電話番号</span>',

		onlyDomestic = 'この電話番号は日本国内でのみ有効です',

		invalidMail  = '連絡先:無効なメール形式]] <span class="error">無効なメール形式</span>',
		nonASCII     = '連絡先:Unicode文字を含んだメールアドレス]] <span class="listing-check-recommended" style="display:none;">メールアドレスにUnicode文字が含まれています</span>',

		invalidSkype = '連絡先:無効なSkypeユーザー名]] <span class="error">Skypeのユーザー名が無効です</span>',
	},

	-- LinkISBN support
	isbnTexts = {
		booksourcesClass = 'wv-booksources', -- CSS class
		invalidISBN      = '<span class="error">無効なISBN</span>',
		invalidCat       = '[[カテゴリ:無効なISBNがあるページ]]'
	}
}