exp = require 'express'
app = exp()
cns = require 'consolidate'
fs  = require 'fs'
hmz = require 'humanize-plus'
mkd = require 'marked'
pth = require 'path'
tof = require 'toffee'

cfg = {
	port: 4747
}



log = console.log

get_markdown = (page,cb) ->
	fs.readFile pth.join('content', "#{page}.md"), (err,file) ->
		if err then return cb err, ''
		
		cb null, mkd file.toString 'utf8'

make_title = (page) ->
	log page
	title = hmz.titleCase page
	"UlrichDev | #{title}"

not_found_404 = "<p>We could not find the page you asked for. It may not exist anymore, or you may just be wrong. If there are enough requests we might (re)create it.</p>"

app.engine 'toffee', cns.toffee

app.set 'view engine', 'toffee'
app.set 'views', pth.join __dirname, 'content'

app.enable 'trust proxy'
app.get 'trust proxy'

app.use '/static', exp.static pth.join __dirname, 'static'

# app.use '/content', page_renderer (toffee, requested bit in middle)
app.use '/(:page)?', (req,res) ->
	log "hit page handler"
	
	page = req.params.page ? 'home'
	
	get_markdown page, (err,body) ->
		if err then body = not_found_404
		
		res.render 'scaffold', {
			content: body,
			page: page,
			title: make_title page
		}

app.listen cfg.port, () ->
	log "Webserver started [express, port #{cfg.port}]"