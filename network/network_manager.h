#pragma once
#include <stdbool.h>

typedef struct network_manager_t network_manager_t;

network_manager_t* network_manager_create(void);
void network_manager_destroy(network_manager_t* manager);
void network_manager_update(network_manager_t* manager);
void network_manager_connect(network_manager_t* manager);
