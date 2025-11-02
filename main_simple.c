#include <psp2/ctrl.h>
#include <psp2/kernel/processmgr.h>
#include <psp2/display.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Aplicación básica de VitaCast
    printf("VitaCast - Podcast Player para PS Vita\n");
    printf("Versión 1.0.0\n");
    printf("Presiona START para salir\n");
    
    // Configurar el modo de entrada del controlador
    // Esto es necesario para que el controlador funcione correctamente
    sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);
    
    SceCtrlData pad;
    int running = 1;
    
    while (running) {
        // Leer entrada del controlador
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_START) {
            running = 0;
        }
        
        // Pequeño delay para evitar uso excesivo de CPU
        sceKernelDelayThread(10000); // 10ms
    }
    
    // Salir de la aplicación correctamente
    sceKernelExitProcess(0);
    return 0;
}
