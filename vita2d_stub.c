#include <psp2/kernel/threadmgr.h>
#include <stdint.h>

// Stub definitions para vita2d si no está disponible
typedef struct vita2d_texture {
    uint32_t dummy;
} vita2d_texture;

#define RGBA8(r,g,b,a) ((((a)&0xFF)<<24) | (((b)&0xFF)<<16) | (((g)&0xFF)<<8) | (((r)&0xFF)<<0))

int vita2d_init(void) { return 0; }
int vita2d_fini(void) { return 0; }
void vita2d_wait_rendering_done(void) {}
void vita2d_clear_screen(void) {}
void vita2d_start_drawing(void) {}
void vita2d_end_drawing(void) {}
void vita2d_swap_buffers(void) {}
void vita2d_set_clear_color(unsigned int color) { (void)color; }
void vita2d_draw_rectangle(float x, float y, float w, float h, unsigned int color) { (void)x; (void)y; (void)w; (void)h; (void)color; }
void vita2d_draw_texture(const vita2d_texture *texture, float x, float y) { (void)texture; (void)x; (void)y; }
void vita2d_free_texture(vita2d_texture *texture) { (void)texture; }
vita2d_texture* vita2d_load_PNG_file(const char *filename) { (void)filename; return NULL; }
