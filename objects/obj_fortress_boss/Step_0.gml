/// @description Logika Utama, Pergerakan & Update Layer Embusan Fase 3 (FIX PRESISI TOTAL)

// ⚡ PAKSA RESET RESOLUSI DI SETIAP FRAME
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

// ⚡ JIKA BOSS SUDAH MATI TOTAL (FAKE DESTROY)
if (variable_instance_exists(id, "boss_fully_dead") && boss_fully_dead) {
    exit; 
}

// ===================================================================
// ⚡ PROSES KEMATIAN BOSS
// ===================================================================
var bos_kalah = false;
if (variable_instance_exists(id, "core_main_hp") && core_main_hp <= 0) {
    bos_kalah = true;
}

if (bos_kalah) {
    with (obj_laser) { active = false; } 
    with (obj_laser_h) { active = false; }
    with (obj_laser_fase3) { instance_destroy(); } 
    with (obj_snowball_1) { instance_destroy(); } 
    with (obj_rocket_1) { instance_destroy(); }
    
    if (death_timer == -1) { 
        death_timer = 180; 
        var key_inst = instance_create_layer(x, y + 40, "Instances_1", obj_key); 
        if (key_inst != noone) {
            key_inst.is_dropped = true; 
            key_inst.vsp = -3; 
        }
    }
    
    death_timer--; 
    camera_set_view_pos(view_camera[0], camera_get_view_x(view_camera[0]) + irandom_range(-4, 4), camera_get_view_y(view_camera[0]) + irandom_range(-4, 4));
    
    if (death_timer <= 0) {
        var final_back_id = layer_background_get_id("Background");
        if (final_back_id != -1) {
            layer_background_blend(final_back_id, make_color_rgb(40, 30, 60));
        }
        boss_fully_dead = true; 
    }
    exit; 
}

// ==========================================
// 1. TIMER, ANIMASI & KALIBRASI KOORDINAT JUMBO
// ==========================================
pulse_time += 0.05;
bob_time   += (transisi_timer > 0) ? 0.25 : 0.03;

if (hit_flash > 0) hit_flash--; 
if (phase2_flash_alpha > 0) phase2_flash_alpha = max(0, phase2_flash_alpha - 0.2);

var bob = sin(bob_time) * 5;
var bx = x;
var by = y + bob;

// Amankan variabel koordinat laras meriam berputar
l_turret_x = bx - 185; 
r_turret_x = bx + 185; 
turret_base_y = by + 20; 

// ==========================================
// 2. BACKGROUND & PETIR TRANSISI
// ==========================================
if (phase == 1) { bg_target_sky_r = 135; bg_target_sky_g = 206; bg_target_sky_b = 250; }
else if (phase == 2) { bg_target_sky_r = 255; bg_target_sky_g = 100; bg_target_sky_b = 30; }
else { bg_target_sky_r = 40; bg_target_sky_g = 30; bg_target_sky_b = 60; } 

bg_sky_r = lerp(bg_sky_r, bg_target_sky_r, bg_lerp_speed);
bg_sky_g = lerp(bg_sky_g, bg_target_sky_g, bg_lerp_speed);
bg_sky_b = lerp(bg_sky_b, bg_target_sky_b, bg_lerp_speed);

var back_id = layer_background_get_id("Background");
if (back_id != -1) layer_background_blend(back_id, make_color_rgb(round(bg_sky_r), round(bg_sky_g), round(bg_sky_b)));

if (phase == 3) {
    lightning_timer--;
    if (lightning_timer <= 0) { lightning_active = true; flash_alpha = 1.0; lightning_timer = irandom_range(60, 180); }
}
if (flash_alpha > 0) flash_alpha -= 0.08;

// ==========================================
// 3. RESPOND RESPAWN SYSTEM CO-OP
// ==========================================
if (phase == 2 || phase == 3) {
    if (p1_respawn_timer > 0) {
        p1_respawn_timer--;
        if (p1_respawn_timer <= 0) {
            if (instance_exists(real_p1)) {
                real_p1.x = real_p1.spawn_x; real_p1.y = real_p1.spawn_y;
                real_p1.vsp = 0; real_p1.hsp = 0; real_p1.is_hanging = false;
                real_p1.is_dead_phase2 = false; real_p1.image_alpha = 0.5;
            }
            p1_respawn_timer = -1;
        }
    }
    if (p2_respawn_timer > 0) {
        p2_respawn_timer--;
        if (p2_respawn_timer <= 0) {
            if (instance_exists(real_p2)) {
                real_p2.x = real_p2.spawn_x; real_p2.y = real_p2.spawn_y;
                real_p2.vsp = 0; real_p2.hsp = 0; real_p2.is_hanging = false;
                real_p2.is_dead_phase2 = false; real_p2.image_alpha = 0.5;
            }
            p2_respawn_timer = -1;
        }
    }
    if (p1_respawn_timer > 0 && p2_respawn_timer > 0) {
        phase = 1; phase1_timer = 0; transisi_timer = -1; hp = max_hp; shoot_timer = 60;
        p1_respawn_timer = -1; p2_respawn_timer = -1;
        top_destroyed = false; bottom_destroyed = false;
        core_top_hp = 5; core_bottom_hp = 5; core_main_hp = 100;
        with (obj_laser) { active = false; } with (obj_laser_h) { active = false; }
        if (instance_exists(real_p1)) { real_p1.is_dead_phase2 = false; real_p1.image_alpha = 1; }
        if (instance_exists(real_p2)) { real_p2.is_dead_phase2 = false; real_p2.image_alpha = 1; }
        scr_respawn();
        with(obj_snowball_1) { instance_destroy(); }
        with(obj_rocket_1)   { instance_destroy(); }
        exit;
    }
}

// ==========================================
// 4. LOGIKA LOCK TARGET & SINKRONISASI TARGETING TURRET
// ==========================================
var target_left = real_p1; 
var target_right = real_p2;

if (instance_exists(real_p1)) {
    if (variable_instance_exists(real_p1, "is_dead_phase2") && real_p1.is_dead_phase2) target_left = real_p2;
}
if (instance_exists(real_p2)) {
    if (variable_instance_exists(real_p2, "is_dead_phase2") && real_p2.is_dead_phase2) target_right = real_p1;
}

// Sisi kiri mendeteksi bottom_destroyed, sisi kanan mendeteksi top_destroyed
if (!bottom_destroyed && instance_exists(target_left)) {
    var left_ok = true;
    if (variable_instance_exists(target_left, "is_dead_phase2") && target_left.is_dead_phase2) left_ok = false;
    if (left_ok) {
        var ta = point_direction(l_turret_x, turret_base_y, target_left.x, target_left.y);
        top_angle = clamp(ta, 200, 340); 
    }
}
if (!top_destroyed && instance_exists(target_right)) {
    var right_ok = true;
    if (variable_instance_exists(target_right, "is_dead_phase2") && target_right.is_dead_phase2) right_ok = false;
    if (right_ok) {
        var ba = point_direction(r_turret_x, turret_base_y, target_right.x, target_right.y);
        bottom_angle = clamp(ba, 200, 340); 
    }
}

// ==========================================
// 5. MANAGEMENT SERANGAN FASE 3
// ==========================================
if (phase == 3) {
    if (!variable_instance_exists(id, "fase3_mode"))      fase3_mode = 1; 
    if (!variable_instance_exists(id, "fase3_timer"))     fase3_timer = 240; 
    if (!variable_instance_exists(id, "sweep_angle"))     sweep_angle = 180;
    if (!variable_instance_exists(id, "sweep_direction")) sweep_direction = 1;
    if (!variable_instance_exists(id, "survival_timer"))  survival_timer = 30 * room_speed;

    if (fase3_mode != 4 && survival_timer > 0) survival_timer--;
    if (fase3_timer > 0) fase3_timer--;
}

// ==========================================
// 6. LOGIKA EMBUSAN PELURU AKURAT 100%
// ==========================================
if (hp > 0 || phase == 3) {
    if (transisi_timer > 0) {
        transisi_timer--; x += irandom_range(-6, 6); y += irandom_range(-3, 3);
        if (hp > 6) hp = max(6, hp - (3 / 180));
        if (transisi_timer <= 0) {
            x = xstart; y = ystart; phase = 2; shoot_timer = 60;
            p1_respawn_timer = -1; p2_respawn_timer = -1;
            with (obj_laser) { active = true; } with (obj_laser_h) { active = true; }
        }
    } else {
        shoot_timer--;
        if (shoot_timer <= 0) {
            if (phase == 1 || phase == 2) {
                shoot_timer = 60;
                
                // PELURU KELUAR TEPAT DARI MONCONG MERIAM KIRI JUMBO
                if (!bottom_destroyed) {
                    var spawn_l_x = l_turret_x + lengthdir_x(90, top_angle); 
                    var spawn_l_y = turret_base_y + lengthdir_y(90, top_angle);
                    var b_top = instance_create_layer(spawn_l_x, spawn_l_y, "Instances_1", obj_snowball_1);
                    b_top.hsp = lengthdir_x(3.5, top_angle); b_top.vsp = lengthdir_y(3.5, top_angle);
                    b_top.bullet_type = "phase1"; b_top.lifetime = 320; b_top.use_gravity = false;
                }
                
                // PELURU KELUAR TEPAT DARI MONCONG MERIAM KANAN JUMBO
                if (!top_destroyed) {
                    var spawn_r_x = r_turret_x + lengthdir_x(90, bottom_angle); 
                    var spawn_r_y = turret_base_y + lengthdir_y(90, bottom_angle);
                    var b_bottom = instance_create_layer(spawn_r_x, spawn_r_y, "Instances_1", obj_snowball_1);
                    b_bottom.hsp = lengthdir_x(3.5, bottom_angle); b_bottom.vsp = lengthdir_y(3.5, bottom_angle);
                    b_bottom.bullet_type = "phase1"; b_bottom.lifetime = 320; b_bottom.use_gravity = false;
                }
                
                // SPARK ROKET FASE 2 TEPAT DI MONCONG
                if (phase == 2 && irandom(100) < 35) {
                    if (!bottom_destroyed) {
                        var spawn_l_x = l_turret_x + lengthdir_x(90, top_angle); var spawn_l_y = turret_base_y + lengthdir_y(90, top_angle);
                        var r_top = instance_create_layer(spawn_l_x, spawn_l_y, "Instances_1", obj_rocket_1);
                        r_top.dir_angle = top_angle; r_top.hsp = lengthdir_x(7.5, top_angle); r_top.vsp = lengthdir_y(7.5, top_angle);
                    }
                    if (!top_destroyed) {
                        var spawn_r_x = r_turret_x + lengthdir_x(90, bottom_angle); var spawn_r_y = turret_base_y + lengthdir_y(90, bottom_angle);
                        var r_bottom = instance_create_layer(spawn_r_x, spawn_r_y, "Instances_1", obj_rocket_1);
                        r_bottom.dir_angle = bottom_angle; r_bottom.hsp = lengthdir_x(7.5, bottom_angle); r_bottom.vsp = lengthdir_y(7.5, bottom_angle);
                    }
                }
            }
        } 

        // ===================================================================
        // ⚡ MODIFIKASI FINAL FASE 3: KOORDINAT TURUN KE POROS TENAH (+45 PIKSEL)
        // ===================================================================
        if (phase == 3) {
            if (fase3_mode == 1) {
                with (obj_laser) { active = false; } with (obj_laser_h) { active = false; }
                if (shoot_timer <= 0) {
                    sweep_angle += (7 * sweep_direction);
                    if (sweep_angle >= 360) { sweep_angle = 360; sweep_direction = -1; }
                    if (sweep_angle <= 180) { sweep_angle = 180; sweep_direction = 1; }
                    
                    // Sumbu diturunkan ke +45 agar terkunci simetris di ulu hati lingkaran
                    var b_snow = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                    if (b_snow != noone) {
                        b_snow.hsp = lengthdir_x(random_range(3.0, 5.5), sweep_angle); 
                        b_snow.vsp = lengthdir_y(random_range(3.0, 5.5), sweep_angle);
                        b_snow.bullet_type = "phase3_chaos"; b_snow.lifetime = 300; b_snow.use_gravity = false;
                        b_snow.depth = id.depth - 5; 
                    }
                    shoot_timer = 4; 
                }
                if (fase3_timer <= 0) { 
                    fase3_mode = (survival_timer <= 0) ? 4 : 2;
                    fase3_timer = (fase3_mode == 4) ? 400 : 200; shoot_timer = 0; 
                }
            }
            else if (fase3_mode == 2) {
                if (!variable_instance_exists(id, "laser_already_spawned")) laser_already_spawned = false;
                if (!laser_already_spawned) {
                    
                    // 🌟 FIX MATEMATIKA ABSOLUT: Lahir tepat di sumbu tengah core (+45)
                    var laser_inst = instance_create_layer(bx, by + 45, "Instances_1", obj_laser_fase3);
                    if (laser_inst != noone) {
                        if (choose(0, 1) == 0) { laser_inst.laser_angle = 215; laser_inst.sweep_dir = 1; laser_inst.target_stop_angle = 270; } 
                        else { laser_inst.laser_angle = 325; laser_inst.sweep_dir = -1; laser_inst.target_stop_angle = 270; }
                        laser_inst.depth = id.depth - 5;
                    }
                    laser_already_spawned = true; 
                }
                shoot_timer = 30; 
                if (fase3_timer <= 0) { 
                    fase3_mode = (survival_timer <= 0) ? 4 : 3;
                    fase3_timer = (fase3_mode == 4) ? 400 : 180; shoot_timer = 0; laser_already_spawned = false; 
                }
            }
            else if (fase3_mode == 3) {
                if (!variable_instance_exists(id, "rhythm_angle_offset")) { rhythm_angle_offset = 0; rhythm_dir = 1; }
                if (shoot_timer <= 0) {
                    var fan_spread = 25; var base_angle = 270 + rhythm_angle_offset; 
                    for (var i = 0; i < 4; i++) {
                        var shot_angle = base_angle - (3 * fan_spread / 2) + (i * fan_spread);
                        
                        // Samakan koordinat sumbu Y ke +45
                        var b_snow = instance_create_layer(bx, by + 45, "Instances_1", obj_snowball_1);
                        if (b_snow != noone) {
                            b_snow.bullet_type = "phase3_chaos"; b_snow.use_gravity = false;
                            b_snow.hsp = lengthdir_x(3.8, shot_angle); b_snow.vsp = lengthdir_y(3.8, shot_angle); b_snow.lifetime = 180;
                            b_snow.depth = id.depth - 5;
                        }
                    }
                    rhythm_angle_offset += (15 * rhythm_dir);
                    if (abs(rhythm_angle_offset) >= 30) rhythm_dir = -rhythm_dir;
                    shoot_timer = 12; 
                }
                if (fase3_timer <= 0) { 
                    fase3_mode = (survival_timer <= 0) ? 4 : 1;
                    fase3_timer = (fase3_mode == 4) ? 400 : 240; shoot_timer = 0; laser_already_spawned = false;
                }
            }
            else if (fase3_mode == 4) {
                if (fase3_timer > 40) {
                    x = xstart + irandom_range(-3, 3); y = ystart + irandom_range(-2, 2);
                    var giga_exist = false;
                    with (obj_rocket_1) { if (bullet_type == "giga_overheat" || bullet_type == "giga_reflected") giga_exist = true; }
                    if (!giga_exist) {
                        
                        // Samakan koordinat sumbu Y ke +45
                        var giga_rocket = instance_create_layer(bx, by + 45, "Instances_1", obj_rocket_1);
                        if (giga_rocket != noone) {
                            giga_rocket.bullet_type = "giga_overheat"; giga_rocket.hsp = 0; giga_rocket.vsp = 3.2; 
                            giga_rocket.image_xscale = 4.0; giga_rocket.image_yscale = 4.0; giga_rocket.image_blend = c_orange; 
                            giga_rocket.depth = id.depth - 5;
                        }
                    }
                }
                if (fase3_timer <= 0) {
                    fase3_mode = 1; fase3_timer = 240; survival_timer = 30 * room_speed; shoot_timer = 45; laser_already_spawned = false;
                }
            }
        }
    }
}

// ==========================================
// 7. TIMEOUT TRANSISI FASE
// ==========================================
if (phase == 1 && phase1_timer++ >= phase1_timeout && transisi_timer == -1) transisi_timer = 180;
if (phase == 2 && top_destroyed && bottom_destroyed && jeda_fase3 == -1) jeda_fase3 = 180; 

if (jeda_fase3 > 0) {
    jeda_fase3--; x = xstart + irandom_range(-5, 5); y = ystart + irandom_range(-3, 3);
    if (jeda_fase3 <= 0) {
        x = xstart; y = ystart; phase = 3; core_main_hp = 100;
        with (obj_spike) { visible = true; } lightning_timer = 60; 
    }
}