SHELL := /bin/bash
TURNOUT_DATES := august-2-2012 august-5-2010 august-7-2014 march-6-2012 \
	november-2-2010 november-6-2012
REGISTRATION_DATES := june-2014 june-2013 june-2012 december-2013 december-2012 \
	december-2011
GEN_FILES := $(patsubst %,gen/voter-turnout-%.csv,$(TURNOUT_DATES)) \
	$(patsubst %,gen/voter-registration-%.csv,$(REGISTRATION_DATES))

all: $(GEN_FILES)

.PHONY: clean
clean:
	rm gen/ -r

voter-turnout.zip: $(GEN_FILES)
	rm -f $@
	zip $@ $^

gen/voter-%.csv: raw/voter-%.txt Makefile
	@mkdir -p $(dir $@)
	<$< tr "[a-z]" "[A-Z]" | \
		tr -d ',' | \
		sed -e ':a; 1 ! { /^[^0-9 ,]* [^0-9 ,]/ { s/^\([^0-9 ,]*\) /\1_/; ta; }; }' | \
		sed -e 's/\([0-9]\{0,2\}\)\.\([0-9]\{2\}\)%/0.\1\2/g' | \
		tr ' ' ',' > $@
