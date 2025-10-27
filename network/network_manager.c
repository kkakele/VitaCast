#include "network_manager.h"
#include <stdlib.h>
#include <curl/curl.h>

typedef struct network_manager_t {
    int connected;
} network_manager_t_impl;

network_manager_t* network_manager_create(void) {
    network_manager_t_impl* n = (network_manager_t_impl*)malloc(sizeof(network_manager_t_impl));
    if (!n) return NULL;
    n->connected = 0;
    return (network_manager_t*)n;
}

void network_manager_destroy(network_manager_t* manager) {
    free(manager);
}

void network_manager_update(network_manager_t* manager) {
    (void)manager;
}

void network_manager_connect(network_manager_t* manager) {
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    n->connected = 1;
}
