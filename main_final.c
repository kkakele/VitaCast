#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
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
    vita2d_pgf *font;
    int selected_item;
    int menu_items;
} vita_cast_app_t;

static vita_cast_app_t *app = NULL;

static int vita_cast_init() {
    printf("Inicializando %s %s...\n", APP_TITLE, APP_VERSION);
    
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x00, 0x00, 0x00, 0xFF));
    
    app = malloc(sizeof(vita_cast_app_t));
    if (!app) {
        printf("Error: no se pudo alocar memoria\n");
        return -1;
    }
    
    memset(app, 0, sizeof(vita_cast_app_t));
    app->running = true;
    app->current_state = APP_STATE_MAIN_MENU;
    app->selected_item = 0;
    app->menu_items = 4;
    
    // Cargar fuente
    app->font = vita2d_load_default_pgf();
    if (!app->font) {
        printf("Advertencia: no se pudo cargar la fuente\n");
    }
    
    // Intentar cargar textura de fondo
    app->background_texture = vita2d_load_PNG_file("app0:/assets/background.png");
    if (!app->background_texture) {
        printf("Advertencia: no se pudo cargar background.png\n");
    }
    
    printf("Inicializaci\xc3\xb3n completada\n");
    return 0;
}

static void vita_cast_cleanup() {
    if (app) {
        if (app->background_texture) {
            vita2d_free_texture(app->background_texture);
            app->background_texture = NULL;
        }
        if (app->font) {
            vita2d_free_pgf(app->font);
            app->font = NULL;
        }
        free(app);
        app = NULL;
    }
    vita2d_fini();
    printf("VitaCast finalizado\n");
}

static void vita_cast_render() {
    vita2d_start_drawing();
    vita2d_clear_screen();
    
    // Fondo
    if (app->background_texture) {
        vita2d_draw_texture(app->background_texture, 0, 0);
    } else {
        vita2d_draw_rectangle(0, 0, 960, 544, RGBA8(0x1A, 0x1A, 0x1A, 0xFF));
    }
    
    // T\xc3\xadtulo
    if (app->font) {
        vita2d_pgf_draw_text(app->font, 30, 50, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.8f, APP_TITLE);
        vita2d_pgf_draw_text(app->font, 30, 85, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 0.9f, "Podcast & Music Player");
    }
    
    // Men\xc3\xba
    const char* menu_items[] = {"Podcasts", "M\xc3\xbasica", "Reproductor", "Configuraci\xc3\xb3n"};
    int start_y = 200;
    int item_height = 60;
    
    for (int i = 0; i < app->menu_items; i++) {
        int y = start_y + (i * item_height);
        uint32_t bg_color = (i == app->selected_item) ? RGBA8(0x00, 0x7A, 0xFF, 0x60) : RGBA8(0x20, 0x20, 0x20, 0x40);
        uint32_t text_color = (i == app->selected_item) ? RGBA8(0xFF, 0xFF, 0xFF, 0xFF) : RGBA8(0xAA, 0xAA, 0xAA, 0xFF);
        
        // Fondo del item
        vita2d_draw_rectangle(150, y - 10, 660, 50, bg_color);
        
        // Indicador
        if (i == app->selected_item) {
            vita2d_draw_rectangle(160, y + 5, 5, 20, RGBA8(0x00, 0x7A, 0xFF, 0xFF));
        }
        
        // Texto
        if (app->font) {
            vita2d_pgf_draw_text(app->font, 180, y + 20, text_color, 1.2f, menu_items[i]);
        }
    }
    
    // Ayuda
    if (app->font) {
        vita2d_pgf_draw_text(app->font, 30, 520, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 0.7f, 
            "START: Salir | X: Seleccionar | O: Volver | D-Pad: Navegar");
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

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    if (vita_cast_init() < 0) {
        printf("Error: fallo al inicializar\n");
        vita_cast_cleanup();
        sceKernelDelayThread(3 * 1000000);
        sceKernelExitProcess(0);
        return -1;
    }
    
    while (app && app->running) {
        vita_cast_update();
        vita_cast_render();
        vita2d_wait_rendering_done();
        sceKernelDelayThread(16666); // ~60 FPS
    }
    
    vita_cast_cleanup();
    sceKernelExitProcess(0);
    return 0;
}
