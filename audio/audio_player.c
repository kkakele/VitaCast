#include "audio_player.h"
#include <stdlib.h>
#include <psp2/kernel/threadmgr.h>

typedef struct audio_player_t {
    int dummy;
} audio_player_t_impl;

audio_player_t* audio_player_create(void) {
    audio_player_t_impl* p = (audio_player_t_impl*)malloc(sizeof(audio_player_t_impl));
    if (!p) return NULL;
    p->dummy = 0;
    return (audio_player_t*)p;
}

void audio_player_destroy(audio_player_t* player) {
    free(player);
}

void audio_player_update(audio_player_t* player) {
    (void)player;
}
