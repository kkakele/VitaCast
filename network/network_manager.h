#pragma once
#include <stdbool.h>

typedef enum {
    NET_STATE_DISCONNECTED = 0,
    NET_STATE_CONNECTING,
    NET_STATE_CONNECTED,
    NET_STATE_ERROR
} network_state_t;

typedef struct network_manager_t network_manager_t;

network_manager_t* network_manager_create(void);
void network_manager_destroy(network_manager_t* manager);
void network_manager_update(network_manager_t* manager);

bool network_manager_connect(network_manager_t* manager);
void network_manager_disconnect(network_manager_t* manager);
network_state_t network_manager_get_state(network_manager_t* manager);

bool network_manager_is_connected(network_manager_t* manager);
const char* network_manager_get_status_text(network_manager_t* manager);
