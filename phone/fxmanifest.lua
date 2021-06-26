fx_version 'bodacious'
game 'gta5'


ui_page 'html/ui.html'
files {
	'html/icons/*.png',
	'html/icons/*.gif',
	'html/ui.html',
	'html/gurgle.png',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/fondo.jpg',
	'html/backgroundwhite.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/timeago.js',
}

client_scripts {
	'@es_extended/locale.lua',
	'configs/client_custom.lua',
	'locales/*.lua',
	'configs/config.lua',
	'client/apps.lua',
	'client/open.lua',
	'client/main.lua',
	'client/yellowpages.lua',
	'client/services.lua',
	'client/calls.lua',
	'client/eWallet.lua',
	'client/appstore.lua',
	'client/contacts.lua',
	'client/functions.lua',
	'client/photos.lua',
	'client/twitter.lua',
	'client/animations.lua',
}

server_script {
	'configs/config.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	"server/server.lua",
	"server/llamados.lua",
}
