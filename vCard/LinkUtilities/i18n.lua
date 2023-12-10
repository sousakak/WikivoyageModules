-- shared internationalisation for link modules

return {
	-- documentation
	moduleInterface = {
		suite  = 'Link utilities',
		sub    = 'i18n',
		serial = '2023-12-09',
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

	-- patterns for delimiters except ','
	delimiters      = { ' [aA][nN][dD] ', ' [oO][rR] ' },

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

	-- Skype query parameters
	params = {
		add       = '',
		call      = '',
		chat      = '',
		sendfile  = '',
		userinfo  = '',
		voicemail = ''
	},

	-- LinkISBN support
	isbnTexts = {
		booksourcesClass = 'wv-booksources', -- CSS class
		invalidISBN      = '<span class="error">無効なISBN</span>',
		invalidCat       = '[[カテゴリ:無効なISBNがあるページ]]'
	}
}