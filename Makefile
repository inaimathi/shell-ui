define deploy-lang
	rsync -v --exclude '*~' $(1)/* /usr/bin/
endef

install: install-python

install-python:
	$(call deploy-lang, python)

install-ruby:
	$(call deploy-lang, ruby)