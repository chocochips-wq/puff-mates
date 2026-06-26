// =======================
// CARI TITIK POTONG
// =======================
var laser_end_x  = x - laser_length;
var umbrella_side = instance_find(obj_umbrella_side, 0);
var blocked      = false;

if(umbrella_side != noone && umbrella_side.holder != noone) {
    var umb_x = umbrella_side.x;
    var umb_y = umbrella_side.y;
    if(abs(umb_y - y) < 70) {
        if(umb_x < x && umb_x > laser_end_x) {
            laser_end_x = umb_x;
            blocked     = true;
        }
    }
}

var draw_length = x - laser_end_x;
if(draw_length <= 0) exit;

// =======================
// DRAW ZIGZAG HORIZONTAL (kanan ke kiri)
// =======================
var seg_width   = 8;
var zag_height  = 6;
var anim_speed  = 2;
var anim_offset = -(pulse_timer * anim_speed) mod (seg_width * 2);

var cur_x   = x + anim_offset;
var go_down = true;

var points_x = [];
var points_y = [];
array_push(points_x, cur_x);
array_push(points_y, y);

while(cur_x > laser_end_x - seg_width) {
    cur_x  -= seg_width;
    var zy  = go_down ? y + zag_height : y - zag_height;
    array_push(points_x, cur_x);
    array_push(points_y, zy);
    go_down = !go_down;
}

// Glow luar
draw_set_alpha(0.3);
draw_set_color(make_color_rgb(255, 160, 80));
for(var i = 0; i < array_length(points_x) - 1; i++) {
    var ax = clamp(points_x[i],   laser_end_x, x);
    var ay = points_y[i];
    var bx = clamp(points_x[i+1], laser_end_x, x);
    var by = points_y[i+1];
    draw_line_width(ax, ay, bx, by, 8);
}

// Glow tengah
draw_set_alpha(0.6);
draw_set_color(make_color_rgb(255, 220, 100));
for(var i = 0; i < array_length(points_x) - 1; i++) {
    var ax = clamp(points_x[i],   laser_end_x, x);
    var ay = points_y[i];
    var bx = clamp(points_x[i+1], laser_end_x, x);
    var by = points_y[i+1];
    draw_line_width(ax, ay, bx, by, 4);
}

// Core putih
draw_set_alpha(1);
draw_set_color(c_white);
for(var i = 0; i < array_length(points_x) - 1; i++) {
    var ax = clamp(points_x[i],   laser_end_x, x);
    var ay = points_y[i];
    var bx = clamp(points_x[i+1], laser_end_x, x);
    var by = points_y[i+1];
    draw_line_width(ax, ay, bx, by, 2);
}

// Impact — hanya muncul saat kena payung
var ip = sin(pulse_timer * 0.25) * 0.3 + 0.7;
if(blocked) {
    draw_set_alpha(ip * 0.7);
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_circle(laser_end_x, y, 12, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_circle(laser_end_x, y, 4, false);
}
draw_set_alpha(1);
draw_set_color(c_white);