exp = require 'express'
app = exp()
mkd = require 'marked'
pth = require 'path'
tof = require 'toffee'

cfg = {
	port: 4747
}

log = console.log

app.use '/static', exp.static pth.join __dirname, 'static'

# app.use '/content', page_renderer (toffee, requested bit in middle)

app.all '*', (req,res) ->
	res.render '404', {}

app.listen cfg.port, () ->
	log "Webserver started [express, port #{cfg.port}]"