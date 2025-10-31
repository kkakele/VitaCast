#include <psp2/ctrl.h>
#include <psp2/kernel/threadmgr.h>
#include <psp2/kernel/processmgr.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Inicializar controles
    sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);
    
    // Aplicación básica de VitaCast
    printf("VitaCast - Podcast Player para PS Vita\n");
    printf("Version 2.0.0\n");
    printf("Presiona START para salir\n");
    
    SceCtrlData pad;
    int running = 1;
    
    while (running) {
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_START) {
            running = 0;
        }
        
        sceKernelDelayThread(10000); // 10ms
    }
    
    sceKernelExitProcess(0);
    return 0;
}
