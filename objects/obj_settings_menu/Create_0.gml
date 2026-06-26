/// @description Inisialisasi Jendela & Array Audio

menu_width  = 500;
menu_height = 420;

menu_scale = 0.0;
menu_target_scale = 1.0;
anim_speed = 0.15;

slider_name        = ["Master Volume", "Music Volume", "SFX Volume"];
slider_global_var  = ["vol_master", "vol_music", "vol_sfx"];
slider_yy          = [-110, -40, 30];
slider_is_dragging = [false, false, false];

total_sliders = array_length(slider_name);

slider_w = 260;
slider_h = 8;
knob_r   = 10;

btn_mute_w = 140;
btn_mute_h = 36;
btn_mute_y = 100;

btn_back_w = 140;
btn_back_h = 40;
btn_back_y = 160;

is_closing = false;

// Inisialisasi global.mute_music dan global.mute_sfx jika belum ada
if (!variable_global_exists("mute_music") || !variable_global_exists("mute_sfx")) {
    ini_open("puff_mates_settings.ini");
    if (!variable_global_exists("mute_music")) global.mute_music = ini_read_real("Audio", "mute_music", 0);
    if (!variable_global_exists("mute_sfx"))   global.mute_sfx   = ini_read_real("Audio", "mute_sfx",   0);
    ini_close();
}