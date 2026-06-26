// ==========================================
// 1. TIMER & ANIMASI
// ==========================================
pulse_time += 0.05;
bob_time   += 0.03;

if (hit_flash > 0) {
    hit_flash--;
}

// ==========================================
// 2. BACKGROUND TRANSITION
// ==========================================
if (phase == 1) {
    bg_target_sky_r = 135;
    bg_target_sky_g = 206;
    bg_target_sky_b = 250;
} else if (phase == 2) {
    bg_target_sky_r = 255;
    bg_target_sky_g = 100;
    bg_target_sky_b = 30;
} else {
    bg_target_sky_r = 40;
    bg_target_sky_g = 30;
    bg_target_sky_b = 60;
}

bg_sky_r = lerp(bg_sky_r, bg_target_sky_r, bg_lerp_speed);
bg_sky_g = lerp(bg_sky_g, bg_target_sky_g, bg_lerp_speed);
bg_sky_b = lerp(bg_sky_b, bg_target_sky_b, bg_lerp_speed);

var back_id = layer_background_get_id("Background");

if (back_id != -1) {
    layer_background_blend(
        back_id,
        make_color_rgb(round(bg_sky_r), round(bg_sky_g), round(bg_sky_b))
    );
}

// ==========================================
// 3. UPDATE POSISI BOSS MENGHADAP BAWAH
// ==========================================
top_turret_x    = x + 80;
bottom_turret_x = x - 80;
turret_y        = y + 80;

// ==========================================
// 4. KILAT FASE 3
// ==========================================
if (phase == 3) {
    lightning_timer--;

    if (lightning_timer <= 0) {
        lightning_active = true;
        flash_alpha      = 1.0;
        lightning_timer  = irandom_range(60, 180);
    }
}

if (flash_alpha > 0) {
    flash_alpha -= 0.08;
}

// ==========================================
// 5. AIMING TURRETS
// KANAN INCAR PLAYER 2, KIRI INCAR PLAYER 1
// JANGKAUAN LEBIH LUAS TAPI TETAP KE BAWAH
// ==========================================

var player_1 = noone;
var player_2 = noone;

for (var i = 0; i < instance_number(obj_player); i++) {
    var p = instance_find(obj_player, i);

    if (p.p_id == 0) {
        player_1 = p;
    }

    if (p.p_id == 1) {
        player_2 = p;
    }
}

if (player_1 == noone) {
    player_1 = instance_nearest(bottom_turret_x, turret_y, obj_player);
}

if (player_2 == noone) {
    player_2 = instance_nearest(top_turret_x, turret_y, obj_player);
}

var aim_bob = sin(bob_time) * 5;

// Turret kanan incar Player 2
if (!top_destroyed && player_2 != noone) {
    var ta = point_direction(
        top_turret_x,
        turret_y + aim_bob + 40,
        player_2.x,
        player_2.y
    );

    top_angle = clamp(ta, 190, 350);
}

// Turret kiri incar Player 1
if (!bottom_destroyed && player_1 != noone) {
    var ba = point_direction(
        bottom_turret_x,
        turret_y + aim_bob + 40,
        player_1.x,
        player_1.y
    );

    bottom_angle = clamp(ba, 190, 350);
}
// ==========================================
// 6. SHOOTING
// ==========================================
if (hp > 0) {
    shoot_timer--;

    if (shoot_timer <= 0) {
        var shoot_delay;

        if (phase == 3) {
            shoot_delay = 45;
        } else if (phase == 2) {
            shoot_delay = 60;
        } else {
            shoot_delay = 80;
        }

        shoot_timer = shoot_delay;

      var bullet_speed        = 12;
var bullet_speed_phase3 = 14;
var rocket_speed        = 6;
var bullet_life         = 800;
        var shoot_bob           = sin(bob_time) * 5;

        // ==================================
        // TURRET KANAN
        // ==================================
        if (!top_destroyed) {
            var tx = top_turret_x + lengthdir_x(60, top_angle);
            var ty = turret_y + shoot_bob + 40 + lengthdir_y(60, top_angle);

            if (phase == 1) {
                var b_top_1 = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_1.hsp = lengthdir_x(bullet_speed, top_angle);
                b_top_1.vsp = lengthdir_y(bullet_speed, top_angle);
                b_top_1.bullet_type = "ball";
                b_top_1.life = bullet_life;
            } else if (phase == 2) {
                var top_a1 = top_angle - 30;
                var top_a2 = top_angle;
                var top_a3 = top_angle + 30;

                var b_top_2a = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_2a.hsp = lengthdir_x(bullet_speed, top_a1);
                b_top_2a.vsp = lengthdir_y(bullet_speed, top_a1);
                b_top_2a.bullet_type = "ball";
                b_top_2a.life = bullet_life;

                var b_top_2b = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_2b.hsp = lengthdir_x(bullet_speed, top_a2);
                b_top_2b.vsp = lengthdir_y(bullet_speed, top_a2);
                b_top_2b.bullet_type = "ball";
                b_top_2b.life = bullet_life;

                var b_top_2c = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_2c.hsp = lengthdir_x(bullet_speed, top_a3);
                b_top_2c.vsp = lengthdir_y(bullet_speed, top_a3);
                b_top_2c.bullet_type = "ball";
                b_top_2c.life = bullet_life;

                var r_top = instance_create_layer(tx, ty, "Instances_1", obj_rocket_1);
                r_top.dir_angle = top_angle;
                r_top.hsp = lengthdir_x(rocket_speed, top_angle);
                r_top.vsp = lengthdir_y(rocket_speed, top_angle);
            } else {
                var top_b1 = top_angle - 60;
                var top_b2 = top_angle - 30;
                var top_b3 = top_angle;
                var top_b4 = top_angle + 30;
                var top_b5 = top_angle + 60;

                var b_top_3a = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_3a.hsp = lengthdir_x(bullet_speed_phase3, top_b1);
                b_top_3a.vsp = lengthdir_y(bullet_speed_phase3, top_b1);
                b_top_3a.bullet_type = "ball";
                b_top_3a.life = bullet_life;

                var b_top_3b = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_3b.hsp = lengthdir_x(bullet_speed_phase3, top_b2);
                b_top_3b.vsp = lengthdir_y(bullet_speed_phase3, top_b2);
                b_top_3b.bullet_type = "ball";
                b_top_3b.life = bullet_life;

                var b_top_3c = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_3c.hsp = lengthdir_x(bullet_speed_phase3, top_b3);
                b_top_3c.vsp = lengthdir_y(bullet_speed_phase3, top_b3);
                b_top_3c.bullet_type = "ball";
                b_top_3c.life = bullet_life;

                var b_top_3d = instance_create_layer(tx, ty, "Instances_1", obj_snowball);
                b_top_3d.hsp = lengthdir_x(bullet_speed_phase3, top_b4);
                b_top_3d.vsp = lengthdir_y(bullet_speed_phase3, top_b4);
                b_top_3d.bullet_type = "ball";
                b_top_3d.life = bullet_life;

                var b_top_3e = instance_create_layer(tx, ty, "Instances_1", obj_snowball_1);
                b_top_3e.hsp = lengthdir_x(bullet_speed_phase3, top_b5);
                b_top_3e.vsp = lengthdir_y(bullet_speed_phase3, top_b5);
                b_top_3e.bullet_type = "ball";
                b_top_3e.life = bullet_life;
            }
        }

        // ==================================
        // TURRET KIRI
        // ==================================
        if (!bottom_destroyed) {
            var bx2 = bottom_turret_x + lengthdir_x(60, bottom_angle);
            var by2 = turret_y + shoot_bob + 40 + lengthdir_y(60, bottom_angle);

            if (phase == 1) {
                var b_bottom_1 = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_1.hsp = lengthdir_x(bullet_speed, bottom_angle);
                b_bottom_1.vsp = lengthdir_y(bullet_speed, bottom_angle);
                b_bottom_1.bullet_type = "ball";
                b_bottom_1.life = bullet_life;
            } else if (phase == 2) {
                var bottom_a1 = bottom_angle - 30;
                var bottom_a2 = bottom_angle;
                var bottom_a3 = bottom_angle + 30;

                var b_bottom_2a = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_2a.hsp = lengthdir_x(bullet_speed, bottom_a1);
                b_bottom_2a.vsp = lengthdir_y(bullet_speed, bottom_a1);
                b_bottom_2a.bullet_type = "ball";
                b_bottom_2a.life = bullet_life;

                var b_bottom_2b = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_2b.hsp = lengthdir_x(bullet_speed, bottom_a2);
                b_bottom_2b.vsp = lengthdir_y(bullet_speed, bottom_a2);
                b_bottom_2b.bullet_type = "ball";
                b_bottom_2b.life = bullet_life;

                var b_bottom_2c = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_2c.hsp = lengthdir_x(bullet_speed, bottom_a3);
                b_bottom_2c.vsp = lengthdir_y(bullet_speed, bottom_a3);
                b_bottom_2c.bullet_type = "ball";
                b_bottom_2c.life = bullet_life;

                var r_bottom = instance_create_layer(bx2, by2, "Instances_1", obj_rocket_1);
                r_bottom.dir_angle = bottom_angle;
                r_bottom.hsp = lengthdir_x(rocket_speed, bottom_angle);
                r_bottom.vsp = lengthdir_y(rocket_speed, bottom_angle);
            } else {
                var bottom_b1 = bottom_angle - 60;
                var bottom_b2 = bottom_angle - 30;
                var bottom_b3 = bottom_angle;
                var bottom_b4 = bottom_angle + 30;
                var bottom_b5 = bottom_angle + 60;

                var b_bottom_3a = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_3a.hsp = lengthdir_x(bullet_speed_phase3, bottom_b1);
                b_bottom_3a.vsp = lengthdir_y(bullet_speed_phase3, bottom_b1);
                b_bottom_3a.bullet_type = "ball";
                b_bottom_3a.life = bullet_life;

                var b_bottom_3b = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_3b.hsp = lengthdir_x(bullet_speed_phase3, bottom_b2);
                b_bottom_3b.vsp = lengthdir_y(bullet_speed_phase3, bottom_b2);
                b_bottom_3b.bullet_type = "ball";
                b_bottom_3b.life = bullet_life;

                var b_bottom_3c = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_3c.hsp = lengthdir_x(bullet_speed_phase3, bottom_b3);
                b_bottom_3c.vsp = lengthdir_y(bullet_speed_phase3, bottom_b3);
                b_bottom_3c.bullet_type = "ball";
                b_bottom_3c.life = bullet_life;

                var b_bottom_3d = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_3d.hsp = lengthdir_x(bullet_speed_phase3, bottom_b4);
                b_bottom_3d.vsp = lengthdir_y(bullet_speed_phase3, bottom_b4);
                b_bottom_3d.bullet_type = "ball";
                b_bottom_3d.life = bullet_life;

                var b_bottom_3e = instance_create_layer(bx2, by2, "Instances_1", obj_snowball_1);
                b_bottom_3e.hsp = lengthdir_x(bullet_speed_phase3, bottom_b5);
                b_bottom_3e.vsp = lengthdir_y(bullet_speed_phase3, bottom_b5);
                b_bottom_3e.bullet_type = "ball";
                b_bottom_3e.life = bullet_life;
            }
        }
    }
}

// ==========================================
// 7. SIMULTANEOUS STOMP DETECTION
// ==========================================
if (top_stomp_timer > 0) {
    top_stomp_timer--;
}

if (bottom_stomp_timer > 0) {
    bottom_stomp_timer--;
}

if (main_stomp_timer > 0) {
    main_stomp_timer--;
}

if (top_stomp_timer <= 0) {
    top_stomped_by = [];
}

if (bottom_stomp_timer <= 0) {
    bottom_stomped_by = [];
}

if (main_stomp_timer <= 0) {
    main_stomped_by = [];
}

// ==========================================
// 8. PHASE MANAGEMENT
// ==========================================
if (hp <= 6 && phase == 1) {
    phase = 2;

    with (obj_laser) {
        active = true;
    }

    with (obj_laser_h) {
        active = true;
    }
}

if (hp <= 3 && phase == 2) {
    phase = 3;

    with (obj_stalactite) {
        idle_timer = 20;
    }

    with (obj_spike) {
        visible = true;
    }

    lightning_timer = 60;
}

// ==========================================
// 9. MATI
// ==========================================
if (hp <= 0) {
    with (obj_laser) {
        active = false;
    }

    with (obj_laser_h) {
        active = false;
    }

    with (obj_snowball_1) {
        instance_destroy();
    }

    with (obj_rocket_1) {
        instance_destroy();
    }

    if (death_timer == -1) {
        death_timer = 180;
    }

    death_timer--;

    camera_set_view_pos(
        view_camera[0],
        camera_get_view_x(view_camera[0]) + irandom_range(-3, 3),
        camera_get_view_y(view_camera[0]) + irandom_range(-3, 3)
    );

    if (death_timer <= 0) {
        room_goto_next();
    }
}

