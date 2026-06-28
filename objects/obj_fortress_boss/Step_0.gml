/// @description Logika Utama, Pergerakan & Update Jeda Transisi Sinematik 10 Detik

if (window_get_fullscreen()) {
    var display_w = display_get_width();
    var display_h = display_get_height();
    if (surface_exists(application_surface)) {
        if (surface_get_width(application_surface)  != display_w || surface_get_height(application_surface) != display_h) {
            surface_resize(application_surface, display_w, display_h);
        }
    }
    if (view_enabled && view_visible[0]) {
        view_set_wport(0, display_w);
        view_set_hport(0, display_h);
    }
}

if (boss_fully_dead) exit;

// ===================================================================
// PROSES KEMATIAN DEFINITIF BOSS
// ===================================================================
if (core_main_hp <= 0) {
    with (obj_laser)       { active = false; }
    with (obj_laser_h)     { active = false; }
    with (obj_laser_fase3) { instance_destroy(); }
    with (obj_snowball_1)  { instance_destroy(); }
    with (obj_rocket_1)    { instance_destroy(); }

    if (death_timer == -1) {
        death_timer = 180;
        var key_inst = instance_create_layer(x, y + 40, "Instances_1", obj_key);
        if (key_inst != noone) {
            key_inst.is_dropped = true;
            key_inst.vsp        = -3;
        }
    }

    death_timer--;
    camera_set_view_pos(
        view_camera[0],
        camera_get_view_x(view_camera[0]) + irandom_range(-4, 4),
        camera_get_view_y(view_camera[0]) + irandom_range(-4, 4)
    );

    if (death_timer <= 0) {
        var final_back_id = layer_background_get_id("Background");
        if (final_back_id != -1) {
            layer_background_blend(final_back_id, make_color_rgb(40, 30, 60));
        }
        boss_fully_dead = true;
    }
    exit;
}

// ===================================================================
// TIMEOUT OTOMATIS FASE 1 → FASE 2
// ===================================================================
if (phase == 1 && transisi_timer == -1) {
    phase1_timer++;
    if (phase1_timer >= phase1_timeout) {
        transisi_timer = 180;
    }
}

// ==========================================
// UPDATE ANIMASI & POROS KOORDINAT
// ==========================================
pulse_time += 0.05;
bob_time   += (transisi_timer > 0) ? 0.25 : 0.03;

if (hit_flash        > 0) hit_flash--;
if (phase2_flash_alpha > 0) phase2_flash_alpha = max(0, phase2_flash_alpha - 0.2);

var bob       = sin(bob_time) * 5;
var bx        = xstart;
var by        = ystart + bob;
l_turret_x    = bx - 185;
r_turret_x    = bx + 185;
turret_base_y = by + 20;

var ground_y = 710;

// ===================================================================
// 🌟 FISIKA JATUH BEBAS (HANYA AKTIF SETELAH LEDAKAN BERANTAI SELESAI / FRAME < 450)
// ===================================================================
if (jeda_fase3 > 0 && jeda_fase3 <= 450) {

    // --- KOTAK KIRI JATUH MANDIRI ---
    if (bottom_destroyed) {
        if (!puing_l_initialized) {
            puing_l_y           = ystart + 20;
            puing_l_vsp         = 3.0; // Entakan dorongan awal jatuh
            puing_l_angle       = 0;
            puing_l_rot_speed   = choose(-6, -4, 4, 6); // Berputar lebih cepat biar lebay
            puing_l_bounce_count = 0;
            puing_l_initialized = true;
        }
        
        if (!puing_l_grounded && jeda_fase3 > 120) {
            puing_l_vsp += puing_gravity;
            puing_l_y   += puing_l_vsp;
            puing_l_angle += puing_l_rot_speed;
            
            if (puing_l_y >= ground_y - 45) {
                if (puing_l_bounce_count < 2) {
                    puing_l_vsp = -puing_l_vsp * 0.45; // Efek pantulan elastis
                    puing_l_y = ground_y - 45;
                    puing_l_rot_speed *= -0.6;
                    puing_l_bounce_count++;
                    camera_set_view_pos(view_camera[0], camera_get_view_x(view_camera[0]) + irandom_range(-8, 8), camera_get_view_y(view_camera[0]) + irandom_range(-8, 8));
                } else {
                    puing_l_y        = ground_y - 45;
                    puing_l_angle    = round(puing_l_angle / 90) * 90;
                    puing_l_grounded = true;
                }
            }
        }
    }

    // --- KOTAK KANAN JATUH MANDIRI ---
    if (top_destroyed) {
        if (!puing_r_initialized) {
            puing_r_y           = ystart + 20;
            puing_r_vsp         = 3.0;
            puing_r_angle       = 0;
            puing_r_rot_speed   = choose(-6, -4, 4, 6);
            puing_r_bounce_count = 0;
            puing_r_initialized = true;
        }
        if (!puing_r_grounded && jeda_fase3 > 120) {
            puing_r_vsp += puing_gravity;
            puing_r_y   += puing_r_vsp;
            puing_r_angle += puing_r_rot_speed;
            
            if (puing_r_y >= ground_y - 45) {
                if (puing_r_bounce_count < 2) {
                    puing_r_vsp = -puing_r_vsp * 0.45;
                    puing_r_y = ground_y - 45;
                    puing_r_rot_speed *= -0.6;
                    puing_r_bounce_count++;
                    camera_set_view_pos(view_camera[0], camera_get_view_x(view_camera[0]) + irandom_range(-8, 8), camera_get_view_y(view_camera[0]) + irandom_range(-8, 8));
                } else {
                    puing_r_y        = ground_y - 45;
                    puing_r_angle    = round(puing_r_angle / 90) * 90;
                    puing_r_grounded = true;
                }
            }
        }
    }
}

// ===================================================================
// 🛠️ ENGINE SEKUENS JEDA TRANSISI TOTAL 10 DETIK (STATE ISOLATION)
// ===================================================================
if (phase == 2 && top_destroyed && bottom_destroyed && jeda_fase3 == -1) {
    jeda_fase3 = 600; // 10 Detik
}

if (jeda_fase3 > 0) {
    jeda_fase3--;

    // 💥 SEKUENS A: Frame 600 - 450 (RENTETAN LEDAKAN MAUT RAKSASA - TURRET BELUM JATUH!)
    if (jeda_fase3 > 450) {
        ledakan_aktif = true;
        ledakan_timer++;
        
        // Jantung radius ledakan berdenyut membesar menyelimuti seluruh kotak
        ledakan_radius_l = 60 + (sin(ledakan_timer * 0.8) * 50) + irandom(20);
        ledakan_radius_r = 60 + (cos(ledakan_timer * 0.8) * 50) + irandom(20);
        
        // Guncangan layar gempa bumi ekstrem selama ledakan terjadi
        camera_set_view_pos(view_camera[0], camera_get_view_x(view_camera[0]) + irandom_range(-12, 12), camera_get_view_y(view_camera[0]) + irandom_range(-8, 8));
        
        x = xstart + irandom_range(-4, 4);
        y = ystart + irandom_range(-2, 2);
    }
    // 💥 SEKUENS B: Frame 450 - 150 (LEDAKAN SELESAI, TURRET LEPAS TERJUN BEBAS, BOSS CHARGING)
    else if (jeda_fase3 <= 450 && jeda_fase3 > 150) {
        ledakan_aktif = false; // Matikan ledakan raksasa, puing mulai meluncur jatuh di atas
        
        x = xstart + irandom_range(-6, 6);
        y = ystart + irandom_range(-4, 4);

        explosion_burst--;
        if (explosion_burst <= 0) {
            explosion_burst = 8;
            hit_flash       = 3; // Kedip bodi darurat makin rusuh
        }
    }
    // SEKUENS C: Frame 150 - 0
	else if (jeda_fase3 <= 150 && jeda_fase3 > 0) {

    // --- SUB-FASE C1: Frame 150-100 → Pintu buka dulu, kotak belum bergerak ---
    if (jeda_fase3 > 100) {
        // Biarkan door_open_offset lerp duluan (dihandle di bawah)
        // Kotak tetap di ground, belum ditarik
        puing_l_y = ground_y - 45;
        puing_r_y = ground_y - 45;
        magnet_progress = 0;
    }
    // --- SUB-FASE C2: Frame 100-0 → Pintu sudah terbuka, kotak ditarik magnet ---
    else {
        var linear_progress = (100 - jeda_fase3) / 100;
        magnet_progress = sin(linear_progress * (pi / 2)); // Easing Sine Out

        var target_boss_y = ystart + 20;
        puing_l_y = lerp(ground_y - 45, target_boss_y, magnet_progress);
        puing_r_y = lerp(ground_y - 45, target_boss_y, magnet_progress);

        puing_l_angle = lerp(puing_l_angle, 0, 0.12);
        puing_r_angle = lerp(puing_r_angle, 0, 0.12);

        // Guncang saat ditarik magnet
        x = xstart + irandom_range(-9, 9);
        y = ystart + irandom_range(-6, 5);
    }
}

    // 💥 TRANSISI COMPLETE: MASUK FASE 3 MUTLAK
    if (jeda_fase3 <= 0) {
        x = xstart;
        y = ystart;

        phase           = 3;
        magnet_progress = 1.0;
        core_main_hp    = 100;

        fase3_mode            = 1;
        fase3_timer           = 60;
        shoot_timer           = 60;
        laser_already_spawned = false;
        survival_timer        = 30 * room_speed;
        rhythm_angle_offset   = 0;
        rhythm_dir            = 1;
        sweep_angle           = 180;
        sweep_direction       = 1;
        lightning_timer       = 60;
    }

    exit; // Kunci state penembakan lain
}

// ==========================================
// BACKGROUND WEATHER LERPING
// ==========================================
if      (phase == 1) { bg_target_sky_r = 135; bg_target_sky_g = 206; bg_target_sky_b = 250; }
else if (phase == 2) { bg_target_sky_r = 255; bg_target_sky_g = 100; bg_target_sky_b = 30;  }
else                 { bg_target_sky_r = 40;  bg_target_sky_g = 30;  bg_target_sky_b = 60;  }

bg_sky_r = lerp(bg_sky_r, bg_target_sky_r, bg_lerp_speed);
bg_sky_g = lerp(bg_sky_g, bg_target_sky_g, bg_lerp_speed);
bg_sky_b = lerp(bg_sky_b, bg_target_sky_b, bg_lerp_speed);

var back_id = layer_background_get_id("Background");
if (back_id != -1) {
    layer_background_blend(back_id, make_color_rgb(
        round(bg_sky_r), round(bg_sky_g), round(bg_sky_b)
    ));
}

if (phase == 3) {
    lightning_timer--;
    if (lightning_timer <= 0) {
        lightning_active = true;
        flash_alpha      = 1.0;
        lightning_timer  = irandom_range(60, 180);
    }
}
if (flash_alpha > 0) flash_alpha -= 0.08;

// ==========================================
// CO-OP RESPAWN MANAGEMENT
// ==========================================
if (phase == 2 || phase == 3) {
    if (p1_respawn_timer > 0) {
        p1_respawn_timer--;
        if (p1_respawn_timer <= 0) {
            if (instance_exists(real_p1)) {
                real_p1.x              = real_p1.spawn_x;
                real_p1.y              = real_p1.spawn_y;
                real_p1.vsp            = 0;
                real_p1.hsp            = 0;
                real_p1.is_hanging     = false;
                real_p1.is_dead_phase2 = false;
                real_p1.image_alpha    = 0.5;
            }
            p1_respawn_timer = -1;
        }
    }
    if (p2_respawn_timer > 0) {
        p2_respawn_timer--;
        if (p2_respawn_timer <= 0) {
            if (instance_exists(real_p2)) {
                real_p2.x              = real_p2.spawn_x;
                real_p2.y              = real_p2.spawn_y;
                real_p2.vsp            = 0;
                real_p2.hsp            = 0;
                real_p2.is_hanging     = false;
                real_p2.is_dead_phase2 = false;
                real_p2.image_alpha    = 0.5;
            }
            p2_respawn_timer = -1;
        }
    }

    if (p1_respawn_timer > 0 && p2_respawn_timer > 0) {
        phase          = 1;
        phase1_timer   = 0;
        transisi_timer = -1;
        hp             = max_hp;
        shoot_timer    = 60;

        p1_respawn_timer = -1;
        p2_respawn_timer = -1;

        top_destroyed    = false;
        bottom_destroyed = false;
        core_top_hp      = 5;
        core_bottom_hp   = 5;
        core_main_hp     = 100;

        magnet_progress    = 0;
        laser_tether_timer = 0;

        puing_l_y           = 0;
        puing_r_y           = 0;
        puing_l_vsp         = 0;
        puing_r_vsp         = 0;
        puing_l_grounded    = false;
        puing_r_grounded    = false;
        puing_l_initialized = false;
        puing_r_initialized = false;
        puing_l_angle       = 0;
        puing_r_angle       = 0;
        ledakan_aktif       = false;

        jeda_fase3            = -1;
        fase3_mode            = 1;
        fase3_timer           = 240;
        laser_already_spawned = false;
        survival_timer        = 30 * room_speed;

        with (obj_laser)      { active = false; }
        with (obj_laser_h)    { active = false; }
        with (obj_snowball_1) { instance_destroy(); }
        with (obj_rocket_1)   { instance_destroy(); }

        if (instance_exists(real_p1)) { real_p1.is_dead_phase2 = false; real_p1.image_alpha = 1; }
        if (instance_exists(real_p2)) { real_p2.is_dead_phase2 = false; real_p2.image_alpha = 1; }

        scr_respawn();
        exit;
    }
}

// ==========================================
// TARGETING AUTOMATION
// ==========================================
var target_left  = real_p1;
var target_right = real_p2;

if (instance_exists(real_p1)) {
    if (variable_instance_exists(real_p1, "is_dead_phase2") && real_p1.is_dead_phase2) {
        target_left = real_p2;
    }
}
if (instance_exists(real_p2)) {
    if (variable_instance_exists(real_p2, "is_dead_phase2") && real_p2.is_dead_phase2) {
        target_right = real_p1;
    }
}

if (phase == 1 || phase == 2) {
    if (!bottom_destroyed && instance_exists(target_left)) {
        var _p1_dead = (variable_instance_exists(target_left, "is_dead_phase2") && target_left.is_dead_phase2);
        if (!_p1_dead) {
            var ta    = point_direction(l_turret_x, turret_base_y, target_left.x, target_left.y);
            top_angle = clamp(ta, 200, 340);
        }
    }
    if (!top_destroyed && instance_exists(target_right)) {
        var _p2_dead = (variable_instance_exists(target_right, "is_dead_phase2") && target_right.is_dead_phase2);
        if (!_p2_dead) {
            var ba       = point_direction(r_turret_x, turret_base_y, target_right.x, target_right.y);
            bottom_angle = clamp(ba, 200, 340);
        }
    }
}

// ===================================================================
// SERANGAN FASE 3 MURNI
// ===================================================================
if (phase == 3) {
    shoot_timer--;
    if (fase3_mode != 4 && survival_timer > 0) survival_timer--;
    if (fase3_timer   > 0) fase3_timer--;

    // MODE 1: Semburan Lingkaran Chaos
    if (fase3_mode == 1) {
        with (obj_laser)   { active = false; }
        with (obj_laser_h) { active = false; }

        if (shoot_timer <= 0) {
            sweep_angle += (7 * sweep_direction);
            if (sweep_angle >= 360) { sweep_angle = 360; sweep_direction = -1; }
            if (sweep_angle <= 180) { sweep_angle = 180; sweep_direction =  1; }

            var b_snow = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
            if (b_snow != noone) {
                b_snow.hsp         = lengthdir_x(random_range(3.0, 5.5), sweep_angle);
                b_snow.vsp         = lengthdir_y(random_range(3.0, 5.5), sweep_angle);
                b_snow.bullet_type = "phase3_chaos";
                b_snow.lifetime    = 300;
                b_snow.use_gravity = false;
                b_snow.depth       = id.depth - 5;
            }
            shoot_timer = 4;
        }

        if (fase3_timer <= 0) {
            fase3_mode  = (survival_timer <= 0) ? 4 : 2;
            fase3_timer = (fase3_mode == 4)     ? 400 : 200;
            shoot_timer = 0;
        }
    }
    // MODE 2: Sapuan Laser Fase 3
    else if (fase3_mode == 2) {
        if (!laser_already_spawned) {
            var laser_inst = instance_create_layer(bx, by + 45, "Instances_1", obj_laser_fase3);
            if (laser_inst != noone) {
                if (choose(0, 1) == 0) {
                    laser_inst.laser_angle       = 215;
                    laser_inst.sweep_dir         = 1;
                    laser_inst.target_stop_angle = 270;
                } else {
                    laser_inst.laser_angle       = 325;
                    laser_inst.sweep_dir         = -1;
                    laser_inst.target_stop_angle = 270;
                }
                laser_inst.depth = id.depth - 5;
            }
            laser_already_spawned = true;
        }
        shoot_timer = 30;

        if (fase3_timer <= 0) {
            fase3_mode            = (survival_timer <= 0) ? 4 : 3;
            fase3_timer           = (fase3_mode == 4)     ? 400 : 180;
            shoot_timer           = 0;
            laser_already_spawned = false;
        }
    }
    // MODE 3: Tembakan Kipas Berirama
    else if (fase3_mode == 3) {
        if (shoot_timer <= 0) {
            var fan_spread = 25;
            var base_angle = 270 + rhythm_angle_offset;
            for (var i = 0; i < 4; i++) {
                var shot_angle = base_angle - (3 * fan_spread / 2) + (i * fan_spread);
                var b_fan      = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                if (b_fan != noone) {
                    b_fan.bullet_type = "phase3_chaos";
                    b_fan.use_gravity = false;
                    b_fan.hsp         = lengthdir_x(3.8, shot_angle);
                    b_fan.vsp         = lengthdir_y(3.8, shot_angle);
                    b_fan.lifetime    = 180;
                    b_fan.depth       = id.depth - 5;
                }
            }
            rhythm_angle_offset += (15 * rhythm_dir);
            if (abs(rhythm_angle_offset) >= 30) rhythm_dir = -rhythm_dir;
            shoot_timer = 12;
        }

        if (fase3_timer <= 0) {
            fase3_mode            = (survival_timer <= 0) ? 4 : 1;
            fase3_timer           = (fase3_mode == 4)     ? 400 : 240;
            shoot_timer           = 0;
            laser_already_spawned = false;
        }
    }
    // MODE 4: Giga Rocket Overheat
    else if (fase3_mode == 4) {
        if (fase3_timer > 40) {
            x = xstart + irandom_range(-3, 3);
            y = ystart + irandom_range(-2, 2);

            var giga_exist = false;
            with (obj_rocket_1) {
                if (bullet_type == "giga_overheat" || bullet_type == "giga_reflected") {
                    giga_exist = true;
                }
            }
            if (!giga_exist) {
                var giga_rocket = instance_create_layer(bx, by + 45, "Instances_1", obj_rocket_1);
                if (giga_rocket != noone) {
                    giga_rocket.bullet_type  = "giga_overheat";
                    giga_rocket.hsp          = 0;
                    giga_rocket.vsp          = 3.2;
                    giga_rocket.image_xscale = 4.0;
                    giga_rocket.image_yscale = 4.0;
                    giga_rocket.image_blend  = c_orange;
                    giga_rocket.depth        = id.depth - 5;
                }
            }
        }

        if (fase3_timer <= 0) {
            fase3_mode            = 1;
            fase3_timer           = 240;
            survival_timer        = 30 * room_speed;
            shoot_timer           = 45;
            laser_already_spawned = false;
        }
    }

    // Volt-Tether Horizontal
    if (magnet_progress >= 1.0) {
        laser_tether_timer += 0.02;
        laser_tether_y      = by + 90 + (sin(laser_tether_timer) * 60);

        var hit_p = collision_line(
            bx - 185, laser_tether_y,
            bx + 185, laser_tether_y,
            obj_player, false, true
        );
        if (hit_p != noone && !(variable_instance_exists(hit_p, "is_dead_phase2") && hit_p.is_dead_phase2)) {
            if (hit_p.p_id == 0) p1_respawn_timer = respawn_delay_time;
            if (hit_p.p_id == 1) p2_respawn_timer = respawn_delay_time;
            hit_p.is_dead_phase2 = true;
            hit_p.image_alpha    = 0;
        }
    }
}

// ==========================================
// SERANGAN FASE 1 & FASE 2
// ==========================================
if (phase == 1 || phase == 2) {
    if (transisi_timer > 0) {
        transisi_timer--;
        x += irandom_range(-6, 6);
        y += irandom_range(-3, 3);

        if (hp > 6) hp = max(6, hp - (3.0 / 180.0));

        if (transisi_timer <= 0) {
            x = xstart;
            y = ystart;
            phase       = 2;
            shoot_timer = 60;
            with (obj_laser)   { active = true; }
            with (obj_laser_h) { active = true; }
        }
    } else {
        shoot_timer--;
        if (shoot_timer <= 0) {
            shoot_timer = 60;

            if (!bottom_destroyed) {
                var b_top = instance_create_layer(
                    l_turret_x + lengthdir_x(90, top_angle),
                    turret_base_y + lengthdir_y(90, top_angle),
                    "Instances_1", obj_snowball_1
                );
                if (b_top != noone) {
                    b_top.hsp         = lengthdir_x(3.5, top_angle);
                    b_top.vsp         = lengthdir_y(3.5, top_angle);
                    b_top.bullet_type = "phase1";
                    b_top.lifetime    = 320;
                    b_top.use_gravity = false;
                }
            }
            if (!top_destroyed) {
                var b_bottom = instance_create_layer(
                    r_turret_x + lengthdir_x(90, bottom_angle),
                    turret_base_y + lengthdir_y(90, bottom_angle),
                    "Instances_1", obj_snowball_1
                );
                if (b_bottom != noone) {
                    b_bottom.hsp         = lengthdir_x(3.5, bottom_angle);
                    b_bottom.vsp         = lengthdir_y(3.5, bottom_angle);
                    b_bottom.bullet_type = "phase1";
                    b_bottom.lifetime    = 320;
                    b_bottom.use_gravity = false;
                }
            }

            if (phase == 2 && irandom(100) < 35) {
                if (!bottom_destroyed) {
                    var spawn_l_x = l_turret_x + lengthdir_x(90, top_angle);
                    var spawn_l_y = turret_base_y + lengthdir_y(90, top_angle);
                    var r_top = instance_create_layer(spawn_l_x, spawn_l_y, "Instances_1", obj_rocket_1);
                    if (r_top != noone) {
                        r_top.dir_angle = top_angle;
                        r_top.hsp       = lengthdir_x(7.5, top_angle);
                        r_top.vsp       = lengthdir_y(7.5, top_angle);
                    }
                }
                if (!top_destroyed) {
                    var spawn_r_x = r_turret_x + lengthdir_x(90, bottom_angle);
                    var spawn_r_y = turret_base_y + lengthdir_y(90, bottom_angle);
                    var r_bottom = instance_create_layer(spawn_r_x, spawn_r_y, "Instances_1", obj_rocket_1);
                    if (r_bottom != noone) {
                        r_bottom.dir_angle = bottom_angle;
                        r_bottom.hsp       = lengthdir_x(7.5, bottom_angle);
                        r_bottom.vsp       = lengthdir_y(7.5, bottom_angle);
                    }
                }
            }
        }
    }
}