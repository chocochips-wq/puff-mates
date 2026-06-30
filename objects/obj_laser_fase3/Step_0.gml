// ==========================================
// STEP EVENT: obj_laser_fase3 (FIX PRESISI UTUHMU)
// ==========================================
laser_timer--;

var boss = instance_find(obj_fortress_boss, 0);
if (boss != noone) {
    // 🌟 SINKRONISASI CO-ORDINAT: Ikut membaca goyangan boss dan dikunci mati ke +45 piksel!
    var bob = sin(boss.bob_time) * 5;
    x = boss.x;
    y = boss.y + bob + 45; 
    
    // JIKA MASIH FASE PERINGATAN (90 frame pertama / 1.5 detik):
    // Laser DIAM di tempat asal (tidak bergerak dulu), lantai fokus berkedip merah!
    if (laser_timer > 120) {
        is_lethal = false;
        
        // Logika animasi berkedip merah transparan
        flash_alpha += flash_speed;
        if (flash_alpha >= 0.6 || flash_alpha <= 0.1) {
            flash_speed = -flash_speed; // Balikkan arah alpha biar kedip-kedip
        }
    } 
    // JIKA SUDAH MASUK FASE AKTIF (Mulai menyembur dan bergerak menyapu):
    else if (laser_timer <= 120 && laser_timer > 0) {
        is_lethal = true;

        // BUGFIX AUDIO: mainkan sound_laser tepat saat laser ini mulai aktif.
        // Guard dengan was_lethal + audio_is_playing supaya kalau ada 2
        // laser_fase3 sekaligus (turret kiri+kanan) suaranya tidak dobel.
        if (!was_lethal && !audio_is_playing(sound_laser)) {
            audio_play_sound(sound_laser, 8, false);
        }
        was_lethal = true;
        
        // Pergerakan menyapu yang lambat dan kalem
        if (sweep_dir == 1) {
            if (laser_angle < target_stop_angle) laser_angle += 0.5; 
            else laser_angle = target_stop_angle; 
        } 
        else if (sweep_dir == -1) {
            if (laser_angle > target_stop_angle) laser_angle -= 0.5; 
            else laser_angle = target_stop_angle; 
        }
        
        // Deteksi tabrakan mematikan dengan player
        var x_end = x + lengthdir_x(laser_length, laser_angle);
        var y_end = y + lengthdir_y(laser_length, laser_angle);
        
        var hit_player = collision_line(x, y, x_end, y_end, obj_player, false, true);
        if (hit_player != noone && variable_instance_exists(hit_player, "is_dead_phase2") && !hit_player.is_dead_phase2) {
            if (hit_player.p_id == 0) boss.p1_respawn_timer = boss.respawn_delay_time;
            if (hit_player.p_id == 1) boss.p2_respawn_timer = boss.respawn_delay_time;
            
            hit_player.is_dead_phase2 = true;
            hit_player.image_alpha = 0; 
        }
    }
} else {
    instance_destroy();
    exit;
}

if (laser_timer <= 0) {
    instance_destroy();
}