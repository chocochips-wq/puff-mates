// Defensive Checks: Pastikan variabel kustom selalu terdefinisi
if (!variable_instance_exists(id, "is_menu_door")) is_menu_door = false;
if (!variable_instance_exists(id, "is_locked")) is_locked = false;
if (!variable_instance_exists(id, "shake_timer")) shake_timer = 0;
if (!variable_instance_exists(id, "warning_timer")) warning_timer = 0;
if (!variable_instance_exists(id, "bubble_scale")) bubble_scale = 0.0;
if (!variable_instance_exists(id, "bubble_alpha")) bubble_alpha = 0.0;
if (!variable_instance_exists(id, "target_room")) target_room = noone;
if (!variable_instance_exists(id, "level_number_label")) level_number_label = "";

// =======================
// BUKA PINTU & UPDATE LOBBY
// =======================
if (is_menu_door) {
    // Tentukan status terkunci dinamis di lobby
    is_locked = (target_room == Room2 && global.max_unlocked_level < 2)
             || (target_room == Room3 && global.max_unlocked_level < 3)
             || (target_room == Room4 && global.max_unlocked_level < 4)
             || (target_room == Room5 && global.max_unlocked_level < 5);
             
    if (is_locked) {
        sprite_index = spr_door_closed;
        image_speed = 0;
        image_index = 0;
        opened = false;
        
        // Pemicu goyang gembok jika pemain menabrak pintu terkunci
        if (place_meeting(x, y, obj_player)) {
            if (shake_timer <= 0) {
                shake_timer = 15;
                warning_timer = 90; // Tampilkan peringatan "Selesaikan level sebelumnya"
            }
        }
    }
    
    if (shake_timer > 0) shake_timer--;
    if (warning_timer > 0) warning_timer--;
    
    // Hitung secara dinamis player yang menyentuh pintu di menu
    var touching_count = 0;
    with (obj_player) {
        if (place_meeting(x, y, other)) touching_count++;
    }
    players_entered = touching_count;
    
    // Pintu menu terbuka jika 2 player menyentuhnya secara bersamaan
    if (players_entered >= 2 && !opened && !is_locked) {
        opened = true;
        sprite_index = spr_door_open;
        image_index = 0;
        image_speed = 1;
    }
    
    // Deteksi jarak ke player terdekat untuk mengontrol speech bubble info
    var dist = 99999;
    var p_near = instance_nearest(x + sprite_width / 2, y + sprite_height / 2, obj_player);
    if (p_near != noone) {
        dist = distance_to_object(p_near);
    }
    
    // Sembunyikan bubble jika pintu sedang terbuka (animasi masuk)
    var target_scale = 0.0;
    if (!opened && dist < 65) {
        target_scale = 1.0;
    }
    
    bubble_alpha = lerp(bubble_alpha, target_scale, 0.15);
    bubble_scale = lerp(bubble_scale, target_scale, 0.18);
}

// Untuk level biasa, buka dengan kunci
if (!opened && !is_locked && !is_menu_door) {
    var p = instance_place(x, y, obj_player);

    if (p != noone) {
        var k = instance_find(obj_key, 0);

        if (k != noone && k.holder == p) {
            opened = true;
            instance_destroy(k);

            sprite_index = spr_door_open;
            image_index = 0;
            image_speed = 1;
        }
    }
}

// =======================
// ANIMASI PINTU SELESAI
// =======================
if (opened && !anim_done) {
    if (image_index >= image_number - 1) {
        anim_done = true;
        image_speed = 0;
    }
}

// =======================
// PLAYER MASUK KE PINTU
// =======================
if (opened && anim_done) {

// JIKA PINTU MENU LOBBY (Transisi layar langsung dimulai)
if (is_menu_door) {
    var mgr = instance_find(obj_menu_manager, 0);
    if (mgr != noone) {
        // Kirim posisi pintu sebagai titik asal circle wipe
        mgr.circle_origin_x = x + sprite_width / 2;
        mgr.circle_origin_y = y + sprite_height / 2;
        mgr.fade_target = 1.0;
        mgr.fade_room = target_room;
    } else {
        room_goto(target_room);
    }
    exit;
}

    // PLAYER NORMAL (untuk level biasa - sembunyikan player saat masuk)
    with (obj_player) {
        if (place_meeting(x, y, other) && visible) {
            visible = false;
            other.players_entered++;
        }
    }

    // JIKA 2 PLAYER SUDAH MASUK (hanya untuk level biasa)
    if (players_entered >= 2) {
        if (!global.level_complete) {
            global.level_complete = true;
            global.level_timer = 180;
            txt_x = -300;

            audio_stop_all();
            audio_play_sound(sound_level_clear, 1, false);

            // Simpan progress hanya jika level diselesaikan (bukan pintu menu)
            var room_name = room_get_name(room);
            var digits = string_digits(room_name);
            if (digits != "") {
                var current_level = real(digits);
                if (current_level >= global.max_unlocked_level) {
                    global.max_unlocked_level = current_level + 1;
                    ini_open("save_data.ini");
                    ini_write_real("Progress", "max_unlocked", global.max_unlocked_level);
                    ini_close();
                }
            }
        }
    }
}

// =======================
// PINDAH ROOM (hanya untuk level biasa)
// =======================
if (global.level_complete) {
    global.level_timer--;

    if (global.level_timer <= 0) {
        global.level_complete = false;
        global.level_timer = 0;
        room_goto_next();
    }
}