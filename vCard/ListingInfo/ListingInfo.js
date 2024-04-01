//<nowiki>
/*******************************************************************************
 * ListingInfo v1.5
 * Date: 2023-02-25
 * This script is called as a gadget
 * Presents a dialog showing characteristics of a single listing
 * Original author: Roland Unger
 * Support of desktop and mobile views
 * Documentation: https://de.wikivoyage.org/wiki/Wikivoyage:ListingInfo.js
 ******************************************************************************/
/* eslint-disable mediawiki/class-doc */

( function ( $, mw ) {
	'use strict';

	var listingPopup = function() {

		/******************* Internationalization *****************************/

		const version = '2023-02-05';

		// strings depending on user language
		const userStrings = {
			de: {
				// headers
				booking:  'Buchung, Vergleich und Bewertung',
				contact:  'Kontakt',
				credit:   'Kreditkarten',
				features: 'Ausstattung',
				figure:   'Bild',
				hours:    'Zeiten',
				map:      'Lagekarte',

				// contacts
				email:    'E-Mail',
				fax:      'Fax',
				mobile:   'Mobil',
				phone:    'Tel.',
				skype:    'Skype',
				tollfree: 'Tel. gebührenfrei',
				web:      'Internet',

				// actionButtons
				buttonText:    'info',
				buttonTooltip: 'Öffnet ein Popup-Fenster mit den wichtigsten vCard-Daten und teilweise mit Buchungsmöglichkeiten an',

				bookingTooltip:  'Buchungslinks anzeigen',
				closeTooltip:    'Dialogfenster schließen',
				contactTooltip:  'Kontakt anzeigen',
				featuresTooltip: 'Ausstattung anzeigen',
				figureTooltip:   'Abbildung anzeigen',
				mapTooltip:      'Karte anzeigen',
				taxiTooltip:     'Bringen Sie mich zu',

				rssTooltip: 'RSS-Feed der Einrichtung',
				urlTooltip: 'Website der Einrichtung'
			},
			en: {
				// headers
				booking:  'Booking, comparison, and evaluation',
				contact:  'Contact',
				credit:   'Credit cards',
				features: 'Features',
				figure:   'Image',
				hours:    'Hours',
				map:      'Position map',

				// contacts
				email:    'Email',
				fax:      'Fax',
				mobile:   'Mobile',
				phone:    'Phone',
				skype:    'Skype',
				tollfree: 'Tollfree',
				web:      'Internet',

				// actionButtons
				buttonText:    'info',
				buttonTooltip: 'Opens a pop-up window with the most important listing data and partly with booking opportunities',

				bookingTooltip:  'Shows booking links',
				closeTooltip:    'Closes the dialog',
				contactTooltip:  'Shows contacts',
				featuresTooltip: 'Shows features',
				figureTooltip:   'Shows an image',
				mapTooltip:      'Shows a position map',
				taxiTooltip:     'Please take me to',

				rssTooltip: 'RSS feed of this institution',
				urlTooltip: 'Website of this institution'
			},
            ja: {
				// headers
				booking:  '予約、比較、レビュー',
				contact:  '連絡',
				credit:   'クレジットカード',
				features: '特徴',
				figure:   '画像',
				hours:    '営業時間',
				map:      '地図',

				// contacts
				email:    'メール',
				fax:      'ファックス',
				mobile:   '携帯電話',
				phone:    '電話番号',
				skype:    'Skype',
				tollfree: 'フリーダイヤル',
				web:      'ウェブサイト',

				// actionButtons
				buttonText:    '情報',
				buttonTooltip: '重要な情報をポップアップで表示します。',

				bookingTooltip:  '予約リンクを表示',
				closeTooltip:    'ダイアログを閉じる',
				contactTooltip:  '連絡先を表示',
				featuresTooltip: '特徴を表示',
				figureTooltip:   '画像を表示',
				mapTooltip:      '地図を表示',
				taxiTooltip:     'アクセス方法',

				rssTooltip: 'この場所のRSSフィード',
				urlTooltip: 'この場所のウェブサイト'
			}
		};

		const translations = {
			de: { takeRequest: 'Bitte bringen Sie mich zu…',
				name: 'Name', comment: 'Kommentar', address: 'Anschrift', directions: 'Wegbeschreibung' },
			en: { takeRequest: 'Please take me to…',
				name: 'Name', comment: 'Comment', address: 'Address', directions: 'Directions' },
			af: { takeRequest: 'Neem my asseblief na …',
				name: 'Naam', comment: 'Opmerking', address: 'Adres', directions: 'Hoe om daar te kom' }, // native speaker
			ar: { takeRequest: 'من فضلك ، أريد الذهاب إلى…',
				name: 'الاسم', comment: 'التعليق', address: 'العنوان', directions: 'الموقع والاتجاه' }, // native speaker
			az: { takeRequest: 'Xahiş edirəm məni … aparın',
				name: 'Ad', comment: 'Şərh', address: 'Ünvan', directions: 'Yer və necə getməli' }, // native speaker
			be: { takeRequest: 'Калі ласка, вазьміце мяне да …' }, // Weißrussisch
			bg: { takeRequest: 'Моля, вземете ме до …' ,
				name: 'Име', comment: 'Коментар', address: 'Адрес', directions: 'Местоположение и пристигане' }, // native speaker
			bn: { takeRequest: 'আমাকে নিয়ে যান …',
				name: 'নাম', comment: 'মন্তব্য', address: 'ঠিকানা', directions: 'দিকনির্দেশ' },
			bs: { takeRequest: 'Molim te, vodi me do …',
				name: 'Ime', comment: 'Komentar', address: 'Adresa', directions: 'Mjesto i odredište' }, // native speaker
			ca: { takeRequest: 'Porta’m a …' },
			cs: { takeRequest: 'Vezměte mě prosím na toto místo:',
				name: 'Jméno', comment: 'Komentář', address: 'Adresa', directions: 'Cíl a cesta' }, // native speaker
			da: { takeRequest: 'Jeg vil gerne til …',
				name: 'Navn', comment: 'Kommentar', address: 'Adresse', directions: 'Kørselsvejledning' }, // native speaker
			el: { takeRequest: 'Παρακαλώ να με πάτε στο(ν)/στη(ν) …',
				name: 'Όνομα', comment: 'Σχόλιο', address: 'Διεύθυνση', directions: 'Τοποθεσία και άφιξη' }, // native speaker
			es: { takeRequest: 'Por favor, lléveme a…',
				name: 'Nombre', comment: 'Comentario', address: 'Dirección', directions: 'Indicaciones' }, // native speaker
			et: { takeRequest: 'Palun viige mind …',
				name: 'Nimi', comment: 'Kommentaar', address: 'Aadress', directions: 'Asukoht ja saabumine' }, // native speaker
			fa: { takeRequest: 'لطفا من را ببر به…',
				name: 'نام', comment: 'یادداشت', address: 'نشانی', directions: 'مسیرها' }, // native speaker
			fi: { takeRequest: 'Vie minut …',
				name: 'Nimi', comment: 'Kommentti', address: 'Osoite', directions: 'Ohjeet' }, // native speaker
			fr: { takeRequest: 'Pouvez-vous m’emmenez à/au…',
				name: 'Nom', comment: 'Commentaire', address: 'Adresse', directions: 'Direction' }, // native speaker
			ga: { takeRequest: 'Tabhair dom go …' }, // Irisch
			gd: { takeRequest: 'Thoir dhomh gu …' }, // Schottisch-gälisch
			gu: { takeRequest: 'કીરપા કરકે મૈના લે જો …'    , // Gujarati provided by an Indian guy
				name: 'નાબ', comment: 'પાસ', address: 'પતા', directions: 'ઢીશા' },
			he: { takeRequest: 'בבקשה תיקח אותי ל…',
				name: 'שם', comment: 'תגובה', address: 'כתובת', directions: 'הוראות' },
			hi: { takeRequest: 'कृपया मुझे वहाँ ले जाएं…' ,
				name: 'नाम', comment: 'पास', address: 'पता', directions: 'दीशा' }, //Hindi provided by an Indian guy
			hr: { takeRequest: 'Molim Vas, odvedi me …' },
			hu: { takeRequest: 'Kérem, vigyen a/az …-hoz/hez/höz',
				name: 'Név', comment: 'Megjegyzés', address: 'Cím', directions: 'Odajutás' }, // native speaker
			hy: { takeRequest: 'Խնդրում եմ ինձ տանել …',
				name: 'Անուն', comment: 'Բացատրություն', address: 'Հասցե', directions: 'Վայր եւ ցուցումներ' }, // Armenisch, native speaker
			id: { takeRequest: 'Tolong hantarkan saya ke …',
				name: 'Nama', comment: 'Komen', address: 'Alamat', directions: 'Arah' }, // Indonesian: same like malay (statement of a Sabahan native Malay speaker)
			is: { takeRequest: 'Vinsamlegast taktu mig til …' },
			it: { takeRequest: 'Per favore, mi porti a…',
				name: 'Nome', comment: 'Commento', address: 'Indirizzo', directions: 'Posizione e arrivo' }, // Italian native speaker
			ja: { takeRequest: '次の場所にお願いします：',
				name: '場所', comment: 'コメント', address: '住所', directions: '経路' }, // Japanese native speaker
			ka: { takeRequest: 'გთხოვთ მიმიყვანოთ…',
				name: 'დასახელება', comment: 'კომენტარი', address: 'მისამართი', directions: 'დანიშნულების ადგილი' }, // Georgisch, native speaker
			kk: { takeRequest: 'Маған …' }, // Kasachisch
			km: { takeRequest: 'សូមជូនខ្ញុំទៅ …',
				name: 'ឈ្មោះ', comment: 'នែនាំ', address: 'អាសយដ្ឋាន', directions: 'ទិសដៅ' }, // Khmer: by native speaker from Phnom Penh
			ko: { takeRequest: '… 로 가주세요',
				name: '이름', comment: '호텔 안내', address: '주소', directions: '찾아가는 길' }, // Korean: verified by a native speaker from Seoul
			ky: { takeRequest: 'Суранам, мени алып…' }, // Kirgisisch
			lb: { takeRequest: 'Huelt mech op …' },
			lt: { takeRequest: 'Prašau, paimk mane …' },
			lv: { takeRequest: 'Lūdzu, aizvediet mani uz …',
				name: 'Nosaukums', comment: 'Komentars', address: 'Adrese', directions: 'Virzieni' }, // Lettisch -- native speaker
			mk: { takeRequest: 'Ве молам, земи ме …' }, // Mazedonisch
			mn: { takeRequest: 'Намайг аваарай …' },
			ms: { takeRequest: 'Tolong hantarkan saya ke …',
				name: 'Nama', comment: 'Komen', address: 'Alamat', directions: 'Arah' }, // Malay: verified by a Sabahan native speaker
			mt: { takeRequest: 'Jekk jogħġbok ħudni …' },
			my: { takeRequest: 'ငါ့ကိုအယူကို ကျေးဇူးပြု. ...' }, // Birmanisch
			nan: { takeRequest: '請帶我去 …',
				name: '姓名', comment: '評語', address: '住址', directions: '抵達方式' }, // Taiwanesisch: verified by a Taiwanese native speaker
			nb: { takeRequest: 'Kan du kjøre meg til …',
				name: 'Navn', comment: 'Kommentar', address: 'Adresse', directions: 'Sted og tid' }, // Bokmål, native speaker
			ne: { takeRequest: 'कृपया मुझे वहाँ ले जाएं…' ,
				name: 'नाम', comment: 'पास', address: 'पता', directions: 'दीशा' }, // Nepalese provided by an Indian guy
			nl: { takeRequest: 'Breng me alstublieft naar…',
				name: 'Naam', comment: 'Commentaar', address: 'Adres', directions: 'Route' }, // native speaker
			no: { takeRequest: 'Kan du kjøre meg til …',
				name: 'Navn', comment: 'Kommentar', address: 'Adresse', directions: 'Sted og tid' }, // Bokmål, native speaker
			pl: { takeRequest: 'Proszę mnie zabrać do…',
				name: 'Nazwa', comment: 'Komentarz', address: 'Adres', directions: 'Wskazówki dojuzdu' }, // native speaker
			pt: { takeRequest: 'Por favor, leve-me para …',
				name: 'Nome', comment: 'Comentário', address: 'Endereço', directions: 'Direções' }, // native speaker
			pu: { takeRequest: 'ਕਿਰਪਾ ਕਰਕੇ ਮੈਨੂ ਲੈ ਚਲੌं…' ,
				name: 'ਨਾਮ', comment: 'ਢੇ ਕੋਲ', address: 'ਪਤਾ', directions: 'ਵਲ' }, //Punjabie provided by an Indian guy
			ro: { takeRequest: 'Te rog să mă dai la …',
				name: 'Nume', comment: 'Comentariu', address: 'Adresă', directions: 'Indicații' },
			ru: { takeRequest: 'Пожалуйста, отвезите меня в…',
				name: 'Название', comment: 'Комментарий', address: 'Адрес', directions: 'Пояснения' }, // Russian native speaker
			sk: { takeRequest: 'Prosím, môžete ma vziať na miesto …',
				name: 'Menom', comment: 'Komentár', address: 'Adresa', directions: 'v oblasti' }, // native spaker
			sl: { takeRequest: 'Prosim, vzemite me …' },
			sq: { takeRequest: 'Ju lutem më dërgoni në …',
				name: 'Emri', comment: 'Komenti', address: 'Adresa', directions: 'Vendndodhja dhe Mbërritja' }, // Albanisch, native speaker
			sr: { takeRequest: 'Молим те, води ме до …',
				name: 'Име', comment: 'Коментар', address: 'Адреса', directions: 'Место и одредиште' }, // native speaker
			sv: { takeRequest: 'Snälla ta mig till …',
				name: 'Namn', comment: 'Kommentar', address: 'Adress', directions: 'Vägbeskrivning' }, // native speaker
			tg: { takeRequest: 'Лутфан маро ба …' },
			th: { takeRequest: 'กรุณาพาฉันไปที่ …' ,
				name: 'ชื่อ', comment: 'แนะนำ', address: 'ที่อยู่', directions: 'สถานที่ตั้ง' }, //Thai: by native speakerfrom Chiang Mai, North Thailand
			tl: { takeRequest: 'Pakiusap dalhin mo ako sa …',
				name: 'Pangalan', comment: 'Komento', address: 'Address', directions: 'Paano pumunta doon' }, // Tagalog (Filipino) provided by a native speaker from anywhere in Luzon
			tr: { takeRequest: 'Lütfen beni … götür',
				name: 'Ad', comment: 'Özellik', address: 'Adres', directions: 'Yer ve varış noktası' }, // native speaker
			uk: { takeRequest: 'Будь ласка, відвезіть мене до …',
				name: 'Назва', comment: 'Коментар', address: 'Адреса', directions: 'Як дістатись' }, // native speaker
			uz: { takeRequest: 'Iltimos, meni olib boring …' },
			vi: { takeRequest: 'Xin hãy đưa tôi đến …',
				name: 'Tên', comment: 'Chú thích', address: 'Địa chỉ', directions: 'Chỉ đường' },
			yue: { takeRequest: '请带我去……',
				name: '名字', comment: '评论', address: '地址', directions: '方向' }, // Cantonese: from a native speaker from city of Guangzhou
			zh: { takeRequest: '您好，请您带我去……',
				name: '名称', comment: '评价与备注', address: '地址', directions: '如何到达酒店' }, // Mandarin: from a native speaker from city of Hefei
		};

		const sites = [
			{ data: 'data-agoda-com', site: 'Agoda.com', title: 'Hotel auf Agoda.com', formatter: 'https://www.agoda.com/de-de/$1.html', grClass: 'group1' },
			{ data: 'data-booking-com', site: 'Booking.com', title: 'Hotel auf Booking.com', formatter: 'https://www.booking.com/hotel/$1.de.html', grClass: 'group1' },
			{ data: 'data-expedia-com', site: 'Expedia.com', title: 'Hotel auf Expedia.com', formatter: 'https://www.expedia.com/$1.Hotel-Information', grClass: 'group1' },
			{ data: 'data-historic-hotels-america', site: 'HistoricHotels.org', title: 'Hotel auf HistoricHotels.org', formatter: 'https://www.historichotels.org/hotels-resorts/$1', grClass: 'group1' },
			{ data: 'data-historic-hotels-europe', site: 'HistoricHotelsOfEurope.com', title: 'Hotel auf HistoricHotelsOfEurope.com', formatter: 'https://www.historichotelsofeurope.com/property-details.html/$1', grClass: 'group1' },
			{ data: 'data-historic-hotels-worldwide', site: 'HistoricHotelsWorldwide.com', title: 'Hotel auf HistoricHotelsWorldwide.com', formatter: 'http://www.historichotelsworldwide.com/hotels-resorts/$1', grClass: 'group1' },
			{ data: 'data-hotels-com', site: 'Hotels.com', title: 'Hotel auf Hotels.com', formatter: 'https://de.hotels.com/$1/', grClass: 'group1' },
			{ data: 'data-hostelworld-com', site: 'Hostelworld.com', title: 'Hostel auf Hostelworld.com', formatter: 'https://www.hostelworld.com/hosteldetails.php/_/_/$1', grClass: 'group1' },
			{ data: 'data-kayak-com', site: 'Kayak.com', title: 'Hotel auf Kayak.com', formatter: 'https://www.kayak.de/hotels/-h$1-details/', grClass: 'group1' },
			{ data: 'data-leading-hotels', site: 'LHW.com', title: 'Hotel auf Leading Hotels of the World', formatter: 'https://www.lhw.com/hotel/$1', grClass: 'group1' },
			{ data: 'data-preferred-hotels', site: 'PreferredHotels.com', title: 'Hotel auf PreferredHotels.com', formatter: 'https://preferredhotels.com/destinations/$1', grClass: 'group1' },
			{ data: 'data-recreation-gov', site: 'Recreation.gov facility', title: 'Einrichtung auf Recreation.gov', formatter: 'https://www.recreation.gov/recreationalAreaDetails.do?facilityId=$1', grClass: 'group1' },
			{ data: 'data-relais-chateaux', site: 'RelaisChateaux.com', title: 'Einrichtung auf RelaisChateaux.com', formatter: 'https://www.relaischateaux.com/us/wd/$1', grClass: 'group1' },
			{ data: 'data-skyscanner-com', site: 'Skyscanner.com', title: 'Metasuche auf Skyscanner.com', formatter: 'https://www.skyscanner.de/hotels/_/_/_/ht-$1', grClass: 'group1' },
			{ data: 'data-trip-com', site: 'Trip.com', title: 'Einrichtung auf Trip.com', formatter: 'https://www.trip.com/hotels/_-hotel-detail-$1', grClass: 'group1' },
			{ data: 'data-tripadvisor-com', site: 'Tripadvisor.com', title: 'Einrichtung auf Tripadvisor.com', formatter: 'https://www.tripadvisor.com/$1', grClass: 'group1' },

			{ data: 'data-alpenverein-de', site: 'Alpenverein.de', title: 'Schutzhütte auf Alpenverein.de', formatter: 'https://www.alpenverein.de/DAV-Services/Huettensuche/wd/$1', grClass: 'group1' },
			{ data: 'data-alpenverein-at', site: 'Alpenverein.at', title: 'Schutzhütte auf Alpenverein.at', formatter: 'https://www.alpenverein.at/huetten/index.php?huette_nr=$1', grClass: 'group1' },
			{ data: 'data-pzs-si', site: 'PZS.si', title: 'Schutzhütte auf im Verzeichnis des Alpenvereins Sloweniens', formatter: 'https://en.pzs.si/koce.php?pid=$1', grClass: 'group1' },
			{ data: 'data-sac-cas-ch', site: 'SAC-CAS.ch', title: 'Schutzhütte und Gipfel auf im Verzeichnis des Schweizer Alpen-Clubs', formatter: 'https://beta.sac-cas.ch/de/huetten-und-touren/tourenportal/$1/', grClass: 'group1' },

			{ data: 'data-foursquare-id', site: 'Foursquare.com', title: 'Einrichtung auf Foursquare.com', formatter: 'https://www.foursquare.com/v/$1', grClass: 'group2' },
			{ data: 'data-google-maps-cid', site: 'Maps.google.com', title: 'Einrichtung auf Google Maps', formatter: 'https://maps.google.com/?cid=$1', grClass: 'group2' },
		];

		// technical constants
		const contactKeys = [ 'phone', 'mobile', 'tollfree', 'fax', 'email', 'skype' ],
			fallbackLang = 'en',
			allowedNamespaces = [
				0, // Main
				2, // User
				4  // Project
			];

		// separators for translate function
		const separators = {
			header:  '<br />',
			section: ' / '
		};

		const selectors = {
			background:       '#voy-info-background',
			kartographerLink: '.mw-kartographer-maplink',
			listing:          '.vCard',
			infoDialog:       '#voy-listing-info',
			metadata:         'span.listing-metadata-items'
		};

		const classes = {
			address:     'listing-address',
			alt:         'listing-alt',
			checkin:     'listing-checkin',
			checkout:    'listing-checkout',
			comment:     'listing-comment',
			commons:     'listing-sister-commons',
			credit:      'listing-credit',
			directions:  'listing-directions',
			email:       'listing-email',
			fax:         'listing-fax',
			features:    'listing-subtype',
			hours:       'listing-hours',
			icon:        'listing-icon',
			mobile:      'listing-mobile',
			name:        'listing-name',
			phone:       'listing-landline',
			tollfree:    'listing-tollfree',
			skype:       'listing-skype',
			socialMedia: 'listing-social-media',

			prefix:      'voy-info-',

			booking:     'voy-info-booking',
			button:      'voy-info-button',
			buttonImage: 'voy-info-button-img',
			buttonPane:  'voy-info-button-pane',
			container:   'voy-info-container',
			image:       'voy-info-image',
			infoPane:    'voy-info-pane',
			isMobile:    'voy-info-mobile',
			map:         'voy-info-map',

			background:  'ui-widget-overlay'
		};

		const data = {
			addressLocal: 'data-address-local',
			color:     'data-color',
			directionsLocal: 'data-directions-local',
			image:     'data-image',
			lat:       'data-lat',
			lon:       'data-lon',
			lang:      'data-lang',
			name:      'data-name',
			nameLocal: 'data-name-local',
			rss:       'data-rss',
			type:      'data-group', // other wikis: 'data-type'
			url:       'data-url'
		};

		const makiIcons = {
			area:      'land-use',
			buy:       'shop',
			'do':      'swimming',
			drink:     'bar',
			eat:       'restaurant',
			error:     'cross',
			go:        'suitcase',
			health:    'hospital',
			nature:    'park',
			other:     'star-stroked',
			religion:  'circle-stroked',
			see:       'town-hall',
			sleep:     'lodging',
			populated: 'town',
			view:      'camera',
		};

		// internal use
		const pageLang = mw.config.get( 'wgPageContentLanguage' ),
			userLang = mw.config.get( 'wgUserLanguage' ),
			isMobile = ( /android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test( navigator.userAgent.toLowerCase() ) );
//			isMobile = true;

		// dialog move
		const position = {
			mouse: {},
			dialog: {}
		};

		// map support
		const mapParams = {
			map: null
		};

		/********************* String management ******************************/

		var messages = {};

		// copying translation strings to messages depending on chain languages
		function addMessages( strings, chain ) {
			for ( var i = chain.length - 1; i >= 0; i-- ) {
				if ( strings.hasOwnProperty( chain[ i ] ) ) {
					$.extend( messages, strings[ chain[ i ] ] );
				}
			}
		}

		// copying translation strings to messages
		function setupMessages() {
			const chain = ( userLang == pageLang ) ? [ pageLang, fallbackLang ] :
				[ userLang, pageLang, fallbackLang ];
			addMessages( userStrings, chain );
		}

		/************************** Dialog ************************************/

		// Opening the dialog
		function open() {
			close();

			const width = 400, height = 300,
				id = selectors.infoDialog.substring( 1 );
			var left = ( document.body.scrollWidth - width ) / 2 + $( document ).scrollLeft();
			left = ( left < 0 ) ? 0 : left;
			var top = ( window.innerHeight - height ) / 2 + $( document ).scrollTop();
			top = ( top < 0 ) ? 0 : top;

			const infoDialog = $( '<div/>', {
				id: id,
				'class': 'mw-parser-output' + ( isMobile ? ( ' ' + classes.isMobile ) : '' ),
				role: 'dialog',
				tabindex: '-1',
				'aria-modal': 'true',
				'aria-labelledby': id,
				'data-version': version,
				css: { width: width, height: height, display: 'flex',
					left: left, top: top }
				})
				.keydown( handleKeyCodes ); // Handle TAB and ESC keycodes
			$( 'body' )
				.click( handleOutsideClick )
				.append( $( '<div/>', {
					id: selectors.background.substring( 1 ),
					'class': classes.background
				}) )
				.append( infoDialog );

			return infoDialog;
		}

		// Key code event handler for TAB and ESC keys
		function handleKeyCodes( event ) {
			switch( event.keyCode ) {
				case 9: // TAB
					const tabbables = $( event.delegateTarget ).find( ':visible' ).filter( 'a[href], area[href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), button:not([disabled]), [tabindex="0"]' ),
						first = tabbables.filter( ':first' ),
						last = tabbables.filter( ':last' );
					if ( event.target === last[ 0 ] && !event.shiftKey ) {
						event.preventDefault();
						first.focus();
					} else if ( event.target === first[ 0 ] && event.shiftKey ) {
						event.preventDefault();
						last.focus();
					}
    	    		break;
	        	case 27: // ESC
					event.preventDefault();
        			close();
        			break;
			}
		}

		// Click event handler if clicked outside the dialog
		function handleOutsideClick( event ) {
			// Real ouside click?
			if ( !$( event.target ).closest( selectors.infoDialog ).length ) {
				const infoDialog = $( selectors.infoDialog ),
					disabledButton = $( 'button:disabled', infoDialog );
				if ( disabledButton.length ) {
					disabledButton.next().focus();
				} else {
					$( 'button', infoDialog ).first().focus();
				}
			}
		}

		// Closing the dialog
		function close() {
			$( 'body' ).off( 'click', handleOutsideClick );
			$( selectors.infoDialog ).remove();
			$( selectors.background ).remove();
		}

		// Focus the button of the following info pane
		function focusNextButton() {
			$( selectors.infoDialog + ' button:disabled' ).next().focus();
		}

		// Creating header with the opportunity to use it as a move tool
		function makeHeader( text, move ) {
			const header = $( '<h2/>', {
				css: { flex: 'none' }
			}).html( text );
		
			if ( move ) {
				header.css( 'cursor', 'move' )
				.mouseup( function( e ) {
					$( this ).off( 'mousemove', dialogMove ).css( 'cursor', 'move' );
					focusNextButton();
				})
				.mouseout( function( e ) {
					$( this ).off( 'mousemove', dialogMove ).css( 'cursor', 'move' );
					focusNextButton();
				})
				.mousedown( function( e ) {
					var dialog = $( selectors.infoDialog );
					$( this ).on( 'mousemove', dialogMove ).css( 'cursor', 'grabbing' );
					position.mouse.X = e.clientX;
					position.mouse.Y = e.clientY;
					position.dialog.X = parseInt( dialog.css( 'left' ) );
					position.dialog.Y = parseInt( dialog.css( 'top' ) );
				});
			}
			return header;
		}

		// Event handler for mouse move
		function dialogMove( e ) {
			$( selectors.infoDialog )
				.css( { left: position.dialog.X - position.mouse.X + e.clientX,
					top: position.dialog.Y - position.mouse.Y + e.clientY } );
		}
	
		/***************** Info panes and selection ***************************/

		// Making buttons with event handlers
		// Image name is used as an id, too
		// cancel = true means it is the cancel button
		function makeButton( buttonPane, img, tooltip, cancel ) {
			const button = $( '<button/>', {
				'class': classes.button,
				title: messages[ tooltip ],
				id: img,
				css: { clear: 'right', float: 'right' }
			})
			.append( $( '<div/>', {
				'class': classes.buttonImage
			}) );

			if ( cancel ) {
				button.click( function() {
					close();
				});
			} else {
				button.click( function( e ) {
					changeInfoPane( e, buttonPane );
				});
			}
			button.appendTo( buttonPane );
		}
	
		// Make an info pane distinguishable by id
		function makeInfoPane( id ) {
			return $( '<div/>', {
				id: classes.prefix + id,
				'class': classes.infoPane,
				css: { display: 'none' }
			});
		}

		// Select an info pane by id and disable its button
		function selectInfoPane( buttonPane, id ) {
			const buttons = buttonPane.children();
			if ( !id ) {
				id = buttons.first().attr( 'id' );
			}
			buttons.each( function() {
				$( this ).prop( 'disabled', $( this ).attr( 'id' ) === id );
			});
		
			buttonPane.siblings().each( function() {
				if ( $( this ).attr( 'id' ) === classes.prefix + id ) {
					$( this ).css( { display: 'flex', 'flex-direction': 'column' } )
						.trigger( 'voy:show' );
				} else {
					$( this ).css( { display: 'none' } );
				}
			});

			buttons.filter( ':disabled' ).next().focus();
		}

		// Event handler for info-pane change triggered by clicking on its
		// belonging buttons or button child images
		function changeInfoPane( e, buttonPane ) {
			const button = $( e.target ).closest( 'button' ),
				id = ( button.length ) ? button.attr( 'id' ) : '';
			if ( id ) {
				selectInfoPane( buttonPane, id );
			}
		}

		/********************** Helper function *******************************/

		// Specifying language of a text and wrap it with right-to-left mark
		// if necessary
		function langSpan( text, lang ) {
			if ( !text ) {
				return '';
			}
			const r2l = {
				ar: ' ',
				dv: ' ',
				fa: ' ',
				he: ' ',
				ms: ' ',
				ur: ' ',
			};
			const dir = ( lang in r2l ) ? ' dir="rtl"' : '';
			const t = mw.format( '<span lang="$1"$2>$3</span>', lang, dir, text );
			return ( lang in r2l ) ? '&rlm;' + t + '&lrm;' : t;
		}
	
		// Getting HTML text from a wrapper tag specified by aClass.
		// context is the dialog itself
		function getHTML( aClass, context ) {
			const span = $( '.' + aClass, context );
			return ( span.length ) ? span.first().html() : '';
		}
	
		function getOuterHTML( aClass, context ) {
			const span = $( '.' + aClass, context );
			return ( span.length ) ? span.first().prop( 'outerHTML' ) : '';
		}
	
		// Making a header with wikilang and country lang identifiers
		function translate( lang, wikiLang, id, separator ) {
			var s = translations[ wikiLang ][ id ];
			if ( wikiLang !== lang ) {
				var t = '';
				if ( lang && lang in translations && id in translations[ lang ] ) {
					t = langSpan( translations[ lang ][ id ], lang );
				} else if ( wikiLang !== 'en' ) {
					t = translations.en[ id ];
				}
				s += ( t ) ? separator + t : '';
			}
			return s;
		}

		// replace spaces and entities
		function replaceEntities( s ) {
			return $( '<span />' ).html( s.replace( /\s/g, '_' ) ).text();
		}

		/**************** Making and filling dialog ***************************/

		// Creating the dialog
		// Event handler called by listingPopup.init
		function dialog( element ) {
			const listing = element.closest( selectors.listing ),
				listingName = $( '.' + classes.name, listing ).first();

			const dialog = open(),
				buttonPane = $( '<div/>', {
				id: classes.buttonPane
			});

			const place = {};
			place.name = listing.attr( data.name );
			if ( !place.name ) {
				const link = $( 'a', listingName ).first();
				place.name = ( link.length ) ? link.text() : listingName.text();
			}
			place.nameHTML = listingName.html();
			place.lang = listing.attr( data.lang );
			const at = place.lang.indexOf( '-' );
			if ( at > -1 ) {
				place.lang = place.lang.substring( 0, at );
			}
			const s = listing.attr( data.nameLocal );
			place.nameLocal = ( s ) ? langSpan( s, place.lang ) : getHTML( classes.alt, listing );

			// adding pages
			for ( var i = 0; i < pages.length; i++ ) {
				pages[ i ]( dialog, buttonPane, listing, place );
			}

			// combining elements
			if ( $( 'button', buttonPane ).length < 2 ) {
				buttonPane.empty();
			}
			makeButton( buttonPane, 'cancelImg', 'closeTooltip', true );
			dialog.append( buttonPane );
			selectInfoPane( buttonPane );
		}

		const pages = [];

		/****** "Bring me to …" page ******/

		function bringMeToPage( dialog, buttonPane, listing, place ) {
            function placeInfo( container, key, keyLocal, wikiLang ) {
                const global = getHTML( classes[ key ], listing );
                var s = ( keyLocal ) ? listing.attr( data[ keyLocal ] ) : null;
                const local = ( s ) ? langSpan( s, place.lang ) : '';
                if ( global || local ) {
                    s = translate( place.lang, wikiLang, key, separators.section );
                    var t = local;
                    if ( global ) {
                        t += ( local ) ? '<br />' + global : global;
                    }
                    container.append( '<dl><dt>' + s + '</dt><dd>' + t + '</dd></dl>' );
                }
            }

           	const buttonId = 'taxiImg';
			var wikiLang = pageLang;
			if ( userLang && translations[ userLang ] ) {
				wikiLang = userLang;
			}

            var s = translate( place.lang, wikiLang, 'takeRequest', separators.header );
			const container = $( '<div/>', {
				'class': classes.container
			});
			const infoPane = makeInfoPane( buttonId )
				.append( makeHeader( s, true ) )
				.append( container );

			s = translate( place.lang, wikiLang, 'name', separators.section );
			var t = place.nameLocal;
			t += ( place.nameLocal ) ? '<br />' + place.name : place.name;
			container.append( '<dl><dt>' + s + '</dt><dd>' + t + '</dd></dl>' );

			placeInfo( container, 'comment', null, wikiLang );
			placeInfo( container, 'address', 'addressLocal', wikiLang );
			placeInfo( container, 'directions', 'directionsLocal', wikiLang );

			dialog.append( infoPane );
			makeButton( buttonPane, buttonId, 'taxiTooltip', false );
		}
		pages.push( bringMeToPage );

		/****** Image page ******/

		function imagePage( dialog, buttonPane, listing, place ) {
			const buttonId = 'figureImg';
			var image = replaceEntities( listing.attr( data.image ) || '' );
			if ( image ) {
				var s = place.nameHTML;
				if ( place.nameLocal ) {
					s += '<br />' + place.nameLocal;
				}

				image = 'https://commons.wikimedia.org/wiki/Special:FilePath/' +
					mw.html.escape( image ) + '?width=700';
				image = mw.format( '<img src="$1" title="$2" />', image, place.name );
				var infoPane = makeInfoPane( buttonId )
					.append( mw.format( '<div class="$1">$2</div>', classes.image, image ) )
					.append( '<p><strong>' + s + '</strong> ' +
						getOuterHTML( classes.commons, listing ) + '</p>' );
				// map support
				mapParams.thumb = image;

				dialog.append( infoPane );
				makeButton( buttonPane, buttonId, 'figureTooltip', false );			
			}
		}
		pages.push( imagePage );

		/****** Map page ******/

		// Creating a Kartographer map
		function createMap() {
			// see also: https://www.mediawiki.org/wiki/Help:Extension:Kartographer/Developer_guide
			mw.loader.using( [ 'ext.kartographer.box' ], function () {
				const kartoBox = mw.loader.require( 'ext.kartographer.box' );

				mapParams.map = kartoBox.map( {
					container: $( '#' + classes.map )[ 0 ],
					center: [ mapParams.lat, mapParams.lon ],
					captionText: mapParams.title,
					zoom: 15,
					allowFullScreen: true,
					alwaysInteractive: true,
					isFullScreen: false,
					featureType: 'mapframe'
				} );

				const mapData = [ {
					'type': 'Feature',
					properties: {
						'marker-color': mapParams.color,
						'marker-size': 'medium',
						'marker-symbol': makiIcons[ mapParams.type ] || '',
						title: mapParams.title,
						description: mapParams.thumb
					},
					geometry: {
						'type': 'Point',
						coordinates: [ mapParams.lon, mapParams.lat ]
					}
				} ];
				const layerOptions = { name: 'Position' };
				mapParams.map.addGeoJSONLayer( mapData, layerOptions );
			} );
		}

		function mapPage( dialog, buttonPane, listing, place ) {
			mapParams.map = null;

			const link = $( selectors.kartographerLink, listing ).first();
			if ( link.length ) {
				const buttonId = 'mapImg';
				var s = place.nameHTML;
				if ( place.nameLocal ) {
					s += '<br />' + place.nameLocal;
				}

				mapParams.title = place.name;
				mapParams.type = listing.attr( data.type );
				mapParams.lat = link.attr( data.lat );
				mapParams.lon = link.attr( data.lon );
				mapParams.color = listing.attr( data.color );

				const infoPane = makeInfoPane( buttonId )
					.append( $( '<div/>', {
						id: classes.map
						}) )
					.append( '<p><strong>' + s + '</strong></p>' )
					.on( 'voy:show', function( event ) {
						// map is created later if dialog is visible
						if ( !mapParams.map ) {
							createMap();
						}
					});

				dialog.append( infoPane );
				makeButton( buttonPane, buttonId, 'mapTooltip', false );
			}
		}
		pages.push( mapPage );

		/****** Contact page ******/

		function contactPage( dialog, buttonPane, listing, place ) {
			function makeImgLink( linkType, link, title ) {
				return mw.format( '<span class="$4 listing-$1" title="$2">' +
					'<a class="external text" href="$3" rel="nofollow">' +
					'<span style="color-adjust:exact;-webkit-print-color-adjust:exact;print-color-adjust:exact">$1</span>' +
					'</a></span> ', linkType, title, link, classes.icon );
			}

			const buttonId = 'contactImg';
			const cFormat = '<p><strong>$1:</strong> $2</p>';
			const container = $( '<div/>', {
				'class': classes.container
			});
			var c, i, s;
			for ( i = 0; i < contactKeys.length; i++ ) {
				c = contactKeys[ i ];
				s = getHTML( classes[ c ], listing );
				if ( s ) {
					container.append( mw.format( cFormat, messages[ c ], s ) );
				}
			}

			s = '';
			const url = listing.attr( data.url );
			if ( url ) {
				s = makeImgLink( 'url', url, messages.urlTooltip );
			}

			const rss = listing.attr( data.rss );
			if ( rss ) {
				s += makeImgLink( 'rss', rss, messages.rssTooltip );
			}

			const socialMedia = $( '.' + classes.socialMedia, listing );
			if ( socialMedia.length ) {
				socialMedia.each( function() {
					s += $( this ).prop( 'outerHTML' );
				});
			}
			if ( s ) {
				container.append( mw.format( cFormat, messages.web, s ) );
			}

			if ( $( 'p', container ).length ) {
				const infoPane = makeInfoPane( buttonId )
					.append( makeHeader( messages.contact, true ) )
					.append( container );
				dialog.append( infoPane );
				makeButton( buttonPane, buttonId, 'contactTooltip', false );
			}
		}
		pages.push( contactPage );

		/****** Features page ******/
		
		function featuresPage( dialog, buttonPane, listing, place ) {
			const buttonId = 'featuresImg';
			const infoPane = makeInfoPane( buttonId )
				.css( { 'overflow-y': 'auto' } );
			var move = true;

			var features = getHTML( classes.features, listing );
			if ( features ) {
				infoPane.append( makeHeader( messages.features, move ) );
				move = false;
				infoPane.append( '<p>' + features + '</p>' );
			}

			var credit = getHTML( classes.credit, listing );
			if ( credit ) {
				infoPane.append( makeHeader( messages.credit, move ) );
				move = false;
				infoPane.append( '<p>' + credit + '</p>' );
			}

			var checkin = getHTML( classes.checkin, listing );
			var checkout = getHTML( classes.checkout, listing );
			var hours = getHTML( classes.hours, listing );
			if ( hours + checkin + checkout ) {
				infoPane.append( makeHeader( messages.hours, move ) );
				if ( hours ) {
					infoPane.append( '<p>' + hours + '</p>' );
				}
				if ( checkin ) {
					infoPane.append( '<p>' + checkin + '</p>' );
				}
				if ( checkout ) {
					infoPane.append( '<p>' + checkout + '</p>' );
				}
			}

			if ( $( 'h2', infoPane ).length ) {
				dialog.append( infoPane );
				makeButton( buttonPane, buttonId, 'featuresTooltip', false );
			}
		}
		pages.push( featuresPage );

		/****** Booking, comparison, and rating page ******/

		function bookingPage( dialog, buttonPane, listing, place ) {
			var count = 0, i, li, s, site;
			const ul = $( '<ul/>', {
				'class': classes.booking
			});

			for ( i = 0; i < sites.length; i++ ) {
				site = sites[ i ];
				s = listing.attr( site.data );
				if ( s ) {
					s = site.formatter.replace( '$1', s );
					li = $( '<li/>', {
						'class': selectors.infoDialog.substring( 1 ) + '-' + site.grClass,
						})
						.append( $( '<a/>', {
							'class': 'external text',
							target: '_blank',
							href: s,
							title: site.title,
							text: site.site
						}) );
					ul.append( li );
					count += 1;
				}
			}
	
			if ( count ) {
				const buttonId = 'bookingImg';
				const container = $( '<div/>', {
					'class': classes.container
				});
				const infoPane = makeInfoPane( buttonId )
					.append( makeHeader( messages.booking, true ) )
					.append( container );

				s = place.nameHTML;
				if ( place.nameLocal ) {
					s += '<br />' + place.nameLocal;
				}
				container.append( '<p>' + s + '</p>' )
					.append( ul );

				dialog.append( infoPane );
				makeButton( buttonPane, buttonId, 'bookingTooltip', false );
			}
		}
		pages.push( bookingPage );

		/*********************** Initialization *******************************/

		// Check if namespace and action is allowed
		function checkIfAllowed() {
			const namespace = mw.config.get( 'wgNamespaceNumber' );
			return allowedNamespaces.includes( namespace );
		}

		// Adding "info" buttons and event handlers after vCard text
		function init() {
			if ( !checkIfAllowed() ) {
				return;
			}
			setupMessages();

			var popupButton = $( '<button/>', {
					title: messages.buttonTooltip,
					text: messages.buttonText
				} )
				.click( function( e ) {
					dialog( $( this ) );
				});
			popupButton = $( '<span/>', {
					'class': 'listing-metadata-item listing-info-button voy-timeless-no-emoji noprint'
				})
				.append( popupButton );

			$( selectors.metadata ).append( popupButton );
		}

		return { init: init };
	} ();
	
	$( listingPopup.init );

} ( jQuery, mediaWiki ) );

//</nowiki>
