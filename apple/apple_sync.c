#include "apple_sync.h"
#include <stdlib.h>

typedef struct apple_sync_t {
    int dummy;
} apple_sync_t_impl;

apple_sync_t* apple_sync_create(void) {
    apple_sync_t_impl* s = (apple_sync_t_impl*)malloc(sizeof(apple_sync_t_impl));
    if (!s) return NULL;
    s->dummy = 0;
    return (apple_sync_t*)s;
}

void apple_sync_destroy(apple_sync_t* sync) {
    free(sync);
}

void apple_sync_update(apple_sync_t* sync) {
    (void)sync;
}
