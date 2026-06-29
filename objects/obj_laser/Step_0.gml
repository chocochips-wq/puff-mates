/// @description Logika Hitbox Laser & Proteksi Player

pulse_timer++;

// ===================================================================
// CEK COLLISION DENGAN PLAYER
// Laser berbahaya kecuali player dilindungi payung tepat di bawahnya
// ===================================================================
var umbrella = instance_find(obj_umbrella, 0);

with(obj_player) {
    // Cek apakah player dalam jalur laser secara horizontal (x)
    var in_laser_x = (x > other.x - other.laser_width)
                  && (x < other.x + other.laser_width);
    // Cek apakah player dalam panjang laser secara vertikal (y)
    var in_laser_y = (y > other.y)
                  && (y < other.y + other.laser_length);

    if(in_laser_x && in_laser_y) {
        // Cek apakah dilindungi payung
        var protected = false;
        if(umbrella != noone && umbrella.holder != noone) {
            // PERBAIKAN: Posisi X laser ini harus berada di dalam batas kiri-kanan fisik payung saat ini
            if (other.x >= umbrella.bbox_left && other.x <= umbrella.bbox_right) {
                protected = true;
            }
        }
        if(!protected) scr_respawn();
    }
}