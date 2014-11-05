SHELL := /bin/bash
RAW_DATES := august-7 june-1

all: $(patsubst %,gen/voter-turnout-%.csv,$(RAW_DATES))

gen/voter-turnout-%.csv: raw-voter-turnout-%.txt Makefile
	@mkdir -p $(dir $@)
	<$< tr "[a-z]" "[A-Z]" | \
		tr -d ',' | \
		sed -e 's/\(..\)\.\(..\)%/0.\1\2/g' | \
		tr ' ' ',' > $@
