#include <vitasdk.h>
#include <stdint.h>
#include <stdlib.h>

// Stub de vita2d - funciones m?nimas para compilaci?n sin la librer?a
// Definir tipos y macros si no est?n disponibles
#ifndef _VITA2D_H
typedef void vita2d_texture;
#define RGBA8(r, g, b, a) ((uint32_t)((r) | ((g) << 8) | ((b) << 16) | ((a) << 24)))
#endif

// Implementaciones stub (funciones vac?as pero que permiten compilar)
int vita2d_init(void) { return 0; }
int vita2d_fini(void) { return 0; }
void vita2d_wait_rendering_done(void) {}
void vita2d_clear_screen(void) {}
void vita2d_start_drawing(void) {}
void vita2d_end_drawing(void) {}
void vita2d_swap_buffers(void) {}
void vita2d_set_clear_color(unsigned int color) { (void)color; }
void vita2d_draw_rectangle(float x, float y, float w, float h, unsigned int color) { 
    (void)x; (void)y; (void)w; (void)h; (void)color; 
}
void vita2d_draw_texture(const vita2d_texture *texture, float x, float y) { 
    (void)texture; (void)x; (void)y; 
}
void vita2d_free_texture(vita2d_texture *texture) { 
    if (texture) free(texture);
}
vita2d_texture* vita2d_load_PNG_file(const char *filename) { 
    (void)filename; 
    return NULL; 
}
