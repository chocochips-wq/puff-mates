var tile_size = 32;

for(var i = 0; i < room_width; i += tile_size){

    // lubang 1
    if(i >= 800 && i <= 900) continue;

    // lubang 2
    if(i >= 1100 && i <= 1200) continue;

}

audio_stop_all();
audio_play_sound(sound_bgm_main, 1, true);