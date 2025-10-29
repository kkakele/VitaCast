#include <psp2/kernel/processmgr.h>
#include <psp2/kernel/threadmgr.h>
#include <psp2/ctrl.h>
#include <stdio.h>
#include <string.h>

// Funciones básicas de debug screen
void psvDebugScreenInit();
void psvDebugScreenPrintf(const char *format, ...);

#define printf psvDebugScreenPrintf

int main(int argc, char *argv[]) {
    psvDebugScreenInit();
    
    printf("VitaCast Test v1.0\n");
    printf("Presiona X para salir\n");
    
    SceCtrlData pad;
    
    while (1) {
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_CROSS) {
            break;
        }
        
        sceKernelDelayThread(100000); // 100ms
    }
    
    sceKernelExitProcess(0);
    return 0;
}

// Implementación simple de debugScreen
static int psvDebugScreenCoordX = 0;
static int psvDebugScreenCoordY = 0;

void psvDebugScreenInit() {
    psvDebugScreenCoordX = 0;
    psvDebugScreenCoordY = 0;
}

void psvDebugScreenPrintf(const char *format, ...) {
    // Implementación dummy para compilar
}
