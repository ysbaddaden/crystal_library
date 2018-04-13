#include "../src/crystal.h"
#include "../src/counter.h"
#include <gc.h>

// The program must never segfault because GC collected the counter reference.
int main(int argc, char *argv[]) {
    counter_t counter;
    int i = 0;

    crystal_library_init(1, argv);
    counter = counter_new(0);

    for (;; i++) {
        counter_incr(counter, 1);
        counter_decr(counter, 1);
        GC_gcollect();
    }

    counter_free(counter);
    return 0;
}
