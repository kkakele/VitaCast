#include "ui_manager.h"
#include <psp2/ctrl.h>
#include <vita2d.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct ui_manager_t {
    app_state_t requested_state;
    int frame_counter;
    int selected_item;
    int max_items;
    vita2d_pgf *font;
} ui_manager_t_impl;

ui_manager_t* ui_manager_create(void) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)malloc(sizeof(ui_manager_t_impl));
    if (!m) return NULL;
    
    m->requested_state = APP_STATE_MAIN_MENU;
    m->frame_counter = 0;
    m->selected_item = 0;
    m->max_items = 5;
    
    // Cargar fuente por defecto
    m->font = vita2d_load_default_pgf();
    if (!m->font) {
        printf("Advertencia: UI Manager no pudo cargar fuente\n");
    }
    
    return (ui_manager_t*)m;
}

void ui_manager_destroy(ui_manager_t* manager) {
    if (manager) {
        ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
        if (m->font) {
            vita2d_free_pgf(m->font);
        }
        free(manager);
    }
}

void ui_manager_update(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    
    SceCtrlData pad;
    sceCtrlPeekBufferPositive(0, &pad, 1);
    
    static SceCtrlData old_pad = {0};
    
    // Navegaci?n por men?
    if ((pad.buttons & SCE_CTRL_DOWN) && !(old_pad.buttons & SCE_CTRL_DOWN)) {
        m->selected_item = (m->selected_item + 1) % m->max_items;
    }
    if ((pad.buttons & SCE_CTRL_UP) && !(old_pad.buttons & SCE_CTRL_UP)) {
        m->selected_item = (m->selected_item - 1 + m->max_items) % m->max_items;
    }
    
    // Selecci?n de opciones
    if ((pad.buttons & SCE_CTRL_CROSS) && !(old_pad.buttons & SCE_CTRL_CROSS)) {
        switch (m->selected_item) {
            case 0: m->requested_state = APP_STATE_PODCASTS; break;
            case 1: m->requested_state = APP_STATE_MUSIC; break;
            case 2: m->requested_state = APP_STATE_PLAYER; break;
            case 3: m->requested_state = APP_STATE_SEARCH; break;
            case 4: m->requested_state = APP_STATE_SETTINGS; break;
        }
    }
    
    // Volver al men? principal con bot?n O
    if ((pad.buttons & SCE_CTRL_CIRCLE) && !(old_pad.buttons & SCE_CTRL_CIRCLE)) {
        m->requested_state = APP_STATE_MAIN_MENU;
        m->selected_item = 0;
    }
    
    old_pad = pad;
    m->frame_counter++;
}

static void draw_menu_item(vita2d_pgf *font, const char* text, int y, int selected, int index) {
    uint32_t bg_color = (index == selected) ? RGBA8(0x00, 0x7A, 0xFF, 0x60) : RGBA8(0x20, 0x20, 0x20, 0x40);
    uint32_t text_color = (index == selected) ? RGBA8(0xFF, 0xFF, 0xFF, 0xFF) : RGBA8(0xAA, 0xAA, 0xAA, 0xFF);
    
    // Fondo del item
    vita2d_draw_rectangle(150, y - 10, 660, 50, bg_color);
    
    // Texto
    if (font) {
        vita2d_pgf_draw_text(font, 170, y + 20, text_color, 1.2f, text);
    }
    
    // Indicador de selecci?n
    if (index == selected) {
        vita2d_draw_rectangle(160, y + 5, 5, 20, RGBA8(0x00, 0x7A, 0xFF, 0xFF));
    }
}

void ui_manager_render_main_menu(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    
    // T?tulo del men?
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "Men\xc3\xba Principal");
    }
    
    // Opciones del men?
    const char* menu_items[] = {"Podcasts", "M\xc3\xbasica", "Reproductor", "Buscar", "Configuraci\xc3\xb3n"};
    int start_y = 200;
    int item_height = 60;
    
    for (int i = 0; i < 5; i++) {
        draw_menu_item(m->font, menu_items[i], start_y + (i * item_height), m->selected_item, i);
    }
}

void ui_manager_render_podcasts(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "Podcasts");
        vita2d_pgf_draw_text(m->font, 150, 250, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "No hay podcasts disponibles");
    }
}

void ui_manager_render_music(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "M\xc3\xbasica");
        vita2d_pgf_draw_text(m->font, 150, 250, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "No hay m\xc3\xbasica disponible");
    }
}

void ui_manager_render_player(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "Reproductor");
        vita2d_pgf_draw_text(m->font, 150, 250, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "No hay reproducci\xc3\xb3n activa");
    }
}

void ui_manager_render_settings(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "Configuraci\xc3\xb3n");
        vita2d_pgf_draw_text(m->font, 150, 250, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "Versi\xc3\xb3n: 2.0.0");
    }
}

void ui_manager_render_search(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "Buscar Podcasts");
        vita2d_pgf_draw_text(m->font, 150, 250, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "Introduce t\xc3\xa9rmino de b\xc3\xbasqueda");
    }
}

void ui_manager_render_downloads(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_pgf_draw_text(m->font, 150, 150, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "Descargas");
        vita2d_pgf_draw_text(m->font, 150, 250, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "No hay descargas activas");
    }
}

app_state_t ui_manager_get_requested_state(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    return m->requested_state;
}
