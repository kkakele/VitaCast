#include <psp2/kernel/processmgr.h>
#include <psp2/ctrl.h>
#include <psp2/kernel/threadmgr.h>

int main(int argc, char *argv[]) {
    SceCtrlData pad;
    
    // Loop simple esperando START
    while (1) {
        sceCtrlPeekBufferPositive(0, &pad, 1);
        
        if (pad.buttons & SCE_CTRL_START) {
            break;
        }
        
        sceKernelDelayThread(100000); // 100ms
    }
    
    sceKernelExitProcess(0);
    return 0;
}
