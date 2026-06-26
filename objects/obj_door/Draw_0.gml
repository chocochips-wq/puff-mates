// Defensive Checks: Pastikan variabel kustom selalu terdefinisi
if (!variable_instance_exists(id, "is_menu_door")) is_menu_door = false;
if (!variable_instance_exists(id, "is_locked")) is_locked = false;
if (!variable_instance_exists(id, "shake_timer")) shake_timer = 0;
if (!variable_instance_exists(id, "warning_timer")) warning_timer = 0;
if (!variable_instance_exists(id, "bubble_scale")) bubble_scale = 0.0;
if (!variable_instance_exists(id, "bubble_alpha")) bubble_alpha = 0.0;
if (!variable_instance_exists(id, "target_room")) target_room = noone;
if (!variable_instance_exists(id, "level_number_label")) level_number_label = "";

// 1. Gambar Pintu (dengan Efek Getar jika shake_timer aktif)
var draw_x = x;
if (shake_timer > 0) {
    draw_x += sin(shake_timer * 1.5) * 3;
}
draw_sprite_ext(sprite_index, image_index, draw_x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// 2. Gambar Gembok Emas Prosedural jika pintu terkunci di lobby
if (is_menu_door && is_locked) {
    var lock_cx = draw_x + sprite_width / 2;
    var lock_cy = y + sprite_height / 2 + 8;
    
    // Lingkar gembok (shackle abu-abu besi)
    draw_set_color(make_color_rgb(170, 170, 170));
    draw_circle(lock_cx, lock_cy - 10, 8, true);
    draw_circle(lock_cx, lock_cy - 10, 9, true);
    draw_circle(lock_cx, lock_cy - 10, 7, true);
    
    // Badan gembok (kotak emas retro bulat)
    draw_set_color(make_color_rgb(230, 170, 40));
    draw_roundrect_ext(lock_cx - 10, lock_cy - 7, lock_cx + 10, lock_cy + 9, 6, 6, false);
    
    // Outline cokelat tua
    draw_set_color(make_color_rgb(130, 80, 10));
    draw_roundrect_ext(lock_cx - 10, lock_cy - 7, lock_cx + 10, lock_cy + 9, 6, 6, true);
    
    // Lubang kunci hitam kecil
    draw_set_color(c_black);
    draw_circle(lock_cx, lock_cy, 2.5, false);
    draw_triangle(lock_cx - 1.2, lock_cy, lock_cx + 1.2, lock_cy, lock_cx, lock_cy + 5, false);
}

// 3. Gambar Balon Dialog (Speech Bubble Info) di Atas Pintu
if (is_menu_door && bubble_scale > 0.01) {
    var bx = x + sprite_width / 2;
    var by = y - 42 - (1.0 - bubble_scale) * 12; // Efek melayang naik saat tumbuh
    var bw = 100 * bubble_scale;
    var bh = 42 * bubble_scale;
    
    // Bayangan Balon Dialog
    draw_set_alpha(0.25 * bubble_alpha);
    draw_set_color(c_black);
    draw_roundrect_ext(bx - bw/2 + 4, by - bh + 4, bx + bw/2 + 4, by + 4, 10, 10, false);
    
    // Badan Balon Dialog (Warna Cream Retro)
    draw_set_alpha(bubble_alpha);
    draw_set_color(make_color_rgb(255, 250, 235));
    draw_roundrect_ext(bx - bw/2, by - bh, bx + bw/2, by, 10, 10, false);
    
    // Outline Cokelat Tua
    draw_set_color(make_color_rgb(70, 45, 20));
    draw_roundrect_ext(bx - bw/2, by - bh, bx + bw/2, by, 10, 10, true);
    
    // Panah Penunjuk di bawah balon
    var arr_w = 8 * bubble_scale;
    draw_set_color(make_color_rgb(255, 250, 235));
    draw_triangle(bx - arr_w, by, bx + arr_w, by, bx, by + arr_w, false);
    draw_set_color(make_color_rgb(70, 45, 20));
    draw_line(bx - arr_w, by, bx, by + arr_w);
    draw_line(bx + arr_w, by, bx, by + arr_w);
    
    // Teks & Lencana di dalam balon
    if (bubble_scale > 0.65) {
        draw_set_font(-1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Label level (e.g. "LEVEL 1")
        draw_set_color(make_color_rgb(70, 45, 20));
        draw_text_transformed(bx, by - bh + 12 * bubble_scale, level_number_label, 1.0, 1.0, 0);
        
        // Badge bawah
        var badge_w = 60 * bubble_scale;
        var badge_h = 13 * bubble_scale;
        var bdy = by - 12 * bubble_scale;
        
        if (is_locked) {
            // Merah LOCKED
            draw_set_color(make_color_rgb(220, 70, 70));
            draw_roundrect_ext(bx - badge_w/2, bdy - badge_h/2, bx + badge_w/2, bdy + badge_h/2, 4, 4, false);
            draw_set_color(c_white);
            draw_text_transformed(bx, bdy, "LOCKED", 0.72, 0.72, 0);
        } else {
            // Hijau PLAY
            draw_set_color(make_color_rgb(60, 175, 75));
            draw_roundrect_ext(bx - badge_w/2, bdy - badge_h/2, bx + badge_w/2, bdy + badge_h/2, 4, 4, false);
            draw_set_color(c_white);
            
            if (players_entered > 0) {
                // Jika sudah ada pemain di dalam pintu
                draw_text_transformed(bx, bdy, string(players_entered) + "/2 IN", 0.72, 0.72, 0);
            } else {
                draw_text_transformed(bx, bdy, "PLAY", 0.75, 0.75, 0);
            }
        }
    }
    
    // Reset parameter
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// 4. Gambar Peringatan Merah jika Pemain menabrak Pintu Terkunci
if (is_menu_door && is_locked && warning_timer > 0) {
    var w_alpha = min(1.0, warning_timer / 15.0);
    draw_set_alpha(w_alpha);
    
    var wx = x + sprite_width / 2;
    var wy = y - 118; // Geser lebih ke atas agar tidak menabrak speech bubble utama
    
    draw_set_font(-1);
    var warn_text = "SELESAIKAN LEVEL SEBELUMNYA!";
    var ww = string_width(warn_text) + 16; // Lebar dinamis berdasarkan teks + padding
    var wh = 22;
    
    // Bayangan
    draw_set_color(c_black);
    draw_set_alpha(0.25 * w_alpha);
    draw_roundrect_ext(wx - ww/2 + 3, wy - wh/2 + 3, wx + ww/2 + 3, wy + wh/2 + 3, 6, 6, false);
    
    // Balon Peringatan Merah
    draw_set_alpha(w_alpha);
    draw_set_color(make_color_rgb(235, 60, 60));
    draw_roundrect_ext(wx - ww/2, wy - wh/2, wx + ww/2, wy + wh/2, 6, 6, false);
    
    // Border Putih
    draw_set_color(c_white);
    draw_roundrect_ext(wx - ww/2, wy - wh/2, wx + ww/2, wy + wh/2, 6, 6, true);
    
    // Teks Warning
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(wx, wy + 1, warn_text);
    
    // Reset parameter drawing
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
