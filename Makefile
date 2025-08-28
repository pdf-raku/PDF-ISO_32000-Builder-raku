# to-json
PDF=src/PDF32000_2008.pdf
PDF_URL=https://opensource.adobe.com/dc-acrobat-sdk-docs/standards/pdfstandards/pdf/PDF32000_2008.pdf
# -- Stage I --
XML=PDF-ISO_32000.xml
HTML=PDF-ISO_32000.html

# export paths
ROLE_BASE=ISO_32000
EXPORT_REPO=git@github.com:pdf-raku/PDF-ISO_32000-raku.git
EXPORT_ROOT=../PDF-ISO_32000-raku
RESOURCE_DIR=$(EXPORT_ROOT)/resources/ISO_32000
MODULE_DIR=$(EXPORT_ROOT)/lib/$(ROLE_BASE)

# -- Stage II --
SOURCES = $(wildcard $(RESOURCE_DIR)/*.json)
RESOURCES = $(SOURCES) $(wildcard $(RESOURCE_DIR)/misc/*.json)
RESOURCE_NAMES = $(subst $(RESOURCE_DIR),ISO_32000,$(RESOURCES))

# -- Stage III --
MODULES = $(subst $(RESOURCE_DIR),$(MODULE_DIR),$(patsubst %.json,%.rakumod,$(SOURCES)))

all :
	@echo "*** Initialising ***"
	@zef --deps-only install .
	@echo "*** Stage-I: Extracting tagged content from ISO-32000 (PDF Specification) ***"
	@$(MAKE) pdf-to-xml
	@echo "*** Stage-II: Extracting specification tables as JSON resources ***"
	@$(MAKE) xml-to-json
	@echo "*** Stage-III: Converting JSON resources to Raku roles ***"
	@$(MAKE) json-to-raku
	@echo "*** Stage-IV: Publishing (resource index, README.md, META6.json) ****"
	@$(MAKE) meta6 readme
	@echo "*** generate HTML ***"
	@$(MAKE) xml-to-html

## Setup
setup : $(EXPORT_ROOT) $(PDF)

$(PDF) :
	wget -O $(PDF) $(PDF_URL)

$(EXPORT_ROOT) :
	git clone $(EXPORT_REPO) $(EXPORT_ROOT)

pdf-to-xml : $(XML)

xml-to-html : $(HTML)

$(XML) : $(PDF)
	pdf-tag-dump --omit=Span --valid --css=tagged-pdf.css $(PDF) > $(XML);

$(HTML) : $(XML)
	xslt --xsl=iso32000.xsl $(XML) > $(HTML)

xml-to-json : pdf-to-xml
	raku etc/make-json.raku --make --out-dir=$(RESOURCE_DIR) $(XML)

json-to-raku : $(MODULES)

$(MODULES): $(MODULE_DIR)/%.rakumod: $(RESOURCE_DIR)/%.json
	raku etc/make-modules.raku --role-name="$(ROLE_BASE)::$(basename $(notdir $@))" $< > $@ 

readme : $(EXPORT_ROOT)/README.md

$(EXPORT_ROOT)/README.md : $(EXPORT_ROOT)/src/README.in $(MODULES)
	(cat $< ; raku -I $(EXPORT_ROOT)/lib etc/make-readme-tables.raku  --root=$(EXPORT_ROOT) $(MODULES)) > $@

meta6 : $(EXPORT_ROOT)/resources/ISO_32000-index.json $(EXPORT_ROOT)/META6.json

$(EXPORT_ROOT)/resources/ISO_32000-index.json $(EXPORT_ROOT)/META6.json : $(EXPORT_ROOT)/src/META6.in $(MODULES) $(RESOURCES)
	raku etc/make-meta6.raku --root=$(EXPORT_ROOT) $< $(MODULES) $(RESOURCE_NAMES) > $(EXPORT_ROOT)/META6.json

clean : 
	rm -vf $(EXPORT_ROOT)/META6.json $(EXPORT_ROOT)/README.md $(EXPORT_ROOT)/resources/ISO_32000-index.json $(RESOURCE_DIR)/*.json $(RESOURCE_DIR)/misc/*.json $(MODULE_DIR)/*.rakumod

# Slowest step is generating the XML extract
realclean : clean
	rm -vf $(XML)
	rm -vf $(PDF)
