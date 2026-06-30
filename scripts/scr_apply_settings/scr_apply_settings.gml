function scr_apply_settings() {

    if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 1.0;
    if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;
    if (!variable_global_exists("mute_all"))   global.mute_all   = false;

    // Master volume
    if (global.mute_all) {
        audio_master_gain(0);
    } else {
        audio_master_gain(global.vol_master);
    }

    // Music
    // BUGFIX: sebelumnya dibungkus if(audio_group_is_loaded(audio_group_music))
    // yang selalu false karena group itu kosong (semua sound sebenarnya ada
    // di audiogroup_default). Sekarang gain diatur langsung per-sound.
    if (audio_exists(sound_menu)) {
        audio_sound_gain(sound_menu, global.mute_all ? 0 : global.vol_music, 0);
    }
    if (audio_exists(sound_bgm_main)) {
        audio_sound_gain(sound_bgm_main, global.mute_all ? 0 : global.vol_music, 0);
    }
    if (audio_exists(sound_bgm_boss_phase1)) {
        audio_sound_gain(sound_bgm_boss_phase1, global.mute_all ? 0 : global.vol_music, 0);
    }
    if (audio_exists(sound_bgm_boss_phase2)) {
        audio_sound_gain(sound_bgm_boss_phase2, global.mute_all ? 0 : global.vol_music, 0);
    }
    if (audio_exists(sound_bgm_boss_phase3)) {
        audio_sound_gain(sound_bgm_boss_phase3, global.mute_all ? 0 : global.vol_music, 0);
    }

    // SFX
    // BUGFIX: sama seperti di atas, sekaligus menambahkan sound_snowball &
    // sound_laser yang sebelumnya tidak pernah disertakan sama sekali.
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
    if (audio_exists(sound_snowball)) {
        audio_sound_gain(sound_snowball, global.mute_all ? 0 : global.vol_sfx, 0);
    }
    if (audio_exists(sound_laser)) {
        audio_sound_gain(sound_laser, global.mute_all ? 0 : global.vol_sfx, 0);
    }
    if (audio_exists(sound_boss_hit)) {
        audio_sound_gain(sound_boss_hit, global.mute_all ? 0 : global.vol_sfx, 0);
    }
    if (audio_exists(sound_explosion_giga)) {
        audio_sound_gain(sound_explosion_giga, global.mute_all ? 0 : global.vol_sfx, 0);
    }

    // ==========================================
    // FIX VISUAL ANTI-LOMPAT:
    // Update nilai global.fullscreen agar selalu sinkron dengan kondisi layar asli
    // ==========================================
    global.fullscreen = window_get_fullscreen(); 
    window_set_fullscreen(global.fullscreen);
}