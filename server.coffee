exp = require 'express'
app = exp()
B   = require 'bluebird'
cns = require 'consolidate'
fs  = require 'fs'
fs.readFileB = B.promisify fs.readFile
hlt = require 'highlight.js'
hmz = require 'humanize-plus'
mkd = require 'marked'
pth = require 'path'
tof = require 'toffee'

cfg = {
	port: 4747
}

mkd.setOptions {
	highlight: (code) -> hlt.highlightAuto(code).value
}


log = console.log

get_markdown = (page) ->
	fs.readFileB pth.join('content', "#{page}.md")
	  .then (file) -> mkd file.toString 'utf8'

make_title = (page) ->
	title = hmz.titleCase page
	"UlrichDev | #{title}"

render_page = (res,body,page) ->
	res.render 'scaffold', {
		content: body,
		page: page,
		title: make_title page
	}


not_found_404 = "<p>We could not find the page you asked for. It may not exist anymore, or you may just be wrong. If there are enough requests we might (re)create it.</p>"

app.engine 'toffee', cns.toffee

app.set 'view engine', 'toffee'
app.set 'views', pth.join __dirname, 'content'

app.enable 'trust proxy'
app.get 'trust proxy'

app.use '/static', exp.static pth.join __dirname, 'static'

# app.use '/content', page_renderer (toffee, requested bit in middle)
app.use '/(:page)?', (req,res) ->
	page = req.params.page ? 'home'
	
	get_markdown page
		.then (body) -> render_page res, body, page
		.catch (err) -> render_page res, not_found_404, page

app.listen cfg.port, () ->
	log "Webserver started [express, port #{cfg.port}]"