# Configuration
GEDIT_PLUGIN_DIR = ~/.local/share/gedit/plugins

# Data for i18n
AUTHOR="Bruno Schneider"
AUTHOR_EMAIL="boschneider@gmail.com"
VERSION=0.1
DOMAIN=messages
APPLICATION="Indent Converter (gedit plugin)"
PACKAGE="Indent Converter"
POT_FILE="locale/indent-converter.pot"
YEAR := $(shell date +%Y)

install:
	@if [ ! -d $(GEDIT_PLUGIN_DIR) ]; then \
		mkdir -p $(GEDIT_PLUGIN_DIR);\
	fi
	@echo "installing indent-converter plugin";
	@rm -rf $(GEDIT_PLUGIN_DIR)/indent-converter*;
	@cp -Rv indent-converter.py indent-converter.plugin locale $(GEDIT_PLUGIN_DIR);

i18n: $(POT_FILE) compile-locales

uninstall:
	@echo "uninstalling indent-converter plugin";
	@rm -rf $(GEDIT_PLUGIN_DIR)/indent-converter*;

# Generates a l10n .po-template by searching through source files (private)
$(POT_FILE): indent-converter.py
	xgettext --language=Python \
	         --copyright-holder=$(AUTHOR) \
	         --package-name=$(APPLICATION) \
	         --package-version=$(VERSION) \
	         --msgid-bugs-address=$(AUTHOR_EMAIL) \
	         --output=$(POT_FILE) \
	         *.py
	sed -i 's/SOME DESCRIPTIVE TITLE/Indent Converter message catalog/' $(POT_FILE)
	sed -i 's/YEAR/$(YEAR)/g' $(POT_FILE)
	sed -i 's/PACKAGE/$(PACKAGE)/' $(POT_FILE)
	sed -i 's/FIRST AUTHOR/$(subst ",,$(AUTHOR))/' $(POT_FILE)
	sed -i 's/EMAIL@ADDRESS/$(subst ",,$(AUTHOR_EMAIL))/' $(POT_FILE)
	sed -i 's/#, fuzzy//' $(POT_FILE)
# Generates the binary l10n .mo-files for all known languages
compile-locales:
	for arq in $(wildcard locale/*/*.po); \
	    do msgfmt $$arq -o $${arq%/*}/LC_MESSAGES/$(DOMAIN).mo; done

