# Makefile for TazPkg Web.
#
TEXTDOMAIN?=tazpkg-web.pot
LINGUAS?=de fr pt_BR ru zh

all: msgfmt

# i18n

pot:
	xgettext -o po/$(TEXTDOMAIN) -L Shell \
		--package-name="TazPkg Web" \
		./search.sh ./lib/header.sh

msgmerge:
	@for l in $(LINGUAS); do \
		echo -n "Updating $$l po file."; \
		msgmerge -U po/$$l.po po/$(TEXTDOMAIN); \
	done;

msgfmt:
	@for l in $(LINGUAS); do \
		echo "Compiling $$l mo file..."; \
		mkdir -p po/mo/$$l/LC_MESSAGES; \
		msgfmt -o po/mo/$$l/LC_MESSAGES/$(TEXTDOMAIN) po/$$l.po; \
	done;

# Clean source

clean:
	rm -rf po/mo
	rm -f po/*.mo
	rm -f po/*.*~

