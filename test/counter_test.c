#include <assert.h>
#include "../src/crystal.h"
#include "../src/counter.h"

#define NDEBUG 1

int main(int argc, char *argv[]) {
    counter_t counter;
    int i = 0;

    crystal_library_init(1, argv);

    counter = counter_new(0);
    assert(counter_actual(counter) == 0);

    counter_incr(counter, 1);
    assert(counter_actual(counter) == 1);

    counter_incr(counter, 2);
    assert(counter_actual(counter) == 3);

    counter_decr(counter, 1);
    assert(counter_actual(counter) == 2);

    counter_decr(counter, 2);
    assert(counter_actual(counter) == 0);

    counter_free(counter);
    return 0;
}
