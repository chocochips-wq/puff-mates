/// @description Render Efek Visual Laser Zigzag Presisi

// ===================================================================
// CARI TITIK POTONG (Hanya memotong visual jika menabrak fisik payung)
// ===================================================================
var laser_end_y = y + laser_length;
var umbrella    = instance_find(obj_umbrella, 0);
var blocked     = false;

if(umbrella != noone && umbrella.holder != noone) {
    // PERBAIKAN: Sinar X laser ini hanya akan terpotong jika tepat mengenai koordinat fisik payung
    if (x >= umbrella.bbox_left && x <= umbrella.bbox_right) {
        if(umbrella.y > y && umbrella.y < laser_end_y) {
            laser_end_y = umbrella.y;
            blocked     = true;
        }
    }
}

var draw_length = laser_end_y - y;
if(draw_length <= 0) exit;

pulse_timer++;

// ===================================================================
// DRAW ZIGZAG ANIMASI
// ===================================================================
var seg_height = 8;   // tinggi tiap segitiga zigzag
var zag_width  = 6;   // lebar zigzag kiri kanan
var anim_speed = 1;   // kecepatan animasi turun

// Offset animasi — bikin zigzag terlihat bergerak ke bawah
var anim_offset = - (pulse_timer * anim_speed) mod (seg_height * 2);

var cur_y    = y - anim_offset;
var go_right = true;

// Kumpulkan titik-titik zigzag
var points_x = [];
var points_y = [];
array_push(points_x, x);
array_push(points_y, cur_y);

while(cur_y < laser_end_y + seg_height) {
    cur_y    += seg_height;
    var zx    = go_right ? x + zag_width : x - zag_width;
    array_push(points_x, zx);
    array_push(points_y, cur_y);
    go_right  = !go_right;
}

// Draw layer glow luar (oranye transparan)
draw_set_alpha(0.3);
draw_set_color(make_color_rgb(255, 160, 80));
for(var i = 0; i < array_length(points_x) - 1; i++) {
    var ax = points_x[i];
    var ay = clamp(points_y[i], y, laser_end_y);
    var bx = points_x[i+1];
    var by = clamp(points_y[i+1], y, laser_end_y);
    draw_line_width(ax, ay, bx, by, 8);
}

// Draw layer tengah (kuning)
draw_set_alpha(0.6);
draw_set_color(make_color_rgb(255, 220, 100));
for(var i = 0; i < array_length(points_x) - 1; i++) {
    var ax = points_x[i];
    var ay = clamp(points_y[i], y, laser_end_y);
    var bx = points_x[i+1];
    var by = clamp(points_y[i+1], y, laser_end_y);
    draw_line_width(ax, ay, bx, by, 4);
}

// Draw core putih
draw_set_alpha(1);
draw_set_color(c_white);
for(var i = 0; i < array_length(points_x) - 1; i++) {
    var ax = points_x[i];
    var ay = clamp(points_y[i], y, laser_end_y);
    var bx = points_x[i+1];
    var by = clamp(points_y[i+1], y, laser_end_y);
    draw_line_width(ax, ay, bx, by, 2);
}

// ===================================================================
// EFEK IMPACT
// ===================================================================
var ip = sin(pulse_timer * 0.25) * 0.3 + 0.7;
if(blocked) {
    draw_set_alpha(ip * 0.7);
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_circle(x, laser_end_y, 12, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_circle(x, laser_end_y, 4, false);
} else {
    draw_set_alpha(ip * 0.6);
    draw_set_color(make_color_rgb(255, 160, 50));
    draw_circle(x, laser_end_y, 12, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_circle(x, laser_end_y, 4, false);
}

draw_set_alpha(1);
draw_set_color(c_white);