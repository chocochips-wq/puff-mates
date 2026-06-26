player_count = 0;
with (obj_player) {
    if (point_distance(x, y, other.x, other.y) < 20) {
        other.player_count += 1;
    }
}

if (player_count >= 2) {
    if (keyboard_check(ord("W"))) {
        angle_dir -= rot_spd;
    }
    if (keyboard_check(ord("S"))) {
        angle_dir += rot_spd;
    }
    angle_dir = clamp(angle_dir, -50, 25);
}

if (flash_timer > 0) flash_timer--;

if (player_count >= 2) {
    shoot_timer++;
    if (shoot_timer >= shoot_delay) {
        shoot_timer = 0;
        flash_timer = 8;
		audio_play_sound(sound_cannon, 1, false); 
		with (obj_player) {
            if (point_distance(x, y, other.x, other.y) < 20) {
                in_cannon = false;
                visible = true; // ← TAMBAHKAN INI: Membuat player muncul kembali saat ditembakkan
                cannon_exit_timer = 30;

                var barrel_len = 30;
                x = other.x + lengthdir_x(barrel_len, -other.angle_dir);
                y = other.y + lengthdir_y(barrel_len, -other.angle_dir);
                var launch_spd_x = 80; // ← jarak horizontal
				var launch_spd_y = 25; // ← tinggi lompatan
				hsp = lengthdir_x(launch_spd_x, -other.angle_dir);
				vsp = lengthdir_y(launch_spd_y, -other.angle_dir);
            }
        }
    }
} else {
    shoot_timer = 0;
}

bob_timer += bob_spd;
bob_offset = sin(bob_timer) * bob_height;