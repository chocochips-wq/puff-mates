// ==========================================
// COLLISION SEBELUM GERAK
// ==========================================

// Kalau rocket kena player, room restart
if (collision_line(x, y, x + hsp, y + vsp, obj_player, false, true) != noone) {
    room_restart();
    exit;
}

// Kalau rocket kena ground, rocket hilang / terblok
if (collision_line(x, y, x + hsp, y + vsp, obj_ground, false, true) != noone) {
    instance_destroy();
    exit;
}

// Kalau rocket kena wall, rocket hilang
if (collision_line(x, y, x + hsp, y + vsp, obj_wall, false, true) != noone) {
    instance_destroy();
    exit;
}

// ==========================================
// TRAIL
// ==========================================
trail_x[@ trail_idx] = x;
trail_y[@ trail_idx] = y;
trail_idx = (trail_idx + 1) mod 8;

// ==========================================
// GERAK
// ==========================================
x += hsp;
y += vsp;

// Rotasi rocket mengikuti arah gerak
image_angle = point_direction(0, 0, hsp, vsp);

// ==========================================
// LIFETIME
// ==========================================
life_timer--;

if (life_timer <= 0) {
    instance_destroy();
    exit;
}

// ==========================================
// KELUAR ROOM
// ==========================================
if (x < -50 || x > room_width + 50 || y < -50 || y > room_height + 50) {
    instance_destroy();
    exit;
}