if (room == rm_menu) exit;

var room_name = room_get_name(room);
var digits = string_digits(room_name);
var level_num = (digits != "") ? real(digits) : 1;

// outline
draw_set_font(-1);
draw_set_color(c_black);
draw_text(22, 22, "LEVEL " + string(level_num));

// teks utama
draw_set_color(c_white);
draw_text(20, 20, "LEVEL " + string(level_num));