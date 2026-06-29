/// @description Logika Utama Pergerakan & State Machine Roket 1

// ===================================================================
// VARIABEL PENGAMAN AWAL
// ===================================================================
if (!variable_instance_exists(id, "bullet_type")) {
    bullet_type = "normal";
}

// ===================================================================
// LOGIKA KHUSUS 1: DETEKSI PANTULAN ROKET OVERHEAT FASE 3 (PAYUNG PRESISI)
// ===================================================================
if (bullet_type == "giga_overheat") {
    
    var umbrella = instance_find(obj_umbrella, 0);
    var hit_by_umbrella = false;

    if (umbrella != noone && umbrella.holder != noone) {
        // 1. Cek horizontal: Koordinat X roket harus berada di dalam lebar fisik payung
        var inside_umbrella_x = (x >= umbrella.bbox_left && x <= umbrella.bbox_right);
        
        // 2. Cek vertikal: Jarak ujung bawah roket mendekati permukaan atas payung
        var inside_umbrella_y = (y >= umbrella.y - 35 && y <= umbrella.y + 15);
        
        if (inside_umbrella_x && inside_umbrella_y) {
            hit_by_umbrella = true;
        }
    }

    // Jika sukses terbentur payung secara presisi visual
    if (hit_by_umbrella) {
        var boss = instance_find(obj_fortress_boss, 0);
        if (boss != noone && boss.phase == 3 && boss.fase3_mode == 4) {
            
            status = -1; // Keluar dari status bawaan 0/1/2/3 agar tidak diganggu logic tanah
            bullet_type = "giga_reflected";
            image_blend = c_aqua; // Roket berubah warna jadi biru neon
            
            // FIX VISUAL: Paksa skala roket kembali normal 1:1 agar ukurannya tidak rusak saat membal
            image_xscale = 1.0;
            image_yscale = 1.0;
            
            // Balikkan arah roket tegak lurus ke atas menuju core perut bos
            var target_x = boss.x;
            var target_y = boss.y + 160;
            var ang = point_direction(x, y, target_x, target_y);
            
            if (variable_instance_exists(id, "dir_angle")) dir_angle = ang;
            
            // Efek Kinetik: Roket meluncur kilat ke atas!
            hsp = lengthdir_x(14.0, ang);
            vsp = lengthdir_y(14.0, ang);
            
            // Begitu terpukul sukses, paksa bos langsung menyudahi fase lemasnya
            boss.fase3_timer = 0;
            audio_play_sound(sound_key, 1, false); // Kasih SFX dentangan pantulan sukses
        }
    }
}

// ===================================================================
// LOGIKA KHUSUS 2: DETEKSI ROKET REFLECTED MENGENAI CORE PERUT BOS
// ===================================================================
if (bullet_type == "giga_reflected") {
    var boss = instance_find(obj_fortress_boss, 0);
    if (boss != noone) {
        var dist_core = point_distance(x, y, boss.x, boss.y + 160);
        if (dist_core < 95) {
            if (variable_instance_exists(boss, "core_main_hp")) {
                // PERBAIKAN: Dikurangi 25 HP agar membutuhkan total 4 hantaman roket baru bos kalah
                boss.core_main_hp -= 100; 
                boss.hit_flash = 25;
                audio_play_sound(sound_lompat, 1, false); // SFX hantaman keras balik
                
                // Efek Getar Ledakan Lebay pada bodi bos
                boss.x += irandom_range(-10, 10);
                boss.y += irandom_range(-10, 10);
            }
            
            instance_destroy();
            exit;
        }
    }
    
    // Update posisi pergerakan khusus roket reflected ke atas langit
    x += hsp;
    y += vsp;
    
    // Update asap trail saat membal ke atas
    if (variable_instance_exists(id, "trail_x") && variable_instance_exists(id, "trail_idx")) {
        trail_x[@ trail_idx] = x;
        trail_y[@ trail_idx] = y;
        trail_idx = (trail_idx + 1) mod 8;
    }
    
    if (y < -100) { instance_destroy(); exit; }
    exit;
}

// ==========================================
// STATUS 0: MELUNCUR JATUH DARI LANGIT
// ==========================================
if (status == 0) {
    x += hsp;
    y += vsp;

    if (place_meeting(x, y, obj_player)) {
        var player_hit = instance_place(x, y, obj_player);
        if (player_hit != noone) {
            var boss_inst = instance_find(obj_fortress_boss, 0);
            if (boss_inst != noone && boss_inst.phase == 2) {
                if (variable_instance_exists(player_hit, "is_dead_phase2") && !player_hit.is_dead_phase2) {
                    if (player_hit.p_id == 0) boss_inst.p1_respawn_timer = boss_inst.respawn_delay_time;
                    if (player_hit.p_id == 1) boss_inst.p2_respawn_timer = boss_inst.respawn_delay_time;
                    
                    player_hit.is_dead_phase2 = true;
                    player_hit.image_alpha = 0;
                }
            } else {
                if (boss_inst != noone && boss_inst.phase == 3) {
                    if (variable_instance_exists(player_hit, "is_dead_phase2") && !player_hit.is_dead_phase2) {
                        if (player_hit.p_id == 0) boss_inst.p1_respawn_timer = boss_inst.respawn_delay_time;
                        if (player_hit.p_id == 1) boss_inst.p2_respawn_timer = boss_inst.respawn_delay_time;
                        player_hit.is_dead_phase2 = true;
                        player_hit.image_alpha = 0;
                    }
                } else {
                    with(player_hit) { scr_respawn(); }
                }
            }
            instance_destroy();
            exit;
        }
    }

    if (place_meeting(x, y + vsp, obj_ground)) {
        while(!place_meeting(x, y + 1, obj_ground)) {
            y += 1;
        }
        status = 1; 
        hsp = 0; 
        vsp = 0;
    }
}

// ==========================================
// STATUS 1: DIAM DI TANAH MENUNGGU DIAMBIL PLAYER
// ==========================================
else if (status == 1) {
    if (place_meeting(x, y, obj_player)) {
        var player_near = instance_place(x, y, obj_player);
        if (player_near != noone && variable_instance_exists(player_near, "is_dead_phase2") && !player_near.is_dead_phase2) {
            
            var already_holding = false;
            with (obj_rocket_1) {
                if (status == 2 && carrier == player_near) {
                    already_holding = true;
                }
            }
            
            if (!already_holding) {
                status = 2;
                carrier = player_near;
            }
        }
    }
}

// ==========================================
// STATUS 2: DIBAWA DI ATAS KEPALA PEMAIN
// ==========================================
else if (status == 2) {
    if (instance_exists(carrier) && variable_instance_exists(carrier, "is_dead_phase2") && !carrier.is_dead_phase2) {
        x = carrier.x;
        y = carrier.y - 48; 

        var shoot_pressed = false;
        if (carrier.p_id == 0)      shoot_pressed = keyboard_check_pressed(vk_space);
        else if (carrier.p_id == 1) shoot_pressed = keyboard_check_pressed(vk_up);

        if (shoot_pressed) {
            status = 3;
            hsp = 0; vsp = -12; carrier = noone;
        }
    } else {
        instance_destroy();
        exit;
    }
}

// ===================================================================
// STATUS 3: MELESAT BALIK NYERANG TURRET BOS (FASE 2)
// ===================================================================
else if (status == 3) {
    y += vsp;
    var boss = instance_find(obj_fortress_boss, 0);
    if (boss != noone && boss.phase == 2) {
        
        var b_bob = sin(boss.bob_time) * 5;
        var b_bx = boss.x;
        var b_by = boss.y + b_bob;
        
        var mat_left_tx  = b_bx - 215; 
        var mat_right_tx = b_bx + 215; 
        var mat_turret_ty = b_by - 10; 
        
        var in_kiri  = (x >= mat_left_tx - 75  && x <= mat_left_tx + 75  && y >= mat_turret_ty - 55 && y <= mat_turret_ty + 55);
        var in_kanan = (x >= mat_right_tx - 75 && x <= mat_right_tx + 75 && y >= mat_turret_ty - 55 && y <= mat_turret_ty + 55);
        
        var can_damage_boss = (boss.hit_flash <= 0);

        // A. KALKULASI HITBOX TURET KANAN
        if (!boss.top_destroyed && in_kanan) {
            if (can_damage_boss) {
                boss.core_top_hp -= 1;
                boss.hit_flash = 20;
                audio_play_sound(sound_lompat, 1, false);
                if(boss.core_top_hp <= 0) boss.top_destroyed = true;
            }
            instance_destroy(); exit;
        }
        
        // B. KALKULASI HITBOX TURET KIRI
        if (!boss.bottom_destroyed && in_kiri) {
            if (can_damage_boss) {
                boss.core_bottom_hp -= 1;
                boss.hit_flash = 20;
                audio_play_sound(sound_lompat, 1, false);
                if(boss.core_bottom_hp <= 0) boss.bottom_destroyed = true;
            }
            instance_destroy(); exit;
        }

        // C. JIKA KEDUA TURET HANCUR -> SERANG BODI UTAMA TENGAH
        if (boss.top_destroyed && boss.bottom_destroyed) {
            var in_bodi_tengah = (x >= b_bx - 115 && x <= b_bx + 115 && y >= b_by - 100 && y <= b_by + 100);
            if (in_bodi_tengah) {
                if (can_damage_boss) {
                    boss.core_main_hp -= 1;
                    boss.hp -= 1; boss.hit_flash = 25;
                    audio_play_sound(sound_lompat, 1, false);
                    if (boss.core_main_hp <= 0) boss.hp = 0;
                }
                instance_destroy();
                exit;
            }
        }
    }

    if (y < -100) {
        instance_destroy();
        exit;
    }
}

// ==========================================
// UPDATE TRAIL ASAP & OUT OF BOUNDS
// ==========================================
if (variable_instance_exists(id, "trail_x") && variable_instance_exists(id, "trail_idx")) {
    trail_x[@ trail_idx] = x;
    trail_y[@ trail_idx] = y;
    trail_idx = (trail_idx + 1) mod 8;
}

if (status == 1) {
    if (variable_instance_exists(id, "life_timer")) {
        life_timer--;
        if (life_timer <= 0) { instance_destroy(); exit; }
    }
}

if (x < -100 || x > room_width + 100 || y > room_height + 100) {
    instance_destroy();
}