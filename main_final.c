#include <vitasdk.h>
#include <vita2d.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define APP_TITLE "VitaCast"
#define APP_VERSION "1.0.0"

typedef enum {
    APP_STATE_MAIN_MENU,
    APP_STATE_PODCASTS,
    APP_STATE_MUSIC,
    APP_STATE_PLAYER,
    APP_STATE_SETTINGS
} app_state_t;

typedef struct {
    app_state_t current_state;
    bool running;
    vita2d_texture *background_texture;
    int selected_item;
    int menu_items;
} vita_cast_app_t;

static vita_cast_app_t *app = NULL;

static int vita_cast_init() {
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x00, 0x00, 0x00, 0xFF));
    
    app = malloc(sizeof(vita_cast_app_t));
    if (!app) return -1;
    
    memset(app, 0, sizeof(vita_cast_app_t));
    app->running = true;
    app->current_state = APP_STATE_MAIN_MENU;
    app->selected_item = 0;
    app->menu_items = 4;
    
    app->background_texture = vita2d_load_PNG_file("app0:/assets/background.png");
    
    return 0;
}

static void vita_cast_cleanup() {
    if (app) {
        if (app->background_texture) {
            vita2d_free_texture(app->background_texture);
        }
        free(app);
    }
    vita2d_fini();
}

static void vita_cast_render() {
    vita2d_start_drawing();
    vita2d_clear_screen();
    
    if (app->background_texture) {
        vita2d_draw_texture(app->background_texture, 0, 0);
    } else {
        vita2d_draw_rectangle(0, 0, 960, 544, RGBA8(0x1A, 0x1A, 0x1A, 0xFF));
    }
    
    // Dibujar menú
    int start_y = 200;
    int item_height = 60;
    
    for (int i = 0; i < app->menu_items; i++) {
        int y = start_y + (i * item_height);
        uint32_t color = (i == app->selected_item) ? RGBA8(0x00, 0x7A, 0xFF, 0xFF) : RGBA8(0xFF, 0xFF, 0xFF, 0xFF);
        
        if (i == app->selected_item) {
            vita2d_draw_rectangle(100, y - 10, 760, 50, RGBA8(0x00, 0x7A, 0xFF, 0x40));
        }
        
        vita2d_draw_rectangle(120, y, 20, 20, color);
        vita2d_draw_rectangle(150, y, 200, 20, color);
    }
    
    vita2d_end_drawing();
    vita2d_swap_buffers();
}

static void handle_input() {
    SceCtrlData pad;
    sceCtrlPeekBufferPositive(0, &pad, 1);
    
    static SceCtrlData old_pad = {0};
    
    if ((pad.buttons & SCE_CTRL_DOWN) && !(old_pad.buttons & SCE_CTRL_DOWN)) {
        app->selected_item = (app->selected_item + 1) % app->menu_items;
    }
    if ((pad.buttons & SCE_CTRL_UP) && !(old_pad.buttons & SCE_CTRL_UP)) {
        app->selected_item = (app->selected_item - 1 + app->menu_items) % app->menu_items;
    }
    
    if ((pad.buttons & SCE_CTRL_CROSS) && !(old_pad.buttons & SCE_CTRL_CROSS)) {
        switch (app->selected_item) {
            case 0: app->current_state = APP_STATE_PODCASTS; break;
            case 1: app->current_state = APP_STATE_MUSIC; break;
            case 2: app->current_state = APP_STATE_PLAYER; break;
            case 3: app->current_state = APP_STATE_SETTINGS; break;
        }
    }
    
    if ((pad.buttons & SCE_CTRL_CIRCLE) && !(old_pad.buttons & SCE_CTRL_CIRCLE)) {
        app->current_state = APP_STATE_MAIN_MENU;
    }
    
    if ((pad.buttons & SCE_CTRL_START) && !(old_pad.buttons & SCE_CTRL_START)) {
        app->running = false;
    }
    
    old_pad = pad;
}

static void vita_cast_update() {
    handle_input();
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
