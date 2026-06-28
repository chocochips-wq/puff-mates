/// @description Inisialisasi Tema Imut Puff Mates

// Kunci resolusi GUI agar font dan panel tetap tajam/HD saat Fullscreen
display_set_gui_size(1280, 720); 

// Atur posisi objek pas di tengah resolusi GUI yang baru dikunci
x = 1280 / 2;
y = 720 / 2;

menu_width  = 560;
menu_height = 420;

menu_scale = 0.0;
menu_target_scale = 1.0;
anim_speed = 0.15;

// Array slider (Volume)
slider_name        = ["Master Volume", "Music Volume", "SFX Volume"];
slider_global_var  = ["vol_master", "vol_music", "vol_sfx"];
slider_yy          = [-100, -35, 30];
slider_is_dragging = [false, false, false];

total_sliders = array_length(slider_name);

slider_w = 320;
slider_h = 16;  // Dipertebal agar lebih bergaya kartun/cute
knob_r   = 14;  // Bulatan diperbesar agar terlihat gemoy

// Tombol Fullscreen
btn_fs_w = 200;
btn_fs_h = 44;
btn_fs_y = 100;

// Tombol Back
btn_back_w = 140;
btn_back_h = 44;
btn_back_y = 160;

is_closing = false;

// 📸 Sistem Screenshot Background
pause_sprite = noone;
if (surface_exists(application_surface)) {
    pause_sprite = sprite_create_from_surface(application_surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0);
}

// Memuat data pengaturan audio awal
if (!variable_global_exists("mute_music") || !variable_global_exists("mute_sfx")) {
    ini_open("puff_mates_settings.ini");
    if (!variable_global_exists("mute_music")) global.mute_music = ini_read_real("Audio", "mute_music", 0);
    if (!variable_global_exists("mute_sfx"))   global.mute_sfx   = ini_read_real("Audio", "mute_sfx",   0);
    ini_close();
}