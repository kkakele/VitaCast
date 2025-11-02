#include "network_manager.h"
#include <psp2/net/net.h>
#include <psp2/net/netctl.h>
#include <psp2/sysmodule.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct network_manager_t {
    network_state_t state;
    char status_text[128];
    int initialized;
} network_manager_t_impl;

network_manager_t* network_manager_create(void) {
    network_manager_t_impl* n = (network_manager_t_impl*)malloc(sizeof(network_manager_t_impl));
    if (!n) return NULL;
    
    memset(n, 0, sizeof(network_manager_t_impl));
    n->state = NET_STATE_DISCONNECTED;
    n->initialized = 0;
    strncpy(n->status_text, "Not connected", sizeof(n->status_text) - 1);
    
    // Inicializar módulos de red
    sceSysmoduleLoadModule(SCE_SYSMODULE_NET);
    
    // Inicializar red
    SceNetInitParam net_param;
    memset(&net_param, 0, sizeof(net_param));
    net_param.memory = malloc(256 * 1024);
    net_param.size = 256 * 1024;
    net_param.flags = 0;
    
    if (sceNetInit(&net_param) >= 0) {
        if (sceNetCtlInit() >= 0) {
            n->initialized = 1;
        }
    }
    
    return (network_manager_t*)n;
}

void network_manager_destroy(network_manager_t* manager) {
    if (!manager) return;
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    
    if (n->initialized) {
        sceNetCtlTerm();
        sceNetTerm();
    }
    
    free(manager);
}

void network_manager_update(network_manager_t* manager) {
    if (!manager) return;
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    
    if (!n->initialized) return;
    
    // Verificar estado de conexión
    int state = 0;
    if (sceNetCtlInetGetState(&state) >= 0) {
        if (state > 0) {
            if (n->state != NET_STATE_CONNECTED) {
                n->state = NET_STATE_CONNECTED;
                strncpy(n->status_text, "Connected to WiFi", sizeof(n->status_text) - 1);
            }
        } else {
            if (n->state != NET_STATE_DISCONNECTED) {
                n->state = NET_STATE_DISCONNECTED;
                strncpy(n->status_text, "Not connected", sizeof(n->status_text) - 1);
            }
        }
    }
}

bool network_manager_connect(network_manager_t* manager) {
    if (!manager) return false;
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    
    if (!n->initialized) return false;
    
    n->state = NET_STATE_CONNECTING;
    strncpy(n->status_text, "Connecting...", sizeof(n->status_text) - 1);
    
    // En una implementación real, aquí se conectaría al WiFi
    // Por ahora simulamos una conexión exitosa
    int state = 0;
    if (sceNetCtlInetGetState(&state) >= 0 && state > 0) {
        n->state = NET_STATE_CONNECTED;
        strncpy(n->status_text, "Connected to WiFi", sizeof(n->status_text) - 1);
        return true;
    }
    
    n->state = NET_STATE_ERROR;
    strncpy(n->status_text, "Connection failed", sizeof(n->status_text) - 1);
    return false;
}

void network_manager_disconnect(network_manager_t* manager) {
    if (!manager) return;
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    
    n->state = NET_STATE_DISCONNECTED;
    strncpy(n->status_text, "Disconnected", sizeof(n->status_text) - 1);
}

network_state_t network_manager_get_state(network_manager_t* manager) {
    if (!manager) return NET_STATE_DISCONNECTED;
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    return n->state;
}

bool network_manager_is_connected(network_manager_t* manager) {
    if (!manager) return false;
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    return (n->state == NET_STATE_CONNECTED);
}

const char* network_manager_get_status_text(network_manager_t* manager) {
    if (!manager) return "Unknown";
    
    network_manager_t_impl* n = (network_manager_t_impl*)manager;
    return n->status_text;
}
