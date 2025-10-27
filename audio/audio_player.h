#pragma once
#include <stdbool.h>

typedef struct audio_player_t audio_player_t;

audio_player_t* audio_player_create(void);
void audio_player_destroy(audio_player_t* player);
void audio_player_update(audio_player_t* player);
