#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <psp2/display.h>
#include <psp2/types.h>
#include <psp2/sysmodule.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <vita2d.h>

#include "ui/ui_manager.h"
#include "audio/audio_player.h"
#include "audio/atrac_decoder.h"
#include "network/network_manager.h"
#include "apple/apple_sync.h"

#define APP_TITLE "VitaCast"
#define APP_VERSION "4.0.0"
#define FRAME_DELAY 16666 // ~60 FPS en microsegundos

// Estructura principal de la aplicación
typedef struct {
    // Managers y componentes
    ui_manager_t* ui;
    audio_player_t* audio;
    network_manager_t* network;
    apple_sync_t* apple;
    
    // Estado de la aplicación
    app_state_t current_state;
    bool running;
    
    // Control de entrada
    SceCtrlData pad;
    SceCtrlData old_pad;
    
    // FPS y timing
    int frame_counter;
    bool demo_mode;
} vitacast_app_t;

static vitacast_app_t* app = NULL;

// ============================================================================
// INICIALIZACIÓN Y LIMPIEZA
// ============================================================================

static int vitacast_init(void) {
    // Cargar módulos del sistema necesarios
    // PGF es necesario para las fuentes de vita2d
    sceSysmoduleLoadModule(SCE_SYSMODULE_PGF);
    
    // Inicializar vita2d (esto inicializa GXM internamente)
    if (vita2d_init() < 0) {
        printf("ERROR: No se pudo inicializar vita2d\n");
        return -1;
    }
    vita2d_set_clear_color(RGBA8(26, 26, 46, 255)); // Fondo oscuro estilo PS Vita
    
    // Inicializar control
    sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);
    
    // Crear estructura de la app
    app = (vitacast_app_t*)malloc(sizeof(vitacast_app_t));
    if (!app) {
        printf("ERROR: No se pudo asignar memoria para la aplicación\n");
        vita2d_fini();
        return -1;
    }
    
    memset(app, 0, sizeof(vitacast_app_t));
    app->running = true;
    app->current_state = APP_STATE_MAIN_MENU;
    app->frame_counter = 0;
    app->demo_mode = false;
    
    // Inicializar UI Manager
    printf("Inicializando UI Manager...\n");
    app->ui = ui_manager_create();
    if (!app->ui) {
        printf("ERROR: No se pudo inicializar UI Manager\n");
        free(app);
        return -1;
    }
    
    // Inicializar Audio Player
    printf("Inicializando Audio Player...\n");
    app->audio = audio_player_create();
    if (!app->audio) {
        printf("ADVERTENCIA: Audio Player no disponible\n");
    } else {
        printf("Audio Player inicializado correctamente\n");
        // Verificar soporte ATRAC
        if (atrac_decoder_is_available()) {
            printf("Soporte ATRAC3/ATRAC3plus disponible\n");
        }
    }
    
    // Inicializar Network Manager
    printf("Inicializando Network Manager...\n");
    app->network = network_manager_create();
    if (!app->network) {
        printf("ADVERTENCIA: Network Manager no disponible\n");
    } else {
        printf("Network Manager inicializado correctamente\n");
    }
    
    // Inicializar Apple Sync
    printf("Inicializando Apple Sync...\n");
    app->apple = apple_sync_create();
    if (!app->apple) {
        printf("ADVERTENCIA: Apple Sync no disponible\n");
    } else {
        printf("Apple Sync inicializado correctamente\n");
        // Simular inicio de sesión para demo
        apple_sync_sign_in(app->apple, "demo@icloud.com");
    }
    
    printf("\n");
    printf("═══════════════════════════════════════════════════════════\n");
    printf("  VitaCast v%s - Inicializado correctamente\n", APP_VERSION);
    printf("═══════════════════════════════════════════════════════════\n");
    printf("\n");
    
    // Simular reproducción de podcast para demo
    if (app->audio) {
        audio_player_play(app->audio, "ux0:/data/podcasts/tech_talk_ep142.mp3");
    }
    
    sceKernelDelayThread(2000000); // Esperar 2 segundos para que se lea el mensaje
    
    return 0;
}

static void vitacast_cleanup(void) {
    if (!app) return;
    
    printf("\nCerrando VitaCast...\n");
    
    if (app->ui) {
        ui_manager_destroy(app->ui);
        printf("UI Manager cerrado\n");
    }
    
    if (app->audio) {
        audio_player_destroy(app->audio);
        printf("Audio Player cerrado\n");
    }
    
    if (app->network) {
        network_manager_destroy(app->network);
        printf("Network Manager cerrado\n");
    }
    
    if (app->apple) {
        apple_sync_destroy(app->apple);
        printf("Apple Sync cerrado\n");
    }
    
    free(app);
    app = NULL;
    
    // Finalizar vita2d
    vita2d_fini();
    
    printf("VitaCast cerrado correctamente\n");
    sceKernelDelayThread(1000000); // Esperar 1 segundo
}

// ============================================================================
// MANEJO DE ENTRADA
// ============================================================================

static void vitacast_handle_input(void) {
    if (!app || !app->ui) return;
    
    sceCtrlPeekBufferPositive(0, &app->pad, 1);
    
    // Botón START para salir
    if ((app->pad.buttons & SCE_CTRL_START) && !(app->old_pad.buttons & SCE_CTRL_START)) {
        app->running = false;
    }
    
    // Botón SELECT para toggle demo mode
    if ((app->pad.buttons & SCE_CTRL_SELECT) && !(app->old_pad.buttons & SCE_CTRL_SELECT)) {
        app->demo_mode = !app->demo_mode;
        if (app->demo_mode) {
            printf("\n[DEMO MODE ACTIVADO - Navegación automática]\n");
        } else {
            printf("\n[DEMO MODE DESACTIVADO]\n");
        }
    }
    
    // Control de volumen con L/R
    if (app->audio) {
        if (app->pad.buttons & SCE_CTRL_LTRIGGER) {
            int vol = audio_player_get_volume(app->audio);
            audio_player_set_volume(app->audio, vol - 1);
        }
        if (app->pad.buttons & SCE_CTRL_RTRIGGER) {
            int vol = audio_player_get_volume(app->audio);
            audio_player_set_volume(app->audio, vol + 1);
        }
    }
    
    app->old_pad = app->pad;
}

// ============================================================================
// ACTUALIZACIÓN
// ============================================================================

static void vitacast_update(void) {
    if (!app) return;
    
    // Actualizar entrada
    vitacast_handle_input();
    
    // Actualizar UI
    if (app->ui) {
        ui_manager_update(app->ui);
        app->current_state = ui_manager_get_requested_state(app->ui);
    }
    
    // Actualizar Audio
    if (app->audio) {
        audio_player_update(app->audio);
    }
    
    // Actualizar Network
    if (app->network) {
        network_manager_update(app->network);
    }
    
    // Actualizar Apple Sync
    if (app->apple) {
        apple_sync_update(app->apple);
    }
    
    app->frame_counter++;
    
    // Demo mode: cambiar estado automáticamente cada 5 segundos
    if (app->demo_mode && (app->frame_counter % 300 == 0)) {
        app->current_state = (app->current_state + 1) % 7;
    }
}

// ============================================================================
// RENDERIZADO
// ============================================================================

static void vitacast_clear_screen(void) {
    vita2d_start_drawing();
    vita2d_clear_screen();
}

// Función eliminada - ahora se renderiza gráficamente en la UI

static void vitacast_render(void) {
    if (!app || !app->ui) return;
    
    // Limpiar pantalla y comenzar frame
    vitacast_clear_screen();
    
    // Renderizar UI según estado actual
    switch (app->current_state) {
        case APP_STATE_MAIN_MENU:
            ui_manager_render_main_menu(app->ui);
            break;
            
        case APP_STATE_PODCASTS:
            ui_manager_render_podcasts(app->ui);
            break;
            
        case APP_STATE_MUSIC:
            ui_manager_render_music(app->ui);
            break;
            
        case APP_STATE_PLAYER:
            ui_manager_render_player(app->ui);
            break;
            
        case APP_STATE_SETTINGS:
            ui_manager_render_settings(app->ui);
            break;
            
        case APP_STATE_SEARCH:
            ui_manager_render_search(app->ui);
            break;
            
        case APP_STATE_DOWNLOADS:
            ui_manager_render_downloads(app->ui);
            break;
            
        default:
            break;
    }
    
    // Finalizar frame y mostrar
    vita2d_end_drawing();
    vita2d_swap_buffers();
}

// ============================================================================
// MAIN LOOP
// ============================================================================

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    // Inicializar aplicación
    if (vitacast_init() < 0) {
        printf("\nERROR CRÍTICO: No se pudo inicializar VitaCast\n");
        printf("Presiona START para salir\n");
        
        SceCtrlData pad;
        while (1) {
            sceCtrlPeekBufferPositive(0, &pad, 1);
            if (pad.buttons & SCE_CTRL_START) break;
            sceKernelDelayThread(100000);
        }
        
        sceKernelExitProcess(-1);
        return -1;
    }
    
    // Loop principal
    while (app && app->running) {
        // Actualizar
        vitacast_update();
        
        // Renderizar
        vitacast_render();
        
        // Delay para mantener ~60 FPS
        sceKernelDelayThread(FRAME_DELAY);
    }
    
    // Cleanup
    vitacast_cleanup();
    
    // Salir correctamente
    printf("\n¡Gracias por usar VitaCast!\n");
    printf("Saliendo...\n");
    sceKernelDelayThread(1000000);
    
    sceKernelExitProcess(0);
    return 0;
}
