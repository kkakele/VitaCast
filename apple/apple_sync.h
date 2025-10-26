#pragma once
#include <stdbool.h>

typedef struct apple_sync_t apple_sync_t;

apple_sync_t* apple_sync_create(void);
void apple_sync_destroy(apple_sync_t* sync);
void apple_sync_update(apple_sync_t* sync);
