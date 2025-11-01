#include <vitasdk.h>
#include <vita2d.h>

// Definir tipo si no est? definido en vita2d.h
#ifndef _VITA2D_H
typedef void vita2d_texture;
#endif

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
