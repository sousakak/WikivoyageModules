//<nowiki>
/** Listing Editor v2.6.4-de
	2023-12-26

	This script is called by [[MediaWiki:InitListingTools.js]]
	Original authors:
	- ausgehe
	- torty3
	Additional contributors:
	- Andyrom75
	- Wrh2
	- RolandUnger
	Documentation and version history:
	- https://de.wikivoyage.org/wiki/Wikivoyage:ListingEditor.js
*/
/* eslint-disable mediawiki/class-doc */

/** CUSTOMIZATION INSTRUCTIONS:

	Modules: Config, Callbacks, Sister, Core

	Different Wikivoyage language versions have different implementations of
	the listing template, so this module must be customized for each.  The
	Config and Callbacks modules should be the ONLY code that requires
	customization - Core should be shared across all language versions. If for
	some reason the Core module must be modified, ideally the module should be
	modified for all language versions so that the code can stay in sync.
*/

var wvListingEditor = ( function( mw, $ ) {
	'use strict';

// ---------------------------------- Config ----------------------------------

	/**
		Config contains properties that will likely need to be
		modified for each Wikivoyage language version.  Properties in this
		module will be referenced from the other ListingEditor modules.
	*/

	var Config = function() {
		var _Commons  = '//commons.wikimedia.org',
			_Wikidata = '//www.wikidata.org';

		var SYSTEM = {
			version:       '2.6.5-de',

			addSearchLang: [ 'en' ], // for Wikidata search
			Commons_Wiki:  _Commons + '/wiki/',
			Commons_API:   _Commons + '/w/api.php',
			Wikidata_Wiki: _Wikidata + '/wiki/',
			Wikidata_API:  _Wikidata + '/w/api.php',
			geomap:        '//wikivoyage.toolforge.org/w/geomap.php',

			wikiLang:      mw.config.get( 'wgPageContentLanguage' ),
			localLang:     '', // this and the following one are filled by script
			searchLang:    []
		};

		// --------------------------------------------------------------------
		// CONFIGURE THE FOLLOWING TO MATCH THE LISTING TEMPLATE PARAMS & OUTPUT
		// --------------------------------------------------------------------

		// names of the listing templates
		var TEMPLATES = [ 'vCard', 'listing', 'see', 'do', 'buy', 'drink', 'eat', 'sleep' ];
		var MARKERS   = [ 'marker' ];

		// --------------------------------------------------------------------
		// TRANSLATE THE FOLLOWING BASED ON THE WIKIVOYAGE LANGUAGE IN USE
		// --------------------------------------------------------------------

		// map section heading ID to the listing template to use for that section
		var SECTION_TO_DEFAULT_TYPE = {
			'着く': 'station', // go
			'移動する': 'public transport', // go
			'観る': 'monument', // see
			'する': 'sports', // do
			'買う': 'shop', // buy
			'食べる': 'restaurant', // eat
			'飲む': 'bar', // drink
			// dummy line (es) // drink and night life
			'泊まる': 'hotel', // sleep
			'学ぶ': 'education', // education
			'働く': 'administration', // work
			'安全を確保する': 'administration', // security
			'健康を維持する': 'health', // health
			'困ったときは': 'office' // practicalities
		};

		// If any of these patterns are present on a page then no 'add listing'
		// buttons will be added to the page
		var DISALLOW_ADD_LISTING_IF_PRESENT = ['#都市', '#その他の目的地', '#島', '#print-districts'];

		var STRINGS = {
			add: 'リストを追加',
			addTitle: 'リストを追加',
			edit: '編集',
			editTitle: 'リストを編集',
			loading: 'エディターを起動中...',
			ajaxInitFailure: 'エラー：エディターに事前に情報を入れられません',
			saving: '保存中...',
			enterCaptcha: 'キャプチャを入力してください',
			externalLinks: 'あなたの編集には新しい外部リンクが含まれてます',

			cancel: '中止',
			cancelTitle: '変更を破棄',
			cancelMessage: 'エディターを閉じると、記述内容は破棄されます。本当によろしいですか？',
			deleteMessage: 'ウィキデータへのリンクを削除します。よろしいですか？',
			help: '？',
			helpPage: '//ja.wikivoyage.org/wiki/ヘルプ:ListingEditor',
			helpTitle: 'ヘルプ',
			preview: 'プレビュー',
			previewTitle: 'vCardをプレビューします。',
			previewOff: 'プレビューを消去',
			previewOffTitle: 'プレビューを消去',
			refresh: '↺',  //  \ue031 not yet working
			refreshTitle: 'プレビューを更新',
			submit: '送信',
			submitTitle: '変更を保存',
			// license text should match MediaWiki:Wikimedia-copyrightwarning
			licenseText: '変更内容を保存すると、あなたは[https://foundation.wikimedia.org/wiki/Special:MyLanguage/Policy:Terms_of_Use/ja Terms of Use]に同意するとともに、自分の投稿内容を[https://creativecommons.org/licenses/by-sa/4.0/deed.ja CC BY-SA 4.0ライセンス]および[https://www.gnu.org/copyleft/fdl.html GFDL]のもとの公開に同意したことになります。この同意は取り消せません。\nまた、あなたはハイパーリンクまたはURLがクリエイティブ・コモンズライセンスにおける帰属表示として十分であると認めたことになります。',

			ifNecessary: '（必要に応じて）',
			severalGroups: '（推奨：複数のグループ）',
			searchOnMap: '地図で探す',
			deleteWikidataId: '除去',
			deleteWikidataIdTitle: 'vCardからウィキデータIDを削除',
			fillFromWikidata: 'ウィキデータの情報を補完',

			validationCategory: '接頭辞なしで有効なカテゴリ名を入力してください。',
			validationCoord: '緯度・経度が間違っています。',
			validationEmail: 'メールアドレスが間違っています。',
			validationEmptyListing: '名前か住所のどちらかを入力してください。',
			validationFacebook: 'FacebookのプロフィールIDまたはURLが正しくありません。',
			validationFax: 'ファックス番号が間違っています。',
			validationFlickr: 'FlickrユーザーIDまたはURLが間違っています。',
			validationImage: '接頭辞なしで有効なファイル名を入力してください。',
			validationInstagram: 'Instagramのユーザー名またはURLが間違っています。',
			validationLastEdit: '最終更新日が間違っています。',
			validationMapGroup: 'groupの名前が間違っています。',
			validationMissingCoord: '緯度と経度を両方入力してください。',
			validationMobile: '携帯電話番号が間違っています。',
			validationName: '名前または記事リンクが間違っています。',
			validationNames: '名前、住所、道順などの重複した識別子を削除しました。',
			validationPhone: '電話番号が間違っています。',
			validationSkype: 'Skypeのユーザー名が間違っています。',
			validationTollfree: 'フリーダイヤルが間違っています。',
			validationTiktok: 'TikTokのユーザー名またはURLが間違っています。',
			validationTwitter: 'Twitterのユーザー名またはURLが間違っています。',
			validationType: 'typeを指定してください。',
			validationUrl: 'URLが間違っています。',
			validationYoutube: 'YoutubeのチャンネルIDまたはURLが間違っています。',
			validationZoom: 'ズーム（0-19）が間違っています。',

			commonscat: 'カテゴリ',
			image: 'ファイル|画像', //Local prefix for Image (or File)
			added: '$1のvCardを追加しました',
			updated: '$1のvCardを更新しました',
			removed: '$1のvCardを削除しました',

			submitApiError: 'Fehler: Der Server lieferte eine Fehlermeldung beim Versuch der Speicherung der vCard. Bitte versuchen Sie es erneut.',
			submitBlacklistError: 'Fehler: Eine Angabe wurde als schwarzgelistet ermittelt. Bitte entfernen Sie den Eintrag und versuchen Sie es erneut.',
			submitUnknownError: 'Fehler: Ein unbekannter Fehler ist beim Versuch der Speicherung der vCard aufgetreten. Bitte versuchen Sie es erneut.',
			submitHttpError: 'Fehler: Der Server lieferte einen HTTP-Fehler beim Versuch der Speicherung der vCard. Bitte versuchen Sie es erneut.',
			submitEmptyError: 'Fehler: Der Server lieferte eine leere Antwort beim Versuch der Speicherung der vCard. Bitte versuchen Sie es erneut.',

			viewCommonsPageTitle: 'コモンズで画像を表示',
			viewCommonscatPageTitle: 'コモンズのファイルカテゴリへのリンク',
			viewWikidataPage: 'ウィキデータの項目を表示',
			wikidataShared: 'ウィキデータに以下のデータが見つかりました。反映させますか？',
			wikidataSharedNotFound: 'ウィキデータにはデータが見つかりませんでした。',

			natlCurrencyTitle: '現地通貨の記号を挿入',
			intlCurrencyTitle: '国際通貨記号を挿入',
			callingCodeTitle: '市外局番を挿入',
			specialCharsTitle: '特殊文字を挿入',
			linkTitle: 'サイトへのリンク',
			linkText: '<img src="//upload.wikimedia.org/wikipedia/commons/thumb/2/29/OOjs_UI_icon_link-ltr-progressive.svg/64px-OOjs_UI_icon_link-ltr-progressive.svg.png" height="16" width="16" />',
			contentLimit: 1000,
			contentStatus: '文字数：$1',
			additionalSubtypes: 'ウィキデータから追加情報を取得',
			unknownSubtypes: '既知の追加情報は見当たりませんでした',

			deleteListingLabel: 'このvCardを削除',
			deleteListingTitle: 'このvCardの掲載をやめるべき、削除するべきならば、ボックスにチェックを入れてください。リストが除去されます。',
			minorEditLabel: '細部の編集',
			minorEditTitle: '誤字の修正のような小さな編集ならばボックスにチェックを入れてください。',
			statusLabel: 'ステータス',
			statusTitle: '削除や更新などの項目のステータスに関する情報',
			summaryLabel: '編集の要約',
			summaryTitle: '追加・編集についての簡便な要約',
			summaryPlaceholder: '編集の要約を入力…',
			updateLastedit: '最終更新日の更新',
			updateTodayLabel: '最終更新日を今日に設定',
			updateTodayTitle: '情報がすべて最新であることを確認したら、ここにチェックを入れてください。入力された日付か今日の日付が保存されます。',

			textPreviewLabel: 'プレビュー',
			textPreviewTitle: '現在の内容でプレビュー',
			syntaxPreviewLabel: 'ウィキ構文',
			syntaxPreviewTitle: '現在の内容で生成されるウィキ構文',
			chosenNoResults: 'Keine Übereinstimmung mit',

			yes: [ 'y', 'yes', 'はい' ],
			no: [ 'n', 'no', 'いいえ' ],

			from: '%sから',
			fromTo: '%s–%s',
			to: '%sまで',

			sep: ',|;| and | or |、|，|；',
			skypeSep: ';| and | or '
		};

		var COORD_LETTERS =  {
			N: { factor:  1, dir: 'lat' },
			S: { factor: -1, dir: 'lat' },
			E: { factor:  1, dir: 'long' },
			W: { factor: -1, dir: 'long' },
		};

		var CHARS = {
			intlCurrencies: [ '¥', '$', '€', '£', '₩', '&amp;#x202F;' ],
			specialChars: [ 'Ä', 'Ö', 'Ü', 'ä', 'ö', 'ü', 'ß', 'ç', 'ñ', '„', '“', '‚', '‘', '’', '–', '—', '…', '·', '&amp;nbsp;', '&amp;#x202F;' ],
			spaceBeforeCurrencies: true,
			spaceAfterCallingCodes: true
		};

		// --------------------------------------------------------------------
		// CONFIGURE THE FOLLOWING BASED ON WIKIVOYAGE COMMUNITY PREFERENCES
		// --------------------------------------------------------------------

		var OPTIONS = {
			// in pixels, otherwise available space
			MaxDialogWidth: 1200,
			/** set the following flag to false if the listing editor should strip away any
				listing template parameters that are not explicitly configured in the
				TEMPLATES parameter arrays (such as wikipedia, phoneextra, etc).
				if the flag is set to true then unrecognized parameters will be allowed
				as long as they have a non-empty value. */
			AllowUnrecognizedParameters: true,
			// write empty parameters to listing template text
			keepItDefault: true,
			inlineFormat: false,

			CopyToAliases: false,
			CopyToTypeAliases: false,

			// handle punctuation marks at string end
			withoutPunctuation: [ 'address', 'address-local', 'alt', 'checkin', 'checkout', 'comment', 'hours', 'payment', 'price' ],
			// vCard default auto mode
			defaultAuto: true
		};

		/** The arrays below must include entries for each listing template
		parameter in use for each Wikivoyage language version - for example
		"name", "address", "phone", etc.  If all listing template types use
		the same parameters then a single configuration array is sufficient,
		but if listing templates use different parameters or have different
		rules about which parameters are required then the differences must
		be configured - for example, English Wikivoyage uses "checkin" and
		"checkout" in the "sleep" template, so a separate
		SLEEP_TEMPLATE_PARAMETERS array has been created below to define the
		different requirements for that listing template type.

		Once arrays of parameters are defined, the TEMPLATES
		mapping is used to link the configuration to the listing template
		type, so in the English Wikivoyage example all listing template
		types use the PARAMETERS configuration EXCEPT for
		"sleep" listings, which use the SLEEP_TEMPLATE_PARAMETERS
		configuration.

		Fields that can used in the configuration array(s):
		-	id: HTML input ID in the EDITOR_FORM_HTML for this element.
		-	hideDivIfEmpty: id of a <div> in the EDITOR_FORM_HTML for this
			element that should be hidden if the corresponding template
			parameter has no value. For example, the "fax" field is
			little-used and is not shown by default in the editor form if it
			does not already have a value.
		-	keepIt: Include the parameter in the wiki template
			syntax that is saved to the article if the parameter has no
			value. For example, the "image" tag is not included by default
			in the listing template syntax unless it has a value.
			Default keepIt = false
		-	newline: Append a newline after the parameter in the listing
			template syntax when the article is saved.
		-	aliases: aliases for parameter names.
		-	ph: placeholder.
		-	cl: tag class(es).
		-	tp: input type (select, textarea, default: input).
		-	multiple: multiple select fields.

		The following list defines the parameter succession of form output.
		Please translate only the title and the placeholder string ph. */

		var ParametersForLastedit = {
			hours: 'x',
			checkin: 'x',
			checkout: 'x',
			price: 'x'
		};
		var PARAMETERS = {
			name: { label: '名前', title: 'この場所の名前', ph: '  この場所の名前' },
			'name-local': { label: '現地語の名前', title: '現地語での名前', ph: '  現地語での名前', cl: 'editor-foreign addLocalLang' },
			'name-latin': { label: 'ラテン文字名', title: 'ラテン文字での名前', ph: '  ラテン文字での名前' },
			alt: { label: '別名', title: 'この場所の別名', ph: '  この場所の別名' },
			comment: { label: 'コメント', title: '元から、あるいはもはや名前の一部ではない名前や組織についての注記', ph: '  呼称についての注記' },

			type: { label: '種類', title: 'この場所の種類', ph: 'この場所の種類', tp: 'select', multiple: true, keepIt: true },
			group: { label: 'グループ', title: '上書き時のみ使用', ph: '訪問の目的。例：see', tp: 'select', cl: 'addGroupHint' },
			wikidata: { label: 'ウィキデータ', title: 'ウィキデータID', ph: '  ウィキデータID' },
			auto: { label: '自動', title: 'ウィキデータから全データを自動取得', ph: 'ウィキデータから取得', tp: 'select',
				text: '<option value=""></option>' +
					'<option value="y">自動取得</option>' +
					'<option value="n">手動取得（既定）</option>' },

			url: { label: '外部リンク', title: '公式サイトのURL', ph: '  公式サイトのURL', cl: 'addLink' },
			address: { label: '住所', title: 'この場所の住所', ph: '  この場所の住所' },
			'address-local': { label: '現地語の住所', title: '現地語での住所', ph: '  現地語での住所', cl: 'editor-foreign' },
			directions: { label: '道順', title: 'この場所への道順', ph: '  この場所への道順' },
			'directions-local': { label: '現地語の道順', title: '現地語での道順', ph: '  現地語での道順', cl: 'editor-foreign' },
			lat: { aliases: [ 'coord', '緯度' ], label: '緯度', title: 'この場所の緯度', ph: '  この場所の緯度' },
			long: { aliases: [ '経度' ], label: '経度', title: 'この場所の経度', ph: '  この場所の経度', cl: 'addMaplink' },

			phone: { label: '電話番号', title: 'この場所の電話番号', ph: '  この場所の電話番号', cl: 'addCC addLocalCC' },
			mobile: { label: '携帯電話', title: '携帯電話番号', ph: '  携帯電話番号', cl: 'addCC' },
			tollfree: { label: 'フリーダイヤル', title: 'フリーダイヤル番号', ph: '  フリーダイヤル番号', cl: 'addCC' },
			fax: { label: 'ファックス', title: 'ファックスの番号', ph: '  ファックスの番号', cl: 'addCC addLocalCC' },
			email: { label: 'メール', title: 'メールアドレス', ph: '  メールアドレス' },
			skype: { label: 'Skype-Name', title: 'Skype-Benutzername der Einrichtung', ph: '  Beispiel: myskype' },
			facebook: { label: 'Facebook-URL', title: 'Facebook-Profil-ID oder Facebook-Webadresse der Einrichtung', ph: '  Beispiele: myfacebook, https://www.facebook.com/myfacebook', cl: 'addLink' },
			flickr: { label: 'flickr-Gruppe', title: 'Name der flickr-Gruppe oder flickr-Webadresse der Einrichtung', ph: '  Beispiel: myflickr', cl: 'addLink' },
			instagram: { label: 'Instagram-Name', title: 'Instagram-Benutzername oder Instagram-Webadresse der Einrichtung', ph: '  Beispiel: myinstagram', cl: 'addLink' },
			tiktok: { label: 'TikTok-URL', title: 'TikTok-Benutzername ohne „@“ oder TikTok-Webadresse der Einrichtung', ph: '  Beispiel: mytiktok', cl: 'addLink' },
			twitter: { label: 'Twitter-URL', title: 'Twitter-Benutzername oder Twitter-Webadresse der Einrichtung', ph: '  Beispiel: mytwitter', cl: 'addLink' },
			youtube: { label: 'YouTube-Kanal', title: 'Kennung oder Webadresse des YouTube-Kanals der Einrichtung', ph: '  Beispiel: myyoutube', cl: 'addLink' },

			hours: { label: '営業時間', title: '営業している時間', ph: '  営業している時間' },
			checkin: { label: 'チェックイン', title: 'チェックインの時間', ph: '  チェックインの時間' },
			checkout: { label: 'チェックアウト', title: 'チェックアウトの時間', ph: '  チェックアウトの時間' },
			price: { label: '値段', title: '利用にかかる値段', ph: '  利用にかかる値段', cl: 'addCurrencies' },
			payment: { label: '支払方法', title: '利用できる支払方法', ph: '  利用できる支払方法' },
			subtype: { label: '追加情報', title: '追加の細かな情報', ph: '追加の情報', tp: 'select', multiple: true },
			image: { label: '画像', title: '地図上で表示される画像', ph: '  地図上で表示される画像', cl: 'addImgLink' },
			commonscat: { label: 'コモンズのカテゴリ', title: 'この場所の画像のカテゴリ', ph: '  この場所の画像のカテゴリ', cl: 'addCommonsLink' },
			show: { label: '表示', title: '地図上に表示するもの', ph: '地図上に表示するもの', tp: 'select', multiple: true,
				text: '<optgroup label="座標" id="listing-show-coordinate">' +
					'<option value="all">マーカーと座標</option>' +
					'<option value="poi">マーカー（既定）</option>' +
					'<option value="coord">座標</option>' +
					'<option value="none">座標なし</option>' +
				'</optgroup>' +
				'<optgroup label="アイコン" id="listing-show-symbol">' +
					'<option value="copy">マーカーの複製</option>' +
					'<option value="symbol">MAKIアイコン</option>' +
					'<option value="noairport">空港コードなし</option>' +
					'<option value="nositelinks">外部リンクなし</option>' +
					'<option value="nosocialmedia">ソーシャルメディアなし</option>' +
				'</optgroup>' +
				'<optgroup label="特徴" id="listing-show-subtypes">' +
					'<option value="nosubtype">サブタイプなし</option>' +
					'<option value="nowdsubtype">ウィキデータ由来のサブタイプなし</option>' +
				'</optgroup>' +
				'<optgroup label="vCardの表示" id="listing-show-block">' +
					'<option value="outdent">インデントを下げる</option>' +
					'<option value="inline">インライン表示</option>' +
					'<option value="nowikilink">内部リンクなし' +
					'<option value="noperiod">説明の前にピリオドを付けない</option>' +
				'</optgroup>' },
			zoom: { label: 'Zoom/縮尺', title: '表示される地図の縮尺レベル（0～19）。', ph: '  既定：17' },
			'map-group': { label: 'Map-group', title: '地図のグループ名。vCardを既定とは違う地図に表示したい場合に用います。半角英数字のみを用い、先頭の文字は数字ではいけません。', ph: '  例：group1' },
			lastedit: { label: 'Lastedit/最終更新', title: 'ISO 8601拡張形式（yyyy-mm-dd）で記入。このvCardの最終更新日です。空にした場合、今日の日付が自動挿入されます。', hideDivIfEmpty: 'div_lastedit', ph: '2020-01-15' },

			before: { label: '接頭辞', title: 'vCardの前に置かれる文字や記号', ph: '  例：[[ファイル:Sternchen.jpg]]' },
			description: { aliases: [ 'content' ], label: '内容', title: 'この場所の説明。1000文字以内に収めてください。', keepIt: true, ph: '場所の説明', tp: 'textarea' }
		};

		// ----------------------- Stop translation here -----------------------

		var MODES = {
			add: 'add',
			edit: 'edit'
		};

		// Type dependent hide /show
		var HIDE_AND_SHOW = {
			sleep: { 
				hide: [], // 'div_hours'; needed for campsites etc.
				show: ['div_checkin', 'div_checkout']
			},
			'default':  { 
				hide: ['div_checkin', 'div_checkout'],
				show: [] // 'div_hours'
			}
		};

		var REGEX = {
			name:     /^([^\[\]\|\*]+|\[\[[^\[\]\|\*]+\]\]|\[\[[^\[\]\|]+\|[^\[\]\|\*]+\]\])$/,
			url:      /^(https?:\/\/|\/\/)(\d{1,3}(\.\d{1,3}){0,3}|([^.\/:;<=>?\\@|\s\x00-\x2C\x7F]+\.)+[^.\/:;<=>?\\@|\d\s\x00-\x2C\x7F]{2,10}(:\d+)?)(\/?|\/[-A-Za-z0-9_.,~%+&:;#*?!=()@\/\x80-\xFF]*)$/,
			// protocol:       (https?:\/\/|\/\/)
			// domain:         (\d{1,3}(\.\d{1,3}){0,3}|([^.\/:;<=>?\\@|\s\x00-\x2C\x7F]+\.)+[^.\/:;<=>?\\@|\d\s\x00-\x2C\x7F]{2,10}(:\d+)?)
			// residual:       (\/?|\/[-A-Za-z0-9_.,~%+&:;#*?!=()@\/\x80-\xFF]*)
			// not considered: logins like login:password@, IPv6 addresses; will be added if necessary

			phone:    /^(\+[1-9]|[\d\(])([\dA-Z \-\(\)\.]+[\dA-Z ])(( ([Ee][Xx][Tt]\.? |[Aa][Pp][Pp]\.? |x)\d+)?)( *\([^\)]+\))?$/,
			email:    /^[^@^\(^\)\s]+@[^@^\(^\)\s]+\.[^@^\(^\)\s]+( *\([^\)]+\))?$/,
			skype:    /^[a-z][a-z0-9\.,\-_]{5,31}(\?(add|call|chat|sendfile|userinfo|voicemail))?( *\([^\)]+\))?$/,
			facebook: /^(https:\/\/www\.facebook\.com\/.+|(?!.*\.(?:com|net))[a-z\d.]{5,}|[-.\w\d]+\-\d+)$/i,
			flickr:   /^(https:\/\/www\.flickr\.com\/.+|\d{5,11}@N\d{2})$/,
			instagram:/^(https:\/\/www\.instagram\.com\/.+|explore\/locations\/[1-9]\d{0,15}|[0-9a-z_][0-9a-z._]{0,28}[0-9a-z_])$/,
			tiktok:   /^(https:\/\/www\.tiktok\.com\/@.+|[0-9A-Za-z_][0-9A-Za-z_.]{1,23})$/i,
			twitter:  /^(https:\/\/twitter\.com\/.+|[0-9a-z_]{1,15})$/i,
			youtube:  /^(https:\/\/www\.youtube\.com\/.+|UC[-_0-9A-Za-z]{21}[AQgw])$/,

			image:    new RegExp( '^(?!([Ff]ile|[Ii]mage|' + STRINGS.image + '):)' + '.+\.(tif|tiff|gif|png|jpg|jpeg|jpe|webp|xcf|ogg|ogv|svg|pdf|stl|djvu|webm|mpg|mpeg)$', 'i' ),
			commonscat: new RegExp( '^(?!(category|' + STRINGS.commonscat + '):)' + '.+$', 'i' ),
			zoom:     /^1?[0-9]$/,
			mapgroup: /^[A-Za-z][A-Za-z0-9]*$/,
			lastedit: /^((20\d{2}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01]))|((0?[1-9]|[12][0-9]|3[01])\.(0?[1-9]|1[012])\.20\d{2}))$/
		};

		var FIELDS = {
			name:        { regex: REGEX.name, m: STRINGS.validationName, wd: false },
			url:         { regex: REGEX.url, m: STRINGS.validationUrl, wd: true },
			phone:       { regex: REGEX.phone, m: STRINGS.validationPhone, wd: true, sep: STRINGS.sep },
			mobile:      { regex: REGEX.phone, m: STRINGS.validationMobile, wd: false, sep: STRINGS.sep },
			tollfree:    { regex: REGEX.phone, m: STRINGS.validationTollfree, wd: false, sep: STRINGS.sep },
			fax:         { regex: REGEX.phone, m: STRINGS.validationFax, wd: true, sep: STRINGS.sep },
			email:       { regex: REGEX.email, m: STRINGS.validationEmail, wd: true, sep: STRINGS.sep },
			skype:       { regex: REGEX.skype, m: STRINGS.validationSkype, wd: true, sep: STRINGS.skypeSep },
			facebook:    { regex: REGEX.facebook, m: STRINGS.validationFacebook, wd: true },
			flickr:      { regex: REGEX.flickr, m: STRINGS.validationFlickr, wd: true },
			instagram:   { regex: REGEX.instagram, m: STRINGS.validationInstagram, wd: true },
			tiktok:      { regex: REGEX.tiktok, m: STRINGS.validationTiktok, wd: true },
			twitter:     { regex: REGEX.twitter, m: STRINGS.validationTwitter, wd: true },
			youtube:     { regex: REGEX.youtube, m: STRINGS.validationYoutube, wd: true },
			image:       { regex: REGEX.image, m: STRINGS.validationImage, wd: true },
			commonscat:  { regex: REGEX.commonscat, m: STRINGS.validationCategory, wd: false },
			zoom:        { regex: REGEX.zoom, m: STRINGS.validationZoom, wd: false },
			'map-group': { regex: REGEX.mapgroup, m: STRINGS.validationMapGroup, wd: false },
			lastedit:    { regex: REGEX.lastedit, m: STRINGS.validationLastEdit, wd: false }
		};

		var WIKIDATA_CLAIMS = {
			name:        { type: 'label', which: 'wiki' },
			'name-local':{ type: 'label', which: 'local' },
			url:         { p:  'P856' },
			address:     { p: 'P6375', type: 'monolingual', which: 'wiki', max: 10 },
			'address-local': { p: 'P6375', type: 'monolingual', which: 'local', max: 10 },
			directions:  { p: 'P2795', type: 'monolingual', which: 'wiki', max: 10 },
			'directions-local': { p: 'P2795', type: 'monolingual', which: 'local', max: 10 },
			lat:         { p:  'P625', type: 'coordinate', which: 'latitude' },
			long:        { p:  'P625', type: 'coordinate', which: 'longitude' },

			phone:       { p: 'P1329', max: 5, type: 'contact' },
			fax:         { p: 'P2900', max: 3, type: 'contact' },
			email:       { p:  'P968', type: 'email', max: 5 },
			skype:       { p: 'P2893' },
			facebook:    { p: 'P2013' },
			flickr:      { p: 'P3267' },
			instagram:   { p: 'P2003' },
			tiktok:      { p: 'P7085' },
			twitter:     { p: 'P2002' },
			youtube:     { p: 'P2397' },

			// type:     {}
			subtype:     { p: [ 'P912', 'P2012', 'P2846', 'P2848', 'P5023', 'P10290' ], label: 'Features', type: 'subtype', table: '', result: 'table', max: 50 },
			hours:       { p: 'P3025', type: 'hours', max: 5 },
			checkin:     { p: 'P8745', type: 'id' },
			checkout:    { p: 'P8746', type: 'id' },
			price:       { p: 'P2555', type: 'au', max: 5 },
			payment:     { p: 'P2851', type: 'id', max: 10 },
			image:       { p:   'P18' },
			commonscat:  { p:  'P373' }
		};

		var SHOW_OPTIONS = { // strings should be not empty
			none: 1,
			poi: 1,
			coord: 1,
			copy: 1,
			all: 1,
			symbol: 1,
			nowdsubtype: 1,
			noairport: 1,
			noperiod: 1,
			nositelinks: 1,
			nosocialmedia: 1,
			nosubtype: 1,
			nowikilink: 1,
			outdent: 1,
			inline: 1
		};

		var PROPERTIES = {
			quantity: 'P1114',
			minimumAge: 'P2899',
			maximumAge: 'P4135',
			dayOpen: 'P3027',
			dayClosed: 'P3028',
			hourOpen: 'P8626',
			hourClosed: 'P8627',
		};

		var COMMENTS = {
			contact: [ 'P366', 'P518', 'P642', 'P1001', 'P1559', 'P106' ],
			fee:     [ 'P5314', 'P518', 'P6001', 'P1264', 'P585', 'P2899', 'P4135', 'P642'],
			hours:   [ 'P8626', 'P8627', 'P3027', 'P3028' ]
		};

		// --------------------------------------------------------------------
		// CONFIGURE THE FOLLOWING TO IMPLEMENT THE UI FOR THE LISTING EDITOR
		// --------------------------------------------------------------------

		var SELECTORS = {
			/** these selectors should match a value defined in the EDITOR_FORM_HTML
				if the selector refers to a field that is not used by a Wikivoyage
				language version the variable should still be defined, but the
				corresponding element in EDITOR_FORM_HTML can be removed and thus
				the selector will not match anything and the functionality tied to
				the selector will never execute. */
			editorDelete: '#checkbox-delete',
			editorForm: '#listingeditor-form',
			editorLastedit: '#checkbox-lastedit',
			editorMinorEdit: '#checkbox-minor',
			editorSummary: '#input-summary',
			wikidataLabel: '#input-wikidata-label',

			editLink: '.listing-edit-button button',
			saveForm: '#progress-dialog',
			loadingForm: '#loading-dialog',
			captchaForm: '#captcha-dialog',
			addButton: 'listing-add-button',
			content: '', // set by script

			// document selectors
			geoIndicator: '#mw-indicator-i3-geo .wv-coord-indicator',
			// selector that identifies the listing elements into which the
			// 'edit' link will be placed
			metadataSelector: 'span.listing-metadata-items'
		};

		// --------------------------------------------------------------------
		// ADDING OPTIONS
		// --------------------------------------------------------------------

		var LINK_FORMATTERS = {
			facebook: 'https://www.facebook.com/$1',
			flickr: 'https://www.flickr.com/photos/$1',
			instagram: 'https://www.instagram.com/$1/',
			tiktok: 'https://www.tiktok.com/@$1',
			twitter: 'https://twitter.com/$1',
			youtube: 'https://www.youtube.com/channel/$1',
			url: '$1'
		};

		var CHOSEN_OPTIONS = {
			no_results_text: STRINGS.chosenNoResults,
			width: '100%',
			rtl: false,
			allow_single_deselect: true,
			disable_search_threshold: 5
		};

		// utilities for form elements creation
		var getInputId = function( id ) {
			return 'input-' + id;
		};

		var input = function( id, add ) {
			if ( !id || id === '' ) return '';

			var el, tagId = getInputId( id ),
				p = PARAMETERS[ id === 'wikidata-label' ? 'wikidata' : id ],
				attr = mw.format( 'id="$1"', tagId ) +
					( p.cl ? mw.format( ' class="$1"', p.cl ) : '' );

			switch ( p.tp || '' ) {
				case 'select':
					if ( !p.text && !p.multiple )
						p.text = '<option value=""></option>';
					attr += ( p.multiple ? ' multiple="multiple"' : '' ) +
						( p.ph ? mw.format( ' data-placeholder="$1"', p.ph ) : '' );
					el = mw.format( '<select class="chosen-select" title="$1" $2>$3</select>', p.title, attr, p.text || '' );
					break;
				case 'textarea':
					el = mw.format( '<textarea rows="8" title="$1" $2></textarea>', p.title, attr );
					break;
				default:
					el = mw.format( '<input type="text" title="$1" $2>', p.title, attr );
			}

			return mw.format( '<div id="div_$1" class="editor-row">', id ) +
				mw.format( '<div><label for="$1" title="$2">$3</label></div>',
					tagId, p.title, p.label ) +
				mw.format( '<div class="editor-input">$1</div>', el + ( add || '' ) ) +
			'</div>';
		};

		var inputs = function( arr ) {
			var s = '';
			for ( var id of arr )
				s += input( id );
			return s;
		};

		/** The below HTML is the UI that will be loaded into the listing editor
			dialog box when a listing is added or edited. EACH WIKIVOYAGE LANGUAGE
			SITE CAN CUSTOMIZE THIS HTML - fields can be removed, added, displayed
			differently, etc. Note that it is important that any changes to the HTML
			structure are also made to the TEMPLATES parameter arrays since that
			array provides the mapping between the editor HTML and the listing
			template fields. */

		var EDITOR_FORM_HTML = '<form id="listingeditor-form">' +
			'<div class="listingeditor-container">' +
			'<div class="listingeditor-col">' +
				// maybe a Callbacks.initFindOnMapLink or Callbacks.initSymbolFormFields update necessary
				inputs( [ 'name', 'alt', 'comment', 'url', 'address', 'directions', 'lat', 'long',
					 'phone', 'tollfree', 'mobile', 'fax', 'email', 'skype', 'facebook', 'flickr', 'instagram', 'tiktok', 'twitter', 'youtube' ] ) +
			'</div>' +

			'<div class="listingeditor-col">' +
				inputs( [ 'type', 'group' ] ) +
				input( 'subtype',
					'<div class="input-other" id="listingeditor-additionalSubtypes" style="display: none"><a href="javascript:" title="' + STRINGS.additionalSubtypes + '">[ + ]</a></div>' ) +
				input( 'show' ) +
				input( 'wikidata-label',
					'<div class="input-other" id="wikidata-tools">' +
						'<input type="hidden" id="input-wikidata"><span id="wikidata-value-link"></span> | ' +
						'<a href="javascript:" id="wikidata-remove" title="' + STRINGS.deleteWikidataIdTitle + '">' + STRINGS.deleteWikidataId + '</a>' +
					'</div>' ) +
				input( 'auto', '<div id="div_wikidata_update" class="input-other"><a href="javascript:" id="wikidata-shared">' + STRINGS.fillFromWikidata + '</a></div>' ) +
				inputs( [ 'hours', 'checkin', 'checkout', 'price', 'payment', 'image', 'commonscat', 'zoom',
					'map-group', 'before', 'name-local', 'name-latin', 'address-local', 'directions-local' ] ) +
			'</div>' +
			'</div>' +
			
			input( 'description' ) +

			// update the Callbacks.hideEditOnlyFields method if
			// the status and/or summary rows are removed or modified
			'<div id="div_status" class="editor-row">' +
				mw.format( '<div title="$1">$2</div>', STRINGS.statusTitle, STRINGS.statusLabel ) +
				'<div>' +
					// update the Callbacks.updateLastEditDate
					// method if the last edit input is removed or modified
					'<span id="div_lastedit">' +
						mw.format( '<label for="$1" title="$2">$3</label> ', getInputId( 'lastedit' ), PARAMETERS.lastedit.title, PARAMETERS.lastedit.label ) +
						'<input type="text" size="10" id="' + getInputId( 'lastedit' ) + '">' +
					'</span>' +
					'<span id="span-lasteditToday">' +
						'<input type="checkbox" id="checkbox-lastedit" />' +
						mw.format( '<label for="checkbox-lastedit" class="listingeditor-tooltip" title="$1">$2</label>', STRINGS.updateTodayTitle, STRINGS.updateTodayLabel ) +
					'</span>' +
					'<span id="span-delete">' +
						'<input type="checkbox" id="checkbox-delete">' +
						mw.format( '<label for="checkbox-delete" class="listingeditor-tooltip" title="$1">$2</label>', STRINGS.deleteListingTitle, STRINGS.deleteListingLabel ) +
					'</span>' +
				'</div>' +
			'</div>' +

			'<div id="div_summary">'+
				'<div class="listingeditor-divider"></div>' +
				'<div class="editor-row">' +
					mw.format( '<div><label for="input-summary" title="$1">$2</label></div>', STRINGS.summaryTitle, STRINGS.summaryLabel ) +
					'<div class="editor-input">' +
						'<input type="text" id="input-summary" placeholder="' + STRINGS.summaryPlaceholder + '">' +
						mw.format( '<div id="span-minor" class="input-other"><input type="checkbox" id="checkbox-minor"><label for="checkbox-minor" class="listingeditor-tooltip" title="$1">$2</label></div>', STRINGS.minorEditTitle, STRINGS.minorEditLabel ) +
					'</div>' +						
				'</div>' +
			'</div>' +

			'<div id="listingeditor-preview" style="display: none;">' +
				'<div class="listingeditor-divider"></div>' +
				'<div class="editor-row">' +
					'<div>' +
						mw.format( '<input type="radio" name="previewSelect" id="select-preview" value="Template preview" checked="checked" /> <label for="select-preview" title="$1">$2</label><br />', STRINGS.textPreviewTitle, STRINGS.textPreviewLabel ) +
						mw.format( '<input type="radio" name="previewSelect" id="select-syntax" value="Wiki syntax" /> <label for="select-syntax" title="$1">$2</label>', STRINGS.syntaxPreviewTitle, STRINGS.syntaxPreviewLabel ) +
					'</div>' +
					'<div>' +
						'<div id="listingeditor-preview-text" class="listingeditor-preview-div"></div>' +
						'<div id="listingeditor-preview-syntax" class="listingeditor-preview-div" style="display: none"></div>' +
					'</div>' +
				'</div>' +
			'</div>' +

			'</form>';

		var MODULE_TABLES = {
			types: window.ListingEditor.types || [],
			groups: window.ListingEditor.groups || [],
			subtypes: window.ListingEditor.subtypes,
			subtypeGroups: 12,

			currencies: window.ListingEditor.currencies,
			q_ids: [ window.ListingEditor.payments, window.ListingEditor.hours, window.ListingEditor.qualifiers ],

			typeList: {},
			groupList: {},
			subtypeList: {},

			typeAliases: {},
			groupAliases: {},
			subtypeAliases: {},
		};

		// expose public members
		return {
			CHARS: CHARS,
			CHOSEN_OPTIONS: CHOSEN_OPTIONS,
			COMMENTS: COMMENTS,
			COORD_LETTERS: COORD_LETTERS,
			DISALLOW_ADD_LISTING_IF_PRESENT: DISALLOW_ADD_LISTING_IF_PRESENT,
			EDITOR_FORM_HTML: EDITOR_FORM_HTML,
			FIELDS: FIELDS,
			getInputId: getInputId,
			HIDE_AND_SHOW: HIDE_AND_SHOW,
			LINK_FORMATTERS: LINK_FORMATTERS,
			MARKERS: MARKERS,
			MODES: MODES,
			MODULE_TABLES: MODULE_TABLES,
			OPTIONS: OPTIONS,
			PARAMETERS: PARAMETERS,
			ParametersForLastedit: ParametersForLastedit,
			PROPERTIES: PROPERTIES,
			SECTION_TO_DEFAULT_TYPE: SECTION_TO_DEFAULT_TYPE,
			SELECTORS: SELECTORS,
			SHOW_OPTIONS: SHOW_OPTIONS,
			STRINGS: STRINGS,
			SYSTEM: SYSTEM,
			TEMPLATES: TEMPLATES,
			WIKIDATA_CLAIMS: WIKIDATA_CLAIMS
		};
	}();

// ---------------------------------- Sister ----------------------------------

	/**
		Sister implements functionality for information interchange to
		Wikimedia sister websites
	*/

	var Sister = function() {
		// perform an ajax query of a sister site
		var ajaxQuery = function( url, data, success ) {
			data.format = 'json';
			$.ajax({
				url: url,
				data: data,
				dataType: 'jsonp',
				success: success
			});
		};

		function _initializeAutocomplete( siteData, ajaxData, parseAjaxResponse ) {
			var autocompleteOptions = {
				source: function( request, response ) {
					ajaxData.search = request.term;
					var ajaxSuccess = function( jsonObj ) {
						response( parseAjaxResponse( jsonObj ) );
					};
					ajaxQuery( siteData.apiUrl, ajaxData, ajaxSuccess );
				}
			};
			if ( siteData.selectFunction )
				autocompleteOptions.select = siteData.selectFunction;
			siteData.selector.autocomplete( autocompleteOptions )
				.data( 'ui-autocomplete' )._renderItem = function( ul, item ) {
					var isImage = item.label.match( /^File:/i );
					var label = mw.html.escape( item.label.replace( /^(File:|Category:)/i, '' ) );
					if ( isImage )
						label = '<span class="autocomplete-thumbnail" style="background-image: url(&quot;https://commons.wikimedia.org/wiki/Special:FilePath/' +
							label.replace( /' '/g, '_' ) + '?width=200&quot;);"></span> ' + label;
					return $( '<li>' ).data( 'ui-autocomplete-item', item )
						.append( $( '<a>' ).html( label ) ).appendTo( ul );
				};
		}

		var initializeAutocomplete = function( siteData ) {
			var sel = $( siteData.selector );
			var currentValue = sel.val();
			if ( currentValue )
				siteData.updateLinkFunction( currentValue, siteData.form );
			sel.change( function() {
				siteData.updateLinkFunction( sel.val(), siteData.form );
			});
			siteData.selectFunction = function(event, ui) {
				siteData.updateLinkFunction(ui.item.value, siteData.form);
			};
			var ajaxData = siteData.ajaxData;
			ajaxData.action = 'opensearch';
			ajaxData.list = 'search';
			ajaxData.limit = 10;
			ajaxData.redirects = 'resolve';
			var parseAjaxResponse = function( jsonObj ) {
				var results = [], i, title;
				var titleResults = $( jsonObj[ 1 ] );
				for ( i = 0; i < titleResults.length; i++ ) {
					title = titleResults[ i ];
					results.push( {
						value: title.replace( /^(File:|Category:)/i, '' ),
						label: title,
						description: $( jsonObj[ 2 ] )[ i ],
						link: $( jsonObj[ 3 ] )[ i ]
					} );
				}
				return results;
			};
			_initializeAutocomplete( siteData, ajaxData, parseAjaxResponse );
		};


		// expose public members
		return {
			ajaxQuery: ajaxQuery,
			initializeAutocomplete: initializeAutocomplete
		};
	}();

// --------------------------------- Wikibase ---------------------------------

	/**
		Sister implements functionality Wikidata support
	*/

	var Wikibase = function() {
		// get a Wikidata entity object
		var getEntity = function( id, success, props ) {
			props = props || 'labels|claims|datatype';
			var languages = [].concat( Config.SYSTEM.searchLang );
			if ( Config.SYSTEM.localLang !== '' )
				languages.push( Config.SYSTEM.localLang );
			languages = languages.join( '|' );
			var data = {
				action: 'wbgetentities',
				ids: id,
				languages: languages,
				props: props
			};
			Sister.ajaxQuery( Config.SYSTEM.Wikidata_API, data, success );
		};

		// parse the wikidata "entity" object from the wikidata response
		function checkEntity( id, jsonObj ) {
			return jsonObj && jsonObj.entities && jsonObj.entities[ id ] ?
				jsonObj.entities[ id ] : null;
		}

		// parse the wikidata display label from the wikidata response
		var getLabels = function( id, jsonObj ) {
			var entityObj = checkEntity( id, jsonObj );
			if ( !entityObj || !entityObj.labels )
				return null;
			var wiki = '', local = '', lang;
			for ( lang of Config.SYSTEM.searchLang )
				if ( entityObj.labels[ lang ] ) {
					wiki = entityObj.labels[ lang ].value;
					break;
				}
			if ( Config.SYSTEM.localLang !== '' && entityObj.labels[ Config.SYSTEM.localLang ] )
				local = entityObj.labels[ Config.SYSTEM.localLang ].value;
			return { wiki: wiki, local: local };
		};

		// get Wikidata Id label from array
		function getIdLabel( id ) {
			for ( var arr of Config.MODULE_TABLES.q_ids ) {
				if ( arr && arr[ id ] )
					return arr[ id ];
			}
			return id;
		}

		function getAllStatements( entityClaims, property ) {
			var obj, propertyObj, statements = [];
			if ( !entityClaims || !entityClaims[ property ] )
				return statements;
			propertyObj = entityClaims[ property ];
			if ( !propertyObj || propertyObj.length === 0 )
				return statements;

			for ( obj of propertyObj )
				if ( obj.mainsnak && obj.mainsnak.snaktype === 'value' &&
					obj.mainsnak.datavalue )
					statements.push( {
						value: obj.mainsnak.datavalue.value,
						qualifiers: obj.qualifiers,
//						references: obj.references,
						rank: obj.rank
					} );
			return statements;
		}

		function getBestStatements( entityClaims, property ) {
			var statements = [];
			var allStatements = getAllStatements( entityClaims, property );
			if ( !allStatements || allStatements.length === 0 )
				return statements;

			var rank = 'normal', statement;
			for ( statement of allStatements )
				if ( statement.rank === rank )
					statements.push( { value: statement.value, qualifiers: statement.qualifiers } );
				else if ( statement.rank === 'preferred' ) {
					rank = 'preferred';
					// remove all previous statements
					statements = [ { value: statement.value, qualifiers: statement.qualifiers } ];
				}
			return statements;
		}

		function getUnit( unit ) {
			var u = ( '' + unit ).replace( /https?:\/\/www.wikidata.org\/entity\//ig, '' );
			return u === '1' ? '' : u;
		}

		function htmlDecode( s ) {
			var tag = document.createElement( 'textarea' );
			tag.innerHTML = s;
			return tag.value;
		}

		function getQuantity( value ) {
			var val = 1 * value.amount;
			if ( val === 0 ) return '0';
			var unit = getUnit( value.unit );

			if ( unit !== '' ) {
				var item = Config.MODULE_TABLES.currencies[ unit ];
				if ( item ) {
					val = ( item.mul ? item.mul : 1 ) * val;
					unit = ( item.f || Config.MODULE_TABLES.currencies.default || '%s unit' )
						.replace( /unit/g, item.iso );
				} else
					unit = '%s ' + getIdLabel( unit );
			} else
				unit = '%s';
			val = new Intl.NumberFormat( Config.SYSTEM.wikiLang,
				{ minimumFractionDigits: val % 1 == 0 ? 0 : 2 }
				).format( val );
			return htmlDecode( unit.replace( /%s/g, val ) );
		}

		function getHours( statement ) {
			function getItems( parts, prop1, prop2 ) {
				var arr = [], end, i, start;
				var count = Math.max( parts[ prop1 ].length, parts[ prop2 ].length );
				for ( i = 0; i < count; i++ ) {
					start = parts[ prop1 ][ i ];
					end = parts[ prop2 ][ i ];
					if ( start && end )
						arr.push( start + '–' + end );
					else
						arr.push( start || end );
				}
				return arr.join( ',' );
			}

			var i, item, parts = {}, property;
			var result = getIdLabel( statement.value.id );

			var dayOpen = Config.PROPERTIES.dayOpen;
			var dayClosed = Config.PROPERTIES.dayClosed;
			var hourOpen = Config.PROPERTIES.hourOpen;
			var hourClosed = Config.PROPERTIES.hourClosed;

			if ( statement.qualifiers ) {
				for ( property of Config.COMMENTS.hours ) {
					parts[ property ] = [];
					if ( statement.qualifiers[ property ] )
						for ( item of statement.qualifiers[ property ] )
							if ( item.snaktype === 'value' && item.datavalue.type === 'wikibase-entityid' )
								parts[ property ].push( getIdLabel( item.datavalue.value.id ) );
				}
				item = getItems( parts, hourOpen, hourClosed );
				if ( item !== '' ) result += ' ' + item;
				item = getItems( parts, dayOpen, dayClosed );
				if ( item !== '' ) result += ' (' + item + ')';
			}
			return result;
		}

		function getComments( qualifiers, properties ) {
			if ( typeof( qualifiers ) == 'undefined' ) return '';
			var comments = [], item, minAge, maxAge, property, value;
			var minimumAge = Config.PROPERTIES.minimumAge;
			var maximumAge = Config.PROPERTIES.maximumAge;
			for ( property of properties ) {
				if ( typeof( qualifiers[ property ] ) == 'undefined' ) continue;

				if ( property === minimumAge )
					minAge = getQuantity( qualifiers[ property ][ 0 ].datavalue.value );
				else if ( property === maximumAge )
					maxAge = getQuantity( qualifiers[ property ][ 0 ].datavalue.value );
				else
					for ( item of qualifiers[ property ] )
						if ( item.snaktype === 'value' ) {
							value = item.datavalue.value;
							switch( item.datavalue.type ) {
								case 'monolingual':
									value = value.text;
									break;
								case 'wikibase-entityid':
									value = getIdLabel( value.id );
									break;
							}
							if ( typeof( value ) === 'string' && value !== '' )
								comments.push( value );
							
						}
			}

			if ( minAge && maxAge )
				comments.push( Config.STRINGS.fromTo
					.replace( '%s', parseInt( minAge ) ).replace( '%s', maxAge ) );
			else if ( minAge )
				comments.push( Config.STRINGS.from.replace( '%s', minAge ) );
			else if ( maxAge )
				comments.push( Config.STRINGS.to.replace( '%s', maxAge ) );

			return ( comments.length === 0 ) ? '' : ' (' + comments.join( ', ' ) + ')';
		}

		// parse the wikidata "claim" object from the wikidata response
		var getStatements = function( id, jsonObj, claim ) {
			if ( claim.type === 'label' ) {
				var labels = getLabels( id, jsonObj );
				if ( labels ) {
					if ( claim.which === 'wiki' && labels.wiki && labels.wiki !== '' )
						return labels.wiki;
					if ( claim.which === 'local' && labels.local && labels.local !== '' )
						return labels.local;
				}
				return null;
			}

			var entity = checkEntity( id, jsonObj );
			if ( !entity || !entity.claims )
				return null;

			var count, lang, pos, property, properties, val, values, results = [],
				statement, statements;

			properties = typeof claim.p == 'string' ? [ claim.p ] : claim.p;
			for ( property of properties ) {
				statements = getBestStatements( entity.claims, property );
				if ( statements.length === 0 )
					continue;
				claim.max = claim.max || 1;
				if ( claim.max < statements.length )
					statements.splice( claim.max, statements.length );

				switch( claim.type ) {
					case 'monolingual':
						values = {};
						for ( statement of statements ) {
							lang = statement.value.language;
							pos = lang.indexOf( '-' );
							if ( pos >= 0 )
								lang = lang.substr( 0, pos );
							values[ lang ] = statement.value.text;
						}
						if ( claim.which == 'wiki' )
							for ( lang of Config.SYSTEM.searchLang ) {
								val = values[ lang ];
								if ( val ) {
									results.push( val );
									break;
								}
							}
						else {
							val = values[ Config.SYSTEM.localLang ];
							if ( val )
								results.push( val );
						}
						break;
					case 'au': // fees
						for ( statement of statements )
							results.push( getQuantity( statement.value ) +
								getComments( statement.qualifiers, Config.COMMENTS.fee ) );
						break;
					case 'subtype':
					case 'id':
						for ( statement of statements ) {
							if ( typeof claim.table == 'object' )
								if ( claim.table[ statement.value.id ] ) {
									// subtype
									count = 1;
									var quantity = Config.PROPERTIES.quantity;
									if ( statement.qualifiers && statement.qualifiers[ quantity ] ) {
										count = parseInt( getQuantity( statement.qualifiers[ quantity ][ 0 ].datavalue.value ) );
										if ( typeof( count ) != 'number' || count < 2 )
											count = 1;
									}
									val = claim.table[ statement.value.id ];
									if ( count > 1 ) val += ':' + count;
									results.push( val );
								} else
									results.push( getIdLabel( statement.value.id ) );
							else
								results.push( getIdLabel( statement.value.id ) );
						}
						break;
					case 'hours':
						for ( statement of statements ) {
							val = getHours( statement );
							if ( val !== '' ) results.push( val );
						}
						break;
					default:
						for ( statement of statements ) {
							switch( claim.type ) {
								case 'coordinate':
									if ( claim.which == 'latitude' )
										val = Math.round( statement.value.latitude * 1E6 ) / 1E6;
									else
										val = Math.round( statement.value.longitude * 1E6 ) / 1E6;
									break;
								case 'email':
								case 'contact':
									val = statement.value.replace( 'mailto:', '' ) +
										getComments( statement.qualifiers, Config.COMMENTS.contact );
									break;
								default:
									val = statement.value;
							}
							results.push( val );
						}
				} // switch type
			} // for property

			if ( results.length === 0 )
				return null;
			else {
				if ( claim.result && claim.result == 'table' )
					return results;
				else			
					return results.join( ', ' );
			}
		};

		// expose public members
		return {
			getEntity: getEntity,
			getLabels: getLabels,
			getStatements: getStatements
		};
	}();

// -------------------------------- Callbacks ---------------------------------

	/** 
		Callbacks implements custom functionality that may be
		specific to how a Wikivoyage language version has implemented the
		listing template.  For example, English Wikivoyage uses a "last edit"
		date that needs to be populated when the listing editor form is
		submitted, and that is done via custom functionality implemented as a
		SUBMIT_FORM_CALLBACK function in this module.
	*/

	var Callbacks = function() {
		// dialogue elements
		var ELEMENTS = {};

		// array of functions to invoke when creating the listing editor form.
		// these functions will be invoked with the form DOM object as the
		// first element and the mode as the second element.
		var CREATE_FORM_CALLBACKS = [];

		// array of functions to invoke when submitting the listing editor
		// form but prior to validating the form. these functions will be
		// invoked with the mapping of listing attribute to value as the first
		// element and the mode as the second element.
		var SUBMIT_FORM_CALLBACKS = [];

		// array of validation functions to invoke when the listing editor is
		// submitted. these functions will be invoked with an array of
		// validation messages as an argument; a failed validation should add a
		// message to this array, and the user will be shown the messages and
		// the form will not be submitted if the array is not empty.
		var VALIDATE_FORM_CALLBACKS = [];

		// storage for Wikidata results
		var wdResults = {};

		/**
			Helper functions
		*/

		// check if only yes or no is entered
		var checkYesNo = function( value ) {
			var v = value.toLowerCase();
			return Config.STRINGS.yes.includes( v ) ? 'y' :
				( Config.STRINGS.no.includes( v ) ? 'n' : '' );
		};

		// sort subtypes by groups
		var sortSubtypes = function( s ) {
			return s.sort( function( a, b ) {
				var aa = a.replace( /:.*$/g, '' );
				var bb = b.replace( /:.*$/g, '' );
				var subtypeList = Config.MODULE_TABLES.subtypeList;
				if ( subtypeList[ aa ] && subtypeList[ bb ] ) {
					if ( subtypeList[ aa ].g < subtypeList[ bb ].g )
						return -1;
					if ( subtypeList[ aa ].g > subtypeList[ bb ].g )
						return 1;
				}
				return aa.localeCompare( bb );
			});
		};

		// remove comments from a parameter
		var removeComments = function( s ) {
			return s.replace( /<!--.*?-->/g, '' ).trim();
		};

		// --------------------------------------------------------------------
		// LISTING EDITOR UI INITIALIZATION CALLBACKS
		// --------------------------------------------------------------------
		
		// character count for description
		var characterCount = function( form, mode ) {
			ELEMENTS.description.keyup( function( e ) {
				var count = $( this ).val().length;
				$( '#counter-description', form )
					.html( mw.format( Config.STRINGS.contentStatus, count ) )
					.toggleClass( 'input-content-limit', count > Config.STRINGS.contentLimit );
			}).trigger( 'keyup' );	
		};
		CREATE_FORM_CALLBACKS.push( characterCount );

		/**
			Add listeners to the currency symbols, calling codes and special
			characters so that clicking on a symbol will insert it into the input.
		*/

		var initSymbolFormFields = function( form, mode ) {
			$( '.editor-charinsert', form ).click( function() {
				var _this = $( this );
				var input = $( '#' + _this.attr( 'data-for' ) );
				var caretPos = input[ 0 ].selectionStart;
				var oldValue = input.val();
				var symbol = _this.find( 'a' ).text();
				var charType = _this.attr( 'data-type' ) || '';
				var char = oldValue.substring( caretPos-1, caretPos );
				if ( Config.CHARS.spaceBeforeCurrencies && symbol != '&#x202F;' &&
					charType == 'currency-char' && caretPos > 0 &&
					char >= '0' && char <= '9' )
					symbol = '&#x202F;' + symbol;
				else if ( Config.CHARS.spaceAfterCallingCodes && charType == 'phone-char' )
					symbol = symbol + ' ';

				var newValue = oldValue.substring(0, caretPos) + symbol + oldValue.substring( caretPos );
				input.val( newValue ).select();
				// now setting the cursor behind the symbol inserted
				caretPos = caretPos + symbol.length;
				input[ 0 ].setSelectionRange( caretPos, caretPos );
			});
		};
		CREATE_FORM_CALLBACKS.push( initSymbolFormFields );

		// handling coordinates
		function checkForSplit() {
			var long = ELEMENTS.long;
			if ( removeComments( long.val() ) !== '' ) return;

			var lat = ELEMENTS.lat;
			var value = removeComments( lat.val().toUpperCase() );
			var coords = value.split( /[,;\|]/ );
			if ( coords.length === 2 ) {
				lat.val( coords[ 0 ].trim() );
				long.val( coords[ 1 ].trim() );
				return;
			}
			for ( var d of [ 'N', 'S' ] ) {
				coords = value.split( d );
				if ( coords.length === 2 ) {
					lat.val( coords[ 0 ].trim() + ' ' + d );
					long.val( coords[ 1 ].trim() );
					return;
				}
			}
		}

		function parseCoord( coord, aDir ) {
			var s = coord.trim(), v, l;
			var result = { coord: s, error: 2 }; // 2 = is error
			if ( s === '' ) {
				result.error = 1;
				return result;
			}

			var mx = aDir === 'lat' ? 90 : 180;
			if ( isNaN( coord ) ) { // try conversion dms -> dec
				s = s.toUpperCase()
					.replace( /[‘’′´`]/ig, "'" )
					.replace( /''/ig, '"' )
					.replace( /[“”″]/ig, '"' )
					.replace( /[−–—]/ig, '-' )
					.replace( /[_\\\/\s\0]/ig, ' ' )
					.replace( /([A-Z])/ig, ' $1' )
					.replace( /\s*([°"\'])/ig, '$1 ' )
					.split( ' ' );
				for ( var i = s.length - 1; i >= 0; i-- ) {
					s[ i ] = s[ i ].trim();
					if ( s[ i ] === null || s[ i ] === '' )
						s.splice( i, 1 );
				}

				if ( s.length < 1 || s.length > 4 )
					return result;

				var units = [ '°', "'", '"', ' ' ];
				var res   = [ 0, 0, 0, 1 ]; // 1 = positive direction

				for ( i = 0; i < s.length; i++ ) {
					v = s[ i ].replace( units[ i ], '' );
					if ( !isNaN( v ) ) { // a number
						v = parseFloat( v );
						switch( i ) {
							case 3: // only for direction letter
								return result;
							case 0:
								res[ 0 ] = v;
								break;
							case 1:
							case 2:
								if ( v < 0 || v >= 60 || res[ i - 1 ] != Math.round( res[ i - 1 ] ))
									return result;
								res[ i ] = v;
						}
					} else { // not a number: allowed only at the last position
						if ( i == 0 || ( i + 1 ) != s.length || res[ 0 ] < 0 ||
							v.length !== 1 || !Config.COORD_LETTERS[ v ] )
							return result;
						l = Config.COORD_LETTERS[ v ];
						if ( aDir !== l.dir )
							return result;
						res[ 3 ] = l.factor;
					}
				}

				if ( res[ 0 ] < 0 ) {
					res[ 0 ] = -res[ 0 ];
					res[ 3 ] = -1;
				}
				result.coord = ( res[ 0 ] + res[ 1 ] / 60 + res[ 2 ] / 3600 ) * res[ 3 ];
				result.coord = Math.round( result.coord * 1E6 ) / 1E6; // only 6 digits
			}
			if ( coord < -mx || coord > mx || coord <= -180 )
				return result;

			result.error = 0;
			return result;
		}

		function checkCoordinates() {
			var lat = ELEMENTS.lat;
			var long = ELEMENTS.long;
			var latVal = removeComments( lat.val() );
			var longVal = removeComments( long.val() );

			var r = parseCoord( latVal, 'lat' );
			if ( r.coord !== latVal )
				lat.val( r.coord );
			var result = r.error;
			lat.toggleClass( 'listingeditor-invalid-input', r.error > 1 );

			r = parseCoord( longVal, 'long' );
			if ( r.coord !== longVal )
				long.val( r.coord );
			result += r.error;
			long.toggleClass( 'listingeditor-invalid-input', r.error > 1 );
			return result;
		}

		var checkCoordInput = function( form, mode ) {
			ELEMENTS.long.blur(function() {
				checkCoordinates();
			});
			ELEMENTS.lat.blur(function() {
				checkForSplit();
				checkCoordinates();
			}).trigger( 'blur' );
		};
		CREATE_FORM_CALLBACKS.push( checkCoordInput );

		/**
			Add listeners on various fields to update the "find on map" link.
		*/
		function getValFromInput( sel ) {
			var el = ELEMENTS[ sel ];
			if ( el.val() === '' && el.hasClass( 'listingeditor-wikidata-placeholder' ) )
				return el.attr( 'placeholder' );
			else
				return removeComments( el.val() );			
		}

		function getLatlngStr( form ) {
			var latlngStr = '?lang=' + Config.SYSTEM.wikiLang;
//			// page & location cause the geomap-link crash
//			latlngStr += '&page=' + encodeURIComponent( mw.config.get( 'wgTitle' ) );

			var lat = getValFromInput( 'lat' );
			var long = getValFromInput( 'long' );
			if ( lat === '' || long === '' ) {
				var indicator = $( Config.SELECTORS.geoIndicator );
				lat = indicator.attr( 'data-lat' ) || '';
				long = indicator.attr( 'data-lon' ) || '';
			}
			lat = parseCoord( lat, 'lat' );
			long = parseCoord( long, 'long' );
			if ( lat.error === 0 && long.error === 0 )
				latlngStr += '&lat=' + lat.coord + '&lon=' + long.coord + '&zoom=15';

//			var address = getValFromInput( 'address' );
//			var name = getValFromInput( 'name' );
//			if ( address !== '' )
//				latlngStr += '&location=' + encodeURIComponent( address );
//			else if ( name !== '' )
//				latlngStr += '&location=' + encodeURIComponent( name );

			return latlngStr;	
		}

		var initFindOnMapLink = function( form, mode ) {
			$( '.addMaplink', form ).parent()
				.append( $( '<div class="input-other"><a id="geomap-link" target="_blank">' + Config.STRINGS.searchOnMap + '</a></div>' ) );

			var geolink = $( '#geomap-link', form );
			function updateGeolink() {
				geolink.attr( 'href', Config.SYSTEM.geomap + getLatlngStr( form ) );
			}

			if ( geolink.length ) {
				ELEMENTS.address.change( updateGeolink );
				ELEMENTS.lat.change( updateGeolink );
				ELEMENTS.long.change( updateGeolink ).trigger( 'change' );
			}
		};
		CREATE_FORM_CALLBACKS.push( initFindOnMapLink );

		/**
			Add listeners on type selector field.
		*/
		function typesChanged( values, form ) {
			var color, different = false, first = '', group, i, obj, sleep = false, val;

			// make firstType first if existent
			if ( ELEMENTS.firstType !== '' ) {
				for ( i = 0; i < values.length; i++ ) {
					if ( values[ i ] == ELEMENTS.firstType ) {
						values.splice( i, 1 );
						values.unshift( ELEMENTS.firstType );
						break;
					}
					if ( i == values.length - 1 )
						ELEMENTS.firstType = '';
				}
			}

			for ( i = 0; i < values.length; i++ ) {
				val = values[ i ];
				for ( obj of Config.MODULE_TABLES.types )
					if ( obj.type === val ) {
						group = obj.group;
						break;
					}
				if ( i === 0 )
					first = group;
				else if ( group != first )
					different = true;
				if ( group == 'sleep' )
					sleep = true;
			}
			obj = ( sleep ? Config.HIDE_AND_SHOW.sleep : Config.HIDE_AND_SHOW[ first ] ) ||
				Config.HIDE_AND_SHOW.default;
			for( i of obj.show )
				$( '#' + i, form ).show();
			for( i of obj.hide )
				if ( $( '#' + i + ' input', form ).val() === '' )
					$( '#' + i, form ).hide();

			// set input shadow
			color = '#f0f0f0';
			for ( obj of Config.MODULE_TABLES.groups )
				if ( obj.group === first ) {
					color = obj.color;
					break;
				}
			obj = $( '#div_type .chosen-choices', form );
			if ( obj.length )
				obj.css( 'box-shadow', '20px 0 0 0 ' + color + ' inset' );
			else {
				// chosen plugin is maybe not yet active
				var style = '#div_type .chosen-choices { box-shadow: 20px 0 0 0 ' + color + ' inset }';
				$( 'head' ).append( '<style type="text/css">' + style + '</style>' );
			}

			// set hint to group
			$( '.group-hint', form ).text( different ? Config.STRINGS.severalGroups : Config.STRINGS.ifNecessary );
		}

		var initTypeSelector = function( form, mode ) {
			ELEMENTS.group.parent().append( $( '<div class="input-other group-hint"></div>' ) );
			ELEMENTS.type.on( 'keydown keyup change click' , function() {
				typesChanged( $( this ).val(), form );
			}).trigger( 'keyup' );
		};
		CREATE_FORM_CALLBACKS.push( initTypeSelector );
		
		var initGroupSelector = function( form, mode ) {
			ELEMENTS.group.on( 'keydown keyup change click', function() {
				var color = '#f0f0f0', obj;
				for ( obj of Config.MODULE_TABLES.groups )
					if ( obj.group === this.value ) {
						color = obj.color;
						break;
					}
				$( '#input_group_chosen .chosen-single', form )
					.css( 'box-shadow', '20px 0 0 0 ' + color + ' inset' );
			}).trigger( 'keyup' );
		};
		CREATE_FORM_CALLBACKS.push( initGroupSelector );
		
		var initLastEditCheckBox = function( form, mode ) {
			$( Config.SELECTORS.editorLastedit, form ).change( function() {
				if ( this.checked && $( '#div_lastedit', form ).is( ':visible' ) )
					ELEMENTS.lastedit.val( getCurrentDate() );
			});
		};
		CREATE_FORM_CALLBACKS.push( initLastEditCheckBox );

		var hideEditOnlyFields = function( form, mode ) {
			if ( mode !== Config.MODES.edit )
				$( '#span-delete', form ).hide();
		};
		CREATE_FORM_CALLBACKS.push( hideEditOnlyFields );

		// Check against regex
		function regexTest( field, val ) {
			var i, s, sRegex, test = true, valTab;
			val = val.trim();
			if ( field.sep ) {
				sRegex = new RegExp( '(' + field.sep + ')(?![^(]*\\))', 'ig' );
				valTab = val.split( sRegex );
				sRegex = new RegExp( '^(' + field.sep.replace( / /g , '' ) + ')$', 'ig' );
				for ( i = valTab.length - 1; i >= 0; i-- ) {
					valTab[ i ] = valTab[ i ].trim().replace( sRegex, '' );
					if ( valTab[ i ] === '' ) valTab.splice( i, 1 );
				}
			} else
				valTab = [ val ];
			for ( s of valTab ) {
				test = field.regex.test( s );
				if ( !test ) break;
			}
			return test;
		}

		// Field checks against regex
		function initCheckAgainstRegex( key, field, form ) {
			var val10;
			ELEMENTS[ key ].blur( function() {
				var _this = $( this, form );
				var val = removeComments( _this.val() );
				if ( field.wd && val !== '' && checkYesNo( val ) !== '' )
					_this.removeClass( 'listingeditor-invalid-input' );
				else {
					val10 = val.substr( 0, 10 );
					if ( key === 'url' && !regexTest( field, val ) &&
						val.search( 'ht' ) !== 0 && val10.search( ':' ) < 0 &&
						val10.search( '//' ) < 0 ) {
						val10 = 'http://' + val;
						if ( regexTest( field, val10 ) ) {
							val = val10;
							_this.val( val );
						}
					}
					_this.toggleClass( 'listingeditor-invalid-input',
						val !== '' && !regexTest( field, val ) );
				}
			}).trigger( 'blur' );
		}

		var checkFields = function( form, mode ) {
			for ( var parameter in Config.FIELDS )
				initCheckAgainstRegex( parameter, Config.FIELDS[ parameter ], form);
		};
		CREATE_FORM_CALLBACKS.push( checkFields );

		function setDefaultPlaceholders( form ) {
			for ( var parameter in Config.PARAMETERS ) {
				var obj = Config.PARAMETERS[ parameter ];
				if ( obj.ph && ( !obj.tp || obj.tp !== 'select' ) )
					ELEMENTS[ parameter ].attr( 'placeholder', obj.ph )
						.addClass( 'listingeditor-default-placeholder' )
						.removeClass( 'listingeditor-wikidata-placeholder' );
			}
			$( Config.SELECTORS.wikidataLabel ).attr( 'placeholder', Config.PARAMETERS.wikidata.ph )
				.addClass( 'listingeditor-default-placeholder' );
		}

		function updatePlaceholder( key, value ) {
			if ( value && ELEMENTS[ key ] )
				ELEMENTS[ key ].attr( 'placeholder', value )
					.addClass( 'listingeditor-wikidata-placeholder' )
					.removeClass( 'listingeditor-default-placeholder' )
					.trigger( 'change' );
		}

		function updatePlaceholders( id, form ) {
			setDefaultPlaceholders( form );

			var success = function( jsonObj ) {
				var item, key, res;
				var addSubtypes = $( '#listingeditor-additionalSubtypes' );
				addSubtypes.hide();
				wdResults = {};
				for ( key in Config.WIKIDATA_CLAIMS ) {
					item = Config.WIKIDATA_CLAIMS[ key ];
					res = Wikibase.getStatements( id, jsonObj, item );
					if ( res )
						wdResults[ key ] = res;
				}
				if ( !wdResults.address && wdResults[ 'address-local' ] ) {
					wdResults.address = wdResults[ 'address-local' ];
					delete wdResults[ 'address-local' ];
				}
				for ( key in wdResults ) {
					if ( key === 'subtype' ) {
						wdResults.subtype = sortSubtypes( wdResults.subtype );
						addSubtypes.show();
						continue;
					}
					updatePlaceholder( key, wdResults[ key ] );
					if ( key === 'name' )
						$( Config.SELECTORS.wikidataLabel ).attr( 'placeholder', wdResults.name )
							.addClass( 'listingeditor-default-placeholder' );				}
			};
			Wikibase.getEntity( id, success );
		}

		function wikidataLink( form, value ) {
			$( '#wikidata-value-link', form ).html( $( '<a />', {
				target: '_new',
				href: Config.SYSTEM.Wikidata_Wiki + mw.util.wikiUrlencode(value),
				title: Config.STRINGS.viewWikidataPage,
				text: value
			}) );
			if ( !Config.OPTIONS.defaultAuto )
				ELEMENTS.auto.val( 'y' ).trigger( 'chosen:updated' );
			$( '#wikidata-value-display-container', form ).show();
			$( '#div_auto', form ).show();
		}

		function updateSiteLink(siteLinkData, form) {
			var input = $( siteLinkData.inputSelector, form );
			var siteLink = $( siteLinkData.linkSelector, form );
			var val = removeComments( input.val() || '' );
			if ( val === '' && input.hasClass( 'listingeditor-wikidata-placeholder' ) )
				val = input.attr( 'placeholder' );
			if ( val === '' )
				siteLink.hide();
			else {
				siteLinkData.href = Config.SYSTEM.Commons_Wiki +
					mw.util.wikiUrlencode(siteLinkData.namespace + val);
				var link = $("<a />", {
					target: "_new",
					href: siteLinkData.href,
					title: siteLinkData.linkTitle
				}).append( $( siteLinkData.text ) );
				siteLink.html(link).show();
			}
		}

		function commonsLink(value, form) {
			var siteLinkData = {
				inputSelector: '#input-image',
				linkSelector: '#image-value-link',
				namespace: 'File:',
				linkTitle: Config.STRINGS.viewCommonsPageTitle,
				text: Config.STRINGS.linkText
			};
			updateSiteLink( siteLinkData, form );
		}

		function commonscatLink(value, form) {
			var siteLinkData = {
				inputSelector: '#input-commonscat',
				linkSelector: '#commonscat-value-link',
				namespace: 'Category:',
				linkTitle: Config.STRINGS.viewCommonscatPageTitle,
				text: Config.STRINGS.linkText
			};
			updateSiteLink( siteLinkData, form );
		}

		function updateFieldIfNotNull( key, value ) {
			if ( value )
				ELEMENTS[ key ].val( value );
		}

		function updateWikidataSharedFields( form ) {
			var key, msg = '';

			for ( key in wdResults )
				msg += '\n' + Config.PARAMETERS[ key ].label + ': ' +
					( typeof wdResults[ key ] == 'object' ? wdResults[ key ].join( ', ' ) : wdResults[ key ] );

			if ( msg !== '' ) {
				if ( confirm( Config.STRINGS.wikidataShared + '\n' + msg ) ) {
					for ( key in wdResults ) {
						switch( key ) {
							case 'image':
								updateFieldIfNotNull( 'image', wdResults.image );
								commonsLink( wdResults.image, form );
								break;
							case 'commonscat':
								updateFieldIfNotNull( 'commonscat', wdResults.commonscat );
								commonscatLink( wdResults.commonscat, form );
								break;
							case 'subtype':
								if ( wdResults.subtype.length ) {
									var sel = ELEMENTS.subtype, i, j;
									var old = sel.val();
									for ( i = 0; i < old.length; i++ ) {
										for ( j = wdResults.subtype.length - 1; j >= 0; j-- ) {
											if ( wdResults.subtype[ j ] == old[ i ] ) {
												wdResults.subtype.splice( j, 1 );
												break;
											}
										}
									}
									sel.val( old.concat( wdResults.subtype ) )
										.trigger( 'chosen:updated' );
								}
								break;
							default:
								updateFieldIfNotNull( key, wdResults[ key ] );
						}
					}
					ELEMENTS.auto.val( '' ).trigger( 'chosen:updated' );
					ELEMENTS.name.focus();
				}
			} else
				alert( Config.STRINGS.wikidataSharedNotFound );
		}

		function parseWikiDataResult( jsonObj ) {
			var results = [];
			for ( var result of $( jsonObj.search ) ) {
				var label = result.label;
				if ( result.match && result.match.text )
					label = result.match.text;
				var data = {
					value: label,
					label: label,
					description: result.description,
					id: result.id
				};
				results.push( data );
			}
			return results;
		}

		var wikidataLookup = function( form, mode ) {
			// get the display value for the pre-existing wikidata record ID
			var wikidataRemove = function(form) {
				ELEMENTS.wikidata.val('');
				$(Config.SELECTORS.wikidataLabel, form).val('');
				$('#input-auto').val('');
				$('#wikidata-tools', form).hide();
				$('#div_auto', form).hide();
				setDefaultPlaceholders(form);
			};

			var id = removeComments( ELEMENTS.wikidata.val() );
			if ( id ) {
				wikidataLink( form, id );
				var success = function( jsonObj ) {
					var id = ELEMENTS.wikidata.val();
					var label = Wikibase.getLabels( id, jsonObj ) || '';
					label = label.wiki !== '' ? label.wiki : id;
					$( Config.SELECTORS.wikidataLabel ).val( label );
				};
				Wikibase.getEntity( id, success, 'labels' );
				updatePlaceholders( id, form );
			} else
				wikidataRemove(form);
			// set up autocomplete to search for results as the user types
			$( Config.SELECTORS.wikidataLabel, form ).autocomplete({
				source: function( request, response ) {
					var ajaxUrl = Config.SYSTEM.Wikidata_API;
					var ajaxData = {
						action: 'wbsearchentities',
						search: request.term,
						language: Config.SYSTEM.wikiLang,
						uselang: Config.SYSTEM.wikiLang
					};
					var ajaxSuccess = function( jsonObj ) {
						response(parseWikiDataResult(jsonObj));
					};
					Sister.ajaxQuery( ajaxUrl, ajaxData, ajaxSuccess );
				},
				select: function(event, ui) {
					ELEMENTS.wikidata.val(ui.item.id);
					wikidataLink('', ui.item.id);

					updatePlaceholders(ui.item.id, form );
				}
			}).data( 'ui-autocomplete' )._renderItem = function( ul, item ) {
				var label = mw.html.escape( item.label ) + ' <small>' + item.id + '</small>';
				if ( item.description )
					label += '<br /><small>' + mw.html.escape( item.description ) + '</small>';
				return $( '<li>' ).data( 'ui-autocomplete-item', item )
					.append( $( '<a>' ).html( label )).appendTo( ul );
			};
			// add a listener to the "remove" button so that links can be deleted
			$('#wikidata-remove', form).click(function() {
				if ( confirm( Config.STRINGS.deleteMessage ) )
					wikidataRemove(form);
			});
			$( Config.SELECTORS.wikidataLabel, form ).change(function() {
				if ( !$(this).val() )
					wikidataRemove(form);
			});
			$( '#listingeditor-additionalSubtypes a', form ).click( function() {
				var msg = [], t;
				if ( wdResults.subtype )
					for ( t of wdResults.subtype ) {
						t = t.split( ':' );
						t[ 1 ] = t.length > 1 ? parseInt( t[ 1 ] ) : 1;
						if ( Config.MODULE_TABLES.subtypeList[ t[ 0 ] ] )
							t[ 0 ] = Config.MODULE_TABLES.subtypeList[ t[ 0 ] ].n; // translate subtypes
						if ( t[ 0 ].indexOf( '[' ) > -1 ) {
							if ( t[ 1 ] > 1 )
								t[ 0 ] = t[ 1 ] + ' ' + t[ 0 ].replace( /\[([^\[\]]*)(\|[^\[\]]*)?\]/g, '$1' );
							else
								t[ 0 ] = t[ 0 ].replace( /\[([^\[\]]*)\|([^\[\]]*)\]/g, '$2' );
						}
						msg.push( t[ 0 ].replace( /\[([^\[\]]*)\]/g, '' )
							.replace( /[,;\/].*$/ig, '' ) );
					}
				msg = msg.join( ', ' );
				if ( msg === '' )
					msg = Config.STRINGS.unknownSubtypes;
				alert( Config.STRINGS.additionalSubtypes + ':\n\n' + msg );
			});
			$('#wikidata-shared', form).click(function() {
				updateWikidataSharedFields( form );
			});
			ELEMENTS.image.parent().append( $( '<div id="image-value-link" class="input-other"></div>' ) );
			Sister.initializeAutocomplete( {
				apiUrl: Config.SYSTEM.Commons_API,
				selector: ELEMENTS.image,
				form: form,
				ajaxData: { namespace: 6 },
				updateLinkFunction: commonsLink
			} );
			ELEMENTS.commonscat.parent().append( $( '<div id="commonscat-value-link" class="input-other"></div>' ) );
			Sister.initializeAutocomplete( {
				apiUrl: Config.SYSTEM.Commons_API,
				selector: ELEMENTS.commonscat,
				form: form,
				ajaxData: { namespace: 14 },
				updateLinkFunction: commonscatLink
			} );
		};
		CREATE_FORM_CALLBACKS.push( wikidataLookup );

		var selectPreview = function(form, mode) {
			$( 'input[name=previewSelect]', form ).click( function() {
				var checked = $( '#select-preview', form ).prop( 'checked' );
				$( '#listingeditor-preview-text', form ).toggle( checked );
				$( '#listingeditor-preview-syntax', form ).toggle( !checked );
			});
		};
		CREATE_FORM_CALLBACKS.push( selectPreview );

		var addLinks = function( form, mode ) {
			$( '.addLink', form ).each( function() {
				var _this = $( this );
				var id = _this.attr('id').replace( 'input-', '' );
				_this.parent().append( $( '<div class="input-other"></div>' )
					.attr( 'id', 'link-' + id ) );
				_this.change( function() {
					var val = removeComments( _this.val() );
					if ( val === '' && _this.hasClass( 'listingeditor-wikidata-placeholder' ) )
						val = _this.attr( 'placeholder' );
					if ( val !== '' && checkYesNo( val ) === '' ) {
						if ( val.indexOf( 'http' ) )
							val = mw.format( Config.LINK_FORMATTERS[ id ], val );
						var link = $( '<a />', {
							target: '_new',
							href: val,
							title: Config.STRINGS.linkTitle,
						}).append( $( Config.STRINGS.linkText ) ) ;
						$( '#link-' + id, form ).html( link );
					} else
						$( '#link-' + id, form ).empty();
					var tabables = $( "input[tabindex != '-1']:visible", form );
					var index = tabables.index( this );
					if ( !ELEMENTS.name.is( ':focus' ) )
						tabables.eq( index + 1 ).focus();
				}).trigger( 'change' );
			});
		};
		CREATE_FORM_CALLBACKS.push( addLinks );

		var chosenInit = function( form, mode ) {
			$( '.chosen-select', form ).chosen( Config.CHOSEN_OPTIONS );
			ELEMENTS.show.change( function() {
				var coordGroup = $( '#listing-show-coordinate option', form );
				var isCoord = false;
				coordGroup.each( function() {
					if ( $( this ).is( ':selected' ) )
						isCoord = true;
				});
				if ( isCoord )
					coordGroup.each( function() {
						if ( !$( this ).is( ':selected' ) )
							$( this ).prop( 'disabled', true );
					});
				else
					coordGroup.prop( 'disabled', false );

				var showGroup = $( '#listing-show-block option', form );
				var isShow = false;
				showGroup.each( function() {
					if ( $( this ).is( ':selected' ) )
						isShow = true;
				});
				if ( isShow )
					showGroup.each( function() {
						if ( !$( this ).is( ':selected' ) )
							$( this ).prop( 'disabled', true );
					});
				else
					showGroup.prop( 'disabled', false );

				$( this ).trigger( 'chosen:updated' );
			}).trigger( 'change' );
			ELEMENTS.group.trigger( 'keyup' );
		};
		CREATE_FORM_CALLBACKS.push( chosenInit );
		
		// --------------------------------------------------------------------
		// LISTING EDITOR FORM SUBMISSION CALLBACKS
		// --------------------------------------------------------------------

		/**
			Return the current date in the format "2020-01-31".
		*/
		var getCurrentDate = function() {
			var today = new Date();
			var date = today.getFullYear() + '-';
			// Date.getMonth() returns 0-11
			date += ( today.getMonth() + 1 ).toString().padStart( 2, '0' ) + '-';
			return date + today.getDate().toString().padStart( 2, '0' );
		};

		/**
			Only update last edit date if this is a new listing or if the
			"information up-to-date" box checked.
		*/
		var updateLastEditDate = function( listing, origListing, mode ) {
			var currentDate = getCurrentDate(),
				editorLastedit = $( Config.SELECTORS.editorLastedit );

			for ( var p in Config.ParametersForLastedit ) {
				if ( listing[ p ] !== ( origListing[ p ] || '' ) ) {
					editorLastedit.prop( 'checked', true );
					break;
				}
			}

			if ( editorLastedit.is( ':checked' ) ) {
				listing.lastedit = currentDate;
			} else if ( listing.lastedit !== '' ) {
				listing.lastedit = listing.lastedit.replace( /\-(\d)\-/g, '-0$1-' )
					.replace( /\-(\d)$/g, '-0$1' );
				if ( listing.lastedit !== currentDate && confirm( Config.STRINGS.updateLastedit ) )
					// with OK/Cancel buttons, Yes/No is more complex
					listing.lastedit = currentDate;
			}
		};
		SUBMIT_FORM_CALLBACKS.push( updateLastEditDate );

		// --------------------------------------------------------------------
		// LISTING EDITOR FORM VALIDATION CALLBACKS
		// --------------------------------------------------------------------

		/**
		 * Verify all listings have at least a name, address or alt value.
		 */
		var validateListingHasData = function( validationFailureMessages ) {
			var name = ELEMENTS.name;
			var wikidata = ELEMENTS.wikidata.val();
			// Fill name field from Wikidata
			if ( name.val() === '' && wikidata !== '' &&
				name.filter( '.listingeditor-wikidata-placeholder' ).length > 0 ) {
				name.val( name.attr( 'placeholder' ) );
				return;
			}
			if ( name.val() === '' && ELEMENTS.address.val() === '' &&
				ELEMENTS.alt.val() === '' && wikidata === '' ) 
				validationFailureMessages.push( Config.STRINGS.validationEmptyListing );
		};
		VALIDATE_FORM_CALLBACKS.push( validateListingHasData );

		/**
			Delete group parameter if identical to types group.
		*/
		var isGroupNecessary = function( validationFailureMessages ) {
			var types = ELEMENTS.type.val();
			var group = ELEMENTS.group;
			var wikidata = ELEMENTS.wikidata.val();

			if ( types.length === 0 && group.val() === '' && wikidata === '' ) {
				validationFailureMessages.push(Config.STRINGS.validationType);
				return;
			}
			if ( types.length === 0 )
				return;

			var different = false, first = '', i, obj;
			for ( i = 0; i < types.length; i++ )
				for ( obj of Config.MODULE_TABLES.types )
					if ( types[ i ] === obj.type ) {
						if ( i === 1 )
							first = obj.group;
						if ( first !== obj.group )
							different = true;
						break;
					}
			if ( different )
				return;
			// if type group equals group then delete group
			if ( first === group )
				group.val( '' );
		};
		VALIDATE_FORM_CALLBACKS.push( isGroupNecessary );

		/**
			Validate coordinates
		*/
		var validateCoords = function( validationFailureMessages ) {
			var lat = removeComments( ELEMENTS.lat.val() );
			var long = removeComments( ELEMENTS.long.val() );
			if ( lat === '' && long === '' )
				return;
			if ( lat === '' ) {
				validationFailureMessages.push( Config.STRINGS.validationMissingCoord );
				return;
			}
			checkForSplit();
			if ( long === '' ) {
				validationFailureMessages.push( Config.STRINGS.validationMissingCoord );
				return;
			}
			if ( checkCoordinates() > 0 )
				validationFailureMessages.push( Config.STRINGS.validationCoord );
		};
		VALIDATE_FORM_CALLBACKS.push( validateCoords );
		
		/**
			Implement SIMPLE RegExp validation. Invalid entries can
			still get through, but this method implements a minimal amount of
			validation in order to catch the worst offenders.
		*/

		var validateFields = function( validationFailureMessages ) {
			var field, parameter, val;
			for ( parameter in Config.FIELDS ) {
				field = Config.FIELDS[ parameter ];
				val = ELEMENTS[ parameter ].val().trim();
				if ( field.wd && val !== '' && checkYesNo( val ) !== '' )
					return;
				if ( val !== '' && !regexTest( field, val ) )
					validationFailureMessages.push( field.m );
			}
		};
		VALIDATE_FORM_CALLBACKS.push( validateFields );

		// remove identical names
		var ckeckNames = function( key1, key2 ) {
			var val = removeComments( ELEMENTS[ key1 ].val().toLowerCase() ); // case-insensitve check
			if ( val !== '' && val === removeComments( ELEMENTS[ key2 ].val().toLowerCase() ) ) {
				ELEMENTS[ key2 ].val( '' );
				return 1;
			}
			return 0;
		};

		var checkMultipleNames = function( validationFailureMessages ) {
			var result = ckeckNames( 'name', 'name-local' );
			result += ckeckNames( 'alt', 'comment' );
			result += ckeckNames( 'name', 'alt' );
			result += ckeckNames( 'name', 'comment' );
			result += ckeckNames( 'address', 'address-local' );
			result += ckeckNames( 'directions', 'directions-local' );
			if ( result > 0 )
				validationFailureMessages.push( Config.STRINGS.validationNames );
		};
		VALIDATE_FORM_CALLBACKS.push( checkMultipleNames );

		// expose public members
		return {
			CREATE_FORM_CALLBACKS: CREATE_FORM_CALLBACKS,
			SUBMIT_FORM_CALLBACKS: SUBMIT_FORM_CALLBACKS,
			VALIDATE_FORM_CALLBACKS: VALIDATE_FORM_CALLBACKS,
			ELEMENTS: ELEMENTS,
			checkYesNo: checkYesNo,
			removeComments: removeComments,
			sortSubtypes: sortSubtypes
		};
	}();

// ----------------------------------- Core -----------------------------------

	/**
		Core contains code that should be shared across different Wikivoyage
		languages. This code uses the custom configurations in the Config and
		Callback modules to initialize the listing editor and process add and
		update requests for listings.
	*/

	var Core = function() {
		var api = new mw.Api();

		var displayBlock = false;
		var inlineListing, inlineDetected,
			replacements = {}, selectComments = {}, sectionText;

		/**
			Form additions before populating the form inputs
		*/

		var additionsToForm = function(mode, clicked, form) {
			var c, data, dataFor, obj, t;

			var listing = clicked.closest( '.vcard' ), body = $( 'body' );
			var getAttr = function( attr ) {
				var d = mode === Config.MODES.edit ? listing.attr( attr ) : null;
				return d || body.attr( attr ) || '';
			};

			var addAlias = function( tab, aliasObj, indx ) {
				if ( !tab || !aliasObj || !aliasObj.alias ) return;

				var t = aliasObj[ indx ].replace( /[_\s]+/g, '_' );
				if ( typeof( aliasObj.alias ) === 'string' )
					tab[ aliasObj.alias ] = t;
				else
					for ( var alias of aliasObj.alias )
						tab[ alias ] = t;
			};

			var addQualifier = function( qualifiers, obj ) {
				if ( typeof obj.wd === 'string' )
					qualifiers[ obj.wd ] = obj.type;
				else if ( obj.wd )
					for ( t of obj.wd )
						qualifiers[ t ] = obj.type;
			};

			var addOption = function( selector, value, label ) {
				selector.append( $( '<option></option>' ).attr( 'value', value ).text( label ) );
			};

			var addChar = function( char, dataFor, title, dataType ) {
				return mw.format( ' <span class="editor-charinsert" data-for="$1" data-type="$2"><a href="javascript:" title="$3">$4</a></span>',
					dataFor, dataType || '', title, char );	
			};

			// setting search languages
			var localLang = getAttr( 'data-lang' );
			Config.SYSTEM.localLang = '';
			if ( Config.SYSTEM.wikiLang != localLang )
				Config.SYSTEM.localLang = localLang;
			Config.SYSTEM.searchLang = [ Config.SYSTEM.wikiLang ];
			for ( c of Config.SYSTEM.addSearchLang )
				if ( c != Config.SYSTEM.wikiLang && c != localLang )
					Config.SYSTEM.searchLang.push( c );

			// adding language to local names
			$( '.editor-foreign', form ).attr( 'dir', getAttr( 'data-dir' ) ).attr( 'lang', localLang );
			$( '.addLocalLang', form ).each( function() {
				$( this ).parent().append( $( '<div class="input-other editor-local-lang"></div>' ) );
			});
			data = getAttr( 'data-lang-name' );
			if ( data !== '' && localLang != Config.SYSTEM.wikiLang )
				$( '.editor-local-lang', form ).text( data );

			// adding national and international currency symbols
			$( '.addCurrencies', form ).each( function() {
				$( this ).parent().append( $( '<div class="input-other currency-chars"></div>' ) );
			});

			var html = '';
			data = getAttr( 'data-currency' );
			if ( data !== '' ) {
				var natlCurrencies = data.split( ',' ).map( function( item ) {
					return addChar( item.trim(), 'input-price', Config.STRINGS.natlCurrencyTitle, 'currency-char' );
				});
				if ( natlCurrencies.length )
					html += natlCurrencies.join( '' ) + ' |';
			}
			for ( c of Config.CHARS.intlCurrencies )
				html += addChar( c, 'input-price', Config.STRINGS.intlCurrencyTitle, 'currency-char' );
			$( '.currency-chars', form ).append( html );

			// adding country and local calling code
			$( '.addCC', form ).each( function() {
				var _this = $( this );
				_this.parent().append(
					$( mw.format( '<div class="input-other input-cc$1" data-for="$2"></div>',
						_this.hasClass( 'addLocalCC' ) ? ' input-cc-local' : '', _this.attr( 'id' ) ) ) );
			});

			var ccLocal = [];
			data = getAttr( 'data-local-calling-code' );
			if ( data !== '' ) {
				var trunkPrefix = getAttr( 'data-trunk-prefix' );
				ccLocal = data.split( ',' ).map( function( item ) {
					item = item.trim();
					// adding trunk prefix if missing
					if ( trunkPrefix !== '' && item.substr( 0, trunkPrefix.length ) !== trunkPrefix )
						item = trunkPrefix + item;
					return item;
				});
			}

			data = getAttr( 'data-country-calling-code' );
			if ( data !== ''  || ccLocal.length > 0 ) {
				$( '.input-cc', form ).each( function() {
					html = '';
					dataFor = $( this ).attr( 'data-for' );
					if ( data !== '' )
						html += addChar( data, dataFor, Config.STRINGS.callingCodeTitle, 'phone-char' );
					$( this ).append( html );
				});
				$( '.input-cc-local', form ).each( function() {
					html = '';
					dataFor = $( this ).attr( 'data-for' );
					for ( c of ccLocal ) {
						// exception for Italy and San Marino
						if ( data !== '+39' && data !== '+378' )
							c = c.replace(/^0/ig, '(0)');
						html += addChar( c, dataFor, Config.STRINGS.callingCodeTitle, 'phone-char' );
					}
					$( this ).append( html );
				});
			}

			// adding counter and special chars to description label
			html = '<br /><br />';
			for ( c of Config.CHARS.specialChars )
				html += addChar( c, 'input-description', Config.STRINGS.specialCharsTitle );
			$( '#div_description label', form ).parent()
				.append( $( '<br /><span id="counter-description"></span>' ) )
				.append( html );

			// populating select fields
			var subtypeQualifiers = {};

			for ( obj of Config.MODULE_TABLES.types ) {
				addOption( Callbacks.ELEMENTS.type, obj.type, obj.label );
				Config.MODULE_TABLES.typeList[ obj.type ] = obj.label; // label is dummy value
				addAlias( Config.MODULE_TABLES.typeAliases, obj, 'type' );

				if ( Config.MODULE_TABLES.subtypes ) {
					Config.MODULE_TABLES.subtypeList[ obj.type ] =
						{ g: Config.MODULE_TABLES.subtypeGroups + 1, wd: obj.wd, n: obj.label };
					addAlias( Config.MODULE_TABLES.subtypeAliases, obj, 'type' );
					addQualifier( subtypeQualifiers, obj );
				}
			}

			for ( obj of Config.MODULE_TABLES.groups ) {
				if ( !obj.is )
					addOption( Callbacks.ELEMENTS.group, obj.group, obj.label );
				Config.MODULE_TABLES.groupList[ obj.group ] = obj.label;
				addAlias( Config.MODULE_TABLES.groupAliases, obj, 'group' );
			}
			for ( obj of Config.MODULE_TABLES.groups )
				if ( obj.is && obj.is === 'color' )
					addOption( Callbacks.ELEMENTS.group, obj.group, obj.label );

			if ( Config.MODULE_TABLES.subtypes )
				for ( obj of Config.MODULE_TABLES.subtypes ) {
					addOption( Callbacks.ELEMENTS.subtype, obj.type, obj.n
						.replace( /\[([^\[\]]*)\|([^\[\]]*)\]/ig, '$2' )
						.replace( /\[([^\[\]]*)\]/ig, '' ) );
					Config.MODULE_TABLES.subtypeList[ obj.type ] =
						{ g: obj.g, wd: obj.wd, n: obj.n, f: obj.f };
					addAlias( Config.MODULE_TABLES.subtypeAliases, obj, 'type' );
					addQualifier( subtypeQualifiers, obj );
				}
			Config.WIKIDATA_CLAIMS.subtype.table = subtypeQualifiers;
		};

		var splitParameters = function( parameter, table, aliases, aliases2, form, selector ) {
			parameter = parameter.toLowerCase()
				.split( ',' ).map( function( item ) {
					return item.trim();
				});
			// translate aliases to types
			for ( var i in parameter ) {
				parameter[ i ] = parameter[ i ].replace(/[_\s]+/g, '_');
				if ( aliases2 && aliases2[ parameter[ i ] ] )
					parameter[ i ] = aliases2[ parameter[ i ] ];
				if ( aliases && aliases[ parameter[ i ] ] )
					parameter[ i ] = aliases[ parameter[ i ] ];
			}
			// remove duplicates
			parameter = parameter.filter( function( value, index, self ) {
				return self.indexOf( value ) === index;
			});
			for ( i = parameter.length - 1; i >= 0; i-- ) {
				// remove empty items
				if ( !parameter[ i ] || parameter[ i ] === '' ) {
					parameter.splice( i, 1 );
					continue;
				}
				// handle unknown items (custom types)
				if ( !table[ parameter[ i ] ] ) {
					if ( !selector || selector === '' )
						parameter.splice( i, 1 );
					else
						$( selector, form )
							.append( $( '<option></option>' ).attr( 'value', parameter[ i ] ).text( parameter[ i ] ) );
				}
			}
			return parameter;
		};

		var checkShowOptions = function( parameter ) {
			var options = {}, i, par;
			for ( par of parameter )
				options[ par ] = 'o';
			if ( options.poi && options.coord && !options.all ) {
				options.all = 'o';
				parameter.push( 'all' );
			}
			for ( i = parameter.length - 1; i >= 0; i-- ) {
				if ( ( options.none || options.all ) &&
					( parameter[ i ] === 'poi' || parameter[ i ] === 'coord' ) )
					parameter.splice( i, 1 );
				if ( options.none && parameter[ i ] === 'all' )
					parameter.splice( i, 1 );
				if ( options.inline && parameter[ i ] === 'outdent' )
					parameter.splice( i, 1 );
			}
			return parameter;
		};

		/**
			Generate the form UI for the listing editor.  If editing an existing
			listing, pre-populate the form input fields with the existing values.
		*/
		var createForm = function( mode, listingAsMap, clicked ) {
			var form = $( Config.EDITOR_FORM_HTML );

			for ( var parameter in Config.PARAMETERS )
				Callbacks.ELEMENTS[ parameter ] = $( '#' + Config.getInputId( parameter ), form );

			additionsToForm( mode, clicked, form );

			// multiple select lists
			var l = listingAsMap.type || '';
			l = splitParameters( l, Config.MODULE_TABLES.typeList,
				Config.MODULE_TABLES.typeAliases, Config.MODULE_TABLES.groupAliases, form, '#input-type' );
			if ( l.length ) Callbacks.ELEMENTS.firstType = l[ 0 ];
			listingAsMap.type = l;

			l = listingAsMap.group;
			if ( l && Config.MODULE_TABLES.groupAliases[ l ] )
				listingAsMap.group = Config.MODULE_TABLES.groupAliases[ l ];
			if ( l && l !== '' && !Config.MODULE_TABLES.groupList[ l ] )
				Callbacks.ELEMENTS.group.append( '<option value="' + l + '">' + l + '</option>' );

			l = listingAsMap.subtype || '';
			l = splitParameters( l, Config.MODULE_TABLES.subtypeList,
				Config.MODULE_TABLES.subtypeAliases, null, form, '#input-subtype' );
			listingAsMap.subtype = l;

			l = listingAsMap.show || '';
			l = splitParameters( l, Config.SHOW_OPTIONS, null, null, form, null );
			l = checkShowOptions( l );
			listingAsMap.show = l;

			l = listingAsMap.name || '';
			if ( l === '' && mode === Config.MODES.edit )
				listingAsMap.name = clicked.closest( '.vcard' ).attr( 'data-name' ) || '';
			if ( !Config.OPTIONS.defaultAuto && listingAsMap.wikidata && !listingAsMap.auto )
				listingAsMap.auto = 'y';

			// populate the empty form with existing values
			for ( parameter in Config.PARAMETERS ) {
				var parameterInfo = Config.PARAMETERS[ parameter ];
				if ( listingAsMap[ parameter] )
					Callbacks.ELEMENTS[ parameter ].val( listingAsMap[ parameter ] );
				else if ( parameterInfo.hideDivIfEmpty )
					$( '#' + parameterInfo.hideDivIfEmpty, form ).hide();
			}
			for ( var f of Callbacks.CREATE_FORM_CALLBACKS )
				f( form, mode );
			return form;
		};

		/**
			Wrap the h2/h3 heading tag and everything up to the next section
			(including sub-sections) in a div to make it easier to traverse the DOM.
			This change introduces the potential for code incompatibility should the
			div cause any CSS or UI conflicts.
		*/
		var getContentSelector = function() {
			var containers = [ '#bodyContent', '#mw_contentwrapper' ]; // Vector, Modern
			for ( var c of containers )
				if ( $( c ).length ) {
					Config.SELECTORS.content = c;
					break;
				}
			return Config.SELECTORS.content;
		};

		var wrapContent = function() {
			unwrapContent();
			$( Config.SELECTORS.content + ' h2.voy-editsection' ).each( function() {
				if ( $( this ).closest( '.toctitle' ).length === 0 ) // not for toc
					$( this ).nextUntil( 'h1.voy-editsection, h2.voy-editsection')
						.addBack() // adding $( this ) element
						.wrapAll( '<div class="voy-h2-section" />' );
			});
			$( Config.SELECTORS.content + ' h3.voy-editsection' ).each( function() {
				$( this ).nextUntil( 'h1.voy-editsection, h2.voy-editsection, h3.voy-editsection' )
					.addBack()
					.wrapAll( '<div class="voy-h3-section" />' );
			});
		};

		var unwrapContent = function() {
			$( '.voy-h3-section, .voy-h2-section' ).replaceWith( function() {
				return $( this ).contents();
			});
		};

		/**
			Place an "add listing" link at the top of each section heading next to
			the "edit" link in the section heading.
		*/
		var addListingButtons = function() {
			if ( $( Config.DISALLOW_ADD_LISTING_IF_PRESENT.join( ',' ) ).length )
				return false;
			for ( var sectionId in Config.SECTION_TO_DEFAULT_TYPE ) {
				// do not search using "#id" for two reasons.  one, the article might
				// re-use the same heading elsewhere and thus have two of the same ID.
				// two, unicode headings are escaped ("è" becomes ".C3.A8") and the dot
				// is interpreted by JQuery to indicate a child pattern unless it is
				// escaped
				var topHeading = $( 'h2 [id="' + sectionId + '"]' );
				if ( topHeading.length ) {
					insertAddListingPlaceholder( topHeading );

					var headings = topHeading.closest( 'h2' )
						.nextUntil( 'h1.voy-editsection, h2.voy-editsection' )
						.find( 'h3' ).addBack( 'h3' ) // itself and descendants
						.find( '.mw-headline' );
					insertAddListingPlaceholder( headings );
				}
			}
		};

		/**
			Append the "add listing" link text to a heading.
		*/
		var insertAddListingPlaceholder = function( parentHeading ) {
			var editSections = $( parentHeading ).next( '.mw-editsection' );
			if ( !editSections.length ) return;

			var isMinerva = $( 'body.skin-minerva' ).length,
				bClass = Config.SELECTORS.addButton;
			if ( isMinerva )
				bClass = 'mw-ui-icon mw-ui-icon-element ' + bClass;
			var addButton = buttonLink( Config.STRINGS.add,
				Config.STRINGS.addTitle, bClass, Config.MODES.add );
			if ( isMinerva ) {
				// Mobile view: Minerva support
				addButton = $( '<span />' ).append( addButton );
				editSections = $( parentHeading ).next( 'span' );
				editSections.after( addButton );
			} else {
				editSections.append( '<span class="mw-editsection-bracket">[ </span>' );
				editSections.append( addButton );
				editSections.append( '<span class="mw-editsection-bracket">]</span>' );
			}
		};

		var buttonLink = function( text, title, bClass, mode ) {
			return $( ( mode === Config.MODES.edit ) ? '<button/>' : '<a href="javascript:" />' )
				.addClass( bClass || '' )
				.attr( 'title', title )
				.text( text )
				.click( function() {
					initListingEditorDialog( mode, $( this ) );
				});
		};

		/**
			Place an "edit" link next to all existing listing tags.
		*/
		var addEditButtons = function() {
			var editButton = buttonLink( Config.STRINGS.edit,
				Config.STRINGS.editTitle, '', Config.MODES.edit );
			editButton = $( '<span class="listing-metadata-item listing-edit-button noprint"></span>' )
				.append( editButton );
			$( Config.SELECTORS.metadataSelector ).append( editButton );
		};

		/**
			Determine whether a listing entry is within a paragraph rather than
			an entry in a list
		*/
		var isInline = function( entry ) {
			return entry.closest( 'p' ).length && entry.closest( 'span.vcard' ).length;
		};

		/**
			Given a DOM element, find the nearest editable section (h2 or h3) that
			it is contained within.
		*/
		var findSectionHeading = function(element) {
			return element.closest( '.voy-h3-section, .voy-h2-section' );
		};

		/**
			Given an editable heading, examine it to determine what section index
			the heading represents.  First heading is 1, second is 2, etc.
		*/
		var findSectionIndex = function( heading ) {
			if ( heading === undefined )
				return 0;

			// Vector etc. skins
			var link = heading.find('.mw-editsection a').attr('href');
			var section = (link !== undefined) ? link.split('=').pop() : 0;
			if (section > 0) return section;

			// MinervaNeue
			link = heading.find('a[data-section]');
			section = link.attr('data-section');
			if (section !== undefined) return section;

			// Mobile view: Minerva support
			link = heading.find('.section-heading a').attr('href');
			return (link !== undefined) ? link.split('=').pop() : 0;
		};

		/**
			Given an edit link that was clicked for a listing, determine what index
			that listing is within a section.  First listing is 0, second is 1, etc.
		*/
		var findListingIndex = function(sectionHeading, clicked) {
			var count = 0;
			$(Config.SELECTORS.editLink, sectionHeading).each(function() {
				if (clicked.is($(this)))
					return false;
				count++;
			});
			return count;
		};

		/**
			Return the listing template type appropriate for the section that
			contains the provided DOM element (example: "see" for "See" sections,
			etc).  If no matching type is found then the default listing template
			type is returned.
		*/
		var findListingTypeForSection = function(entry) {
			var sectionType = entry.closest('div.voy-h2-section').children('h2').find('.mw-headline').attr('id');
			for (var sectionId in Config.SECTION_TO_DEFAULT_TYPE)
				if (sectionType == sectionId)
					return Config.SECTION_TO_DEFAULT_TYPE[sectionId];
			return Config.TEMPLATES[ 0 ];
		};

		var replaceSpecial = function(str) {
			return str.replace(/[.?*+^$[\]\\(){}|-]/g, "\\$&");
		};

		/**
			Return a regular expression that can be used to find all listing
			template invocations (as configured via the TEMPLATES map)
			within a section of wikitext.  Note that the returned regex simply
			matches the start of the template ("{{listing") and not the full
			template ("{{listing|key=value|...}}").
		*/
		var getListingTypesRegex = function() {
			return new RegExp('({{\\s*(' + Config.TEMPLATES.join('|') + ')\\b)(\\s*[\\|}])','ig');
		};

		/**
			Given a listing index, return the full wikitext for that listing
			("{{listing|key=value|...}}"). An index of 0 returns the first listing
			template invocation, 1 returns the second, etc.
		*/
		var getListingWikitextBraces = function(listingIndex) {
			sectionText = sectionText.replace(/[^\S\n]+/g,' ');
			// find the listing wikitext that matches the same index as the listing index
			var listingRegex = getListingTypesRegex();
			// look through all matches for "{{listing|see|do...}}" within the section
			// wikitext, returning the nth match, where 'n' is equal to the index of the
			// edit link that was clicked
			var listingSyntax, regexResult, listingMatchIndex;
			for (var i = 0; i <= listingIndex; i++) {
				regexResult = listingRegex.exec(sectionText);
				listingMatchIndex = regexResult.index;
				listingSyntax = regexResult[1];
			}
			// listings may contain nested templates, so step through all section
			// text after the matched text to find MATCHING closing braces
			// the first two braces are matched by the listing regex and already
			// captured in the listingSyntax variable
			var curlyBraceCount = 2;
			var endPos = sectionText.length;
			var startPos = listingMatchIndex + listingSyntax.length;
			var matchFound = false;
			for (var j = startPos; j < endPos; j++) {
				if (sectionText[j] === '{')
					++curlyBraceCount;
				else if (sectionText[j] === '}')
					--curlyBraceCount;
				if (curlyBraceCount === 0 && (j + 1) < endPos) {
					listingSyntax = sectionText.substring(listingMatchIndex, j + 1);
					matchFound = true;
					break;
				}
			}
			if (!matchFound)
				listingSyntax = sectionText.substring(listingMatchIndex);
			return (listingSyntax || '').trim();
		};

		/**
			Convert raw wiki listing syntax into a mapping of key-value pairs
			corresponding to the listing template parameters.
		*/
		var wikiTextToListing = function( listingWikiSyntax ) {
			var typeRegex = getListingTypesRegex(), comments, key;
			// convert "{{see|" to {{listing|"
			listingWikiSyntax = listingWikiSyntax
				.replace( typeRegex, '{{' + Config.TEMPLATES[ 0 ] + '$3' )
				.slice(0,-2); // remove the trailing braces
			var listingAsMap = parseListing( listingWikiSyntax );
			// replace comment placeholders by its original values
			for ( key in listingAsMap )
				listingAsMap[ key ] = restoreComments(listingAsMap[ key ], false);

			// remove comments from select list and store it
			for ( key in Config.PARAMETERS )
				if ( listingAsMap[ key ] && listingAsMap[ key ] !== '' &&
					Config.PARAMETERS[ key ].tp && Config.PARAMETERS[ key ].tp === 'select' ) {
					comments = listingAsMap[ key ].match( /<!--.*?-->/g );
					if ( comments ) {
						selectComments[ key ] = comments;
						listingAsMap[ key ] = Callbacks.removeComments( listingAsMap[ key ] );
					}
				}
			// convert paragraph tags to newlines
			if ( listingAsMap.description && displayBlock )
				listingAsMap.description = listingAsMap.description.replace(/\s*<p>\s*/g, '\n\n');
			// remove control characters
			for ( key in listingAsMap )
				listingAsMap[ key ] = removeCtrls( listingAsMap[ key ], key == 'description' );

			// sanitize the listing type param to match the configured values, so
			// if the listing contained "Do" it will still match the configured "do"
			if ( !listingAsMap.type )
				listingAsMap.type = '';
			for ( key of Config.TEMPLATES )
				if ( listingAsMap.type.toLowerCase() === key.toLowerCase() ) {
					listingAsMap.type = key;
					break;
				}
			for ( key in listingAsMap ) {
				var c = Callbacks.checkYesNo( listingAsMap[ key ] );
				if ( c !== '' ) listingAsMap[ key ] = c;
			}

			// copying parameter aliases if possible
			var arr, j, key2;
			for ( key in Config.PARAMETERS ) {
				arr = Config.PARAMETERS[ key ].aliases || [];
				for ( key2 of arr ) {
					if ( ( !listingAsMap[ key ] || listingAsMap[ key ] === '' ) &&
						listingAsMap[ key2 ] ) {
						listingAsMap[ key ] = listingAsMap[ key2 ];
						delete( listingAsMap[ key2 ] );
					}
				}
			}

			return listingAsMap;
		};

		/**
			Split the raw template wikitext into an array of params. The pipe
			symbol delimits template params, but this method will also inspect the
			content to deal with nested templates or wikilinks that might contain
			pipe characters that should not be used as delimiters.
		*/

		// masking pipes in templates and wiki links by \x00
		var maskPipes = function( s ) {
			var regex1, regex2, regex3, regex4, t;
			function replacePipes( name, offset, str ) {
				return name.replace( /\|/g, '\x00' ).replace( regex2, '\x01' ).replace( regex3, '\x02' );
			}
			function masking( str, start, end ) {
				regex1 = new RegExp( '\\' + start + '{2}[^\\' + start + '\\' + end + ']*\\' + end + '{2}', 'g' );
				regex2 = new RegExp( '\\' + start, 'g' );
				regex3 = new RegExp( '\\' + end, 'g' );
				regex4 = new RegExp( '\\' + end + '{2}$' );

				str += end + end;
				do {
					t = str;
					str = str.replace( regex1, replacePipes );
				} while ( t !== str );
				return str.replace( regex4, '' ).replace( /\x01/g, start ).replace( /\x02/g, end );
			}
			s = masking( s, '{', '}' );
			return masking( s, '[', ']' );
		};

		var parseListing = function( listingWikiSyntax ) {
			var listingAsMap = {};
			var str = listingWikiSyntax.replace( /[\x00-\x02]/g, '' ).slice( 2 ); // remove {{
			str = maskPipes( str );

			// splitting each parameter
			var results = str.split( '|' );
			results.shift();
			var at, index = 1, match, name, result;
			for ( result of results ) {
				result = result.trim().replace( /\x00/g, '|' );
				match = result.match( /[^<=\{\[]*\s*=/ );
				if ( match && match[ 0 ] !== '=' ) {
					at = match[ 0 ].length;
					name = match[ 0 ].substr( 0, at - 1 )
						.replace( /[\x00-\x0F\x7F]+/g, '')
						.replace( / +/g, ' ').trim();
					listingAsMap[ name ] = result.substr( at ).trim();
				} else {
					listingAsMap[ '' + index ] = result.replace( /^=/, '' ).trim();
					index++;
				}
			}

			return listingAsMap;
		};

		/**
			This method is invoked when an "add" or "edit" listing button is
			clicked and will execute an Ajax request to retrieve all of the raw wiki
			syntax contained within the specified section.  This wiki text will
			later be modified via the listing editor and re-submitted as a section
			edit.
		*/
		var initListingEditorDialog = function( mode, clicked ) {
			wrapContent();
			progressForm(Config.SELECTORS.loadingForm,Config.STRINGS.loading);
			var listingType, sel;
			if ( mode === Config.MODES.add )
				listingType = findListingTypeForSection( clicked );
			else {
				sel = clicked.closest( '.vcard' );
				listingType = sel.attr( 'data-type' );
				displayBlock = sel.prop( 'tagName' ) === 'DIV';
			}
			var sectionHeading = findSectionHeading(clicked);
			var sectionIndex = findSectionIndex(sectionHeading);
			var listingIndex = ( mode === Config.MODES.add ) ? -1 : findListingIndex(sectionHeading, clicked);
			inlineDetected = mode === Config.MODES.edit && isInline( clicked );
			inlineListing = Config.OPTIONS.inlineFormat || inlineDetected;

			// Following code is jQuery 3.x compatible
			$.ajax({
				url: mw.util.wikiScript(''),
				data: { title: mw.config.get('wgPageName'), action: 'raw', section: sectionIndex },
				cache: false, // required
				timeout: 3000
			}).done(function(data, textStatus, jqXHR) {
				sectionText = data;
				openListingEditorDialog(mode, sectionIndex, listingIndex, listingType, clicked);
			}).fail(function(jqXHR, textStatus, errorThrown) {
				closeForm(Config.SELECTORS.loadingForm);
				alert(Config.STRINGS.ajaxInitFailure + ': ' + textStatus + ' ' + errorThrown);
			});
		};

		/**
			This method is called asynchronously after the initListingEditorDialog()
			method has retrieved the existing wiki section content that the
			listing is being added to (and that contains the listing wiki syntax
			when editing).
		*/
		var openListingEditorDialog = function(mode, sectionNumber, listingIndex, listingType, clicked) {
			sectionText = stripComments(sectionText);
			// Not working in Minerva skin because of missing modules

			var listingAsMap = {}, listingWikiSyntax, t;
			if ( mode == Config.MODES.add )
				listingAsMap.type = listingType;
			else {
				listingWikiSyntax = getListingWikitextBraces(listingIndex);
				listingAsMap = wikiTextToListing( listingWikiSyntax );
				t = listingAsMap.type;
				if ( listingType && ( !t || t === "" ) )
					listingAsMap.type = listingType;
				listingType = listingAsMap.type;
			}
			// if a listing editor dialog is already open, get rid of it
			closeForm(Config.SELECTORS.editorForm);
			closeForm(Config.SELECTORS.loadingForm);
			// wide dialogs on huge screens look terrible
			var windw = $( window );
			var dialogWidth = (windw.width() > Config.OPTIONS.MaxDialogWidth) ? Config.OPTIONS.MaxDialogWidth : 'auto';
			var form = $( createForm( mode, listingAsMap, clicked ) );
			form.dialog({
				// modal form - must submit or cancel
				modal: true,
				height: 'auto',
				width: dialogWidth,
				title: mode == Config.MODES.add ? Config.STRINGS.addTitle : Config.STRINGS.editTitle,
				dialogClass: 'listingeditor-dialog',
				close: function() {
					unwrapContent();
				},
				buttons: [
				{
					text: Config.STRINGS.help,
					title: Config.STRINGS.helpTitle,
					id: 'listingeditor-help',
					click: function() { window.open(Config.STRINGS.helpPage);}
				},
				{
					text: Config.STRINGS.submit,
					title: Config.STRINGS.submitTitle,
					click: function() {
						if ($(Config.SELECTORS.editorDelete).is(':checked')) {
							// no validation
							formToText(mode, listingWikiSyntax, listingAsMap, sectionNumber, false);
							$(this).dialog('close');
						}
						else if (validateForm()) {
							formToText(mode, listingWikiSyntax, listingAsMap, sectionNumber, true);
							$(this).dialog('close');
						}
					}
				},
				{
					text: Config.STRINGS.preview,
					title: Config.STRINGS.previewTitle,
					id: 'listingeditor-preview-button',
					click: function() {
						startPreview( listingAsMap );
					}
				},
				{
					text: Config.STRINGS.previewOff,
					title: Config.STRINGS.previewOffTitle,
					id: 'listingeditor-preview-off',
					style: 'display: none',
					click: function() {
						togglePreview( true );
					}
				},
				{
					text: Config.STRINGS.refresh,
					title: Config.STRINGS.refreshTitle,
					icon: 'ui-icon-refresh',
					id: 'listingeditor-refresh',
					style: 'display: none',
					click: function() {
						refreshPreview( listingAsMap );
					}
				},
				{
					text: Config.STRINGS.cancel,
					title: Config.STRINGS.cancelTitle,
					click: function() {
						if ( !checkForChanges( listingAsMap ) || confirm( Config.STRINGS.cancelMessage ) ) {
							$(this).dialog('destroy').remove();
							unwrapContent();
						}
					}
				}
				],
				create: function() {
					$('.ui-dialog-buttonpane').append('<div class="listingeditor-license">' +
						Config.STRINGS.licenseText +
						'<span class="listingeditor-version"> (' + Config.SYSTEM.version + ')</span>' + '</div>');
				}
			});

			var windowHeight = windw.height();
			if ( windowHeight < 720 ) {
				var fontSize = parseFloat( $( '.listingeditor-dialog' ).css( 'font-size' ) );
				$( '.listingeditor-dialog' )
					.css( 'font-size', fontSize * windowHeight / 720 );
				fontSize = parseFloat( $( '.chosen-container' ).css( 'font-size' ) );
				$( '.chosen-container' )
					.css( 'font-size', fontSize * windowHeight / 720 );
			}
		};

		/**
			Commented-out listings can result in the wrong listing being edited, so
			strip out any comments and replace them with placeholders that can be
			restored prior to saving changes.
		*/
		var stripComments = function( text ) {
			// /s supports line break characters in .*
			var regex = [ /<!--.*?-->/gs, /<nowiki>.*?<\/nowiki>/gis, /<pre>.*?<\/pre>/gis ],
				comments, i, j, rep;
			for ( j = 0; j < regex.length; j++ ) {
				comments = text.match( regex[ j ] );
				if ( comments )
					for ( i = 0; i < comments.length; i++ ) {
						rep = '<<<COMMENT' + i + ';' + j + '>>>';
						text = text.replace(comments[ i ], rep);
						replacements[rep] = comments[ i ];
					}
			}
			return text;
		};

		/**
			Search the text provided, and if it contains any text that was
			previously stripped out for replacement purposes, restore it.
		*/
		var restoreComments = function(text, resetReplacements) {
			for ( var key in replacements )
				text = text.replace(key, replacements[key]);
			if ( resetReplacements )
				replacements = {};
			return text;
		};

		/**
			Logic invoked on form submit to analyze the values entered into the
			editor form and to block submission if any fatal errors are found.
		*/
		var validateForm = function() {
			var validationFailureMessages = [];
			for ( var f of Callbacks.VALIDATE_FORM_CALLBACKS )
				f( validationFailureMessages );
			if ( validationFailureMessages.length ) {
				alert( validationFailureMessages.join( '\n' ) );
				return false;
			}
			return true;
		};

		/**
			Convert the listing editor form entry fields into wiki text.  This
			method converts the form entry fields into a listing template string,
			replaces the original template string in the section text with the
			updated entry, and then submits the section text to be saved on the
			server.
		*/
		var getValues = function( listing ) {
			var l = $.extend( true, {}, listing );
			for ( var parameter in Config.PARAMETERS )
				l[ parameter ] = Callbacks.ELEMENTS[ parameter ].val();
			return l;
		};

		var formToText = function( mode, listingWikiSyntax, listingAsMap, sectionNumber, withCallbacks ) {
			var listing = getValues( listingAsMap );
			if ( withCallbacks )
				for ( var f of Callbacks.SUBMIT_FORM_CALLBACKS )
					f( listing, listingAsMap, mode );
			var text = listingToStr( listing );
			var summary = editSummarySection();
			var name = listingAsMap.name;
			if ( listing.name.trim() !== '' )
				name = listing.name.trim();
			if ( mode == Config.MODES.add )
				summary = updateSectionTextWithAddedListing( summary, text, listing, name );
			else
				summary = updateSectionTextWithEditedListing( summary, text, listingWikiSyntax, name );
			if ( $(Config.SELECTORS.editorSummary).val() !== '' )
				summary += ' – ' + $(Config.SELECTORS.editorSummary).val();
			var minor = $(Config.SELECTORS.editorMinorEdit).is(':checked') ? true : false;
			saveForm(summary, minor, sectionNumber, '', '');
		};

		var showPreview = function( listingAsMap ) {
			var text = listingToStr( getValues( listingAsMap ) );
			$( '#listingeditor-preview-syntax' ).text( text );

			$.ajax ({
				url: mw.config.get( 'wgScriptPath' ) + '/api.php?' + $.param({
					action: 'parse',
					prop: 'text',
					contentmodel: 'wikitext',
					format: 'json',
					'text': text,
				}),
				error: function( jqXHR, txt ) {
					$( '#listingeditor-preview' ).hide();
				},
				success: function( data ) {
					$( '#listingeditor-preview-text' ).html( data.parse.text[ '*' ] );
				},
			});
		};

		/**
			Preview
		*/
		var togglePreview = function( visible ) {
			$( '#listingeditor-preview' ).toggle( !visible );
			$( '#listingeditor-refresh' ).toggle( !visible );
			$( '#listingeditor-preview-off' ).toggle( !visible );
			$( '#listingeditor-preview-button' ).toggle( visible );
		};

		var startPreview = function( listingAsMap ) {
			var visible = $( '#listingeditor-preview' ).is( ':visible' );
			togglePreview( visible );
			if ( !visible )
				showPreview( listingAsMap );
		};
		
		var refreshPreview = function( listingAsMap ) {
			if ( $( '#listingeditor-preview' ).is( ':visible' ) )
				showPreview( listingAsMap );
		};

		/**
			For cancel button: check if any changes were made for warning msg.
		*/
		var checkForChanges = function( listingAsMap ) {
			var i, p, val;
			for ( var parameter in Config.PARAMETERS ) {
				p = listingAsMap[ parameter ];
				val = Callbacks.ELEMENTS[ parameter ].val();
				if ( typeof( val ) === 'string' ) {
					if ( val !== ( p || '' ) ) {
						return true;
					}
				} else { // multiple select
					p = p || [];
					if ( val.length !== p.length ) {
						return true;
					}
					for ( i = 0; i < val.length; i++ )
						if ( !p.includes( val[ i ] ) ) {
							return true;
						}
				}
			}
			return false;
		};

		/**
			Begin building the edit summary by trying to find the section name.
		*/
		var editSummarySection = function() {
			var sectionName = getSectionName();
			return ( sectionName.length ) ? '/* ' + sectionName + ' */ ' : '';
		};

		var getSectionName = function() {
			var HEADING_REGEX = /^=+\s*([^=]+)\s*=+\s*\n/;
			var result = HEADING_REGEX.exec(sectionText);
			return ( result !== null ) ? result[ 1 ].trim() : '';
		};

		/**
			After the listing has been converted to a string, add additional
			processing required for adds (as opposed to edits), returning an
			appropriate edit summary string.
		*/
		var updateSectionTextWithAddedListing = function( originalEditSummary, listingWikiText, listing, name ) {
			var summary = originalEditSummary + mw.format( Config.STRINGS.added, name );
			// add the new listing to the end of the section.  if there are
			// sub-sections, add it prior to the start of the sub-sections.
			var index = sectionText.indexOf('===');
			if (index === 0)
				index = sectionText.indexOf('====');
			if (index > 0)
				sectionText = sectionText.substr(0, index) + '* ' + listingWikiText +
					'\n' + sectionText.substr(index);
			else
				sectionText += '\n'+ '* ' + listingWikiText;

			sectionText = restoreComments( sectionText, true );
			return summary;
		};

		/**
			After the listing has been converted to a string, add additional
			processing required for edits (as opposed to adds), returning an
			appropriate edit summary string.
		*/
		var updateSectionTextWithEditedListing = function( originalEditSummary, listingWikiText, listingWikiSyntax, name ) {
			var summary = originalEditSummary;

			// '$&' like in '$&nbsp;' will be misinterpreted in regex replacements
			listingWikiSyntax = listingWikiSyntax.replace( /\$&/ig, '&#36;&');
			sectionText = sectionText.replace( /\$&/ig, '&#36;&');
			listingWikiText = listingWikiText.replace( /\$&/ig, '&#36;&');

			if ( $( Config.SELECTORS.editorDelete ).is( ':checked' ) ) {
				summary += mw.format( Config.STRINGS.removed, name );
				var listRegex = new RegExp('(\\n+[\\:\\*\\#]*)?\\s*' + replaceSpecial( listingWikiSyntax ));
				sectionText = sectionText.replace( listRegex, '' );
			} else {
				summary += mw.format( Config.STRINGS.updated, name );
				sectionText = sectionText.replace( listingWikiSyntax, listingWikiText );
			}
			sectionText = restoreComments(sectionText, true).replace( /&#36;/ig, '$$' ); // restore $
			return summary;
		};

		/**
			Render a dialog that notifies the user that the listing editor is
			loaded or changes are being saved.
		*/
		var closeForm = function(selector) {
			if ( $(selector).length )
				$(selector).dialog('destroy').remove();
		};

		var progressForm = function(selector, text) {
			// if a progress dialog is already open, get rid of it
			closeForm(selector);
			var progress = $('<div id="' + selector.replace( '#', '' ) + '">' + text + '</div>');
			progress.dialog({
				modal: true,
				height: 110,
				width: 300,
				title: ''
			});
			$('.ui-dialog-titlebar').hide();
		};

		/**
			Execute the logic to post listing editor changes to the server so that
			they are saved.  After saving the page is refreshed to show the updated
			article.
		*/
		var saveForm = function(summary, minor, sectionNumber, cid, answer) {
			var editPayload = {
				action: 'edit',
				title: mw.config.get( 'wgPageName' ),
				section: sectionNumber,
				text: sectionText,
				summary: summary,
				captchaid: cid,
				captchaword: answer
			};
			if ( minor )
				editPayload.minor = 'true';
			api.postWithToken(
				"csrf",
				editPayload
			).done(function(data, jqXHR) {
				if (data && data.edit && data.edit.result == 'Success') {
					// since the listing editor can be used on diff pages, redirect
					// to the canonical URL if it is different from the current URL
					var canonicalUrl = $("link[rel='canonical']").attr("href");
					var currentUrlWithoutHash = window.location.href.replace(window.location.hash, "");
					if (canonicalUrl && currentUrlWithoutHash != canonicalUrl) {
						var sectionName = mw.util.escapeIdForLink(getSectionName());
						if (sectionName.length)
							canonicalUrl += "#" + sectionName;
						window.location.href = canonicalUrl;
					} else
						window.location.reload();
				} else if (data && data.error) {
					saveFailed(Config.STRINGS.submitApiError + ' "' + data.error.code + '": ' + data.error.info );
				} else if (data && data.edit.spamblacklist) {
					saveFailed(Config.STRINGS.submitBlacklistError + ': ' + data.edit.spamblacklist );
				} else if (data && data.edit.captcha) {
					closeForm(Config.SELECTORS.saveForm);
					captchaDialog(summary, minor, sectionNumber, data.edit.captcha.url, data.edit.captcha.id);
				} else
					saveFailed(Config.STRINGS.submitUnknownError);
			}).fail(function(code, result) {
				if (code === "http")
					saveFailed(Config.STRINGS.submitHttpError + ': ' + result.textStatus );
				else if (code === "ok-but-empty") {
					saveFailed(Config.STRINGS.submitEmptyError);
				} else
					saveFailed(Config.STRINGS.submitUnknownError + ': ' + code );
			});
			progressForm(Config.SELECTORS.saveForm,Config.STRINGS.saving);
		};

		/**
			If an error occurs while saving the form, remove the "saving" dialog,
			restore the original listing editor form (with all user content), and
			display an alert with a failure message.
		*/
		var saveFailed = function(msg) {
			closeForm(Config.SELECTORS.saveForm);
			$(Config.SELECTORS.editorForm).dialog('open');
			alert(msg);
		};

		/**
			If the result of an attempt to save the listing editor content is a
			Captcha challenge then display a form to allow the user to respond to
			the challenge and resubmit.
		*/
		var captchaDialog = function(summary, minor, sectionNumber, captchaImgSrc, captchaId) {
			// if a captcha dialog is already open, get rid of it
			closeForm(Config.SELECTORS.captchaForm);
			var captcha = $('<div id="captcha-dialog">').text(Config.STRINGS.externalLinks);
			var image = $('<img class="fancycaptcha-image">')
				.attr('src', captchaImgSrc)
				.appendTo(captcha);
			var label = $('<label for="input-captcha">').text(Config.STRINGS.enterCaptcha).appendTo(captcha);
			var input = $('<input id="input-captcha" type="text">').appendTo(captcha);
			captcha.dialog({
				modal: true,
				title: Config.STRINGS.enterCaptcha,
				buttons: [
					{
						text: Config.STRINGS.submit, click: function() {
							saveForm(summary, minor, sectionNumber, captchaId, $('#input-captcha').val());
							$(this).dialog('destroy').remove();
						}
					},
					{
						text: Config.STRINGS.cancel, click: function() {
							$(this).dialog('destroy').remove();
						}
					}
				]
			});
		};

		// remove controls and illegeal chars
		var removeCtrls = function( str, isContent ) {
			str = str.trim();
			if ( str === '' ) return '';
			if ( displayBlock && isContent ) {
				// remove controls from tags at first
				str = str.replace( /(<[^>]+>)/g, function( name, offset, str ) {
					return name.replace( /[\x00-\x0F\x7F]/g, ' ' );
				});
				str = str.replace( /[\x00-\x09\x0B\x0C\x0E\x0F\x7F]/g, ' ' );
			} else
				str = str.replace( /(<\/?br[^%/>]*\/*>|<\/?p[^%/>]*\/*>)/g, ' ' )
					.replace( /[\x00-\x0F\x7F]/g, ' ' );
			return str.trim().replace( / {2,}/g, ' ' );
		};

		var getAlias = function( value, aliases ) {
			for ( var key in aliases )
				if ( aliases[ key ] === value ) {
					value = key;
					break;
				}
			return value;
		};

		var listingToStr = function( listing ) {
			var arr, i, l, par, keepIt;

			// values cleanup
			for ( var parameter in listing ) {
				l = listing[ parameter ];
				if ( typeof l == 'object' )
					for ( i = l.length - 1; i >= 0 ; i-- ) {
						if ( !l[ i ] || l[ i ] === '' )
							l.splice( i, 1 );
					}
				else {
					l = removeCtrls( l, parameter == 'description' )
						.trim()
						.replace( / {2,}/g, ' ' );
					l = maskPipes( l ).replace( /\|/g, '{{!}}' ).replace( /\x00/g, '|' );
					// handle punctuation marks
					if ( Config.OPTIONS.withoutPunctuation.includes( parameter ) )
						l = l.replace( /[.,;!?]+$/, '' );
					if ( parameter === 'description' && l !== '' && !l.match( /[.!?]$/ ) )
						l = l + '.';
				}
				listing[ parameter ] = l;
			}

			var saveStr = '{{' + Config.TEMPLATES[ 0 ] + ' ';
			for ( parameter in Config.PARAMETERS ) {
				// recognized parameters only
				keepIt = Config.PARAMETERS[ parameter ].keepIt ||
					Config.OPTIONS.keepItDefault;
				l = listing[ parameter ];

				switch( parameter ) {
					case 'type':
						if ( Callbacks.ELEMENTS.firstType !== '' )
							for ( i = 0; i < l.length; i++ )
								if ( l[ i ] == Callbacks.ELEMENTS.firstType ) {
									l.splice( i, 1 );
									l.unshift( Callbacks.ELEMENTS.firstType );
									break;
								}
						if ( Config.OPTIONS.CopyToTypeAliases )
							for ( i = 0; i < l.length; i++ )
								l[ i ] = getAlias( l[ i ], Config.MODULE_TABLES.typeAliases );
						l = l.join( ', ' ).replace( /_/g, ' ' );
						break;
					case 'group':
						if ( Config.OPTIONS.CopyToTypeAliases )
							l = getAlias( l, Config.MODULE_TABLES.groupAliases );
						break;
					case 'subtype':
						// sorting subtypes by groups
						l = Callbacks.sortSubtypes( l );
						if ( Config.OPTIONS.CopyToTypeAliases )
							for ( i = 0; i < l.length; i++ )
								l[ i ] = getAlias( l[ i ], Config.MODULE_TABLES.subtypeAliases );
						l = l.join( ', ' ).replace( /_/g, ' ' );
						break;
					case 'show':
						l = checkShowOptions( l );
						l = l.join( ', ' ).replace( /_/g, ' ' );
				}

				if ( selectComments[ parameter ] )
					l = l + selectComments[ parameter ].join( '' );
				par = parameter;
				arr = Config.PARAMETERS[ par ].aliases || [];

				// renaming parameter
				if (Config.OPTIONS.CopyToAliases && arr[0] && !listing[ arr[0] ])
					par = arr[0];
				if ( l !== '' || keepIt )
					saveStr += '| ' + par + ' = ' + l;
				if ( !saveStr.match( /\n$/ ) ) {
					saveStr = saveStr.replace(/\s+$/, '');
					saveStr += ( !inlineListing && Config.PARAMETERS[parameter].newline ) ?
						'\n' : ' ';
				}
			}
			if ( Config.OPTIONS.AllowUnrecognizedParameters )
				// append any unexpected values
				for ( parameter in listing )
					if ( !Config.PARAMETERS[ parameter ] && listing[ parameter ] !== '' )
						saveStr += '| ' + parameter + ' = ' + listing[ parameter ] +
							( inlineListing ) ? ' ' : '\n';

			return inlineDetected ? saveStr.replace( /\s+$/, ' }}' ) : saveStr.replace( /\s+$/, '\n}}' );
		};

		var markHeaders = function() {
			$( 'h1, h2, h3' ).each( function() {
				var _this = $( this );
				var section = findSectionIndex( _this );
				if ( section > 0 ) {
					_this.addClass( 'voy-editsection' )
						.attr( 'data-section', section );
				}
			} );
		};

		/**
			Called on DOM ready, this method initializes the listing editor and
			adds the "add/edit listing" links to sections and existing listings.
		*/
		var init = function() {
			if ( getContentSelector === '' ) return;
			$('head').append('<link rel="stylesheet" type="text/css" href="/w/index.php?title=MediaWiki:Gadget-ListingEditor.css&action=raw&ctype=text/css">');
			markHeaders();
			addEditButtons();
			addListingButtons();
		};

		// expose public members
		return {
			init: init,
			initListingEditorDialog: initListingEditorDialog
		};
	}();

	$( Core.init );

	return {
		initListingEditorDialog: Core.initListingEditorDialog
	};

} ( mediaWiki, jQuery ) );

//</nowiki>