#include "ui_manager.h"
#include <psp2/ctrl.h>
#include <psp2/types.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <vita2d.h>
#include <psp2/kernel/threadmgr.h>

typedef struct ui_manager_t {
    app_state_t requested_state;
    app_state_t current_state;
    int frame_counter;
    int selected_item;
    SceCtrlData old_pad;
    vita2d_pgf* font;
} ui_manager_t_impl;

ui_manager_t* ui_manager_create(void) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)malloc(sizeof(ui_manager_t_impl));
    if (!m) return NULL;
    
    memset(m, 0, sizeof(ui_manager_t_impl));
    m->requested_state = APP_STATE_MAIN_MENU;
    m->current_state = APP_STATE_MAIN_MENU;
    m->frame_counter = 0;
    m->selected_item = 0;
    
    // Cargar fuente del sistema
    m->font = vita2d_load_default_pgf();
    
    return (ui_manager_t*)m;
}

void ui_manager_destroy(ui_manager_t* manager) {
    if (!manager) return;
    
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (m->font) {
        vita2d_free_pgf(m->font);
    }
    
    free(manager);
}

void ui_manager_update(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m) return;
    
    SceCtrlData pad;
    sceCtrlPeekBufferPositive(0, &pad, 1);
    
    // Navegación con D-Pad
    if ((pad.buttons & SCE_CTRL_DOWN) && !(m->old_pad.buttons & SCE_CTRL_DOWN)) {
        m->selected_item = (m->selected_item + 1) % 7; // 7 opciones en menú principal
    }
    
    if ((pad.buttons & SCE_CTRL_UP) && !(m->old_pad.buttons & SCE_CTRL_UP)) {
        m->selected_item = (m->selected_item - 1 + 7) % 7;
    }
    
    // Seleccionar con botón X
    if ((pad.buttons & SCE_CTRL_CROSS) && !(m->old_pad.buttons & SCE_CTRL_CROSS)) {
        // Cambiar estado según selección
        switch(m->selected_item) {
            case 0: m->requested_state = APP_STATE_PODCASTS; break;
            case 1: m->requested_state = APP_STATE_MUSIC; break;
            case 2: m->requested_state = APP_STATE_PLAYER; break;
            case 3: m->requested_state = APP_STATE_SEARCH; break;
            case 4: m->requested_state = APP_STATE_DOWNLOADS; break;
            case 5: m->requested_state = APP_STATE_SETTINGS; break;
            default: m->requested_state = APP_STATE_MAIN_MENU; break;
        }
        m->current_state = m->requested_state;
    }
    
    // Volver con botón O
    if ((pad.buttons & SCE_CTRL_CIRCLE) && !(m->old_pad.buttons & SCE_CTRL_CIRCLE)) {
        m->requested_state = APP_STATE_MAIN_MENU;
        m->current_state = APP_STATE_MAIN_MENU;
        m->selected_item = 0;
    }
    
    m->old_pad = pad;
    m->frame_counter++;
}

void ui_manager_render_main_menu(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const int start_y = 100;
    const int line_height = 50;
    const int start_x = 100;
    const unsigned int color_normal = RGBA8(255, 255, 255, 255);
    const unsigned int color_selected = RGBA8(0, 162, 232, 255);
    
    // Título
    vita2d_pgf_draw_text(m->font, 100, 60, color_selected, 1.0f, "VitaCast - Main Menu");
    
    // Items del menú
    const char* menu_items[] = {
        "Podcasts",
        "Apple Music",
        "Player",
        "Search",
        "Downloads",
        "Settings",
        "Exit"
    };
    
    for (int i = 0; i < 7; i++) {
        int y = start_y + (i * line_height);
        unsigned int color = (m->selected_item == i) ? color_selected : color_normal;
        const char* marker = (m->selected_item == i) ? "► " : "  ";
        char buffer[128];
        snprintf(buffer, sizeof(buffer), "%s%s", marker, menu_items[i]);
        vita2d_pgf_draw_text(m->font, start_x, y, color, 0.8f, buffer);
    }
    
    // Controles
    vita2d_pgf_draw_text(m->font, 100, 500, RGBA8(180, 180, 180, 255), 0.6f, 
                        "X: Select  O: Back  START: Exit");
}

void ui_manager_render_podcasts(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const unsigned int color_title = RGBA8(0, 162, 232, 255);
    const unsigned int color_text = RGBA8(255, 255, 255, 255);
    const unsigned int color_subtext = RGBA8(180, 180, 180, 255);
    
    vita2d_pgf_draw_text(m->font, 100, 60, color_title, 1.0f, "Podcasts - Subscribed Shows");
    
    int y = 120;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.8f, "Tech Talk Weekly");
    y += 30;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Episode 142 - AI Revolution (45:23)");
    
    y += 60;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.8f, "The Daily");
    y += 30;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Today's Top Stories (23:15)");
    
    y += 60;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.8f, "Business Insights");
    y += 30;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Market Analysis Q4 (38:42)");
    
    vita2d_pgf_draw_text(m->font, 100, 500, color_subtext, 0.6f, "X: Play  O: Back");
}

void ui_manager_render_music(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const unsigned int color_title = RGBA8(0, 162, 232, 255);
    const unsigned int color_text = RGBA8(255, 255, 255, 255);
    const unsigned int color_subtext = RGBA8(180, 180, 180, 255);
    
    vita2d_pgf_draw_text(m->font, 100, 60, color_title, 1.0f, "Apple Music - Your Library");
    
    int y = 120.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Recently Played:");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Summer Vibes Playlist (24 songs)");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Chill Lo-Fi Beats (18 songs)");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Rock Classics (42 songs)");
    
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Albums:");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Random Access Memories - Daft Punk");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Thriller - Michael Jackson");
    
    vita2d_pgf_draw_text(m->font, 100, 500, color_subtext, 0.6f, "X: Play  O: Back");
}

void ui_manager_render_player(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const unsigned int color_title = RGBA8(0, 162, 232, 255);
    const unsigned int color_text = RGBA8(255, 255, 255, 255);
    const unsigned int color_subtext = RGBA8(180, 180, 180, 255);
    
    vita2d_pgf_draw_text(m->font, 100, 60, color_title, 1.0f, "Now Playing");
    
    int y = 150.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 1.0f, "Tech Talk Weekly");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.8f, "Episode 142 - AI Revolution");
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_subtext, 0.7f, "Playing...");
    
    y += 80.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Progress: 12:34 / 45:23");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Volume: 80%%");
    
    vita2d_pgf_draw_text(m->font, 100, 500, color_subtext, 0.6f, "Triangle: Prev  X: Pause  Square: Next  O: Back");
}

void ui_manager_render_settings(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const unsigned int color_title = RGBA8(0, 162, 232, 255);
    const unsigned int color_text = RGBA8(255, 255, 255, 255);
    const unsigned int color_subtext = RGBA8(180, 180, 180, 255);
    
    vita2d_pgf_draw_text(m->font, 100, 60, color_title, 1.0f, "Settings");
    
    int y = 120.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Audio:");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Volume: 80%%");
    y += 30.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Quality: High (320kbps)");
    
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Network:");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "WiFi: Connected");
    y += 30.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Auto-Download: Enabled");
    
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Apple Account:");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Status: Signed In");
    
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Storage:");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Cache: 245 MB / 1 GB");
    
    vita2d_pgf_draw_text(m->font, 100, 500, color_subtext, 0.6f, "X: Modify  O: Back");
}

void ui_manager_render_search(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const unsigned int color_title = RGBA8(0, 162, 232, 255);
    const unsigned int color_text = RGBA8(255, 255, 255, 255);
    const unsigned int color_subtext = RGBA8(180, 180, 180, 255);
    
    vita2d_pgf_draw_text(m->font, 100, 60, color_title, 1.0f, "Search Podcasts");
    
    int y = 120.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Search: tech");
    
    y += 60.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Results:");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.8f, "Tech Talk Weekly");
    y += 30.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Technology news and analysis");
    y += 25.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.5f, "Rating: 4.8 - 142 episodes");
    
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.8f, "TechCrunch");
    y += 30.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "Startup and technology news");
    y += 25.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.5f, "Rating: 4.5 - 89 episodes");
    
    vita2d_pgf_draw_text(m->font, 100, 500, color_subtext, 0.6f, "X: Subscribe  O: Back");
}

void ui_manager_render_downloads(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m || !m->font) return;
    
    const unsigned int color_title = RGBA8(0, 162, 232, 255);
    const unsigned int color_text = RGBA8(255, 255, 255, 255);
    const unsigned int color_subtext = RGBA8(180, 180, 180, 255);
    
    vita2d_pgf_draw_text(m->font, 100, 60, color_title, 1.0f, "Downloads");
    
    int y = 120.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Queue:");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "75%% - Tech Talk Ep. 143");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "25%% - The Daily - Today");
    
    y += 60.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Completed:");
    y += 40.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Tech Talk Weekly Ep. 142 (45 MB)");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• Business Insights Q4 (38 MB)");
    y += 35.0;
    vita2d_pgf_draw_text(m->font, 120, y, color_subtext, 0.6f, "• The Daily Yesterday (23 MB)");
    
    y += 50.0;
    vita2d_pgf_draw_text(m->font, 100, y, color_text, 0.7f, "Total: 245 MB");
    
    vita2d_pgf_draw_text(m->font, 100, 500, color_subtext, 0.6f, "X: Manage  O: Back");
}

app_state_t ui_manager_get_requested_state(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m) return APP_STATE_MAIN_MENU;
    return m->requested_state;
}
