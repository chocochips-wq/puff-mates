// === MOVEMENT ===
if (use_gravity) vsp += grv;
x += hsp;
y += vsp;

// === ROTATION EFFECT ===
proj_angle += 8; // Rotasi untuk visual

// === LIFETIME MANAGEMENT ===
lifetime--;
if (lifetime <= 0) instance_destroy();

// === SPREAD EFFECT (Fase 3 - spread pattern) ===
// Jika ditembak dari fase 3, proyektil bisa spread
if (spread_timer < 30) {
    spread_timer++;
    spread_amount = (spread_timer / 30) * max_spread_distance;
    
    // Tambahkan pergerakan spread dari centerline
    if (max_spread_distance > 0) {
        var spread_direction = (id mod 3) - 1; // -1, 0, atau 1
        var spread_force = sin(spread_timer / 30 * pi) * 2;
        hsp += spread_force * spread_direction;
    }
}

// === COLLISION WITH GROUND ===
if (place_meeting(x, y, obj_ground)) {
    instance_destroy();
}

// === COLLISION WITH OBSTACLES ===
if (place_meeting(x, y, obj_wall)) {
    instance_destroy();
}

// === OUT OF BOUNDS ===
if (y > room_height + 50 || x < -50 || x > room_width + 50 || y < -50) {
    instance_destroy();
}