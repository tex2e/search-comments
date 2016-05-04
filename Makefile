
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
	https://github.com/facebook/chisel
target_name := $(notdir $(target_repo))

.PHONY: test install

test:
	@echo $(target_repo)
	@echo $(target_name)

install:
	@$(foreach repo, $(target_repo), \
		if [ ! -d             $(target_dir)/$(notdir $(repo)) ]; then \
			git clone $(repo) $(target_dir)/$(notdir $(repo)); \
		fi; \
	)


define EXTRACT_COMMENT

comment-$(1):
	find $(target_dir)/$(1) -type f -name "*.*" -not -path "$(target_dir)/$(1)/.git/*" \
	| xargs -L 127 ./bin/extract-comment.rb \
	> $(dist_dir)/$(1)-comments.txt

endef

$(foreach i,$(target_name),$(eval $(call EXTRACT_COMMENT,$(i))))
