if(global.level_complete) exit;

if(!instance_exists(obj_player)) exit;

var p1 = noone;
var p2 = noone;
with(obj_player) {
    if(p_id == 0) p1 = id;
    if(p_id == 1) p2 = id;
}
if(p1 == noone || p2 == noone) exit;

var x1 = p1.x;
var y1 = p1.y;
var x2 = p2.x;
var y2 = p2.y;

var dist     = point_distance(x1, y1, x2, y2);
var max_dist = 120;
var tension  = clamp((dist - max_dist * 0.5) / (max_dist * 0.5), 0, 1);

// =======================
// UPDATE SAG (lengkungan tali karena gravitasi)
// Tali slack = melengkung ke bawah
// Tali tegang = semakin lurus
// =======================
rope_sag_target = lerp(28, 2, tension); // slack → banyak lengkung, tegang → hampir lurus
rope_sag        = lerp(rope_sag, rope_sag_target, 0.08);

// =======================
// UPDATE SWING (goyang karena momentum)
// Kalau salah satu player gerak, tali goyang
// =======================
var p1_moving = (abs(p1.x - p1.xprevious) > 0.1);
var p2_moving = (abs(p2.x - p2.xprevious) > 0.1);

if(p1_moving || p2_moving) {
    rope_swing_vel += (irandom_range(-10, 10) * 0.004); // kick kecil saat ada gerakan
}
rope_swing_vel *= 0.88;                   // damping
rope_swing     += rope_swing_vel;
rope_swing     *= 0.92;                   // damping utama

// =======================
// HITUNG TITIK-TITIK TALI (catenary + per-segment physics)
// =======================
var segs = rope_segments;
var spring_k   = 0.25;
var spring_dmp = 0.75;

for(var i = 0; i < segs; i++) {
    var t = i / (segs - 1); // 0.0 → 1.0

    // Posisi base (interpolasi linear antara p1 dan p2)
    var bx = lerp(x1, x2, t);
    var by = lerp(y1, y2, t);

    // Catenary sag — paling besar di tengah (sin(t*pi))
    var sag_amount = sin(t * pi) * rope_sag;

    // Swing — paling besar di tengah, berkurang di ujung
    var swing_amount = sin(t * pi) * rope_swing;

    // Target posisi segmen
    var target_x = bx + swing_amount;
    var target_y = by + sag_amount;

    // Spring physics per segmen (supaya gerakan terasa elastis)
    var force_x = (target_x - (bx + rope_ox[i])) * spring_k;
    var force_y = (target_y - (by + rope_oy[i])) * spring_k;

    rope_vx[@ i] = (rope_vx[i] + force_x) * spring_dmp;
    rope_vy[@ i] = (rope_vy[i] + force_y) * spring_dmp;
    rope_ox[@ i] += rope_vx[i];
    rope_oy[@ i] += rope_vy[i];
}

// =======================
// DRAW TALI — Gaya Pico Park Coral (2px Solid Coral Line)
// =======================
var segments_draw = segs - 1;
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(255, 120, 75)); // Warna orange/coral hangat persis referensi gambar

for(var i = 0; i < segments_draw; i++) {
    var t_a = i / (segs - 1);
    var t_b = (i + 1) / (segs - 1);

    // Posisi segmen A
    var ax = lerp(x1, x2, t_a) + rope_ox[i];
    var ay = lerp(y1, y2, t_a) + rope_oy[i] + sin(t_a * pi) * rope_sag;

    // Posisi segmen B
    var bx2 = lerp(x1, x2, t_b) + rope_ox[i + 1];
    var by2  = lerp(y1, y2, t_b) + rope_oy[i + 1] + sin(t_b * pi) * rope_sag;

    // Gambar garis dengan tebal 2 pixel
    draw_line_width(ax, ay, bx2, by2, 2);
}

// Reset
draw_set_color(c_white);
draw_set_alpha(1.0);

