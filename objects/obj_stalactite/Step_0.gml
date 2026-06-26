// =======================
// STATE MACHINE
// =======================
switch(state) {
    case "idle":
        idle_timer--;
        if(idle_timer <= 0) {
            state = "shaking";
            shake_timer = 40;
        }
    break;

    case "shaking":
        shake_offset = sin(shake_timer * 1.5) * 3;
        x = start_x + shake_offset;
        shake_timer--;
        if(shake_timer <= 0) {
            state = "falling";
            x = start_x;
        }
    break;

    case "falling":
        fall_speed += 0.6;
        fall_speed = min(fall_speed, 16);
        y += fall_speed;

        // Spawn partikel asap es
        part_timer++;
        if(part_timer mod 2 == 0) {
            part_x[@  part_index] = x + irandom_range(-8, 8);
            part_y[@  part_index] = y;
            part_vx[@ part_index] = (irandom_range(-25, 25)) * 0.1;
            part_vy[@ part_index] = irandom_range(-20, -8) * 0.1;
            part_size[@ part_index] = irandom_range(5, 12);
            part_life[@ part_index] = irandom_range(18, 30);
            part_index = (part_index + 1) mod 30;
        }

        // Kena player → respawn
        with(obj_player) {
            if(place_meeting(x, y, other)) scr_respawn();
        }


        // Kena lantai → spawn impact particles lalu reset
        if(place_meeting(x, y, obj_ground)
        || place_meeting(x, y, obj_block_tinggi)
        || y > room_height + 100) {
            // Spawn impact particles
            impact_particles = true;
            for(var i = 0; i < 20; i++) {
                var angle    = irandom_range(180, 360);
                var spd      = irandom_range(5, 20) * 0.3;
                imp_x[@  i]  = x;
                imp_y[@  i]  = y;
                imp_vx[@ i]  = lengthdir_x(spd, angle);
                imp_vy[@ i]  = lengthdir_y(spd, angle);
                imp_size[@ i] = irandom_range(3, 9);
                imp_life[@ i] = irandom_range(15, 30);
            }
            state = "reset";
            reset_timer = 150;
        }
    break;

    case "reset":
        x = start_x;
        y = start_y;
        fall_speed  = 0;
        part_timer  = 0;
        shake_offset = 0;
        reset_timer--;
        if(reset_timer <= 0) {
            state = "shaking";
            shake_timer  = 40;
            idle_timer   = irandom_range(60, 180);
            impact_particles = false;
        }
    break;
}

// =======================
// UPDATE PARTIKEL ASAP
// =======================
for(var i = 0; i < 30; i++) {
    if(part_life[i] > 0) {
        part_x[@  i] += part_vx[i];
        part_y[@  i] += part_vy[i];
        part_vy[@ i] -= 0.015; // melayang ke atas pelan
        part_vx[@ i] *= 0.97;  // friction
        part_life[@ i]--;
    }
}

// =======================
// UPDATE PARTIKEL IMPACT
// =======================
if(impact_particles) {
    for(var i = 0; i < 20; i++) {
        if(imp_life[i] > 0) {
            imp_x[@  i] += imp_vx[i];
            imp_y[@  i] += imp_vy[i];
            imp_vy[@ i] += 0.3; // gravitasi
            imp_vx[@ i] *= 0.95;
            imp_life[@ i]--;
        }
    }
}