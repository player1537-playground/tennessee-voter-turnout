SHELL := /bin/bash
RAW_DATES := august-7 june-1
GEN_FILES := $(patsubst %,gen/voter-turnout-%.csv,$(RAW_DATES))

all: $(GEN_FILES)

voter-turnout.zip: $(GEN_FILES)
	rm $@
	zip $@ $^

gen/voter-turnout-%.csv: raw-voter-turnout-%.txt Makefile
	@mkdir -p $(dir $@)
	<$< tr "[a-z]" "[A-Z]" | \
		tr -d ',' | \
		sed -e 's/\(..\)\.\(..\)%/0.\1\2/g' | \
		tr ' ' ',' > $@
