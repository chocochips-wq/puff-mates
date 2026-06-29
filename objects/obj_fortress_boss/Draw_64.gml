/// @description Renders Dynamic Screen Warning (Phase 2 & Final Phase)

// ==========================================
// DYNAMIC WARNING TEXT (JEDA FASE 2 & FASE 3)
// ==========================================
var is_transisi_f1_to_f2 = (transisi_timer > 0 && hp > 0);
var is_transisi_f2_to_f3 = (variable_instance_exists(id, "jeda_fase3") && jeda_fase3 > 0);

if (is_transisi_f1_to_f2 || is_transisi_f2_to_f3) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    // Tentukan teks warning secara dinamis berdasarkan transisi mana yang aktif
    var warning_text = "WARNING: PHASE 2 STARTED!";
    if (is_transisi_f2_to_f3) {
        warning_text = "WARNING: FINAL PHASE STARTED!";
    }
    
    // Logika animasi berkedip menggunakan current_time div 300
    var blink = (current_time div 300) mod 2 == 0;
    if (blink) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fnt_title);
        
        // Shadow teks hitam biar kebaca di background apapun
        draw_set_color(c_black);
        draw_text(gui_w / 2 + 2, gui_h / 2 + 2, warning_text);
        
        // Teks utama merah menyala (Ulu Hati Kematian)
        draw_set_color(c_red);
        draw_text(gui_w / 2, gui_h / 2, warning_text);
    }
    
    // Reset kembali standarisasi draw state GameMaker biar gak bocor ke font lain
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// ===================================================================
// PENANDA & BAR PROGRES QTE SPAM RECOVERY PLAYER (ANTI-BINGUNG)
// ===================================================================
if (!boss_fully_dead) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Konfigurasi ukuran Bar Nyawa
    var bar_w = 120;
    var bar_h = 10;
    var blink_text = (current_time div 200) mod 2 == 0; // Efek kedip teks biar kerasa darurat

    // -------------------------------------------------------------------
    // PENANDA PLAYER 1 (SPAM SPASI)
    // -------------------------------------------------------------------
    if (p1_respawn_timer > 0 && instance_exists(real_p1)) {
        var px1 = real_p1.spawn_x;
        var py1 = real_p1.spawn_y - 50; // Posisi di atas kepala player
        
        // 1. Gambar Teks Perintah (Blinking)
        draw_set_font(fnt_boss_name);
        draw_set_color(c_black);
        draw_text(px1, py1 - 25, "SPAM [SPACE] TO REVIVE!");
        if (blink_text) {
            draw_set_color(make_color_rgb(255, 215, 0)); // Kuning neon
            draw_text(px1, py1 - 27, "SPAM [SPACE] TO REVIVE!");
        }
        
        // 2. Gambar Background Bar (Hitang/Abu)
        draw_set_color(c_black);
        draw_rectangle(px1 - bar_w/2 - 2, py1 - bar_h/2 - 2, px1 + bar_w/2 + 2, py1 + bar_h/2 + 2, false);
        draw_set_color(make_color_rgb(50, 50, 50));
        draw_rectangle(px1 - bar_w/2, py1 - bar_h/2, px1 + bar_w/2, py1 + bar_h/2, false);
        
        // 3. Gambar Isi Bar (Maju kalau dicharge/ditap!)
        // Nilai p1_respawn_timer dimulai dari maks (misal 180) berkurang ke 0.
        // Kita balik rasionya biar pas ditekan bar-nya malah bertambah penuh!
        var max_delay = variable_instance_exists(id, "respawn_delay_time") ? respawn_delay_time : 180;
        var p1_progress = clamp(1.0 - (p1_respawn_timer / max_delay), 0, 1.0);
        
        draw_set_color(make_color_rgb(255, 60, 60)); // Warna merah recovery
        draw_rectangle(px1 - bar_w/2, py1 - bar_h/2, (px1 - bar_w/2) + (p1_progress * bar_w), py1 + bar_h/2, false);
        
        // Border putih tipis
        draw_set_color(c_white);
        draw_rectangle(px1 - bar_w/2, py1 - bar_h/2, px1 + bar_w/2, py1 + bar_h/2, true);
    }

    // -------------------------------------------------------------------
    // PENANDA PLAYER 2 (SPAM ARROW UP)
    // -------------------------------------------------------------------
    if (p2_respawn_timer > 0 && instance_exists(real_p2)) {
        var px2 = real_p2.spawn_x;
        var py2 = real_p2.spawn_y - 50;
        
        // 1. Gambar Teks Perintah (Blinking)
        draw_set_font(fnt_boss_name);
        draw_set_color(c_black);
        draw_text(px2, py2 - 25, "SPAM [ARROW UP] TO REVIVE!");
        if (blink_text) {
            draw_set_color(make_color_rgb(0, 255, 240)); // Cyan neon
            draw_text(px2, py2 - 27, "SPAM [ARROW UP] TO REVIVE!");
        }
        
        // 2. Gambar Background Bar
        draw_set_color(c_black);
        draw_rectangle(px2 - bar_w/2 - 2, py2 - bar_h/2 - 2, px2 + bar_w/2 + 2, py2 + bar_h/2 + 2, false);
        draw_set_color(make_color_rgb(50, 50, 50));
        draw_rectangle(px2 - bar_w/2, py2 - bar_h/2, px2 + bar_w/2, py2 + bar_h/2, false);
        
        // 3. Gambar Isi Bar
        var max_delay = variable_instance_exists(id, "respawn_delay_time") ? respawn_delay_time : 180;
        var p2_progress = clamp(1.0 - (p2_respawn_timer / max_delay), 0, 1.0);
        
        draw_set_color(make_color_rgb(0, 200, 255)); // Warna biru recovery khusus P2
        draw_rectangle(px2 - bar_w/2, py2 - bar_h/2, (px2 - bar_w/2) + (p2_progress * bar_w), py2 + bar_h/2, false);
        
        // Border putih tipis
        draw_set_color(c_white);
        draw_rectangle(px2 - bar_w/2, py2 - bar_h/2, px2 + bar_w/2, py2 + bar_h/2, true);
    }
    
    // Reset standard font alignment bawaan GM
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}