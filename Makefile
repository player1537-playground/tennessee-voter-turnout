SHELL := /bin/bash

noop :=
space := $(noop) $(noop)
comma := $(noop),$(noop)

TURNOUT_DATES := august-2-2012 august-5-2010 august-7-2014 march-6-2012 \
	november-2-2010 november-6-2012
REGISTRATION_DATES := june-2014 june-2013 june-2012 december-2013 december-2012 \
	december-2011
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
