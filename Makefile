all: .site

wiki/.commit:
	git clone git@github.com:freenet/wiki.wiki.git $(dir $@) && cd wiki && git log HEAD^..HEAD --oneline --no-decorate > .commit

FILES = $(wildcard wiki/*.md) $(wildcard wiki/*.mediawiki) $(wildcard wiki/*.textile)

.site: wiki/.commit Makefile README.md
	mkdir -p site; $(foreach file,$(FILES),pandoc "$(file)" $(if $(filter $(suffix $(file)),.mediawiki),--from mediawiki) -o "site/$(basename $(notdir $(file))).html"; if ! test -e "site/$(basename $(notdir $(file))).html"; then cp "$(file)" site/; emacs -nw -q -L $(dir $@) "site/$(notdir $(file))" --eval "(require 'htmlize)" --eval "(htmlize-buffer)" --eval "(progn (switch-to-buffer \"$(notdir $(file)).html\")(write-file \"$(basename $(notdir $(file))).html\"))" --eval "(kill-emacs)"; fi; )
	cp Makefile README.md htmlize.el site/
