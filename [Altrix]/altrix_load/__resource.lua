resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.5.0'

loadscreen 'html/index.html'

files {
	-- Load Index Page
	'client.lua',
	'html/index.html',
	-- Load Bootstrap & Custom Styles
	'html/css/bootstrap.min.css',
	'html/css/custom.css',
	'html/css/morphext.css',
	-- Load jQuery, Bootstrap and JavaScript 
	'html/js/jquery.min.js',
	'html/js/bootstrap.min.js',
	'html/js/popper.min.js',
	'html/js/app.js',
	'html/js/morphext.min.js',
	-- Load Image Resources
	'html/img/logo.png',
	'html/img/back.png',
	-- Load Audio Source
	'html/audioyoung.mp3'
}

client_script "client.lua"


