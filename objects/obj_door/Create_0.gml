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
target_room = noone;
level_number_label = "";
is_locked = false;

depth = 1;