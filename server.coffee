# ulrichdev: A minimal web/blog server in coffeescript. Experimental.
# Copyright (C) 2014 - 2016  David Ulrich (http://github.com/dulrich)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

exp = require 'express'
app = exp()
B   = require 'bluebird'
cns = require 'consolidate'
fs  = require 'fs'
fs.readFileB = B.promisify fs.readFile
fs.readdirB = B.promisify fs.readdir
hlt = require 'highlight.js'
hmz = require 'humanize-plus'
_   = require 'lodash'
mkd = require 'marked'
pth = require 'path'
rdr = new mkd.Renderer
tof = require 'toffee'

cfg = {
	port : 4747
}

mkd_opt = {
	breaks      : false
	gfm         : true
	highlight   : (code) -> hlt.highlightAuto(code).value
	pedantic    : false
	renderer    : rdr
	sanitize    : true
	smartLists  : true
	smartypants : false
	tables      : true
}

log = console.log

blog_load = (load) ->
	fs.readdirB 'content'
		.map (file) ->
			file.match /^(\d\d\d\d-\d\d-\d\d)-(.+)(.md)$/
		.filter (file) ->
			file?
		.map (file) ->
			out = {
				date  : file[1]
				title : hmz.titleCase file[2].replace /-/g, ' '
				path  : [file[1],file[2]].join('-')
			}
			
			if !load then return out
			
			fs.readFileB pth.join 'content', file[0]
			.then (content) ->
				out.content = mkd content.toString('utf8'), mkd_opt
				out
		.then (blogs) ->
			_(blogs).sortBy (blog) ->
				parseInt blog.date.replace(/-/g,''), 10
			.reverse()
			.valueOf()
		.catch (err) -> []

blog_posts = (start,count) ->
	blog_load(true).then (blogs) ->
		_(blogs).sortBy (blog) ->
			parseInt blog.date.replace(/-/g,''), 10
		.reverse()
		.slice start, count
		.valueOf()

month_index = {
	january   :  1
	february  :  2
	march     :  3
	april     :  4
	may       :  5
	june      :  6
	july      :  7
	august    :  8
	september :  9
	october   : 10
	november  : 11
	december  : 12
}

month_reduce = (mmap,file,i) ->
	mmap[file.month] = mmap[file.month] || []
	mmap[file.month].push file
	mmap

garden_images = () ->
	fs.readdirB 'static/img'
		.map (file) ->
			file.match /^garden-([a-z]+)-(.+).jpg$/
		.filter (file) ->
			file?
		.map (file) ->
			{
				month : file[1]
				name  : file[0]
				title : hmz.titleCase file[2].replace /-/g, ' '
			}
		.reduce month_reduce,{}
		.then (mmap) ->
			_(mmap).sortBy (list,month) ->
				return month_index[month]
			.valueOf()
		.catch (err) -> []

get_markdown = (page) ->
	fs.readFileB pth.join 'content', "#{page}.md"
		.then (file) -> mkd file.toString('utf8'), mkd_opt

make_title = (page) ->
	title = hmz.titleCase page
	"UlrichDev | #{title}"

render_page = (res,body,page) ->
	res.render 'scaffold', {
		extra   : body.extra ? ''
		images  : body.images ? {}
		posts   : body.posts ? []
		content : body.content ? body
		page    : page
		title   : make_title page
		year    : new Date().getFullYear()
	}


not_found_404 = "<p>We could not find the page you asked for. It may not exist anymore, or you may just be wrong. If there are enough requests we might (re)create it.</p>"

app.engine 'toffee', cns.toffee

app.set 'view engine', 'toffee'
app.set 'views', pth.join __dirname, 'content'

app.enable 'trust proxy'
app.get 'trust proxy'

app.use '/static', exp.static pth.join __dirname, 'static'

app.use '/(:page)?', (req,res) ->
	page = req.params.page ? 'home'
	
	get_markdown page
		.then (body) ->
			switch page
				when 'home'
					return blog_posts 0,3
					.then (posts) -> {
						content : body
						posts   : posts
						extra   : 'blog_roll'
					}
				when 'garden'
					return garden_images()
					.then (images) -> {
						content : body
						images  : images
						extra   : 'garden'
					}
				when 'archive'
					return blog_load false
					.then (posts) -> {
						content : body
						posts   : posts
						extra   : 'blog_list'
					}
				else
					body
		.then (body) -> render_page res, body, page
		.catch (err) ->
			log err
			render_page res, not_found_404, page

app.listen cfg.port, () ->
	log "Webserver started [express, port #{cfg.port}]"

