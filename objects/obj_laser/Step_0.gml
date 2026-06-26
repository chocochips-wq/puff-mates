pulse_timer++;

// =======================
// CEK COLLISION DENGAN PLAYER
// Laser berbahaya kecuali player dilindungi payung
// =======================
var umbrella = instance_find(obj_umbrella, 0);

with(obj_player) {
    // Cek apakah player dalam jalur laser (x)
    var in_laser_x = (x > other.x - other.laser_width)
                  && (x < other.x + other.laser_width);
    // Cek apakah player dalam panjang laser (y)
    var in_laser_y = (y > other.y)
                  && (y < other.y + other.laser_length);

    if(in_laser_x && in_laser_y) {
        // Cek apakah dilindungi payung
        var protected = false;
        if(umbrella != noone && umbrella.holder != noone) {
            var umb_x = umbrella.x;
            // Player di bawah payung (dalam radius 80px horizontal)
            if(abs(x - umb_x) < 80) protected = true;
        }
        if(!protected) scr_respawn();
    }
}