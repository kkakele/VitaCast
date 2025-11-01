#include <vitasdk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <curl/curl.h>
#include <vita2d.h>  // Usar stub si la librer?a no est? disponible
#include "ui/ui_manager.h"
#include "audio/audio_player.h"
#include "network/network_manager.h"
// #include "apple/apple_sync.h"  // COMENTADO para prueba
// #include "audio/atrac_decoder.h"  // COMENTADO para prueba

#define APP_TITLE "VitaCast"
#define APP_VERSION "2.0.0"

typedef struct {
    app_state_t current_state;
    bool running;
    vita2d_texture *background_texture;
    ui_manager_t *ui_manager;
    audio_player_t *audio_player;
    network_manager_t *network_manager;
    // apple_sync_t *apple_sync;  // COMENTADO para prueba
} vita_cast_app_t;

static vita_cast_app_t *app = NULL;

static int vita_cast_init() {
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x00, 0x00, 0x00, 0xFF));
    curl_global_init(CURL_GLOBAL_DEFAULT);
    
    app = malloc(sizeof(vita_cast_app_t));
    if (!app) return -1;
    
    memset(app, 0, sizeof(vita_cast_app_t));
    app->running = true;
    app->current_state = APP_STATE_MAIN_MENU;
    
    app->ui_manager = ui_manager_create();
    app->audio_player = audio_player_create();
    app->network_manager = network_manager_create();
    // app->apple_sync = apple_sync_create();  // COMENTADO para prueba
    
    if (!app->ui_manager || !app->audio_player || 
        !app->network_manager) {  // Removido apple_sync
        return -1;
    }
    
    network_manager_connect(app->network_manager);
    app->background_texture = vita2d_load_PNG_file("app0:/assets/background.png");
    
    return 0;
}

static void vita_cast_cleanup() {
    if (app) {
        if (app->background_texture) {
            vita2d_free_texture(app->background_texture);
        }
        
        if (app->ui_manager) ui_manager_destroy(app->ui_manager);
        if (app->audio_player) audio_player_destroy(app->audio_player);
        if (app->network_manager) network_manager_destroy(app->network_manager);
        // if (app->apple_sync) apple_sync_destroy(app->apple_sync);  // COMENTADO
        
        free(app);
    }
    
    curl_global_cleanup();
    vita2d_fini();
}

static void vita_cast_render() {
    vita2d_start_drawing();
    vita2d_clear_screen();
    
    if (app->background_texture) {
        vita2d_draw_texture(app->background_texture, 0, 0);
    } else {
        vita2d_draw_rectangle(0, 0, 960, 544, RGBA8(0x1a, 0x1a, 0x1a, 0xFF));
    }
    
    switch (app->current_state) {
        case APP_STATE_MAIN_MENU:
            ui_manager_render_main_menu(app->ui_manager);
            break;
        case APP_STATE_PODCASTS:
            ui_manager_render_podcasts(app->ui_manager);
            break;
        case APP_STATE_MUSIC:
            ui_manager_render_music(app->ui_manager);
            break;
        case APP_STATE_PLAYER:
            ui_manager_render_player(app->ui_manager);
            break;
        case APP_STATE_SETTINGS:
            ui_manager_render_settings(app->ui_manager);
            break;
        case APP_STATE_SEARCH:
            ui_manager_render_search(app->ui_manager);
            break;
        case APP_STATE_DOWNLOADS:
            ui_manager_render_downloads(app->ui_manager);
            break;
    }
    
    vita2d_end_drawing();
    vita2d_swap_buffers();
}

static void vita_cast_update() {
    ui_manager_update(app->ui_manager);
    audio_player_update(app->audio_player);
    network_manager_update(app->network_manager);
    // apple_sync_update(app->apple_sync);  // COMENTADO para prueba
    
    app_state_t new_state = ui_manager_get_requested_state(app->ui_manager);
    if (new_state != app->current_state) {
        app->current_state = new_state;
    }
}

int main() {
    if (vita_cast_init() < 0) {
        return -1;
    }
    
    while (app->running) {
        vita_cast_update();
        vita_cast_render();
        vita2d_wait_rendering_done();
    }
    
    vita_cast_cleanup();
    return 0;
}
