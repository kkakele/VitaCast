#include <vitasdk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Aplicación básica de VitaCast
    printf("VitaCast - Podcast Player para PS Vita\n");
    printf("Versión 1.0.0\n");
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
    
    return 0;
}
