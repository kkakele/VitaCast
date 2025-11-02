#include "audio_player.h"
#include <psp2/audioout.h>
#include <psp2/types.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct audio_player_t {
    audio_state_t state;
    int volume;
    float position;
    float duration;
    int audio_port;
    char current_file[256];
} audio_player_t_impl;

audio_player_t* audio_player_create(void) {
    audio_player_t_impl* p = (audio_player_t_impl*)malloc(sizeof(audio_player_t_impl));
    if (!p) return NULL;
    
    memset(p, 0, sizeof(audio_player_t_impl));
    p->state = AUDIO_STATE_STOPPED;
    p->volume = 80;
    p->position = 0.0f;
    p->duration = 0.0f;
    p->audio_port = -1;
    
    // Inicializar puerto de audio
    p->audio_port = sceAudioOutOpenPort(SCE_AUDIO_OUT_PORT_TYPE_MAIN, 1024, 48000, SCE_AUDIO_OUT_MODE_STEREO);
    if (p->audio_port < 0) {
        free(p);
        return NULL;
    }
    
    sceAudioOutSetVolume(p->audio_port, SCE_AUDIO_VOLUME_FLAG_L_CH | SCE_AUDIO_VOLUME_FLAG_R_CH, (int[]){p->volume, p->volume});
    
    return (audio_player_t*)p;
}

void audio_player_destroy(audio_player_t* player) {
    if (!player) return;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    
    if (p->audio_port >= 0) {
        sceAudioOutReleasePort(p->audio_port);
    }
    
    free(player);
}

void audio_player_update(audio_player_t* player) {
    if (!player) return;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    
    // Simular actualización de posición cuando está reproduciendo
    if (p->state == AUDIO_STATE_PLAYING) {
        p->position += 0.016f; // ~60 FPS
        if (p->position >= p->duration && p->duration > 0) {
            p->state = AUDIO_STATE_STOPPED;
            p->position = 0.0f;
        }
    }
}

bool audio_player_play(audio_player_t* player, const char* filename) {
    if (!player || !filename) return false;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    
    strncpy(p->current_file, filename, sizeof(p->current_file) - 1);
    p->current_file[sizeof(p->current_file) - 1] = '\0';
    
    // En una implementación real, aquí se cargaría y decodificaría el archivo
    // Por ahora simulamos una duración
    p->duration = 120.0f + (float)(rand() % 300); // 2-7 minutos
    p->position = 0.0f;
    p->state = AUDIO_STATE_PLAYING;
    
    return true;
}

void audio_player_pause(audio_player_t* player) {
    if (!player) return;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    if (p->state == AUDIO_STATE_PLAYING) {
        p->state = AUDIO_STATE_PAUSED;
    }
}

void audio_player_resume(audio_player_t* player) {
    if (!player) return;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    if (p->state == AUDIO_STATE_PAUSED) {
        p->state = AUDIO_STATE_PLAYING;
    }
}

void audio_player_stop(audio_player_t* player) {
    if (!player) return;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    p->state = AUDIO_STATE_STOPPED;
    p->position = 0.0f;
}

audio_state_t audio_player_get_state(audio_player_t* player) {
    if (!player) return AUDIO_STATE_STOPPED;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    return p->state;
}

int audio_player_get_volume(audio_player_t* player) {
    if (!player) return 0;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    return p->volume;
}

void audio_player_set_volume(audio_player_t* player, int volume) {
    if (!player) return;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    
    if (volume < 0) volume = 0;
    if (volume > 100) volume = 100;
    
    p->volume = volume;
    
    if (p->audio_port >= 0) {
        int vol_levels[2] = {volume, volume};
        sceAudioOutSetVolume(p->audio_port, SCE_AUDIO_VOLUME_FLAG_L_CH | SCE_AUDIO_VOLUME_FLAG_R_CH, vol_levels);
    }
}

float audio_player_get_position(audio_player_t* player) {
    if (!player) return 0.0f;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    return p->position;
}

float audio_player_get_duration(audio_player_t* player) {
    if (!player) return 0.0f;
    
    audio_player_t_impl* p = (audio_player_t_impl*)player;
    return p->duration;
}
