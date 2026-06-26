// Hanya putar sound_menu kalau belum jalan
if (!audio_is_playing(sound_menu)) {
    audio_play_sound(sound_menu, 1, true);
}