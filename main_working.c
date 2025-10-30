#include <psp2/kernel/processmgr.h>
#include <psp2/ctrl.h>
#include <psp2/display.h>
#include <psp2/gxm.h>
#include <psp2/types.h>
#include <psp2/kernel/threadmgr.h>
#include <vita2d.h>
#include <stdio.h>
#include <string.h>

#define SCREEN_WIDTH 960
#define SCREEN_HEIGHT 544

int main(int argc, char *argv[]) {
    // Inicializar vita2d
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x40, 0x40, 0x40, 0xFF));
    
    // Crear fuente
    vita2d_pgf *pgf = vita2d_load_default_pgf();
    
    SceCtrlData pad;
    memset(&pad, 0, sizeof(pad));
    
    int running = 1;
    
    while (running) {
        // Leer input
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_START) {
            running = 0;
        }
        
        // Renderizar
        vita2d_start_drawing();
        vita2d_clear_screen();
        
        // Fondo
        vita2d_draw_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, RGBA8(0x1A, 0x1A, 0x2E, 0xFF));
        
        // Título
        vita2d_draw_rectangle(100, 100, 760, 80, RGBA8(0x00, 0x7A, 0xFF, 0xFF));
        vita2d_pgf_draw_text(pgf, 120, 140, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "VitaCast - Podcast Player");
        
        // Versión
        vita2d_pgf_draw_text(pgf, 120, 180, RGBA8(0xCC, 0xCC, 0xCC, 0xFF), 1.0f, "Version 2.1.4 - Funcional");
        
        // Mensaje
        vita2d_draw_rectangle(100, 250, 760, 150, RGBA8(0x2A, 0x2A, 0x3E, 0xFF));
        vita2d_pgf_draw_text(pgf, 120, 290, RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.0f, "Bienvenido a VitaCast!");
        vita2d_pgf_draw_text(pgf, 120, 330, RGBA8(0xCC, 0xCC, 0xCC, 0xFF), 1.0f, "Tu reproductor de podcasts para PS Vita");
        
        // Controles
        vita2d_pgf_draw_text(pgf, 120, 450, RGBA8(0x00, 0xFF, 0x7A, 0xFF), 1.0f, "Presiona START para salir");
        
        vita2d_end_drawing();
        vita2d_swap_buffers();
        vita2d_wait_rendering_done();
    }
    
    // Limpiar
    vita2d_free_pgf(pgf);
    vita2d_fini();
    
    sceKernelExitProcess(0);
    return 0;
}
