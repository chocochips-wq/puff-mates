function scr_play_sound_safe(sound_asset, priority, loop){
    // Pastikan aset suara tersebut memang ada di dalam proyek game
    if (audio_exists(sound_asset)) {
        // Langsung putar suara secara instan tanpa syarat kaku
        audio_play_sound(sound_asset, priority, loop);
    }
}