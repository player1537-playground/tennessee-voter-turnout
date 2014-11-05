SHELL := /bin/bash
TURNOUT_DATES := august-2014
REGISTRATION_DATES := june-2014
GEN_FILES := $(patsubst %,gen/voter-turnout-%.csv,$(TURNOUT_DATES)) \
	$(patsubst %,gen/voter-registration-%.csv,$(REGISTRATION_DATES))

all: $(GEN_FILES)

.PHONY: clean
clean:
	rm gen/ -r

voter-turnout.zip: $(GEN_FILES)
	rm $@
	zip $@ $^

gen/voter-%.csv: raw/voter-%.txt Makefile
	@mkdir -p $(dir $@)
	<$< tr "[a-z]" "[A-Z]" | \
		tr -d ',' | \
		sed -e 's/\(..\)\.\(..\)%/0.\1\2/g' | \
		tr ' ' ',' > $@
