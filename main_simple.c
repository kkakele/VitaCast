#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <vita2d.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define APP_TITLE "VitaCast Simple"
#define APP_VERSION "1.0.0"

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    printf("%s - Podcast Player para PS Vita\n", APP_TITLE);
    printf("Versi\xc3\xb3n %s\n", APP_VERSION);
    printf("Presiona START para salir\n");
    
    // Inicializar vita2d para gr\xc3\xa1ficos
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x1A, 0x1A, 0x1A, 0xFF));
    
    // Cargar fuente
    vita2d_pgf *font = vita2d_load_default_pgf();
    
    SceCtrlData pad;
    int running = 1;
    
    while (running) {
        // Leer controles
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_START) {
            running = 0;
        }
        
        // Renderizar
        vita2d_start_drawing();
        vita2d_clear_screen();
        
        // Fondo
        vita2d_draw_rectangle(0, 0, 960, 544, RGBA8(0x1A, 0x1A, 0x1A, 0xFF));
        
        // T\xc3\xadtulo
        if (font) {
            vita2d_pgf_draw_text(font, 100, 100, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 2.0f, APP_TITLE);
            vita2d_pgf_draw_text(font, 100, 150, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, "Versi\xc3\xb3n: ");
            vita2d_pgf_draw_text(font, 250, 150, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 1.0f, APP_VERSION);
            
            // Mensaje
            vita2d_pgf_draw_text(font, 100, 250, RGBA8(0x00, 0x7A, 0xFF, 0xFF), 1.2f, 
                "\xc2\xa1Bienvenido a VitaCast!");
            vita2d_pgf_draw_text(font, 100, 300, RGBA8(0xCC, 0xCC, 0xCC, 0xFF), 1.0f, 
                "Una aplicaci\xc3\xb3n de podcasts y m\xc3\xbasica para PS Vita");
            
            // Instrucci\xc3\xb3n
            vita2d_pgf_draw_text(font, 100, 500, RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 0.8f, 
                "Presiona START para salir");
        }
        
        vita2d_end_drawing();
        vita2d_swap_buffers();
        vita2d_wait_rendering_done();
        
        sceKernelDelayThread(16666); // ~60 FPS
    }
    
    // Limpieza
    if (font) {
        vita2d_free_pgf(font);
    }
    vita2d_fini();
    
    printf("VitaCast finalizado\n");
    sceKernelExitProcess(0);
    return 0;
}
