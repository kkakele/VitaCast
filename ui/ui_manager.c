#include "ui_manager.h"
#include <psp2/ctrl.h>
#include <psp2/types.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct ui_manager_t {
    app_state_t requested_state;
    app_state_t current_state;
    int frame_counter;
    int selected_item;
    SceCtrlData old_pad;
} ui_manager_t_impl;

ui_manager_t* ui_manager_create(void) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)malloc(sizeof(ui_manager_t_impl));
    if (!m) return NULL;
    
    memset(m, 0, sizeof(ui_manager_t_impl));
    m->requested_state = APP_STATE_MAIN_MENU;
    m->current_state = APP_STATE_MAIN_MENU;
    m->frame_counter = 0;
    m->selected_item = 0;
    
    return (ui_manager_t*)m;
}

void ui_manager_destroy(ui_manager_t* manager) {
    if (manager) {
        free(manager);
    }
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

static void print_header(const char* title) {
    printf("\n");
    printf("╔══════════════════════════════════════════════════════════════╗\n");
    printf("║  %s\n", title);
    printf("╚══════════════════════════════════════════════════════════════╝\n");
}

void ui_manager_render_main_menu(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m) return;
    
    print_header("VitaCast - Main Menu");
    printf("\n");
    printf("  %s 🎙️  Podcasts\n", m->selected_item == 0 ? "►" : " ");
    printf("  %s 🎵  Apple Music\n", m->selected_item == 1 ? "►" : " ");
    printf("  %s ▶️  Player\n", m->selected_item == 2 ? "►" : " ");
    printf("  %s 🔍  Search\n", m->selected_item == 3 ? "►" : " ");
    printf("  %s 📥  Downloads\n", m->selected_item == 4 ? "►" : " ");
    printf("  %s ⚙️  Settings\n", m->selected_item == 5 ? "►" : " ");
    printf("  %s 🚪  Exit\n", m->selected_item == 6 ? "►" : " ");
    printf("\n");
    printf("  ✕ Select  ○ Back  START Exit\n");
}

void ui_manager_render_podcasts(ui_manager_t* manager) {
    (void)manager;
    print_header("Podcasts - Subscribed Shows");
    printf("\n");
    printf("  📻 Tech Talk Weekly\n");
    printf("     Last: Episode 142 - AI Revolution (45:23)\n");
    printf("\n");
    printf("  🎯 The Daily\n");
    printf("     Last: Today's Top Stories (23:15)\n");
    printf("\n");
    printf("  💼 Business Insights\n");
    printf("     Last: Market Analysis Q4 (38:42)\n");
    printf("\n");
    printf("  ✕ Play  ○ Back\n");
}

void ui_manager_render_music(ui_manager_t* manager) {
    (void)manager;
    print_header("Apple Music - Your Library");
    printf("\n");
    printf("  🎵 Recently Played:\n");
    printf("     • Summer Vibes Playlist (24 songs)\n");
    printf("     • Chill Lo-Fi Beats (18 songs)\n");
    printf("     • Rock Classics (42 songs)\n");
    printf("\n");
    printf("  📀 Albums:\n");
    printf("     • Random Access Memories - Daft Punk\n");
    printf("     • Thriller - Michael Jackson\n");
    printf("\n");
    printf("  ✕ Play  ○ Back\n");
}

void ui_manager_render_player(ui_manager_t* manager) {
    (void)manager;
    print_header("Now Playing");
    printf("\n");
    printf("  🎵 Tech Talk Weekly - Episode 142\n");
    printf("     AI Revolution and the Future\n");
    printf("\n");
    printf("  ▶️  Playing...\n");
    printf("\n");
    printf("  Progress: [████████████────────] 12:34 / 45:23\n");
    printf("\n");
    printf("  Volume: ████████░░ 80%%\n");
    printf("\n");
    printf("  ⏮️ Prev  ⏸️ Pause  ⏭️ Next  ○ Back\n");
}

void ui_manager_render_settings(ui_manager_t* manager) {
    (void)manager;
    print_header("Settings");
    printf("\n");
    printf("  🔊 Audio:\n");
    printf("     Volume: 80%%\n");
    printf("     Quality: High (320kbps)\n");
    printf("\n");
    printf("  📡 Network:\n");
    printf("     WiFi: Connected\n");
    printf("     Auto-Download: Enabled\n");
    printf("\n");
    printf("  🍎 Apple Account:\n");
    printf("     Status: Signed In\n");
    printf("     Sync: Enabled\n");
    printf("\n");
    printf("  💾 Storage:\n");
    printf("     Cache: 245 MB / 1 GB\n");
    printf("\n");
    printf("  ✕ Modify  ○ Back\n");
}

void ui_manager_render_search(ui_manager_t* manager) {
    (void)manager;
    print_header("Search Podcasts");
    printf("\n");
    printf("  🔍 Search: [tech_______________]\n");
    printf("\n");
    printf("  Results:\n");
    printf("  📻 Tech Talk Weekly\n");
    printf("     Technology news and analysis\n");
    printf("     ⭐⭐⭐⭐⭐ (4.8) - 142 episodes\n");
    printf("\n");
    printf("  📻 TechCrunch\n");
    printf("     Startup and technology news\n");
    printf("     ⭐⭐⭐⭐ (4.5) - 89 episodes\n");
    printf("\n");
    printf("  ✕ Subscribe  ○ Back\n");
}

void ui_manager_render_downloads(ui_manager_t* manager) {
    (void)manager;
    print_header("Downloads");
    printf("\n");
    printf("  📥 Queue:\n");
    printf("     [████████████░░░░] 75%% - Tech Talk Ep. 143\n");
    printf("     [████░░░░░░░░░░░░] 25%% - The Daily - Today\n");
    printf("\n");
    printf("  ✅ Completed:\n");
    printf("     • Tech Talk Weekly - Episode 142 (45 MB)\n");
    printf("     • Business Insights - Q4 Analysis (38 MB)\n");
    printf("     • The Daily - Yesterday (23 MB)\n");
    printf("\n");
    printf("  💾 Total: 245 MB\n");
    printf("\n");
    printf("  ✕ Manage  ○ Back\n");
}

app_state_t ui_manager_get_requested_state(ui_manager_t* manager) {
    ui_manager_t_impl* m = (ui_manager_t_impl*)manager;
    if (!m) return APP_STATE_MAIN_MENU;
    return m->requested_state;
}
