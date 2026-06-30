/// @description Inisialisasi Audio Manager & Progress Data

// ===================================================================
// 1. CEGAH DUPLIKAT SAAT GANTI ROOM
// ===================================================================
if (instance_number(obj_audio_manager) > 1) {
    instance_destroy();
    exit;
}

// ===================================================================
// 2. NAIKKAN JUMLAH CHANNEL AUDIO
// BUGFIX: default channel GameMaker terbatas. Saat boss fight di Room5
// banyak sound bermain bersamaan (BGM + laser + banyak snowball SFX),
// sound baru bisa "ditolak"/ke-cut karena channel penuh. Naikkan jadi 32.
// ===================================================================
audio_channel_num(32);

// ===================================================================
// 3. FORCE LOAD AUDIO GROUP KUSTOM (BIAR SUARA GAK BISU!)
// ===================================================================
if (!audio_group_is_loaded(audio_group_music)) {
    audio_group_load(audio_group_music);
}

if (!audio_group_is_loaded(audio_group_sfx)) {
    audio_group_load(audio_group_sfx);
}

// Atur volume default (opsional, skala 0.0 sampai 1.0)
audio_group_set_gain(audio_group_music, 0.8, 0);
audio_group_set_gain(audio_group_sfx, 1.0, 0);

// ===================================================================
// 4. INISIALISASI PROGRESS LEVEL DARI FILE LOKAL
// ===================================================================
ini_open("save_data.ini");
global.max_unlocked_level = ini_read_real("Progress", "max_unlocked", 1);
ini_close();