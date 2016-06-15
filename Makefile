CRYSTAL_ROOT ?= /opt/crystal
CRYSTAL_BIN = $(CRYSTAL_ROOT)/bin/crystal
CRYSTAL_PATH := src:$(CRYSTAL_ROOT)/src
CRYSTAL_LIBS = $(CRYSTAL_ROOT)/src/ext/libcrystal.a -lgc -ldl -levent -lpcre
LIBS = ./libcounter.a $(CRYSTAL_LIBS)

libcounter.a: libcounter.o
	ar rcs libcounter.a libcounter.o

libcounter.o: src/counter.cr src/libcounter.cr src/main.cr
	CRYSTAL_PATH="$(CRYSTAL_PATH)" $(CRYSTAL_BIN) compile \
		--release --cross-compile -o libcounter src/libcounter.cr

test: counter_test
	./counter_test

counter_test: libcounter.a test/counter_test.c
	cc test/counter_test.c $(LIBS) -o counter_test

leak_test: libcounter.a test/leak_test.c
	cc test/leak_test.c $(LIBS) -o leak_test
	./leak_test

reference_test: libcounter.a test/reference_test.c
	cc test/reference_test.c $(LIBS) -o reference_test
	./reference_test

.PHONY: clean
clean:
	rm -f libcounter.a libcounter.o *_test bc_flags
