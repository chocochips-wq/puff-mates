opened = false;
anim_done = false;
image_speed = 0;
sprite_index = spr_door_closed;
players_entered = 0;
global.level_complete = false;
global.level_timer = 0;
txt_x = -300; // mulai dari luar kiri
txt_target_x = display_get_gui_width() / 2; // target tengah

// Custom Menu Lobby Variables
is_menu_door = false;
target_room = rm_end; // ⚡ SET TARGET: Langsung arahkan default-nya ke rm_end khusus untuk room bos ini
level_number_label = "";
is_locked = false;

depth = 1;

// =================================================================
// ⚡ FIX PROGRESS LEVEL & PENGAMAN TRANSISI
// =================================================================
// Cek apakah variabel global progress sudah ada, kalau belum kita buat biar gak crash
if (!variable_global_exists("max_unlocked_level")) {
    global.max_unlocked_level = 1; 
}

// Beri tanda pintu ini adalah pintu level boss (misal level 3 atau sesuaikan)
current_level = 3;