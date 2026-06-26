function scr_apply_settings() {

    if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 1.0;
    if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;
    if (!variable_global_exists("mute_all"))   global.mute_all   = false;
    if (!variable_global_exists("fullscreen")) global.fullscreen = false;

    // Master volume
    if (global.mute_all) {
        audio_master_gain(0);
    } else {
        audio_master_gain(global.vol_master);
    }

    // Music group
    if (audio_group_is_loaded(audio_group_music)) {
        audio_group_set_gain(audio_group_music, global.mute_all ? 0 : global.vol_music, 0);
    } else {
        // Fallback: kontrol langsung per sound
        if (audio_exists(sound_menu)) {
            audio_sound_gain(sound_menu, global.mute_all ? 0 : global.vol_music, 0);
        }
        if (audio_exists(sound_bgm_main)) {
            audio_sound_gain(sound_bgm_main, global.mute_all ? 0 : global.vol_music, 0);
        }
    }

    // SFX group
    if (audio_group_is_loaded(audio_group_sfx)) {
        audio_group_set_gain(audio_group_sfx, global.mute_all ? 0 : global.vol_sfx, 0);
    } else {
        // Fallback: kontrol langsung per sound
        if (audio_exists(sound_lompat)) {
            audio_sound_gain(sound_lompat, global.mute_all ? 0 : global.vol_sfx, 0);
        }
        if (audio_exists(sound_cannon)) {
            audio_sound_gain(sound_cannon, global.mute_all ? 0 : global.vol_sfx, 0);
        }
        if (audio_exists(sound_lava_hit)) {
            audio_sound_gain(sound_lava_hit, global.mute_all ? 0 : global.vol_sfx, 0);
        }
        if (audio_exists(sound_key)) {
            audio_sound_gain(sound_key, global.mute_all ? 0 : global.vol_sfx, 0);
        }
        if (audio_exists(sound_level_clear)) {
            audio_sound_gain(sound_level_clear, global.mute_all ? 0 : global.vol_sfx, 0);
        }
    }

    // Visual
    window_set_fullscreen(global.fullscreen);
}