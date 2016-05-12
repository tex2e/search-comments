
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
	https://github.com/WordPress/WordPress \
	https://github.com/angular/angular.js \
	https://github.com/jquery/jquery \
	https://github.com/meteor/meteor \
	https://github.com/torvalds/linux \
	https://github.com/atom/atom \
	https://github.com/adobe/brackets \
	https://github.com/jekyll/jekyll \
	https://github.com/expressjs/express \
	https://github.com/mrdoob/three.js \
	https://github.com/jashkenas/backbone \
	https://github.com/django/django \
	https://github.com/rg3/youtube-dl \
	https://github.com/jashkenas/underscore \
	https://github.com/ariya/phantomjs \
	https://github.com/ansible/ansible \
	https://github.com/jashkenas/coffeescript \
	https://github.com/mitchellh/vagrant \
	https://github.com/Microsoft/TypeScript \
	https://github.com/pugjs/pug \
	https://github.com/github/hubot
target_name := $(notdir $(target_repo))
database_dir := database

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
