
SHELL = /bin/zsh

target_dir := target-data
dist_dir := extracted-data
target_repo := \
	https://github.com/facebook/react \
	https://github.com/facebook/hhvm \
	https://github.com/facebook/relay \
	https://github.com/facebook/react-native \
	https://github.com/facebook/rocksdb \
	https://github.com/facebook/nuclide \
	https://github.com/facebook/chisel \
	https://github.com/rails/rails \
	https://github.com/apple/swift \
	https://github.com/golang/go \
	https://github.com/bower/bower \
	https://github.com/npm/npm \
	https://github.com/php/php-src \
	https://github.com/bbatsov/rubocop \
	https://github.com/eslint/eslint \
	https://github.com/FreeCodeCamp/FreeCodeCamp \
	https://github.com/mbostock/d3 \
	https://github.com/vuejs/vue \
	https://github.com/ruby/ruby \
	https://github.com/robbyrussell/oh-my-zsh \
	https://github.com/Homebrew/brew \
	https://github.com/docker/docker \
	https://github.com/electron/electron \
	https://github.com/twitter/twitter-server \
	https://github.com/WordPress/WordPress
target_name := $(notdir $(target_repo))
database_dir := database

# Target repositories:
# [
#   "FreeCodeCamp/FreeCodeCamp", "twbs/bootstrap", "vhf/free-programming-books",
#   "mbostock/d3", "angular/angular.js", "FortAwesome/Font-Awesome", "facebook/react",
#   "jquery/jquery", "nodejs/node-v0.x-archive", "robbyrussell/oh-my-zsh", "github/gitignore",
#   "sindresorhus/awesome", "airbnb/javascript", "h5bp/html5-boilerplate", "meteor/meteor",
#   "torvalds/linux", "facebook/react-native", "daneden/animate.css", "docker/docker",
#   "rails/rails", "getify/You-Dont-Know-JS", "apple/swift", "Homebrew/legacy-homebrew",
#   "nwjs/nw.js", "hakimel/reveal.js", "electron/electron", "atom/atom", "impress/impress.js",
#   "jlevy/the-art-of-command-line", "moment/moment", "adobe/brackets", "jekyll/jekyll",
#   "Semantic-Org/Semantic-UI", "expressjs/express", "AFNetworking/AFNetworking",
#   "mrdoob/three.js", "socketio/socket.io", "jashkenas/backbone", "driftyco/ionic",
#   "google/material-design-icons", "blueimp/jQuery-File-Upload", "zurb/foundation-sites",
#   "tensorflow/tensorflow", "laravel/laravel", "nodejs/node", "jkbrzt/httpie",
#   "resume/resume.github.com", "chartjs/Chart.js", "NARKOZ/hacker-scripts",
#   "h5bp/Front-end-Developer-Interview-Questions", "necolas/normalize.css", "gulpjs/gulp",
#   "vinta/awesome-python", "google/material-design-lite", "pallets/flask", "nvbn/thefuck",
#   "harvesthq/chosen", "TryGhost/Ghost", "django/django", "kennethreitz/requests",
#   "dypsilon/frontend-dev-bookmarks", "neovim/neovim", "tiimgreen/github-cheat-sheet",
#   "vuejs/vue", "Dogfalo/materialize", "johnpapa/angular-styleguide", "discourse/discourse",
#   "reactjs/redux", "jashkenas/underscore", "ariya/phantomjs", "Modernizr/Modernizr",
#   "nylas/N1", "antirez/redis", "gitlabhq/gitlabhq", "rg3/youtube-dl", "caolan/async",
#   "select2/select2", "tastejs/todomvc", "golang/go", "ansible/ansible", "rust-lang/rust",
#   "Alamofire/Alamofire", "lodash/lodash", "elastic/elasticsearch", "papers-we-love/papers-we-love",
#   "emberjs/ember.js", "bayandin/awesome-awesomeness", "callemall/material-ui",
#   "Trinea/android-open-project", "Prinzhorn/skrollr", "babel/babel",
#   "FezVrasta/bootstrap-material-design", "facebook/pop", "plataformatec/devise",
#   "prakhar1989/awesome-courses", "Polymer/polymer", "webpack/webpack", "getlantern/lantern",
#   "lukehoban/es6features", "numbbbbb/the-swift-programming-language-in-chinese",
#   "open-source-society/computer-science", "kenwheeler/slick", "certbot/certbot",
#   "nvie/gitflow", "balderdashy/sails", "mozilla/pdf.js", "kubernetes/kubernetes",
#   "rs/SDWebImage", "mathiasbynens/dotfiles", "alvarotrigo/fullPage.js", "Microsoft/vscode",
#   "wasabeef/awesome-android-ui", "yahoo/pure", "bower/bower", "typicode/json-server",
#   "caesar0301/awesome-public-datasets", "scrapy/scrapy", "cantino/huginn", "usablica/intro.js",
#   "ReactiveCocoa/ReactiveCocoa", "hammerjs/hammer.js", "gogits/gogs", "Leaflet/Leaflet",
#   "ReactiveX/RxJava", "less/less.js", "facebook/hhvm", "sahat/hackathon-starter",
#   "angular/material", "rethinkdb/rethinkdb", "defunkt/jquery-pjax", "google/web-starter-kit",
#   "IanLunn/Hover", "enaqx/awesome-react", "t4t5/sweetalert", "bevacqua/dragula",
#   "ripienaar/free-for-dev", "git/git", "twbs/ratchet", "Unitech/pm2", "jashkenas/coffeescript",
#   "facebook/immutable-js", "shadowsocks/shadowsocks", "nostra13/Android-Universal-Image-Loader",
#   "josephmisiti/awesome-machine-learning", "reactjs/react-router", "ajaxorg/ace",
#   "avelino/awesome-go", "creationix/nvm", "twitter/typeahead.js", "BradLarson/GPUImage",
#   "limetext/lime", "ftlabs/fastclick", "videojs/video.js", "square/retrofit", "angular-ui/bootstrap",
#   "adam-p/markdown-here", "symfony/symfony", "codepath/android_guides", "bcit-ci/CodeIgniter",
#   "kahun/awesome-sysadmin", "0xAX/linux-insides", "photonstorm/phaser", "syncthing/syncthing",
#   "mitchellh/vagrant", "GitbookIO/gitbook", "angular/angular", "zenorocha/clipboard.js",
#   "ziadoz/awesome-php", "dhg/Skeleton", "firehol/netdata", "ecomfe/echarts", "kriskowal/q",
#   "dokku/dokku", "SnapKit/Masonry", "designmodo/Flat-UI", "VundleVim/Vundle.vim",
#   "sindresorhus/awesome-nodejs", "facebook/flux", "interagent/http-api-design",
#   "Microsoft/TypeScript", "vsouza/awesome-ios", "minimaxir/big-list-of-naughty-strings",
#   "iluwatar/java-design-patterns", "tornadoweb/tornado", "scikit-learn/scikit-learn",
#   "angular/angular-seed", "braydie/HowToBeAProgrammer", "tobiasahlin/SpinKit",
#   "dimsemenov/PhotoSwipe", "rstacruz/nprogress", "square/okhttp", "jdg/MBProgressHUD",
#   "rwaldron/idiomatic.js", "petkaantonov/bluebird", "jasmine/jasmine", "google/iosched",
#   "request/request", "pugjs/pug", "isocpp/CppCoreGuidelines", "justjavac/free-programming-books-zh_CN",
#   "angular-ui/ui-router", "textmate/textmate", "gruntjs/grunt", "twbs/bootstrap-sass",
#   "reddit/reddit", "Valloric/YouCompleteMe", "diaspora/diaspora", "bolshchikov/js-must-watch",
#   "SamyPesse/How-to-Make-a-Computer-Operating-System", "madrobby/zepto", "github/hubot",
#   "karan/Projects", "h5bp/Effeckt.css", "julianshapiro/velocity", "astaxie/build-web-application-with-golang",
#   "pixijs/pixi.js", "feross/webtorrent", "bbatsov/ruby-style-guide", "wycats/handlebars.js",
#   "postcss/postcss", "enyo/dropzone", "BVLC/caffe", "koajs/koa", "kripken/emscripten",
#   "Shopify/dashing", "jmcunningham/AngularJS-Learning", "alex/what-happens-when",
#   "desandro/masonry", "SwiftyJSON/SwiftyJSON", "scottjehl/Respond"
# ]

.PHONY: FORCE test install
FORCE:

all:
	@$(MAKE) install
	@$(MAKE) -j 10 comments
	@$(MAKE) database


# make install
#
# git clone repositories
install:
	@mkdir -p $(target_dir)
	@$(foreach repo, $(target_repo), \
		if [ ! -d             $(target_dir)/$(notdir $(repo)) ]; then \
			git clone $(repo) $(target_dir)/$(notdir $(repo)); \
		fi; \
	)


# make comment-<reponame>
#
# extract comments from the specified repository
define COMMENT

comment-$(1):
	@mkdir -p $(dist_dir)
	ruby ./bin/extract-comment.rb "$(target_dir)/$(1)" > "$(dist_dir)/$(1)-comments.txt"

endef

$(foreach i,$(target_name),$(eval $(call COMMENT,$(i))))


# make comments
#
comments: $(patsubst %, comment-%, $(target_name))


# make detabase
#
# create database of comments
database: FORCE
	-@rm -r $(database_dir)
	@mkdir $(database_dir)
	./bin/split-output-of-extract-comment.rb
	./bin/overwrite-sort-uniq.sh $(database_dir)/*
