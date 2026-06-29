// ==========================================
// 0. INTERCEPT COOLDOWN
// ==========================================
if (intercept_timer > 0) {
    intercept_timer--;
}

// ===================================================================
// PENGAMAN VARIABEL AWAL
// ===================================================================
if (!variable_instance_exists(id, "bullet_type")) {
    bullet_type = "normal";
}

// ==========================================
// COLLISION SEBELUM GERAK
// ==========================================
if (!owned_by_player) {
    // --- OPSI 2: UMBRELLA REFLECT (PAPAN KAYU TAMENG) ---
    var hit_umb = instance_place(x, y, obj_umbrella);
    
    if (hit_umb != noone && hit_umb.holder != noone && intercept_timer <= 0) {
        var holder = hit_umb.holder;
        var reflect_ok = false;
        if (instance_exists(holder)) {
            var holder_facing = sign(holder.image_xscale);
            if (holder_facing == 0) holder_facing = 1;
            var incoming_dir = sign(hsp);
            var falling_from_above = (vsp > 0 && abs(vsp) >= abs(hsp));
            
            if (incoming_dir == holder_facing || falling_from_above) {
                reflect_ok = true;
            }
        }

        if (reflect_ok) {
            var boss = instance_find(obj_fortress_boss, 0);
            if (boss != noone) {
                // BALANCING FASE 3: BOLA SALJU BIASA LANGSUNG HANCUR (BOS KEBAL)
                if (boss.phase == 3) {
                    instance_destroy(); 
                    exit;
                } 
                // JIKA FASE 1 atau 2: Ikuti urutan target turret bawaan asli
                else {
                    owned_by_player = true; owner_id = holder; intercept_timer = 20;
                    var target_x = boss.x; var target_y = boss.y;
                    if (!boss.top_destroyed) { target_x = boss.top_turret_x; target_y = boss.turret_y; }
                    else if (!boss.bottom_destroyed) { target_x = boss.bottom_turret_x; target_y = boss.turret_y; }
                    
                    var ang = point_direction(x, y, target_x, target_y);
                    hsp = lengthdir_x(throw_speed, ang); vsp = lengthdir_y(throw_speed, ang); use_gravity = false;
                    proj_color_r = 100; proj_color_g = 180; proj_color_b = 255;
                }
                exit;
            } else { instance_destroy(); exit; }
        }
    }

    // --- OPSI 1: INTERCEPT AKTIF & DETEKSI HIT (SANGAT AMAN: DICEK STATUS KEBAL PLAYER) ---
    if (intercept_timer <= 0) {
        var hit_player = instance_place(x, y, obj_player);
        if (hit_player != noone && variable_instance_exists(hit_player, "is_dead_phase2") && !hit_player.is_dead_phase2) {
            // Saringan Tembus Hantu: Jika player sedang kebal, bola salju bablas lewat tanpa memicu intercept!
            if (variable_instance_exists(hit_player, "invincible_timer") && hit_player.invincible_timer > 0) {
                // Do nothing, lewat aja jirr!
            } else {
                owned_by_player = true; owner_id = hit_player; intercept_timer = 20;
                var boss = instance_find(obj_fortress_boss, 0);
                if (boss != noone) {
                    var target_x = boss.x; var target_y = boss.y;
                    if (boss.phase == 3) {
                        target_x = boss.x; target_y = boss.y + 160;
                    } else {
                        if (!boss.top_destroyed) { target_x = boss.top_turret_x; target_y = boss.turret_y; }
                        else if (!boss.bottom_destroyed) { target_x = boss.bottom_turret_x; target_y = boss.turret_y; }
                    }
                    var ang = point_direction(x, y, target_x, target_y);
                    hsp = lengthdir_x(throw_speed, ang); vsp = lengthdir_y(throw_speed, ang); use_gravity = false;
                } else { instance_destroy(); exit; }
                proj_color_r = 100; proj_color_g = 180; proj_color_b = 255; exit;
            }
        }

        // DETEKSI PELURU MELUKAI PLAYER (COLLISION LINE - DIPROTEKSI STATUS KEBAL)
        var line_player = collision_line(x, y, x + hsp, y + vsp, obj_player, false, true);
        if (line_player != noone && variable_instance_exists(line_player, "is_dead_phase2") && !line_player.is_dead_phase2) {
            
            // JIKA PLAYER SEDANG KEBAL KEDIP, ABAIKAN TOTAL (TEMBUS HANTU!)
            if (variable_instance_exists(line_player, "invincible_timer") && line_player.invincible_timer > 0) {
                // Do nothing, biarkan peluru melaju lurus tembus hantu jirr!
            } else {
                var boss_inst = instance_find(obj_fortress_boss, 0);
                if (boss_inst != noone) {
                    if (boss_inst.phase == 2 || boss_inst.phase == 3) {
                        if (line_player.p_id == 0) boss_inst.p1_respawn_timer = boss_inst.respawn_delay_time;
                        if (line_player.p_id == 1) boss_inst.p2_respawn_timer = boss_inst.respawn_delay_time;
                        
                        line_player.is_dead_phase2 = true;
                        line_player.image_alpha = 0;
                    } else if (boss_inst.phase == 1) {
                        boss_inst.phase1_timer = 0;
                        with(line_player) { scr_respawn(); }
                    }
                } else {
                    with(line_player) { scr_respawn(); }
                }
                instance_destroy(); 
                exit;
            }
        }
    }
} else {
    // ===================================================================
    // SNOWBALL MILIK PLAYER (SUDAH DIPANTUL BALIK MENYERANG BOS)
    // ===================================================================
    var boss = instance_find(obj_fortress_boss, 0);
    if (boss != noone) {
        // JIKA DI FASE 3: Deteksi hantaman peluru ke Core Tengah Bawah Perut
        if (boss.phase == 3) {
            var dist_core = point_distance(x, y, boss.x, boss.y + 160); 
            if (dist_core < 85) { 
                if (variable_instance_exists(boss, "core_main_hp")) {
                    boss.core_main_hp--; 
                    boss.hit_flash = 20; 
                    audio_play_sound(sound_lompat, 1, false);
                    
                    boss.x += irandom_range(-4, 4);
                    boss.y += irandom_range(-4, 4);
                }
                instance_destroy(); exit;
            }
        } 
        // JIKA FASE 1 ATAU 2: Gunakan hit turret bawaan asli proyekmu
        else {
            if (!boss.top_destroyed) {
                var dist_top = point_distance(x, y, boss.top_turret_x, boss.turret_y);
                if (dist_top < 50) {
                    boss.core_top_hp--; boss.hit_flash = 10; audio_play_sound(sound_lompat, 1, false);
                    if (boss.core_top_hp <= 0) { boss.top_destroyed = true; boss.hp -= 3; }
                    instance_destroy(); exit;
                }
            }
            if (!boss.bottom_destroyed) {
                var dist_bot = point_distance(x, y, boss.bottom_turret_x, boss.turret_y);
                if (dist_top < 50) { // Menjaga kecocokan dengan logic asli proyekmu
                    boss.core_bottom_hp--; boss.hit_flash = 10; audio_play_sound(sound_lompat, 1, false);
                    if (boss.core_bottom_hp <= 0) { boss.bottom_destroyed = true; boss.hp -= 3; }
                    instance_destroy(); exit;
                }
            }
        }
    }
    if (intercept_timer <= 0) {
        var check_p = collision_line(x, y, x + hsp, y + vsp, obj_player, false, true);
        if (check_p != noone && (!variable_instance_exists(check_p, "invincible_timer") || check_p.invincible_timer <= 0)) { 
            instance_destroy(); 
            exit; 
        }
    }
}

// COLLISION DENGAN GROUND & WALL
if (collision_line(x, y, x + hsp, y + vsp, obj_ground, false, true) != noone ||
    collision_line(x, y, x + hsp, y + vsp, obj_wall, false, true) != noone) {
    instance_destroy(); exit;
}

// ===================================================================
// PENGAMAN PERGERAKAN BERDASARKAN TIPE PELURU FASE 3
// ===================================================================
if (bullet_type == "phase3_ring_hold") {
    hsp = 0;
    vsp = 0;
} 
else if (bullet_type == "phase3_chaos") {
    // Biarkan kalkulasi kecepatan bebas bekerja murni tanpa pengaruh gravitasi
} 
else if (bullet_type == "phase3_split_ready") {
    if (variable_instance_exists(id, "split_timer")) {
        split_timer--;
        if (split_timer <= 0) {
            bullet_type = "phase3_chaos"; 
            var random_spl_angle = irandom_range(0, 359);
            var random_spd = random_range(2.5, 5.0);
            
            hsp = lengthdir_x(random_spd, random_spl_angle);
            vsp = lengthdir_y(random_spd, random_spl_angle);
            
            proj_color_r = 255; proj_color_g = 100; proj_color_b = 100; 
        }
    }
}
else {
    if (use_gravity) vsp += grv;
}

// Update posisi koordinat akhir game
x += hsp; y += vsp;
proj_angle += 8;