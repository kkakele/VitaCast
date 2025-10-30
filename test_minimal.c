#include <psp2/kernel/processmgr.h>

int main(int argc, char *argv[]) {
    sceKernelDelayThread(3000000);
    sceKernelExitProcess(0);
    return 0;
}
