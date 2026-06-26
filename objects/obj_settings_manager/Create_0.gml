/// @description Inisialisasi Jendela & Array Audio

// Ukuran jendela menu pengaturan
menu_width  = 500;
menu_height = 420;

// Variabel animasi pop-up
menu_scale = 0.0;
menu_target_scale = 1.0;
anim_speed = 0.15;

// Array slider
slider_name       = ["Master Volume", "Music Volume", "SFX Volume"];
slider_global_var = ["vol_master", "vol_music", "vol_sfx"];
slider_yy         = [-90, -20, 50];
slider_is_dragging = [false, false, false];

total_sliders = array_length(slider_name);

// Ukuran slider
slider_w = 260;
slider_h = 8;
knob_r   = 10;

// Tombol Mute All
btn_mute_w = 160;
btn_mute_h = 36;
btn_mute_y = 120;

// Tombol Back
btn_back_w = 140;
btn_back_h = 40;
btn_back_y = 175;

// Pengaman double klik
is_closing = false;

global.mute_music = ini_read_real("Audio", "mute_music", 0);
global.mute_sfx   = ini_read_real("Audio", "mute_sfx",   0);