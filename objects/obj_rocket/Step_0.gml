// Trail
trail_x[@ trail_idx] = x;
trail_y[@ trail_idx] = y;
trail_idx = (trail_idx + 1) mod 8;

// Gerak
x += hsp;
y += vsp;

// Lifetime
life_timer--;
if (life_timer <= 0) {
    instance_destroy();
    exit;
}

// Kena ground
if (place_meeting(x, y, obj_ground)) {
    instance_destroy();
    exit;
}

// Keluar room
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
    exit;
}

// Kena player
with (obj_player) {
    if (place_meeting(x, y, other)) {
        scr_respawn();
        with (other) { instance_destroy(); }
        exit;
    }
}