#pragma once
#include <stdbool.h>

typedef enum {
    AUDIO_STATE_STOPPED = 0,
    AUDIO_STATE_PLAYING,
    AUDIO_STATE_PAUSED
} audio_state_t;

typedef struct audio_player_t audio_player_t;

audio_player_t* audio_player_create(void);
void audio_player_destroy(audio_player_t* player);
void audio_player_update(audio_player_t* player);

bool audio_player_play(audio_player_t* player, const char* filename);
void audio_player_pause(audio_player_t* player);
void audio_player_resume(audio_player_t* player);
void audio_player_stop(audio_player_t* player);

audio_state_t audio_player_get_state(audio_player_t* player);
int audio_player_get_volume(audio_player_t* player);
void audio_player_set_volume(audio_player_t* player, int volume);

float audio_player_get_position(audio_player_t* player);
float audio_player_get_duration(audio_player_t* player);
