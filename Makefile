
CPPFLAGS += -Isrc
ABI := $(shell mkdir -p bin && cc $(CPPFLAGS) -o bin/get_abi get_abi.c && bin/get_abi)
LIB := lib/$(ABI)

CFLAGS += -fPIC
LDFLAGS += -L$(LIB)

all: $(LIB)/libstackman.a

obj = src/stackman.o src/stackman_s.o


$(LIB)/libstackman.a: lib $(obj)
	$(AR) $(ARFLAGS) -s $@ $(obj)

.PHONY: lib bin
lib:
	mkdir -p $(LIB)
bin:
	mkdir bin

clean:
	rm -f src/*.o tests/*.o
	rm -f bin/*

DEBUG = #-DDEBUG_DUMP

.PHONY: test tests

test: tests
	bin/test
	bin/test_cc
	bin/test_static
	bin/test_asm
	@echo "*** All test suites passed ***"

tests: bin/test
tests: bin/test_cc
tests: bin/test_static
tests: bin/test_asm
tests: LDLIBS := -lstackman

bin/test: tests/test.o $(LIB)/libstackman.a
	$(CC) $(LDFLAGS) -o $@ $< ${DEBUG} $(LDLIBS)

bin/test_cc: tests/test_cc.o $(LIB)/libstackman.a
	$(CXX) $(LDFLAGS) -o $@ $< ${DEBUG} $(LDLIBS)

bin/test_static: tests/test_static.o
	$(CC) $(LDFLAGS) -o $@ $^ ${DEBUG}

bin/test_asm: tests/test_asm.o tests/test_asm_s.o
	$(CC) $(LDFLAGS) -o $@ $^ ${DEBUG}
