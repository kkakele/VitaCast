#include "ui_manager.h"
#include <vitasdk.h>
#include "../vita2d_stub.h"  // Usar stub en lugar de librer?a vita2d
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
    if (pad.buttons & SCE_CTRL_START) {
        // stay in loop; real app would exit
    }
    // simple state toggle demo based on time
    m->frame_counter++;
    if (m->frame_counter % 600 == 0) {
        m->requested_state = (m->requested_state + 1) % 7;
    }
}

static void draw_label(const char* text, int y) {
    vita2d_draw_rectangle(0, y - 2, 960, 20, RGBA8(0,0,0,80));
    // Normally we would draw text using a font; placeholder bar only
}

void ui_manager_render_main_menu(ui_manager_t* manager) { (void)manager; draw_label("Main Menu", 40); }
void ui_manager_render_podcasts(ui_manager_t* manager) { (void)manager; draw_label("Podcasts", 70); }
void ui_manager_render_music(ui_manager_t* manager) { (void)manager; draw_label("Music", 100); }
void ui_manager_render_player(ui_manager_t* manager) { (void)manager; draw_label("Player", 130); }
void ui_manager_render_settings(ui_manager_t* manager) { (void)manager; draw_label("Settings", 160); }
void ui_manager_render_search(ui_manager_t* manager) { (void)manager; draw_label("Search", 190); }
void ui_manager_render_downloads(ui_manager_t* manager) { (void)manager; draw_label("Downloads", 220); }

app_state_t ui_manager_get_requested_state(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    return m->requested_state;
}
