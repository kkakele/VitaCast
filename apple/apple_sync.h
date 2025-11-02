#pragma once
#include <stdbool.h>

typedef enum {
    APPLE_STATE_NOT_SIGNED_IN = 0,
    APPLE_STATE_SIGNED_IN,
    APPLE_STATE_SYNCING,
    APPLE_STATE_ERROR
} apple_sync_state_t;

typedef struct apple_sync_t apple_sync_t;

apple_sync_t* apple_sync_create(void);
void apple_sync_destroy(apple_sync_t* sync);
void apple_sync_update(apple_sync_t* sync);

bool apple_sync_sign_in(apple_sync_t* sync, const char* apple_id);
void apple_sync_sign_out(apple_sync_t* sync);
bool apple_sync_is_signed_in(apple_sync_t* sync);

apple_sync_state_t apple_sync_get_state(apple_sync_t* sync);
const char* apple_sync_get_status_text(apple_sync_t* sync);
const char* apple_sync_get_user_email(apple_sync_t* sync);
