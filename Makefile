.POSIX:

CRYSTAL = /usr/lib/crystal/bin/crystal
CRYSTAL_SRC = /usr/share/crystal/src
CRYSTAL_LIB = /usr/lib/crystal/lib
CRFLAGS = --release

CRYSTAL_PATH = src:$(CRYSTAL_SRC)
LIBS = $(CRYSTAL_SRC)/ext/libcrystal.a -lgc -ldl -levent -lpcre -lpthread
LDFLAGS = -L$(CRYSTAL_LIB) ./libcounter.a $(LIBS)

libcounter.a: libcounter.o
	ar rcs libcounter.a libcounter.o

libcounter.o: src/counter.cr src/libcounter.cr src/crystal/main.cr
	CRYSTAL_PATH="$(CRYSTAL_PATH)" $(CRYSTAL) build $(CRFLAGS) --cross-compile -o libcounter src/libcounter.cr

test: counter_test
	./counter_test

counter_test: libcounter.a test/counter_test.c
	cc test/counter_test.c $(LDFLAGS) -o counter_test

leak_test: libcounter.a test/leak_test.c
	cc test/leak_test.c $(LDFLAGS) -o leak_test
	./leak_test

reference_test: libcounter.a test/reference_test.c
	cc test/reference_test.c $(LDFLAGS) -o reference_test
	./reference_test

clean: phony
	rm -f libcounter.a libcounter.o *_test bc_flags

phony:
