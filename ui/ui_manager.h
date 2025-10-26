#pragma once
#include <stdbool.h>

typedef enum {
    APP_STATE_MAIN_MENU = 0,
    APP_STATE_PODCASTS,
    APP_STATE_MUSIC,
    APP_STATE_PLAYER,
    APP_STATE_SETTINGS,
    APP_STATE_SEARCH,
    APP_STATE_DOWNLOADS
} app_state_t;

typedef struct ui_manager_t ui_manager_t;

ui_manager_t* ui_manager_create(void);
void ui_manager_destroy(ui_manager_t* manager);

void ui_manager_update(ui_manager_t* manager);

void ui_manager_render_main_menu(ui_manager_t* manager);
void ui_manager_render_podcasts(ui_manager_t* manager);
void ui_manager_render_music(ui_manager_t* manager);
void ui_manager_render_player(ui_manager_t* manager);
void ui_manager_render_settings(ui_manager_t* manager);
void ui_manager_render_search(ui_manager_t* manager);
void ui_manager_render_downloads(ui_manager_t* manager);

app_state_t ui_manager_get_requested_state(ui_manager_t* manager);
