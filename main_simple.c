#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <psp2/sysmodule.h>
#include <vita2d.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;
    
    // Inicializar modulos del sistema PRIMERO
    sceSysmoduleLoadModule(SCE_SYSMODULE_PGF);
    
    // Inicializar controladores
    sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);
    
    // Inicializar vita2d
    vita2d_init();
    vita2d_set_clear_color(RGBA8(0x40, 0x40, 0x40, 0xFF));
    
    // Cargar fuente
    vita2d_pgf *font = vita2d_load_default_pgf();
    
    SceCtrlData pad;
    int running = 1;
    
    while (running) {
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_START) {
            running = 0;
        }
        
        vita2d_start_drawing();
        vita2d_clear_screen();
        
        // Dibujar rectangulo de fondo
        vita2d_draw_rectangle(100, 100, 760, 344, RGBA8(0x20, 0x20, 0x20, 0xFF));
        
        // Dibujar texto si hay fuente
        if (font) {
            vita2d_pgf_draw_text(font, 150, 150, 
                RGBA8(0xFF, 0xFF, 0xFF, 0xFF), 1.5f, "VitaCast");
            vita2d_pgf_draw_text(font, 150, 200, 
                RGBA8(0xCC, 0xCC, 0xCC, 0xFF), 1.0f, "Podcast Player para PS Vita");
            vita2d_pgf_draw_text(font, 150, 400, 
                RGBA8(0xAA, 0xAA, 0xAA, 0xFF), 0.8f, "Presiona START para salir");
        }
        
        vita2d_end_drawing();
        vita2d_swap_buffers();
        vita2d_wait_rendering_done();
        
        sceKernelDelayThread(16666);
    }
    
    // Limpieza
    if (font) {
        vita2d_free_pgf(font);
    }
    vita2d_fini();
    
    sceSysmoduleUnloadModule(SCE_SYSMODULE_PGF);
    
    sceKernelExitProcess(0);
    return 0;
}
