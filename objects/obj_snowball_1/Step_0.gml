// ==========================================
// 0. INTERCEPT COOLDOWN
// ==========================================
if (intercept_timer > 0) {
    intercept_timer--;
}

// ==========================================
// COLLISION SEBELUM GERAK
// ==========================================

// Kalau masih milik boss (belum diintercept) → bisa kena player
if (!owned_by_player) {

    // --- OPSI 2: UMBRELLA REFLECT ---
    // Cek apakah snowball mengenai umbrella yang sedang dipegang player
    var hit_umb = instance_place(x, y, obj_umbrella);
    if (hit_umb != noone && hit_umb.holder != noone && intercept_timer <= 0) {
        var holder = hit_umb.holder;
        // Cek arah: umbrella harus menghadap ke arah datangnya snowball
        // (umbrella melindungi dari kanan jika player menghadap ke kanan, dst)
        // Kita sederhanakan: jika snowball datang dari atas (boss di atas), selalu reflect
        // karena umbrella di-hold di atas kepala player (offset_y = -25)
        owned_by_player = true;
        owner_id        = holder;
        intercept_timer = 20; // 20 frame cooldown

        // Balikkan arah ke boss
        var boss = instance_find(obj_fortress_boss, 0);
        if (boss != noone) {
            // Cari turret mana yang belum hancur untuk dijadikan target
            var target_x = boss.x;
            var target_y = boss.y;

            if (!boss.top_destroyed) {
                target_x = boss.top_turret_x;
                target_y = boss.turret_y;
            } else if (!boss.bottom_destroyed) {
                target_x = boss.bottom_turret_x;
                target_y = boss.turret_y;
            }

            var ang = point_direction(x, y, target_x, target_y);
            hsp = lengthdir_x(throw_speed, ang);
            vsp = lengthdir_y(throw_speed, ang);
            use_gravity = false; // Projectile lurus saat dilempar balik
        } else {
            // Kalau boss sudah tidak ada, hancurkan saja
            instance_destroy();
            exit;
        }
        // Ubah warna jadi biru untuk tanda sudah jadi milik player
        proj_color_r = 100;
        proj_color_g = 180;
        proj_color_b = 255;
        exit;
    }

    // --- OPSI 1: INTERCEPT AKTIF (player berlari ke snowball) ---
    // Cek apakah ada player yang menyentuh snowball ini
    if (intercept_timer <= 0) {
        var hit_player = instance_place(x, y, obj_player);
        if (hit_player != noone) {
            // Player bisa intercept hanya jika sedang jatuh / bergerak
            // (bukan diam di tanah — trade-off: harus berani dekat proyektil)
            owned_by_player = true;
            owner_id        = hit_player;
            intercept_timer = 20;

            // Lempar langsung ke boss / turret
            var boss = instance_find(obj_fortress_boss, 0);
            if (boss != noone) {
                var target_x = boss.x;
                var target_y = boss.y;

                if (!boss.top_destroyed) {
                    target_x = boss.top_turret_x;
                    target_y = boss.turret_y;
                } else if (!boss.bottom_destroyed) {
                    target_x = boss.bottom_turret_x;
                    target_y = boss.turret_y;
                }

                var ang = point_direction(x, y, target_x, target_y);
                hsp = lengthdir_x(throw_speed, ang);
                vsp = lengthdir_y(throw_speed, ang);
                use_gravity = false;
            } else {
                instance_destroy();
                exit;
            }

            proj_color_r = 100;
            proj_color_g = 180;
            proj_color_b = 255;
            exit;
        }

        // Kalau tidak kena umbrella & tidak diintercept → kena player = respawn
        if (collision_line(x, y, x + hsp, y + vsp, obj_player, false, true) != noone) {
            room_restart();
            exit;
        }
    }

} else {
    // ==========================================
    // SNOWBALL SUDAH MILIK PLAYER → CARI BOSS
    // ==========================================

    // Kalau kena turret/boss → damage
    var boss = instance_find(obj_fortress_boss, 0);
    if (boss != noone) {

        // --- Cek kena TURRET KANAN ---
        if (!boss.top_destroyed) {
            var dist_top = point_distance(x, y, boss.top_turret_x, boss.turret_y);
            if (dist_top < 50) {
                boss.core_top_hp--;
                boss.hit_flash = 10;
                audio_play_sound(sound_lompat, 1, false);

                if (boss.core_top_hp <= 0) {
                    boss.top_destroyed = true;
                    boss.hp -= 3;
                }
                instance_destroy();
                exit;
            }
        }

        // --- Cek kena TURRET KIRI ---
        if (!boss.bottom_destroyed) {
            var dist_bot = point_distance(x, y, boss.bottom_turret_x, boss.turret_y);
            if (dist_bot < 50) {
                boss.core_bottom_hp--;
                boss.hit_flash = 10;
                audio_play_sound(sound_lompat, 1, false);

                if (boss.core_bottom_hp <= 0) {
                    boss.bottom_destroyed = true;
                    boss.hp -= 3;
                }
                instance_destroy();
                exit;
            }
        }

        // --- Cek kena INTI UTAMA (setelah dua turret hancur) ---
        if (boss.top_destroyed && boss.bottom_destroyed) {
            var dist_core = point_distance(x, y, boss.x, boss.y);
            if (dist_core < 60) {
                boss.core_main_hp--;
                boss.hit_flash = 15;
                audio_play_sound(sound_lompat, 1, false);

                if (boss.core_main_hp <= 0) {
                    boss.hp = 0;
                }
                instance_destroy();
                exit;
            }
        }
    }

    // Snowball reflected tidak boleh kena player sendiri selama cooldown
    if (intercept_timer <= 0) {
        if (collision_line(x, y, x + hsp, y + vsp, obj_player, false, true) != noone) {
            // Jika tidak kena boss tapi kena player, hancurkan saja (jangan restart)
            instance_destroy();
            exit;
        }
    }
}

// ==========================================
// COLLISION DENGAN GROUND & WALL (berlaku untuk semua)
// ==========================================
if (collision_line(x, y, x + hsp, y + vsp, obj_ground, false, true) != noone) {
    instance_destroy();
    exit;
}

if (collision_line(x, y, x + hsp, y + vsp, obj_wall, false, true) != noone) {
    instance_destroy();
    exit;
}

// ==========================================
// MOVEMENT
// ==========================================
if (use_gravity) {
    vsp += grv;
}

x += hsp;
y += vsp;

// ==========================================
// ROTATION EFFECT
// ==========================================
proj_angle += 8;

// ==========================================
// SPREAD EFFECT
// ==========================================
if (spread_timer < 30) {
    spread_timer++;
    spread_amount = (spread_timer / 30) * max_spread_distance;

    if (max_spread_distance > 0) {
        var spread_direction = (id mod 3) - 1;
        var spread_force = sin(spread_timer / 30 * pi) * 2;
        hsp += spread_force * spread_direction;
    }
}

// ==========================================
// LIFETIME
// ==========================================
lifetime--;
life = lifetime;

if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// ==========================================
// OUT OF BOUNDS
// ==========================================
if (y > room_height + 50 || x < -50 || x > room_width + 50 || y < -50) {
    instance_destroy();
}