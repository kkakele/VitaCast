#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <psp2/display.h>
#include <psp2/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define APP_TITLE "VitaCast"
#define APP_VERSION "2.0.1"

// Estructura simple para el estado de la app
typedef struct {
    int current_screen;
    SceCtrlData pad;
    int running;
} AppState;

static AppState *app = NULL;

static int vita_cast_init() {
    sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);
    
    app = malloc(sizeof(AppState));
    if (!app) {
        return -1;
    }
    
    memset(app, 0, sizeof(AppState));
    app->running = 1;
    app->current_screen = 0; // Main menu
    
    return 0;
}

static void vita_cast_cleanup() {
    if (app) {
        free(app);
    }
}

static void draw_title() {
    printf("═══════════════════════════════════════════════════════════\n");
    printf("  VitaCast - Podcast & Music Player for PS Vita\n");
    printf("  Version 2.0.1\n");
    printf("═══════════════════════════════════════════════════════════\n\n");
}

static void draw_menu() {
    printf("[%d] Podcasts\n", app->current_screen == 1 ? 1 : 0);
    printf("[%d] Apple Music\n", app->current_screen == 2 ? 1 : 0);
    printf("[%d] Player\n", app->current_screen == 3 ? 1 : 0);
    printf("[%d] Settings\n", app->current_screen == 4 ? 1 : 0);
}

static void draw_podcasts() {
    printf("PODCASTS\n");
    printf("No podcasts loaded yet.\n");
}

static void draw_music() {
    printf("APPLE MUSIC\n");
    printf("Music playback not implemented yet.\n");
}

static void draw_player() {
    printf("PLAYER\n");
    printf("Nothing playing.\n");
}

static void draw_settings() {
    printf("SETTINGS\n");
    printf("Volume: 100%%\n");
    printf("Brightness: 100%%\n");
}

static void vita_cast_render() {
    printf("\n");
    draw_title();
    
    if (app->current_screen == 0) { // Main menu
        draw_menu();
    } else if (app->current_screen == 1) { // Podcasts
        draw_podcasts();
    } else if (app->current_screen == 2) { // Music
        draw_music();
    } else if (app->current_screen == 3) { // Player
        draw_player();
    } else if (app->current_screen == 4) { // Settings
        draw_settings();
    }
    
    printf("\nPress CROSS to select, CIRCLE to back, START to exit\n");
}

static void handle_input() {
    sceCtrlPeekBufferPositive(0, &app->pad, 1);
    
    static SceCtrlData old_pad = {0};
    
    if ((app->pad.buttons & SCE_CTRL_DOWN) && !(old_pad.buttons & SCE_CTRL_DOWN)) {
        app->current_screen = (app->current_screen + 1) % 5; // 5 screens
    }
    if ((app->pad.buttons & SCE_CTRL_UP) && !(old_pad.buttons & SCE_CTRL_UP)) {
        app->current_screen = (app->current_screen - 1 + 5) % 5; // 5 screens
    }
    
    if ((app->pad.buttons & SCE_CTRL_CROSS) && !(old_pad.buttons & SCE_CTRL_CROSS)) {
        switch (app->current_screen) {
            case 0: 
                app->current_screen = 1; // Podcasts
                break;
            case 1: 
                app->current_screen = 2; // Music
                break;
            case 2: 
                app->current_screen = 3; // Player
                break;
            case 3: 
                app->current_screen = 4; // Settings
                break;
        }
    }
    
    if ((app->pad.buttons & SCE_CTRL_CIRCLE) && !(old_pad.buttons & SCE_CTRL_CIRCLE)) {
        app->current_screen = 0; // Main menu
    }
    
    if ((app->pad.buttons & SCE_CTRL_START) && !(old_pad.buttons & SCE_CTRL_START)) {
        app->running = 0;
    }
    
    old_pad = app->pad;
}

static void vita_cast_update() {
    handle_input();
}

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    if (vita_cast_init() < 0) {
        sceKernelExitProcess(-1);
        return -1;
    }
    
    while (app->running) {
        vita_cast_update();
        vita_cast_render();
        vita2d_wait_rendering_done();
    }
    
    vita_cast_cleanup();
    
    // Salir correctamente
    sceKernelExitProcess(0);
    return 0;
}
