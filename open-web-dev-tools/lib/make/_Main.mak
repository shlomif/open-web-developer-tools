all: dummy

# Toggle to generate production code with compressed and merged JS code/etc.
PROD = 0

RSYNC = rsync --progress --verbose --rsh=ssh -a --inplace

D = ./dest
TEMP_UPLOAD_URL = $${__HOMEPAGE_REMOTE_PATH}/open-web-dev-tools-temp
UPLOAD_URL = $(TEMP_UPLOAD_URL)

ifeq ($(PROD),1)

	D = ./dest-prod

	UPLOAD_URL = hostgator:domains/open-web-dev-tools/public_html

endif

IMAGES_PRE1 = $(SRC_IMAGES)
IMAGES = $(addprefix $(D)/,$(IMAGES_PRE1))

SRC_DIRS = js
SUBDIRS = $(addprefix $(D)/,$(SRC_DIRS))

CSS_TARGETS = $(D)/style.css $(D)/print.css $(D)/jqui-override.css $(D)/web-fc-solve.css

DEST_WEB_FC_SOLVE_UI_MIN_JS = $(D)/js/web-fcs.min.js
DEST_JSES = $(D)/js/require--debug.js $(D)/js/require.js $(D)/js/jq.js

dummy : $(D) $(SUBDIRS) $(IMAGES) $(DEST_WEB_FC_SOLVE_UI_MIN_JS) $(CSS_TARGETS) htaccesses_target $(DEST_JSES)

SASS_STYLE = compressed
# SASS_STYLE = expanded
SASS_CMD = sass --style $(SASS_STYLE)

SASS_HEADERS = lib/sass/common-style.sass

$(CSS_TARGETS): $(D)/%.css: lib/sass/%.sass $(SASS_HEADERS)
	$(SASS_CMD) $< $@

$(D) $(SUBDIRS): % :
	@if [ ! -e $@ ] ; then \
		mkdir $@ ; \
	fi

$(DEST_JSES) $(IMAGES): $(D)/% : src/%
	cp -f $< $@

MULTI_YUI = ./bin/Run-YUI-Compressor

WEB_FCS_UI_JS_SOURCES = $(D)/js/ms-rand.js
$(DEST_WEB_FC_SOLVE_UI_MIN_JS): $(WEB_FCS_UI_JS_SOURCES)
	$(MULTI_YUI) -o $@ $(WEB_FCS_UI_JS_SOURCES)

DEST_BABEL_JSES = $(D)/js/ms-rand.js

all: $(DEST_BABEL_JSES)

$(DEST_BABEL_JSES): $(D)/%.js: lib/babel/%.js
	babel -o $@ $<

TYPESCRIPT__TOOLS = lowercase minify_json prettify_json urlencode uppercase
TYPESCRIPT_DEST_FILES__BASE = $(patsubst %,tools/%,$(TYPESCRIPT__TOOLS)) tools-tests-1 open-web-dev-tools--base
TYPESCRIPT_DEST_FILES = $(patsubst %,$(D)/js/%.js,$(TYPESCRIPT_DEST_FILES__BASE))
TYPESCRIPT_DEST_FILES__NODE = $(patsubst $(D)/%.js,lib/for-node/%.js,$(TYPESCRIPT_DEST_FILES))
TYPESCRIPT_COMMON_DEFS_FILES =

JS_DEST_FILES__NODE =

all: $(JS_DEST_FILES__NODE)

$(JS_DEST_FILES__NODE): lib/for-node/%.js: dest/%.js
	cp -f $< $@

all: $(TYPESCRIPT_DEST_FILES) $(TYPESCRIPT_DEST_FILES__NODE)

$(TYPESCRIPT_DEST_FILES): $(D)/%.js: src/%.ts
	tsc --module amd --out $@ $(TYPESCRIPT_COMMON_DEFS_FILES) $<

$(TYPESCRIPT_DEST_FILES__NODE): lib/for-node/%.js: src/%.ts
	tsc --target es5 --module commonjs --outDir lib/for-node/js $(TYPESCRIPT_COMMON_DEFS_FILES) $<

TOOLS_PAGES_PIVOT = dest/tools/uppercase/index.xhtml

all: $(TOOLS_PAGES_PIVOT)

TOOLS_PAGES_GEN = bin/gen_tools_pages.py

$(TOOLS_PAGES_PIVOT): $(TOOLS_PAGES_GEN)
	mkdir -p dest/tools
	python3 $<

.PHONY:

ALL_HTACCESSES = $(D)/.htaccess

htaccesses_target: $(ALL_HTACCESSES)

$(ALL_HTACCESSES): $(D)/%.htaccess: src/%my_htaccess.conf
	cp -f $< $@

upload: all
	$(RSYNC) $(D)/ $(UPLOAD_URL)

upload_local: all
	$(RSYNC) $(D)/ /var/www/html/$(USER)/open-web-dev-tools

test: all
	prove Tests/*.t

runtest: all
	runprove Tests/*.t

clean:
	rm -f lib/fc-solve-for-javascript/*.bc lib/fc-solve-for-javascript/*.js $(TYPESCRIPT_DEST_FILES__NODE) $(TYPESCRIPT_DEST_FILES) $(TS_CHART_DEST)

# A temporary target to edit the active files.
edit:
	gvim -o bin/gen_tools_pages.py

%.show:
	@echo "$* = $($*)"
