function scr_save_settings(){
	
	if (!variable_global_exists("p1_left"))     global.p1_left     = ord("A");
    if (!variable_global_exists("p1_right"))    global.p1_right    = ord("D");
    if (!variable_global_exists("p1_jump"))     global.p1_jump     = vk_space;
    if (!variable_global_exists("p2_left"))     global.p2_left     = vk_left;
    if (!variable_global_exists("p2_right"))    global.p2_right    = vk_right;
    if (!variable_global_exists("p2_jump"))     global.p2_jump     = vk_up;
    if (!variable_global_exists("cannon_up"))   global.cannon_up   = ord("W");
    if (!variable_global_exists("cannon_down")) global.cannon_down = ord("S");
    if (!variable_global_exists("fullscreen"))  global.fullscreen  = false;
    if (!variable_global_exists("mute_all"))    global.mute_all    = false;
    if (!variable_global_exists("mute_music"))  global.mute_music  = false;
    if (!variable_global_exists("mute_sfx"))    global.mute_sfx    = false;
    if (!variable_global_exists("vol_master"))  global.vol_master  = 1.0;
    if (!variable_global_exists("vol_music"))   global.vol_music   = 1.0;
    if (!variable_global_exists("vol_sfx"))     global.vol_sfx     = 1.0;
// ==========================================
// SIMPAN SEMUA PENGATURAN KE FILE .ini
// Dipanggil setiap kali pemain mengubah setting
// ==========================================
ini_open("puff_mates_settings.ini");

// --- AUDIO ---
ini_write_real("Audio", "vol_master", global.vol_master);
ini_write_real("Audio", "vol_music",  global.vol_music);
ini_write_real("Audio", "vol_sfx",    global.vol_sfx);
ini_write_real("Audio", "mute_all",   global.mute_all);
ini_write_real("Audio", "mute_music", global.mute_music);
ini_write_real("Audio", "mute_sfx",   global.mute_sfx);

// --- VISUAL ---
ini_write_real("Visual", "fullscreen", global.fullscreen);

// --- KONTROL PLAYER 1 ---
ini_write_real("Controls", "p1_left",  global.p1_left);
ini_write_real("Controls", "p1_right", global.p1_right);
ini_write_real("Controls", "p1_jump",  global.p1_jump);

// --- KONTROL PLAYER 2 ---
ini_write_real("Controls", "p2_left",  global.p2_left);
ini_write_real("Controls", "p2_right", global.p2_right);
ini_write_real("Controls", "p2_jump",  global.p2_jump);

// --- KONTROL CANNON ---
ini_write_real("Controls", "cannon_up",   global.cannon_up);
ini_write_real("Controls", "cannon_down", global.cannon_down);

ini_close();
}