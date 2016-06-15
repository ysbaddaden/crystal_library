typedef void *counter_t;

counter_t counter_new(int);
void counter_free(counter_t);

int counter_actual(counter_t);
int counter_incr(counter_t, int);
int counter_decr(counter_t, int);
