#include "../src/crystal.h"
#include "../src/counter.h"

// The program must never grow of memory, and the counter reference must be
// eventually collected by GC, or immediately, that depends on the counter_free
// implementation.
int main(int argc, char *argv) {
    counter_t counter;
    int i = 0;

    crystal_library_init();

    for (;; i++) {
        counter = counter_new(0);
        counter_incr(counter, 1);
        counter_decr(counter, 1);
        counter_free(counter);
    }

    return 0;
}
