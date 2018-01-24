
SHELL = /bin/bash

all: dummy

WITH_DEVEL_VERSION = 1

DEVEL_VER_USE_CACHE = 1

# Toggle to generate production code with compressed and merged JS code/etc.
PROD = 0

RSYNC = rsync --progress --verbose --rsh=ssh -a --inplace

D = ./dest
WML_FLAGS = -DBERLIOS=BERLIOS

#D = /home/httpd/html/ip-noise

TEMP_UPLOAD_URL = $${__HOMEPAGE_REMOTE_PATH}/fc-solve-temp
UPLOAD_URL = $(TEMP_UPLOAD_URL)

ifeq ($(PROD),1)

	D = ./dest-prod

	WML_FLAGS += -DPRODUCTION=1

	UPLOAD_URL = hostgator:domains/fc-solve/public_html

endif

IMAGES_PRE1 = $(SRC_IMAGES)
IMAGES = $(addprefix $(D)/,$(IMAGES_PRE1))

# WML_FLAGS = -DBERLIOS=BERLIOS

HTMLS = $(addprefix $(D)/,$(SRC_DOCS))

INCLUDES_PROTO = std/logo.wml
INCLUDES = $(addprefix lib/,$(INCLUDES_PROTO))

# Remming out because it confuses the validator and no longer needed because
# the web-server now supports indexes.
# SUBDIRS_WITH_INDEXES = $(WIN32_BUILD_SUBDIRS)
#
SRC_DIRS = js
SUBDIRS = $(addprefix $(D)/,$(SRC_DIRS))

INDEXES = $(addsuffix /index.html,$(SUBDIRS_WITH_INDEXES))


COMMON_PREPROC_FLAGS = -I $$HOME/conf/wml/Latemp/lib -I../lib
LATEMP_WML_FLAGS =$(shell latemp-config --wml-flags)

TTML_FLAGS += $(COMMON_PREPROC_FLAGS)
WML_FLAGS += $(COMMON_PREPROC_FLAGS)

WML_FLAGS += --passoption=2,-X3074 \
	-DLATEMP_SERVER=fc-solve -DLATEMP_THEME=better-scm \
	$(LATEMP_WML_FLAGS) --passoption=3,-I../lib/ \
	-I $${HOME}/apps/wml

CSS_TARGETS = $(D)/style.css $(D)/print.css $(D)/jqui-override.css $(D)/web-fc-solve.css

DEST_WEB_FC_SOLVE_UI_MIN_JS = $(D)/js/web-fcs.min.js

dummy : $(D) $(SUBDIRS) $(HTMLS) $(IMAGES) $(RAW_SUBDIRS) $(ARC_DOCS) $(INDEXES) $(DOCS_AUX) $(DOCS_HTMLS) $(DEST_LIBFREECELL_SOLVER_JS) $(DEST_LIBFREECELL_SOLVER_JS_NON_MIN) $(DEST_QSTRING_JS) $(DEST_WEB_FC_SOLVE_UI_MIN_JS) $(CSS_TARGETS) htaccesses_target

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

RECENT_STABLE_VERSION = $(shell ./get-recent-stable-version.sh)

$(ARC_DOCS): $(D)/% : ../../source/%.txt
	cp -f "$<" "$@"

$(DOCS_AUX): $(D)/docs/distro/% : ../../source/%
	cp -f "$<" "$@"

$(DOCS_HTMLS): $(D)/docs/distro/% : ../../source/%
	cat "$<" | perl -0777 -lapE 's#<table #<table summary="identifiers on the left, descriptions on the right" #g' > "$@"

$(HTMLS): $(D)/% : src/%.wml src/.wmlrc template.wml $(INCLUDES)
	WML_LATEMP_PATH="$$(perl -MFile::Spec -e 'print File::Spec->rel2abs(shift)' '$@')" ; \
	(cd src && wml -o "$${WML_LATEMP_PATH}" $(WML_FLAGS) -DLATEMP_FILENAME="$(patsubst src/%.wml,%,$<)" $(patsubst src/%,%,$<))

$(IMAGES): $(D)/% : src/%
	cp -f $< $@

$(RAW_SUBDIRS): $(D)/% : src/%
	rm -fr $@
	cp -r $< $@

MULTI_YUI = ./bin/Run-YUI-Compressor

$(DEST_LIBFREECELL_SOLVER_JS): $(LIBFREECELL_SOLVER_JS)
	cp -f $< $@

$(DEST_QSTRING_JS): lib/jquery/jquery.querystring.js
	$(MULTI_YUI) -o $@ $<


WEB_FCS_UI_JS_SOURCES = $(D)/js/ms-rand.js
$(DEST_WEB_FC_SOLVE_UI_MIN_JS): $(WEB_FCS_UI_JS_SOURCES)
	$(MULTI_YUI) -o $@ $(WEB_FCS_UI_JS_SOURCES)

FCS_VALID_DEST = $(D)/js/fcs-validate.js

TYPINGS = src/js/typings/index.d.ts

DEST_BABEL_JSES = $(D)/js/ms-rand.js

all: $(TYPINGS) $(DEST_BABEL_JSES)

$(DEST_BABEL_JSES): $(D)/%.js: lib/babel/%.js
	babel -o $@ $<

$(TYPINGS):
	cd src/js && typings install dt~qunit --global --save

TEST_FCS_VALID_DEST = $(D)/js/web-fc-solve-tests--fcs-validate.js

TYPESCRIPT_DEST_FILES = $(FCS_VALID_DEST) $(TEST_FCS_VALID_DEST) $(D)/js/tools-tests-1.js
TYPESCRIPT_DEST_FILES__NODE = $(patsubst $(D)/%.js,lib/for-node/%.js,$(TYPESCRIPT_DEST_FILES))
TYPESCRIPT_COMMON_DEFS_FILES = src/js/typings/index.d.ts

JS_DEST_FILES__NODE =

all: $(JS_DEST_FILES__NODE)

$(JS_DEST_FILES__NODE): lib/for-node/%.js: dest/%.js
	cp -f $< $@

all: $(TYPESCRIPT_DEST_FILES) $(TYPESCRIPT_DEST_FILES__NODE)

$(TYPESCRIPT_DEST_FILES): $(D)/%.js: src/%.ts
	tsc --module amd --out $@ $(TYPESCRIPT_COMMON_DEFS_FILES) $<

$(TYPESCRIPT_DEST_FILES__NODE): lib/for-node/%.js: src/%.ts
	tsc --target es5 --module commonjs --outDir lib/for-node/js $(TYPESCRIPT_COMMON_DEFS_FILES) $<

$(TEST_FCS_VALID_DEST): $(patsubst $(D)/%.js,src/%.ts,$(FCS_VALID_DEST))

FC_PRO_4FC_DUMPS = $(filter charts/fc-pro--4fc-intractable-deals--report/data/%.dump.txt,$(SRC_IMAGES))
FC_PRO_4FC_TSVS = $(patsubst %.dump.txt,$(D)/%.tsv,$(FC_PRO_4FC_DUMPS))
FC_PRO_4FC_FILTERED_TSVS = $(patsubst %.dump.txt,$(D)/%.filtered.tsv,$(FC_PRO_4FC_DUMPS))

$(FC_PRO_4FC_TSVS): $(D)/%.tsv: src/%.dump.txt
	perl ../../scripts/convert-dbm-fc-solver-log-to-tsv.pl <(< "$<" perl -lapE 's#[^\t]*\t##') | perl -lanE 'print join"\t",@F[0,2]' > "$@"

$(FC_PRO_4FC_FILTERED_TSVS): %.filtered.tsv : %.tsv
	perl -lanE 'say if ((not /\A[0-9]/) or ($$F[0] % 1_000_000 == 0))' < "$<" > "$@"

$(D)/js-fc-solve/text/index.html: lib/FreecellSolver/ExtractGames.pm ../../source/USAGE.txt

$(D)/charts/fc-pro--4fc-intractable-deals--report/index.html $(D)/charts/fc-pro--4fc-deals-solvability--report/index.html: $(FC_PRO_4FC_FILTERED_TSVS) $(FC_PRO_4FC_TSVS)

all: $(FC_PRO_4FC_TSVS) $(FC_PRO_4FC_FILTERED_TSVS)

.PHONY:

# Build index.html pages for the appropriate sub-directories.
$(INDEXES): $(D)/%/index.html : src/% gen_index.pl
	perl gen_index.pl $< $@

ALL_HTACCESSES = $(D)/.htaccess

htaccesses_target: $(ALL_HTACCESSES)

$(ALL_HTACCESSES): $(D)/%.htaccess: src/%my_htaccess.conf
	cp -f $< $@

upload: all
	$(RSYNC) $(D)/ $(UPLOAD_URL)

# upload_temp: all
#	$(RSYNC) $(TEMP_UPLOAD_URL)

upload_local: all
	$(RSYNC) $(D)/ /var/www/html/shlomif/fc-solve-temp

test: all
	prove Tests/*.t

runtest: all
	runprove Tests/*.t

clean:
	rm -f lib/fc-solve-for-javascript/*.bc lib/fc-solve-for-javascript/*.js $(TYPESCRIPT_DEST_FILES__NODE) $(TYPESCRIPT_DEST_FILES) $(TS_CHART_DEST)

# A temporary target to edit the active files.
edit:
	gvim -o src/js/fcs-validate.ts src/js/web-fc-solve-tests--fcs-validate.ts

%.show:
	@echo "$* = $($*)"
