#ifndef VITA2D_STUB_H
#define VITA2D_STUB_H

#include <stdint.h>
#include <stdbool.h>

// Stub header para vita2d - declaraciones de funciones
typedef void vita2d_texture;

#define RGBA8(r, g, b, a) ((uint32_t)((r) | ((g) << 8) | ((b) << 16) | ((a) << 24)))

// Funciones de vita2d
int vita2d_init(void);
int vita2d_fini(void);
void vita2d_wait_rendering_done(void);
void vita2d_clear_screen(void);
void vita2d_start_drawing(void);
void vita2d_end_drawing(void);
void vita2d_swap_buffers(void);
void vita2d_set_clear_color(unsigned int color);
void vita2d_draw_rectangle(float x, float y, float w, float h, unsigned int color);
void vita2d_draw_texture(const vita2d_texture *texture, float x, float y);
void vita2d_free_texture(vita2d_texture *texture);
vita2d_texture* vita2d_load_PNG_file(const char *filename);

#endif // VITA2D_STUB_H
