/// @description Logika Utama Boss Juggernaut

if (window_get_fullscreen()) {
    var display_w = display_get_width();
    var display_h = display_get_height();
    if (surface_exists(application_surface)) {
        if (surface_get_width(application_surface) != display_w || surface_get_height(application_surface) != display_h) {
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
// HELPER MACRO FISIKA PARTIKEL
// ===================================================================
#macro EXPL_GRAVITY 0.18
#macro EXPL_ARC_DRAG 0.92

// ===================================================================
// KEMATIAN DEFINITIF (MURNI UPDATE VISUAL & HITUNG BESAR SHAKE)
// ===================================================================
if (core_main_hp <= 0) {
    with (obj_laser_fase3) { instance_destroy(); }
    with (obj_snowball_1)  { instance_destroy(); }
    with (obj_rocket_1)    { instance_destroy(); }

    if (death_timer == -1) {
        death_timer      = 180;
        cam_shake_amount = 45; // Hantaman gempa awal sangat brutal!

        var _bx = xstart;
        var _by = ystart;
        for (var _di = 0; _di < expl_max; _di++) {
            var _ang  = random(360);
            var _spd  = random_range(2.0, 9.0);
            var _life = irandom_range(35, 80);
            var _type = choose(0, 0, 1, 1, 2);

            expl_l_x[_di]        = _bx + random_range(-60, 60);
            expl_l_y[_di]        = _by + random_range(-40, 40);
            expl_l_hsp[_di]      = lengthdir_x(_spd, _ang);
            expl_l_vsp[_di]      = lengthdir_y(_spd, _ang);
            expl_l_life[_di]     = _life;
            expl_l_maxlife[_di] = _life;
            expl_l_size[_di]    = random_range(3, 10);
            expl_l_arc[_di]     = random_range(-0.15, 0.15);
            expl_l_type[_di]    = _type;

            expl_r_x[_di]        = _bx + random_range(-60, 60);
            expl_r_y[_di]        = _by + random_range(-40, 40);
            expl_r_hsp[_di]      = lengthdir_x(_spd * 1.2, _ang + irandom_range(-30, 30));
            expl_r_vsp[_di]      = lengthdir_y(_spd * 1.2, _ang + irandom_range(-30, 30));
            expl_r_life[_di]     = _life;
            expl_r_maxlife[_di] = _life;
            expl_r_size[_di]    = random_range(3, 10);
            expl_r_arc[_di]     = random_range(-0.15, 0.15);
            expl_r_type[_di]    = _type;
        }
        expl_l_count      = expl_max;
        expl_r_count      = expl_max;
        expl_l_core_alpha = 1.0;
        expl_r_core_alpha = 1.0;
        expl_l_core_r      = 80;
        expl_r_core_r      = 80;

        var key_inst = instance_create_layer(x, y + 40, "Instances_1", obj_key);
        if (key_inst != noone) {
            key_inst.is_dropped = true;
            key_inst.vsp        = -3;
        }
    }

    // Setiap 20 frame, jaga amunisi getaran biar gak langsung abis
    if (death_timer > 0 && death_timer mod 20 == 0) {
        cam_shake_amount = max(cam_shake_amount, 20);
    }

    // Update partikel ledakan organik
    for (var _pi = 0; _pi < expl_max; _pi++) {
        if (expl_l_life[_pi] > 0) {
            expl_l_hsp[_pi] += expl_l_arc[_pi];
            expl_l_hsp[_pi] *= EXPL_ARC_DRAG;
            expl_l_vsp[_pi] += EXPL_GRAVITY;
            expl_l_x[_pi]   += expl_l_hsp[_pi];
            expl_l_y[_pi]   += expl_l_vsp[_pi];
            expl_l_life[_pi]--;
        }
        if (expl_r_life[_pi] > 0) {
            expl_r_hsp[_pi] += expl_r_arc[_pi];
            expl_r_hsp[_pi] *= EXPL_ARC_DRAG;
            expl_r_vsp[_pi] += EXPL_GRAVITY;
            expl_r_x[_pi]   += expl_r_hsp[_pi];
            expl_r_y[_pi]   += expl_r_vsp[_pi];
            expl_r_life[_pi]--;
        }
    }
if (expl_l_core_alpha > 0) expl_l_core_alpha -= 0.015;
    if (expl_r_core_alpha > 0) expl_r_core_alpha -= 0.015;

    // Bodi utama bergetar korsleting
    x = xstart + irandom_range(-12, 12);
    y = ystart + irandom_range(-9, 9);
    image_blend = choose(c_white, c_red, c_orange, c_yellow);

    death_timer--;

    // ===================================================================
    // SUNTIKAN SHAKE BRUTAL REAL-TIME (PROPORSIONAL SAMA SISA NYAWA TIMEOUT)
    // ===================================================================
    cam_shake_amount = (death_timer / 180) * 45; // Mengisi bensin getaran secara konstan!

    if (death_timer <= 0) {
        cam_shake_amount = 0;
        var final_back_id = layer_background_get_id("Background");
        if (final_back_id != -1) layer_background_blend(final_back_id, make_color_rgb(40, 30, 60));
        boss_fully_dead = true;
    }
    exit;
}

// ===================================================================
// TIMEOUT FASE 1 → FASE 2
// ===================================================================
if (phase == 1 && transisi_timer == -1) {
    phase1_timer++;
    if (phase1_timer >= phase1_timeout) transisi_timer = 180;
}

// ===================================================================
// UPDATE ANIMASI
// ===================================================================
pulse_time += lerp(0.05, 0.2, (phase == 3) ? 1 - (core_main_hp / 100) : 0);
bob_time   += (transisi_timer > 0) ? 0.25 : 0.03;

if (hit_flash > 0) hit_flash--;
if (phase2_flash_alpha > 0) phase2_flash_alpha = max(0, phase2_flash_alpha - 0.2);

var bob       = sin(bob_time) * 5;
var bx        = xstart;
var by        = ystart + bob;
l_turret_x    = bx - 185;
r_turret_x    = bx + 185;
turret_base_y = by + 20;
var ground_y  = 710;

// ===================================================================
// ENRAGE
// ===================================================================
if (phase == 3 && !is_enraged && core_main_hp < 30) {
    is_enraged        = true;
    enrage_speed_mult = 1.35;
    flash_alpha       = 1.0;
    fase3_timer       = min(fase3_timer, 60);
    cam_shake_amount  = max(cam_shake_amount, 16); 
}
if (is_enraged) enrage_flash_timer++;

// ===================================================================
// LOGIKA TAMBAHAN: TURRET OTOMATIS AKTIF KEMBALI DI FASE 3
// ===================================================================
if (phase == 3 && !overload_active) {
    // Kita gunakan alarm bawaan boss atau variabel timer baru khusus turret Fase 3.
    // Jika belum ada variabel timer_turret_fase3 di Create Event, GameMaker otomatis aman memakai variable_instance.
    if (!variable_instance_exists(id, "turret_fase3_timer")) {
        turret_fase3_timer = 80; // Jeda tembakan awal turret di Fase 3
    }
    
    turret_fase3_timer--;
    
    // Target tembakan turret Fase 3 (Ikuti logika targeting yang sudah ada)
    var target_l = instance_exists(real_p1) ? real_p1 : real_p2;
    var target_r = instance_exists(real_p2) ? real_p2 : real_p1;
    
    // Turret Kiri membidik Player Kiri
    if (instance_exists(target_l) && (variable_instance_exists(target_l, "is_dead_phase2") && !target_l.is_dead_phase2)) {
        var ta = point_direction(l_turret_x, turret_base_y, target_l.x, target_l.y);
        top_angle = clamp(ta, 190, 350); // Sudut bidik diperluas sedikit biar lebih responsif
    }
    
    // Turret Kanan membidik Player Kanan
    if (instance_exists(target_r) && (variable_instance_exists(target_r, "is_dead_phase2") && !target_r.is_dead_phase2)) {
        var ba = point_direction(r_turret_x, turret_base_y, target_r.x, target_r.y);
        bottom_angle = clamp(ba, 190, 350);
    }

    // Waktunya Turret Menembak!
    if (turret_fase3_timer <= 0) {
        // Beri jeda tembakan (jika enraged, turret menembak lebih membabi buta jirr!)
        turret_fase3_timer = is_enraged ? 45 : 70; 
        
        // Tembakan Turret Kiri
        var b_f3_left = instance_create_layer(
            l_turret_x + lengthdir_x(90, top_angle),
            turret_base_y + lengthdir_y(90, top_angle),
            "Instances_1", obj_snowball_1
        );
        if (b_f3_left != noone) {
            var _spd = is_enraged ? 4.5 : 3.2;
            b_f3_left.hsp         = lengthdir_x(_spd, top_angle);
            b_f3_left.vsp         = lengthdir_y(_spd, top_angle);
            b_f3_left.bullet_type = "phase1"; // Pakai tipe phase1 biar polanya lurus terarah
            b_f3_left.lifetime    = 280;
            b_f3_left.use_gravity = false;
        }
        
        // Tembakan Turret Kanan
        var b_f3_right = instance_create_layer(
            r_turret_x + lengthdir_x(90, bottom_angle),
            turret_base_y + lengthdir_y(90, bottom_angle),
            "Instances_1", obj_snowball_1
        );
        if (b_f3_right != noone) {
            var _spd = is_enraged ? 4.5 : 3.2;
            b_f3_right.hsp         = lengthdir_x(_spd, bottom_angle);
            b_f3_right.vsp         = lengthdir_y(_spd, bottom_angle);
            b_f3_right.bullet_type = "phase1";
            b_f3_right.lifetime    = 280;
            b_f3_right.use_gravity = false;
        }
        
        // Efek hentakan kecil pada kamera pas turret nembak biar makin berasa impact-nya
        cam_shake_amount = max(cam_shake_amount, 3);
    }
}

// ===================================================================
// UPDATE PARTIKEL LEDAKAN SEMENTARA
// ===================================================================
expl_spawn_timer--;
for (var _pi = 0; _pi < expl_max; _pi++) {
    if (expl_l_life[_pi] > 0) {
        expl_l_hsp[_pi] += expl_l_arc[_pi];
        expl_l_hsp[_pi] *= EXPL_ARC_DRAG;
        expl_l_vsp[_pi] += EXPL_GRAVITY;
        expl_l_x[_pi]   += expl_l_hsp[_pi];
        expl_l_y[_pi]   += expl_l_vsp[_pi];
        expl_l_life[_pi]--;
    }
    if (expl_r_life[_pi] > 0) {
        expl_r_hsp[_pi] += expl_r_arc[_pi];
        expl_r_hsp[_pi] *= EXPL_ARC_DRAG;
        expl_r_vsp[_pi] += EXPL_GRAVITY;
        expl_r_x[_pi]   += expl_r_hsp[_pi];
        expl_r_y[_pi]   += expl_r_vsp[_pi];
        expl_r_life[_pi]--;
    }
}
if (expl_l_core_alpha > 0) expl_l_core_alpha -= 0.02;
if (expl_r_core_alpha > 0) expl_r_core_alpha -= 0.02;

// ===================================================================
// FISIKA JATUH TURRET
// ===================================================================
if (jeda_fase3 > 0 && jeda_fase3 <= 450) {
    if (bottom_destroyed) {
        if (!puing_l_initialized) {
            puing_l_y = ystart + 20; puing_l_vsp = 3.0; puing_l_angle = 0;
            puing_l_rot_speed = choose(-6, -4, 4, 6); puing_l_bounce_count = 0;
            puing_l_initialized = true;
        }
        if (!puing_l_grounded && jeda_fase3 > 120) {
            puing_l_vsp += puing_gravity; puing_l_y += puing_l_vsp; puing_l_angle += puing_l_rot_speed;
            if (puing_l_y >= ground_y - 45) {
                if (puing_l_bounce_count < 2) {
                    puing_l_vsp = -puing_l_vsp * 0.45; puing_l_y = ground_y - 45;
                    puing_l_rot_speed *= -0.6; puing_l_bounce_count++;
                    cam_shake_amount = max(cam_shake_amount, 10); 
                } else {
                    puing_l_y = ground_y - 45;
                    puing_l_angle = round(puing_l_angle / 90) * 90;
                    puing_l_grounded = true;
                }
            }
        }
    }
    if (top_destroyed) {
        if (!puing_r_initialized) {
            puing_r_y = ystart + 20; puing_r_vsp = 3.0; puing_r_angle = 0;
            puing_r_rot_speed = choose(-6, -4, 4, 6); puing_r_bounce_count = 0;
            puing_r_initialized = true;
        }
        if (!puing_r_grounded && jeda_fase3 > 120) {
            puing_r_vsp += puing_gravity; puing_r_y += puing_r_vsp; puing_r_angle += puing_r_rot_speed;
            if (puing_r_y >= ground_y - 45) {
                if (puing_r_bounce_count < 2) {
                    puing_r_vsp = -puing_r_vsp * 0.45; puing_r_y = ground_y - 45;
                    puing_r_rot_speed *= -0.6; puing_r_bounce_count++;
                    cam_shake_amount = max(cam_shake_amount, 10); 
                } else {
                    puing_r_y = ground_y - 45;
                    puing_r_angle = round(puing_r_angle / 90) * 90;
                    puing_r_grounded = true;
                }
            }
        }
    }
}

// ===================================================================
// ENGINE SEKUENS TRANSISI FASE 3
// ===================================================================
if (phase == 2 && top_destroyed && bottom_destroyed && jeda_fase3 == -1) {
    jeda_fase3 = 600;
}

if (jeda_fase3 > 0) {
    jeda_fase3--;

    if (jeda_fase3 > 450) {
        cam_shake_amount = max(cam_shake_amount, 14);
        ledakan_aktif = true;
        ledakan_timer++;

        if (expl_spawn_timer <= 0) {
            expl_spawn_timer = 8;
            var _burst = irandom_range(6, 10);
            for (var _bi = 0; _bi < _burst; _bi++) {
                for (var _slot = 0; _slot < expl_max; _slot++) {
                    if (expl_l_life[_slot] <= 0) {
                        var _ang  = random_range(180, 360);
                        var _spd  = random_range(1.5, 7.0);
                        var _life = irandom_range(20, 50);
                        var _type = choose(0, 0, 0, 1, 1, 2);
                        expl_l_x[_slot]       = l_turret_x + random_range(-45, 45);
                        expl_l_y[_slot]       = turret_base_y + random_range(-30, 20);
                        expl_l_hsp[_slot]     = lengthdir_x(_spd, _ang);
                        expl_l_vsp[_slot]     = lengthdir_y(_spd, _ang);
                        expl_l_life[_slot]    = _life;
                        expl_l_maxlife[_slot] = _life;
                        expl_l_size[_slot]    = random_range(2, 7);
                        expl_l_arc[_slot]     = random_range(-0.2, 0.2);
                        expl_l_type[_slot]    = _type;
                        break;
                    }
                }
                for (var _slot = 0; _slot < expl_max; _slot++) {
                    if (expl_r_life[_slot] <= 0) {
                        var _ang  = random_range(180, 360);
                        var _spd  = random_range(1.5, 7.0);
                        var _life = irandom_range(20, 50);
                        var _type = choose(0, 0, 0, 1, 1, 2);
                        expl_r_x[_slot]       = r_turret_x + random_range(-45, 45);
                        expl_r_y[_slot]       = turret_base_y + random_range(-30, 20);
                        expl_r_hsp[_slot]     = lengthdir_x(_spd, _ang);
                        expl_r_vsp[_slot]     = lengthdir_y(_spd, _ang);
                        expl_r_life[_slot]    = _life;
                        expl_r_maxlife[_slot] = _life;
                        expl_r_size[_slot]    = random_range(2, 7);
                        expl_r_arc[_slot]     = random_range(-0.2, 0.2);
                        expl_r_type[_slot]    = _type;
                        break;
                    }
                }
            }
            expl_l_core_alpha = min(1.0, expl_l_core_alpha + 0.4);
            expl_r_core_alpha = min(1.0, expl_r_core_alpha + 0.4);
            expl_l_core_r = random_range(30, 60);
            expl_r_core_r = random_range(30, 60);
        }
        x = xstart + irandom_range(-4, 4);
        y = ystart + irandom_range(-2, 2);
    }
    else if (jeda_fase3 <= 450 && jeda_fase3 > 150) {
        cam_shake_amount = max(cam_shake_amount, 8);
        ledakan_aktif = false;
        x = xstart + irandom_range(-6, 6);
        y = ystart + irandom_range(-4, 4);
        explosion_burst--;
        if (explosion_burst <= 0) {
            explosion_burst = 8;
            hit_flash = 3;
            for (var _slot = 0; _slot < expl_max; _slot++) {
                if (expl_l_life[_slot] <= 0) {
                    expl_l_x[_slot]       = bx + random_range(-80, 80);
                    expl_l_y[_slot]       = by + random_range(-30, 30);
                    expl_l_hsp[_slot]     = random_range(-1.5, 1.5);
                    expl_l_vsp[_slot]     = random_range(-3, -1);
                    var _elife            = irandom_range(15, 30);
                    expl_l_life[_slot]    = _elife;
                    expl_l_maxlife[_slot] = _elife;
                    expl_l_size[_slot]    = random_range(1.5, 4);
                    expl_l_arc[_slot]     = random_range(-0.08, 0.08);
                    expl_l_type[_slot]    = 1;
                    break;
                }
            }
        }
    }
    else if (jeda_fase3 <= 150 && jeda_fase3 > 0) {
        if (jeda_fase3 > 100) {
            puing_l_y = ground_y - 45;
            puing_r_y = ground_y - 45;
            magnet_progress = 0;
        } else {
            var linear_progress = (100 - jeda_fase3) / 100;
            magnet_progress = sin(linear_progress * (pi / 2));
            var target_boss_y = ystart + 20;
            puing_l_y = lerp(ground_y - 45, target_boss_y, magnet_progress);
            puing_r_y = lerp(ground_y - 45, target_boss_y, magnet_progress);
            puing_l_angle = lerp(puing_l_angle, 0, 0.12);
            puing_r_angle = lerp(puing_r_angle, 0, 0.12);
            cam_shake_amount = max(cam_shake_amount, lerp(4, 12, magnet_progress));
            x = xstart + irandom_range(-9, 9);
            y = ystart + irandom_range(-6, 5);
        }
    }

    if (phase == 3 || (jeda_fase3 > 0 && jeda_fase3 <= 150)) {
        door_open_offset = lerp(door_open_offset, 55, 0.05);
    } else {
        door_open_offset = lerp(door_open_offset, 0, 0.05);
    }

    if (jeda_fase3 <= 0) {
        x = xstart; y = ystart;
        phase = 3; magnet_progress = 1.0; core_main_hp = 100;
        cam_shake_amount = max(cam_shake_amount, 18); 

        fase3_mode  = 1;
        fase3_timer = 240;
        shoot_timer = 0;

        laser_already_spawned = false;
        survival_timer        = 30 * room_speed;
        rhythm_angle_offset   = 0;
        rhythm_dir            = 1;
        sweep_angle           = 180;
        sweep_direction       = 1;
        lightning_timer       = 60;
        spiral_angle          = 0;
        overload_active       = false;
        overload_phase        = 0;

        if (!variable_instance_exists(id, "spiral_wave_dir"))   spiral_wave_dir   = 1;
        if (!variable_instance_exists(id, "spiral_speed_wave")) spiral_speed_wave = 1.0;
    }

    if (cam_shake_amount > 0.5) {
        cam_shake_amount *= cam_shake_decay;
    }
    exit;
}

// ===================================================================
// BACKGROUND WEATHER LERPING
// ===================================================================
if      (phase == 1) { bg_target_sky_r = 135; bg_target_sky_g = 206; bg_target_sky_b = 250; }
else if (phase == 2) { bg_target_sky_r = 255; bg_target_sky_g = 100; bg_target_sky_b = 30;  }
else                 { bg_target_sky_r = 40;  bg_target_sky_g = 30;  bg_target_sky_b = 60;  }

bg_sky_r = lerp(bg_sky_r, bg_target_sky_r, bg_lerp_speed);
bg_sky_g = lerp(bg_sky_g, bg_target_sky_g, bg_lerp_speed);
bg_sky_b = lerp(bg_sky_b, bg_target_sky_b, bg_lerp_speed);

var back_id = layer_background_get_id("Background");
if (back_id != -1) {
    layer_background_blend(back_id, make_color_rgb(round(bg_sky_r), round(bg_sky_g), round(bg_sky_b)));
}

if (phase == 3) {
    door_open_offset = lerp(door_open_offset, 55, 0.05);
    lightning_timer--;
    if (lightning_timer <= 0) {
        lightning_active = true;
        flash_alpha      = 1.0;
        lightning_timer  = irandom_range(60, 180);
        cam_shake_amount = max(cam_shake_amount, 6); 
    }
} else {
    door_open_offset = lerp(door_open_offset, 0, 0.05);
}
if (flash_alpha > 0) flash_alpha -= 0.08;

// ===================================================================
// CO-OP RESPAWN
// ===================================================================
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
        phase = 1; phase1_timer = 0; transisi_timer = -1;
        hp = max_hp; shoot_timer = 60;
        p1_respawn_timer = -1; p2_respawn_timer = -1;
        top_destroyed = false; bottom_destroyed = false;
        core_top_hp = 5; core_bottom_hp = 5; core_main_hp = 100;
        magnet_progress = 0; laser_tether_timer = 0;
        puing_l_y = 0; puing_r_y = 0; puing_l_vsp = 0; puing_r_vsp = 0;
        puing_l_grounded = false; puing_r_grounded = false;
        puing_l_initialized = false; puing_r_initialized = false;
        puing_l_angle = 0; puing_r_angle = 0; ledakan_aktif = false;
        jeda_fase3 = -1; fase3_mode = 1; fase3_timer = 240;
        laser_already_spawned = false; survival_timer = 30 * room_speed;
        is_enraged = false; enrage_speed_mult = 1.0; enrage_flash_timer = 0;
        warning_active = false; warning_timer = -1;
        crossfire_counter = 0; crossfire_cooldown = 0;
        spiral_angle = 0; crack_seed_l = irandom(9999); crack_seed_r = irandom(9999);
        overload_active = false; overload_phase = 0;
        scatter_state = 0; mortar_timer = 0;
        cam_shake_amount = 0; 

        for (var _ri = 0; _ri < expl_max; _ri++) {
            expl_l_life[_ri] = 0;
            expl_r_life[_ri] = 0;
        }
        expl_l_core_alpha = 0;
        expl_r_core_alpha = 0;

        with (obj_laser_fase3) { instance_destroy(); }
        with (obj_snowball_1)  { instance_destroy(); }
        with (obj_rocket_1)    { instance_destroy(); }
        if (instance_exists(real_p1)) { real_p1.is_dead_phase2 = false; real_p1.image_alpha = 1; }
        if (instance_exists(real_p2)) { real_p2.is_dead_phase2 = false; real_p2.image_alpha = 1; }
        scr_respawn(); exit;
    }
}

// ==========================================
// TARGETING
// ==========================================
var target_left  = real_p1;
var target_right = real_p2;
if (instance_exists(real_p1)) {
    if (variable_instance_exists(real_p1, "is_dead_phase2") && real_p1.is_dead_phase2) target_left = real_p2;
}
if (instance_exists(real_p2)) {
    if (variable_instance_exists(real_p2, "is_dead_phase2") && real_p2.is_dead_phase2) target_right = real_p1;
}

if (phase == 1 || phase == 2) {
    if (!bottom_destroyed && instance_exists(target_left)) {
        var _p1_dead = (variable_instance_exists(target_left, "is_dead_phase2") && target_left.is_dead_phase2);
        if (!_p1_dead) {
            var ta = point_direction(l_turret_x, turret_base_y, target_left.x, target_left.y);
            top_angle = clamp(ta, 200, 340);
        }
    }
    if (!top_destroyed && instance_exists(target_right)) {
        var _p2_dead = (variable_instance_exists(target_right, "is_dead_phase2") && target_right.is_dead_phase2);
        if (!_p2_dead) {
            var ba = point_direction(r_turret_x, turret_base_y, target_right.x, target_right.y);
            bottom_angle = clamp(ba, 200, 340);
        }
    }
}

// ===================================================================
// SIKLUS SERANGAN FASE 3
// ===================================================================
if (phase == 3) {
    shoot_timer--;
    if (fase3_timer > 0) fase3_timer--;

    // CORE OVERLOAD
    if (!overload_active && core_main_hp <= 15 && core_main_hp > 0) {
        overload_active  = true;
        overload_phase   = 0;
        overload_timer   = 80;
        cam_shake_amount = max(cam_shake_amount, 14); 
        with (obj_laser_fase3) { instance_destroy(); }
        with (obj_snowball_1)  { instance_destroy(); }
        laser_already_spawned = false;
    }

    if (overload_active) {
        overload_timer--;
        if (overload_phase == 0) {
            x = lerp(x, xstart, 0.1);
            y = lerp(y, ystart, 0.1);
            if (overload_timer <= 0) {
                overload_phase      = 1;
                overload_timer      = 300;
                overload_ring_count = 0;
                overload_ring_timer = 0;
                flash_alpha         = 1.0;
                cam_shake_amount    = max(cam_shake_amount, 18);
            }
        }
        else if (overload_phase == 1) {
            overload_ring_timer--;
            x = xstart + irandom_range(-3, 3);
            y = ystart + irandom_range(-2, 2);
            cam_shake_amount = max(cam_shake_amount, 5); 

            if (overload_ring_timer <= 0 && overload_ring_count < 4) {
                overload_ring_timer = 45;
                overload_ring_count++;
                flash_alpha         = 0.6;
                cam_shake_amount    = max(cam_shake_amount, 12); 

                var ring_peluru = 16;
                var gap_start   = 245;
                var gap_end     = 295;
                for (var _ri = 0; _ri < ring_peluru; _ri++) {
                    var _rang = (_ri / ring_peluru) * 360;
                    if (_rang >= gap_start && _rang <= gap_end) continue;
                    var _rb = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                    if (_rb != noone) {
                        var _rspd = 2.5 + (overload_ring_count * 0.4);
                        _rb.hsp          = lengthdir_x(_rspd, _rang);
                        _rb.vsp          = lengthdir_y(_rspd, _rang);
                        _rb.bullet_type  = "phase3_chaos";
                        _rb.lifetime     = 300;
                        _rb.use_gravity  = false;
                        _rb.proj_color_r = 255;
                        _rb.proj_color_g = overload_ring_count * 40;
                        _rb.proj_color_b = 0;
                        _rb.depth        = id.depth - 10;
                    }
                }
            }
            if (overload_ring_count >= 4 && overload_timer <= 0) core_main_hp = 0;
        }
    }

    if (!overload_active) {
        // SERANGAN 1: Chaos Circle
        if (fase3_mode == 1) {
            if (shoot_timer <= 0) {
                sweep_angle += (7 * sweep_direction);
                if (sweep_angle >= 360) { sweep_angle = 360; sweep_direction = -1; }
                if (sweep_angle <= 180) { sweep_angle = 180; sweep_direction =  1; }

                var b_snow = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                if (b_snow != noone) {
                    b_snow.hsp         = lengthdir_x(random_range(3.0, 5.5) * enrage_speed_mult, sweep_angle);
                    b_snow.vsp         = lengthdir_y(random_range(3.0, 5.5) * enrage_speed_mult, sweep_angle);
                    b_snow.bullet_type = "phase3_chaos";
                    b_snow.lifetime    = 300;
                    b_snow.use_gravity = false;
                    b_snow.depth       = id.depth - 10;
                    b_snow.image_xscale = 1.0;
                    b_snow.image_yscale = 1.0;
                }
                shoot_timer = is_enraged ? 2 : 4;
            }
            if (fase3_timer <= 0) {
                fase3_mode = 2; fase3_timer = 200; shoot_timer = 0;
            }
        }

        // SERANGAN 2: Laser Sweep
        else if (fase3_mode == 2) {
            if (!laser_already_spawned) {
                var laser_inst = instance_create_layer(bx, by + 45, "Instances_1", obj_laser_fase3);
                if (laser_inst != noone) {
                    var avg_player_x = room_width / 2;
                    var p_count = 0;
                    with (obj_player) {
                        if (variable_instance_exists(id, "is_dead_phase2") && !is_dead_phase2) {
                            avg_player_x += x; p_count++;
                        }
                    }
                    if (p_count > 0) avg_player_x = avg_player_x / p_count;

                    if (avg_player_x > bx) {
                        laser_inst.laser_angle       = 325;
                        laser_inst.sweep_dir         = -1;
                        laser_inst.target_stop_angle = 215;
                    } else {
                        laser_inst.laser_angle       = 215;
                        laser_inst.sweep_dir         = 1;
                        laser_inst.target_stop_angle = 325;
                    }
                    laser_inst.depth = id.depth - 10;
                }
                laser_already_spawned = true;
            }
            shoot_timer = 30;
            if (fase3_timer <= 0) {
                fase3_mode = 3; fase3_timer = 180; shoot_timer = 0;
                laser_already_spawned = false;
            }
        }

        // SERANGAN 3: Fan Rhythm
        else if (fase3_mode == 3) {
            if (shoot_timer <= 0) {
                var fan_spread = 25;
                var base_angle = 270 + rhythm_angle_offset;
                for (var i = 0; i < 4; i++) {
                    var shot_angle = base_angle - (3 * fan_spread / 2) + (i * fan_spread);
                    var b_fan = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                    if (b_fan != noone) {
                        b_fan.bullet_type  = "phase3_chaos";
                        b_fan.use_gravity  = false;
                        b_fan.hsp          = lengthdir_x(3.8 * enrage_speed_mult, shot_angle);
                        b_fan.vsp          = lengthdir_y(3.8 * enrage_speed_mult, shot_angle);
                        b_fan.lifetime     = 180;
                        b_fan.depth        = id.depth - 10;
                        b_fan.image_xscale = 1.0;
                        b_fan.image_yscale = 1.0;
                    }
                }
                rhythm_angle_offset += (15 * rhythm_dir);
                if (abs(rhythm_angle_offset) >= 30) rhythm_dir = -rhythm_dir;
                shoot_timer = is_enraged ? 7 : 12;
            }
            if (fase3_timer <= 0) {
                fase3_mode  = 5;
                fase3_timer = 300;
                shoot_timer = 0;
                if (!variable_instance_exists(id, "spiral_wave_dir"))   spiral_wave_dir   = 1;
                if (!variable_instance_exists(id, "spiral_speed_wave")) spiral_speed_wave = 1.0;
            }
        }

        // SERANGAN 5: Spiral Hell (FIX TRANSISI ANTI-STUCK)
        else if (fase3_mode == 5) {
            if (shoot_timer <= 0) {
                var dynamic_gap_center = 270 + (sin(fase3_timer * 0.05) * 45);
                var gap_min = dynamic_gap_center - 20;
                var gap_max = dynamic_gap_center + 20;

                for (var arm = 0; arm < spiral_arms; arm++) {
                    var arm_angle    = spiral_angle + (360 / spiral_arms * arm);
                    var normalized_ang = arm_angle mod 360;
                    if (normalized_ang < 0) normalized_ang += 360;
                    if (normalized_ang >= gap_min && normalized_ang <= gap_max) continue;
                    if (normalized_ang >= 160 && normalized_ang <= 380) {
                        var b_spiral = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                        if (b_spiral != noone) {
                            var spd        = (is_enraged ? 4.5 : 3.3) * random_range(0.9, 1.1);
                            b_spiral.hsp         = lengthdir_x(spd, arm_angle);
                            b_spiral.vsp         = lengthdir_y(spd, arm_angle);
                            b_spiral.bullet_type = "phase3_chaos";
                            b_spiral.lifetime    = 240;
                            b_spiral.use_gravity = false;
                            b_spiral.depth       = id.depth - 10;
                            b_spiral.image_xscale = 1.0;
                            b_spiral.image_yscale = 1.0;
                        }
                    }
                }

                if (variable_instance_exists(id, "spiral_speed_wave")) {
                    spiral_speed_wave = (sin(fase3_timer * 0.08) * 2.5) + 4.0;
                }
                if (fase3_timer == 150 && variable_instance_exists(id, "spiral_wave_dir")) {
                    spiral_wave_dir  = -spiral_wave_dir;
                    flash_alpha      = 0.4;
                    cam_shake_amount = max(cam_shake_amount, 10); 
                }

                var _wdir = 1;
                if (variable_instance_exists(id, "spiral_wave_dir")) {
                    _wdir = spiral_wave_dir;
                }
                var _wspd = variable_instance_exists(id, "spiral_speed_wave") ? spiral_speed_wave : spiral_speed;

                spiral_angle += (_wspd * _wdir) * (is_enraged ? 1.4 : 1.0);
                if (spiral_angle >= 360) spiral_angle -= 360;
                if (spiral_angle < 0)   spiral_angle += 360;

                shoot_timer = is_enraged ? 3 : 5;
            }
            if (fase3_timer <= 0) {
                fase3_mode = 4; fase3_timer = 400; shoot_timer = 0;
            }
        }

        // MODE 4: GIGA ROCKET OVERHEAT
        else if (fase3_mode == 4) {
            if (fase3_timer > 40) {
                x = xstart + irandom_range(-5, 5);
                y = ystart + irandom_range(-3, 3);
                cam_shake_amount = max(cam_shake_amount, 5);

                if (fase3_timer == 395) {
                    warning_timer  = 45;
                    warning_x      = bx;
                    warning_active = true;
                }
                if (warning_active) {
                    warning_timer--;
                    if (warning_timer <= 0) warning_active = false;
                }

                var giga_exist = false;
                with (obj_rocket_1) {
                    if (bullet_type == "giga_overheat" || bullet_type == "giga_reflected") giga_exist = true;
                }

                if (!giga_exist && !warning_active) {
                    var giga_rocket = instance_create_layer(bx, by + 45, "Instances_1", obj_rocket_1);
                    if (giga_rocket != noone) {
                        giga_rocket.bullet_type   = "giga_overheat";
                        giga_rocket.hsp           = 0;
                        giga_rocket.vsp           = 1.8;
                        giga_rocket.image_xscale  = 4.0;
                        giga_rocket.image_yscale  = 4.0;
                        giga_rocket.image_blend   = c_orange;
                        giga_rocket.depth         = id.depth - 10;
                        cam_shake_amount = max(cam_shake_amount, 8); 
                    }
                }
            }
            if (fase3_timer <= 0) {
                fase3_mode     = 1;
                fase3_timer    = 240;
                shoot_timer    = 45;
                warning_active = false;
            }
        }
    }
}

// ===================================================================
// SERANGAN FASE 1 & FASE 2
// ===================================================================
if (phase == 1 || phase == 2) {
    if (transisi_timer > 0) {
        transisi_timer--;
        x += irandom_range(-6, 6);
        y += irandom_range(-3, 3);
        cam_shake_amount = max(cam_shake_amount, 9); 
        if (hp > 6) hp = max(6, hp - (3.0 / 180.0));
        if (transisi_timer <= 0) {
            x = xstart; y = ystart;
            phase       = 2;
            shoot_timer = 60;
            cam_shake_amount = max(cam_shake_amount, 16); 

            if (!instance_exists(obj_laser_fase3)) {
                var laser_l = instance_create_layer(l_turret_x, turret_base_y, "Instances_1", obj_laser_fase3);
                if (laser_l != noone) {
                    laser_l.laser_angle = 270;
                    laser_l.sweep_dir   = 0;
                    laser_l.depth       = id.depth - 10;
                }
                var laser_r = instance_create_layer(r_turret_x, turret_base_y, "Instances_1", obj_laser_fase3);
                if (laser_r != noone) {
                    laser_r.laser_angle = 270;
                    laser_r.sweep_dir   = 0;
                    laser_r.depth       = id.depth - 10;
                }
            }
        }
    } else {
        shoot_timer--;
        if (crossfire_cooldown > 0) crossfire_cooldown--;
        mortar_timer--;

        if (shoot_timer <= 0) {
            shoot_timer = 60;
            crossfire_counter++;

            var do_crossfire = (phase == 2
                && crossfire_counter >= 3
                && crossfire_cooldown <= 0
                && instance_exists(real_p1) && instance_exists(real_p2)
                && !bottom_destroyed && !top_destroyed);

            if (do_crossfire) {
                crossfire_counter = 0;
                crossfire_cooldown = 180;
                cam_shake_amount = max(cam_shake_amount, 7);
                var mid_x = (real_p1.x + real_p2.x) / 2;
                var mid_y = (real_p1.y + real_p2.y) / 2;
                var cf_angle_l = clamp(point_direction(l_turret_x, turret_base_y, mid_x, mid_y), 200, 340);
                for (var ci = -1; ci <= 1; ci++) {
                    var cf_b = instance_create_layer(
                        l_turret_x + lengthdir_x(90, cf_angle_l),
                         turret_base_y + lengthdir_y(90, cf_angle_l),
                        "Instances_1", obj_snowball_1);
                    if (cf_b != noone) {
                        cf_b.hsp          = lengthdir_x(4.5, cf_angle_l + (ci * 8));
                        cf_b.vsp          = lengthdir_y(4.5, cf_angle_l + (ci * 8));
                        cf_b.bullet_type  = "crossfire";
                        cf_b.lifetime     = 320;
                        cf_b.use_gravity  = false;
                        cf_b.proj_color_r = 255;
                        cf_b.proj_color_g = 80;
                        cf_b.proj_color_b = 255;
                    }
                }
                var cf_angle_r = clamp(point_direction(r_turret_x, turret_base_y, mid_x, mid_y), 200, 340);
                for (var ci = -1; ci <= 1; ci++) {
                    var cf_b = instance_create_layer(
                        r_turret_x + lengthdir_x(90, cf_angle_r),
                        turret_base_y + lengthdir_y(90, cf_angle_r),
                        "Instances_1", obj_snowball_1);
                    if (cf_b != noone) {
                        cf_b.hsp          = lengthdir_x(4.5, cf_angle_r + (ci * 8));
                        cf_b.vsp          = lengthdir_y(4.5, cf_angle_r + (ci * 8));
                        cf_b.bullet_type  = "crossfire";
                        cf_b.lifetime     = 320;
                        cf_b.use_gravity  = false;
                        cf_b.proj_color_r = 255;
                        cf_b.proj_color_g = 80;
                        cf_b.proj_color_b = 255;
                    }
                }
                hit_flash = 6;
            } else {
                if (!bottom_destroyed) {
                    var b_top = instance_create_layer(
                        l_turret_x + lengthdir_x(90, top_angle),
                        turret_base_y + lengthdir_y(90, top_angle),
                        "Instances_1", obj_snowball_1);
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
                        "Instances_1", obj_snowball_1);
                    if (b_bottom != noone) {
                        b_bottom.hsp         = lengthdir_x(3.5, bottom_angle);
                        b_bottom.vsp         = lengthdir_y(3.5, bottom_angle);
                        b_bottom.bullet_type = "phase1";
                        b_bottom.lifetime    = 320;
                        b_bottom.use_gravity = false;
                    }
                }

                if (phase == 2) {
                    if (irandom(100) < 35) {
                        if (!bottom_destroyed) {
                            var r_top = instance_create_layer(
                                l_turret_x + lengthdir_x(90, top_angle),
                                turret_base_y + lengthdir_y(90, top_angle),
                                "Instances_1", obj_rocket_1);
                            if (r_top != noone) {
                                r_top.dir_angle = top_angle;
                                r_top.hsp       = lengthdir_x(7.5, top_angle);
                                r_top.vsp       = lengthdir_y(7.5, top_angle);
                            }
                        }
                        if (!top_destroyed) {
                            var r_bottom = instance_create_layer(
                                r_turret_x + lengthdir_x(90, bottom_angle),
                                turret_base_y + lengthdir_y(90, bottom_angle),
                                "Instances_1", obj_rocket_1);
                            if (r_bottom != noone) {
                                r_bottom.dir_angle = bottom_angle;
                                r_bottom.hsp       = lengthdir_x(7.5, bottom_angle);
                                r_bottom.vsp       = lengthdir_y(7.5, bottom_angle);
                            }
                        }
                    }
                    if (mortar_timer <= 0) {
                        mortar_timer  = 180;
                        scatter_state = 1;
                        scatter_hold_timer = 50;
                        for (var _si = 0; _si < 8; _si++) {
                            var _sang = (_si / 8) * 360;
                            if (_sang < 160 || _sang > 380) continue;
                            var _sb = instance_create_layer(bx, by, "Instances_1", obj_snowball_1);
                            if (_sb != noone) {
                                _sb.hsp          = lengthdir_x(3.5, _sang);
                                _sb.vsp          = lengthdir_y(3.5, _sang);
                                _sb.lifetime     = 200;
                                _sb.use_gravity  = false;
                                _sb.proj_color_r = 255;
                                _sb.proj_color_g = 150;
                                _sb.proj_color_b = 0;
                                _sb.bullet_type  = "phase3_split_ready";
                                _sb.split_timer  = 50;
                            }
                        }
                    }
                }
            }
        }
    }
}

if (cam_shake_amount > 0.5) {
    cam_shake_amount *= cam_shake_decay;
}