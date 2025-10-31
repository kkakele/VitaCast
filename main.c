#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <psp2/io/fcntl.h>
#include <psp2/net/net.h>
#include <psp2/net/netctl.h>
#include <psp2/sysmodule.h>
#include <psp2/apputil.h>
#include <vita2d.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ui/ui_manager.h"
#include "audio/audio_player.h"
#include "network/network_manager.h"
#include "apple/apple_sync.h"

#define APP_TITLE "VitaCast"
#define APP_VERSION "2.0.0"

// Memoria para red
#define NET_INIT_SIZE 1*1024*1024
static char net_mem[NET_INIT_SIZE];

typedef struct {
    app_state_t current_state;
    bool running;
    vita2d_texture *background_texture;
    vita2d_pgf *font;
    ui_manager_t *ui_manager;
    audio_player_t *audio_player;
    network_manager_t *network_manager;
    apple_sync_t *apple_sync;
} vita_cast_app_t;

static vita_cast_app_t *app = NULL;

static int vita_cast_init() {
    int ret;
    
    // Inicializar módulos del sistema necesarios según VitaSDK
    sceSysmoduleLoadModule(SCE_SYSMODULE_NET);
    
    // Inicializar red
    SceNetInitParam netInitParam;
    netInitParam.memory = net_mem;
    netInitParam.size = NET_INIT_SIZE;
    netInitParam.flags = 0;
    ret = sceNetInit(&netInitParam);
    if (ret < 0) {
        printf("Error al inicializar red: 0x%08X\n", ret);
    }
    
    ret = sceNetCtlInit();
    if (ret < 0) {
        printf("Error al inicializar netctl: 0x%08X\n", ret);
    }
    
    // Inicializar vita2d para gráficos
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x00, 0x00, 0x00, 0xFF));
    
    // Alocar memoria para la app
    app = malloc(sizeof(vita_cast_app_t));
    if (!app) {
        printf("Error: no se pudo alocar memoria para la app\n");
        return -1;
    }
    
    memset(app, 0, sizeof(vita_cast_app_t));
    app->running = true;
    app->current_state = APP_STATE_MAIN_MENU;
    
    // Cargar fuente PGF para texto
    app->font = vita2d_load_default_pgf();
    if (!app->font) {
        printf("Advertencia: no se pudo cargar la fuente\n");
    }
    
    // Crear managers
    app->ui_manager = ui_manager_create();
    app->audio_player = audio_player_create();
    app->network_manager = network_manager_create();
    app->apple_sync = apple_sync_create();
    
    if (!app->ui_manager || !app->audio_player || 
        !app->network_manager || !app->apple_sync) {
        printf("Error: fallo al crear managers\n");
        return -1;
    }
    
    // Conectar a la red
    network_manager_connect(app->network_manager);
    
    // Intentar cargar textura de fondo
    app->background_texture = vita2d_load_PNG_file("app0:/assets/background.png");
    if (!app->background_texture) {
        printf("Advertencia: no se pudo cargar background.png\n");
    }
    
    printf("VitaCast %s inicializado correctamente\n", APP_VERSION);
    return 0;
}

static void vita_cast_cleanup() {
    if (app) {
        // Liberar texturas
        if (app->background_texture) {
            vita2d_free_texture(app->background_texture);
            app->background_texture = NULL;
        }
        
        // Liberar fuente
        if (app->font) {
            vita2d_free_pgf(app->font);
            app->font = NULL;
        }
        
        // Destruir managers
        if (app->ui_manager) ui_manager_destroy(app->ui_manager);
        if (app->audio_player) audio_player_destroy(app->audio_player);
        if (app->network_manager) network_manager_destroy(app->network_manager);
        if (app->apple_sync) apple_sync_destroy(app->apple_sync);
        
        free(app);
        app = NULL;
    }
    
    // Finalizar vita2d
    vita2d_fini();
    
    // Finalizar red
    sceNetCtlTerm();
    sceNetTerm();
    
    // Descargar módulos del sistema
    sceSysmoduleUnloadModule(SCE_SYSMODULE_NET);
    
    printf("VitaCast finalizado correctamente\n");
}

static void vita_cast_render() {
    vita2d_start_drawing();
    vita2d_clear_screen();
    
    // Fondo
    if (app->background_texture) {
        vita2d_draw_texture(app->background_texture, 0, 0);
    } else {
        vita2d_draw_rectangle(0, 0, 960, 544, RGBA8(0x1a, 0x1a, 0x1a, 0xFF));
    }
    
    // Título de la app
    if (app->font) {
        vita2d_pgf_draw_text(app->font, 30, 50, 
            RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, APP_TITLE);
        
        char version[32];
        snprintf(version, sizeof(version), "v%s", APP_VERSION);
        vita2d_pgf_draw_text(app->font, 30, 80, 
            RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 0.8f, version);
    }
    
    // Renderizar según el estado actual
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
    
    // Info de ayuda
    if (app->font) {
        vita2d_pgf_draw_text(app->font, 30, 520, 
            RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 0.7f, 
            "START: Salir | X: Seleccionar | O: Volver");
    }
    
    vita2d_end_drawing();
    vita2d_swap_buffers();
}

static void vita_cast_update() {
    // Leer controles
    SceCtrlData pad;
    sceCtrlPeekBufferPositive(0, &pad, 1);
    
    static SceCtrlData old_pad = {0};
    
    // Salir con START
    if ((pad.buttons & SCE_CTRL_START) && !(old_pad.buttons & SCE_CTRL_START)) {
        app->running = false;
    }
    
    old_pad = pad;
    
    // Actualizar managers
    ui_manager_update(app->ui_manager);
    audio_player_update(app->audio_player);
    network_manager_update(app->network_manager);
    apple_sync_update(app->apple_sync);
    
    // Actualizar estado
    app_state_t new_state = ui_manager_get_requested_state(app->ui_manager);
    if (new_state != app->current_state) {
        printf("Cambiando estado: %d -> %d\n", app->current_state, new_state);
        app->current_state = new_state;
    }
}

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    printf("Iniciando %s %s...\n", APP_TITLE, APP_VERSION);
    
    if (vita_cast_init() < 0) {
        printf("Error: fallo al inicializar la aplicación\n");
        vita_cast_cleanup();
        sceKernelDelayThread(3 * 1000000); // Esperar 3 segundos para ver el error
        sceKernelExitProcess(0);
        return -1;
    }
    
    // Loop principal
    while (app && app->running) {
        vita_cast_update();
        vita_cast_render();
        vita2d_wait_rendering_done();
        sceKernelDelayThread(16666); // ~60 FPS
    }
    
    vita_cast_cleanup();
    
    // Terminar proceso correctamente
    sceKernelExitProcess(0);
    return 0;
}
