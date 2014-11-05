SHELL := /bin/bash

noop :=
space := $(noop) $(noop)
comma := $(noop),$(noop)

TURNOUT_DATES := 2010-08-05 2010-11-02 2012-03-06 2012-08-02 \
	 2012-11-06 2014-08-07
REGISTRATION_DATES := 2011-12 2012-06 2012-12 2013-06 2013-12 2014-06
GEN_CSV_TURNOUT_FILES := \
	$(patsubst %,gen/csv/voter-turnout-%.csv,$(TURNOUT_DATES))
GEN_CSV_REGISTRATION_FILES := \
	$(patsubst %,gen/csv/voter-registration-%.csv,$(REGISTRATION_DATES))
GEN_CSV_FILES := $(GEN_CSV_TURNOUT_FILES) $(GEN_CSV_REGISTRATION_FILES)

GEN_TURNOUT_CSV := gen/voter-turnout.csv
GEN_REGISTRATION_CSV := gen/voter-registration.csv
GEN_LARGE_CSV := $(GEN_TURNOUT_CSV) $(GEN_REGISTRATION_CSV)

GEN_FILES := $(GEN_CSV_FILES) $(GEN_LARGE_CSV)

all: $(GEN_FILES)

.PHONY: clean
clean:
	rm gen/ -r

voter-turnout.zip: $(GEN_FILES)
	rm -f $@
	zip $@ $^

gen/csv/voter-%.csv: raw/voter-%.txt Makefile
	@mkdir -p $(dir $@)
	<$< tr "[a-z]" "[A-Z]" | \
		tr -d ',' | \
		sed -e ':a; 1 ! { /^[^0-9 ,]* [^0-9 ,]/ { s/^\([^0-9 ,]*\) /\1_/; ta; }; }' | \
		sed -e 's/\([0-9]\{0,2\}\)\.\([0-9]\{2\}\)%/0.\1\2/g' | \
		tr ' ' ',' > $@

gen/voter-turnout.csv: $(GEN_CSV_TURNOUT_FILES)
	csvstack -g $(subst $(space),$(comma),$(TURNOUT_DATES)) -n DATE $^ \
		> $@

gen/voter-registration.csv: $(GEN_CSV_REGISTRATION_FILES)
	csvstack -g $(subst $(space),$(comma),$(REGISTRATION_DATES)) -n DATE $^ \
		> $@

gen/county/turnout-%.csv: gen/voter-turnout.csv
	@mkdir -p $(dir $@)
	csvgrep -c COUNTY -m $* $< > $@
