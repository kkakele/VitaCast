#include "ui_manager.h"
#include <psp2/ctrl.h>
#include <psp2/kernel/threadmgr.h>
#include <vita2d.h>
#include <stdlib.h>
#include <string.h>

typedef struct ui_manager_t {
    app_state_t requested_state;
    int frame_counter;
} ui_manager_t_impl;

ui_manager_t* ui_manager_create(void) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)malloc(sizeof(ui_manager_t_impl));
    if (!m) return NULL;
    m->requested_state = APP_STATE_MAIN_MENU;
    m->frame_counter = 0;
    return (ui_manager_t*)m;
}

void ui_manager_destroy(ui_manager_t* manager) {
    free(manager);
}

void ui_manager_update(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    SceCtrlData pad;
    sceCtrlPeekBufferPositive(0, &pad, 1);
    
    static SceCtrlData old_pad = {0};
    
    // Manejo de controles para cambiar de estado
    if ((pad.buttons & SCE_CTRL_START) && !(old_pad.buttons & SCE_CTRL_START)) {
        // La app debería salir, pero aquí mantenemos el estado actual
        // El manejo real de salida está en main.c
    }
    
    // Cambio de estado basado en controles
    if ((pad.buttons & SCE_CTRL_CROSS) && !(old_pad.buttons & SCE_CTRL_CROSS)) {
        // Avanzar al siguiente estado
        m->requested_state = (m->requested_state + 1) % 7;
    }
    
    if ((pad.buttons & SCE_CTRL_CIRCLE) && !(old_pad.buttons & SCE_CTRL_CIRCLE)) {
        // Volver al menú principal
        m->requested_state = APP_STATE_MAIN_MENU;
    }
    
    old_pad = pad;
    m->frame_counter++;
}

static void draw_label(const char* text, int y) {
    vita2d_draw_rectangle(0, y - 2, 960, 20, RGBA8(0,0,0,80));
    // Barra de fondo para mejor visibilidad
    vita2d_draw_rectangle(50, y - 2, 860, 20, RGBA8(0x2A, 0x2A, 0x2A, 0xFF));
    // Placeholder para texto - normalmente usaríamos una fuente
}

void ui_manager_render_main_menu(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("VitaCast - Menu Principal", 40);
    draw_label("Podcasts", 70);
    draw_label("Apple Music", 100);
    draw_label("Reproductor", 130);
    draw_label("Buscar", 160);
    draw_label("Descargas", 190);
    draw_label("Configuracion", 220);
}

void ui_manager_render_podcasts(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("Podcasts", 40);
    draw_label("Lista de podcasts suscritos", 70);
}

void ui_manager_render_music(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("Apple Music", 40);
    draw_label("Biblioteca de musica sincronizada", 70);
}

void ui_manager_render_player(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("Reproductor", 40);
    draw_label("Reproduciendo...", 70);
}

void ui_manager_render_settings(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("Configuracion", 40);
    draw_label("Ajustes de la aplicacion", 70);
}

void ui_manager_render_search(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("Buscar Podcasts", 40);
    draw_label("Buscar nuevos podcasts", 70);
}

void ui_manager_render_downloads(ui_manager_t* manager) { 
    (void)manager; 
    draw_label("Descargas", 40);
    draw_label("Gestionar descargas offline", 70);
}

app_state_t ui_manager_get_requested_state(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    return m->requested_state;
}
