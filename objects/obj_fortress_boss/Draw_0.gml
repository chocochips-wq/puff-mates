/// @description Full Render: Pintu Belah + Tesla Generator Fase 3 + HP Bar (Laras di Depan)

// ⚡ JARING PENGAMAN: Jika belum terdefinisi, buat default false
if (!variable_instance_exists(id, "boss_fully_dead")) {
    boss_fully_dead = false;
}

// ===================================================================
// A. BAGIAN TUBUH & HP BAR (Hanya digambar JIKA BOSS BELUM MATI TOTAL)
// ===================================================================
if (!boss_fully_dead) {

    draw_set_color(c_white);

    // 1. SAFETY VARIABLE & ANIMATION LERP
    if (!variable_instance_exists(id, "top_turret_x")) {
        top_turret_x    = x + 80;
        bottom_turret_x = x - 80;
        turret_y        = y + 80;
    }

    if (!variable_instance_exists(id, "draw_hp_fase2")) {
        draw_hp_fase2 = 10;
    }

    var target_hp_fase2 = core_top_hp + core_bottom_hp;
    draw_hp_fase2 = lerp(draw_hp_fase2, target_hp_fase2, 0.1);

    if (!variable_instance_exists(id, "door_open_offset")) {
        door_open_offset = 0; 
    }

    // Jika sudah masuk Fase 3, pintu membelah keluar sejauh 55 piksel
    if (phase == 3) {
        door_open_offset = lerp(door_open_offset, 55, 0.05); 
    } else {
        door_open_offset = lerp(door_open_offset, 0, 0.05);
    }

    // 2. PALETTE WARNA PICO PARK (SKALA JUMBO)
    var c_border = c_black;
    var c_armor_dark = make_color_rgb(60, 64, 67);   
    var c_armor_mid  = make_color_rgb(98, 102, 105); 
    var c_armor_light = make_color_rgb(140, 145, 148); 

    if (hit_flash > 0 && (hit_flash div 2) mod 2 == 0) {
        c_armor_dark  = c_white;
        c_armor_mid   = c_white;
        c_armor_light = c_white;
    }

    // 3. POSISI & AMBANG AYUNAN (BOBBING)
    var bob = sin(bob_time) * 5;
    var bx = x;
    var by = y + bob;
    
    var lx = bx - 185;   // Titik pusat Turret Kiri
    var rx = bx + 185;   // Titik pusat Turret Kanan
    var laras_y_offset = by + 20; 
    var core_target_y = by + 45; // Hulu hati Red Core (-5 dari bodi)

    // ===================================================================
    // LAYER 1 [PALING BELAKANG]: PIPA HIDROLIK PENYAMBUNG
    // ===================================================================
    draw_set_color(c_border);
    draw_rectangle(bx - 170, by - 24, bx + 170, by + 24, false); 
    draw_set_color(c_armor_dark);
    draw_rectangle(bx - 166, by - 18, bx + 166, by + 18, false);   

    // ===================================================================
    // LAYER 2 [TENGAH]: RANGKAIAN BODI UTAMA & RED CORE
    // ===================================================================
    var b_w = 115;  
    var b_h = 100;  

    draw_set_color(c_border);
    draw_rectangle(bx - b_w - 2, by - b_h - 2, bx + b_w + 2, by + b_h + 2, false);
    draw_set_color(c_armor_dark);
    draw_rectangle(bx - b_w, by - b_h, bx + b_w, by + b_h, false);

    // INTI ENERGI RED CORE
    if (door_open_offset > 5) {
        var pulse3 = sin(pulse_time * 5) * 5;
        draw_set_color(c_border); draw_circle(bx, core_target_y, 38, false);
        
        draw_set_alpha(0.4);
        draw_set_color(make_color_rgb(255, 30, 30)); draw_circle(bx, core_target_y, 34 + pulse3, false);
        draw_set_alpha(1);

        draw_set_color(make_color_rgb(220, 40, 40)); draw_circle(bx, core_target_y, 26, false);
        draw_set_color(make_color_rgb(255, 120, 120)); draw_circle(bx - 6, core_target_y - 6, 9, false); 
    }

    // MEKANISME PINTU GERBANG BELAH (Kiri & Kanan)
    // --- PINTU BELAH KIRI ---
    var p_kiri_x1 = bx - b_w + 8 - door_open_offset;
    var p_kiri_x2 = bx - door_open_offset;
    if (p_kiri_x2 > bx - b_w + 8) {
        draw_set_color(c_border);
        draw_rectangle(p_kiri_x1 - 2, by - b_h + 6, p_kiri_x2 + 2, by + b_h - 6, false);
        draw_set_color(c_armor_mid);
        draw_rectangle(p_kiri_x1, by - b_h + 8, p_kiri_x2, by + b_h - 8, false);
        
        var pl_kiri_x1 = bx - 70 - door_open_offset;
        var pl_kiri_x2 = bx - door_open_offset;
        if (pl_kiri_x1 < p_kiri_x2 && pl_kiri_x2 > p_kiri_x1) {
            draw_set_color(c_border);
            draw_rectangle(clamp(pl_kiri_x1, p_kiri_x1, p_kiri_x2) - 2, by - b_h + 14, clamp(pl_kiri_x2, p_kiri_x1, p_kiri_x2) + 2, by + b_h - 14, false);
            draw_set_color(c_armor_light);
            draw_rectangle(clamp(pl_kiri_x1, p_kiri_x1, p_kiri_x2), by - b_h + 16, clamp(pl_kiri_x2, p_kiri_x1, p_kiri_x2), by + b_h - 16, false);
        }
    }

    // --- PINTU BELAH KANAN ---
    var p_kanan_x1 = bx + door_open_offset;
    var p_kanan_x2 = bx + b_w - 8 + door_open_offset;
    if (p_kanan_x1 < bx + b_w - 8) {
        draw_set_color(c_border);
        draw_rectangle(p_kanan_x1 - 2, by - b_h + 6, p_kanan_x2 + 2, by + b_h - 6, false);
        draw_set_color(c_armor_mid);
        draw_rectangle(p_kanan_x1, by - b_h + 8, p_kanan_x2, by + b_h - 8, false);
        
        var pl_kanan_x1 = bx + door_open_offset;
        var pl_kanan_x2 = bx + 70 + door_open_offset;
        if (pl_kanan_x1 < p_kanan_x2 && pl_kanan_x2 > p_kanan_x1) {
            draw_set_color(c_border);
            draw_rectangle(clamp(pl_kanan_x1, p_kanan_x1, p_kanan_x2) - 2, by - b_h + 14, clamp(pl_kanan_x2, p_kanan_x1, p_kanan_x2) + 2, by + b_h - 14, false);
            draw_set_color(c_armor_light);
            draw_rectangle(clamp(pl_kanan_x1, p_kanan_x1, p_kanan_x2), by - b_h + 16, clamp(pl_kanan_x2, p_kanan_x1, p_kanan_x2), by + b_h - 16, false);
        }
    }

    if (door_open_offset <= 1) {
        draw_set_color(c_border);
        draw_line_width(bx, by - b_h + 18, bx, by + b_h - 18, 4);
    }

    // ===================================================================
    // LAYER 3: KOTAK MOUNTING TURRET KIRI & KANAN (Ubah Bentuk Gosong Fase 3)
    // ===================================================================
    var t_width = 75;    
    var t_height = 110;  

    // 🌟 Jika Fase 3, warnai modul samping menjadi hancur/gosong
    var c_turret_base = c_armor_dark;
    var c_turret_panel = c_armor_mid;
    if (phase == 3) {
        c_turret_base  = make_color_rgb(30, 32, 35);  // Gosong gelap
        c_turret_panel = make_color_rgb(45, 48, 50);  // Metal rusak
    }

    // --- TURRET KIRI ---
    draw_set_color(c_border); 
    draw_rectangle(lx - t_width - 2, by - t_height/2 - 2, lx + t_width + 2, by + t_height/2 + 2, false);
    draw_set_color(c_turret_base); 
    draw_rectangle(lx - t_width, by - t_height/2, lx + t_width, by + t_height/2, false);
    
    draw_set_color(c_border);
    draw_rectangle(lx - t_width + 16, by - t_height/2 + 16, lx + t_width - 16, by + t_height/2 - 16, false);
    draw_set_color(c_turret_panel); 
    draw_rectangle(lx - t_width + 20, by - t_height/2 + 20, lx + t_width - 20, by + t_height/2 - 20, false);

    // --- TURRET KANAN ---
    draw_set_color(c_border); 
    draw_rectangle(rx - t_width - 2, by - t_height/2 - 2, rx + t_width + 2, by + t_height/2 + 2, false);
    draw_set_color(c_turret_base); 
    draw_rectangle(rx - t_width, by - t_height/2, rx + t_width, by + t_height/2, false);
    
    draw_set_color(c_border);
    draw_rectangle(rx - t_width + 16, by - t_height/2 + 16, rx + t_width - 16, by + t_height/2 - 16, false);
    draw_set_color(c_turret_panel); 
    draw_rectangle(rx - t_width + 20, by - t_height/2 + 20, rx + t_width - 20, by + t_height/2 - 20, false);

    // ===================================================================
    // LAYER 4: TESLA CHARGING LIGHTNING (Efek Sambaran Energi Fase 3)
    // ===================================================================
    // 🌟 Jika masuk Fase 3, gambar petir generator dari rongsokan samping menyengat masuk ke Core tengah
    if (phase == 3 && door_open_offset > 40) {
        draw_set_alpha(random_range(0.4, 0.9)); // Efek kelap-kelip petir dinamis
        
        // Pilih warna listrik: Cyan Neon / Biru Listrik
        var c_tesla_elec = make_color_rgb(0, 240, 255);
        draw_set_color(c_tesla_elec);

        // Petir Generator Kiri Menuju Core
        var cur_lx = lx;
        var cur_ly = laras_y_offset;
        for (var j = 0; j < 4; j++) {
            var next_lx = lerp(lx, bx, (j + 1) / 4);
            var next_ly = lerp(laras_y_offset, core_target_y, (j + 1) / 4) + irandom_range(-8, 8);
            if (j == 3) { next_lx = bx; next_ly = core_target_y; }
            draw_line_width(cur_lx, cur_ly, next_lx, next_ly, 3);
            cur_lx = next_lx; cur_ly = next_ly;
        }

        // Petir Generator Kanan Menuju Core
        var cur_rx = rx;
        var cur_ry = laras_y_offset;
        for (var j = 0; j < 4; j++) {
            var next_rx = lerp(rx, bx, (j + 1) / 4);
            var next_ry = lerp(laras_y_offset, core_target_y, (j + 1) / 4) + irandom_range(-8, 8);
            if (j == 3) { next_rx = bx; next_ly = core_target_y; }
            draw_line_width(cur_rx, cur_ry, next_rx, next_ry, 3);
            cur_rx = next_rx; cur_ry = next_ry;
        }
        
        draw_set_alpha(1);
    }

    // ===================================================================
    // LAYER 5 [PALING DEPAN]: LARAS MERIAM BERPUTAR & SENDI MERAH
    // ===================================================================
    draw_set_color(c_border);
    var tl_x = lx + lengthdir_x(90, top_angle); 
    var tl_y = laras_y_offset + lengthdir_y(90, top_angle);
    draw_line_width(lx, laras_y_offset, tl_x, tl_y, 26); 
    
    var tr_x = rx + lengthdir_x(90, bottom_angle);
    var tr_y = laras_y_offset + lengthdir_y(90, bottom_angle);
    draw_line_width(rx, laras_y_offset, tr_x, tr_y, 26);

    draw_set_color(c_armor_mid);
    draw_line_width(lx, laras_y_offset, tl_x, tl_y, 16); 
    draw_line_width(rx, laras_y_offset, tr_x, tr_y, 16);

    if (!bottom_destroyed) {
        draw_set_color(make_color_rgb(230, 40, 40)); draw_circle(lx, laras_y_offset, 16, false);
    } else {
        draw_set_color(make_color_rgb(40, 40, 40)); draw_circle(lx, laras_y_offset, 12, false);
    }
    
    if (!top_destroyed) {
        draw_set_color(make_color_rgb(230, 40, 40)); draw_circle(rx, laras_y_offset, 16, false);
    } else {
        draw_set_color(make_color_rgb(40, 40, 40)); draw_circle(rx, laras_y_offset, 12, false);
    }

    // ===================================================================
    // 9. HEALTH BAR DUAL-LAYER MULTI-FASE
    // ===================================================================
    if (hp > 0 || phase == 3 || (variable_instance_exists(id, "jeda_fase3") && jeda_fase3 > 0)) {
        var bar_w = 400;
        var bar_h = 20;
        var bar_x = (room_width / 2) - bar_w / 2;
        var bar_y = 30; 

        draw_set_alpha(0.4);
        draw_set_color(c_black);
        draw_rectangle(bar_x + 3, bar_y + 3, bar_x + bar_w + 3, bar_y + bar_h + 3, false);
        draw_set_alpha(1);

        draw_set_color(make_color_rgb(60, 60, 60));
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

        var c_boss_gray   = make_color_rgb(175, 180, 185);
        var c_boss_orange = make_color_rgb(255, 130, 0);
        var c_boss_red    = make_color_rgb(220, 40, 40);

        if (phase == 1) {
            draw_set_color(c_boss_orange);
            draw_rectangle(bar_x + 2, bar_y + 2, bar_x + bar_w - 2, bar_y + bar_h - 2, false);
            var phase1_percentage = 1.0 - (phase1_timer / phase1_timeout);
            var fill_w_gray = clamp(phase1_percentage, 0.0, 1.0) * (bar_w - 4);
            draw_set_color(c_boss_gray);
            draw_rectangle(bar_x + 2, bar_y + 2, bar_x + 2 + fill_w_gray, bar_y + bar_h - 2, false);
        } 
        else if (phase == 2) {
            draw_set_color(c_boss_red);
            draw_rectangle(bar_x + 2, bar_y + 2, bar_x + bar_w - 2, bar_y + bar_h - 2, false);
            var phase2_percentage = (draw_hp_fase2 / 10); 
            var fill_w_orange = clamp(phase2_percentage, 0.0, 1.0) * (bar_w - 4);
            draw_set_color(c_boss_orange);
            draw_rectangle(bar_x + 2, bar_y + 2, bar_x + 2 + fill_w_orange, bar_y + bar_h - 2, false);
        } 
        else if (phase == 3) {
            var phase3_percentage = (core_main_hp / 100);
            var fill_w_red = clamp(phase3_percentage, 0.0, 1.0) * (bar_w - 4);
            draw_set_color(c_boss_red);
            draw_rectangle(bar_x + 2, bar_y + 2, bar_x + 2 + fill_w_red, bar_y + bar_h - 2, false);
        }

        draw_set_alpha(0.2);
        var gl_w = (bar_w - 4);
        if (phase == 1) gl_w = (1.0 - (phase1_timer / phase1_timeout)) * (bar_w - 4);
        if (phase == 2) gl_w = (draw_hp_fase2 / 10) * (bar_w - 4);
        if (phase == 3) gl_w = (core_main_hp / 100) * (bar_w - 4);
        draw_rectangle(bar_x + 2, bar_y + 2, bar_x + 2 + gl_w, bar_y + 8, false);
        draw_set_alpha(1);

        draw_set_color(c_white);
        draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);
        draw_set_font(fnt_boss_name); 
        draw_text(bar_x + bar_w / 2, bar_y - 4, "JUGGERNAUT");
        draw_set_font(fnt_title); 

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

// ===================================================================
// B. BAGIAN LATAR BELAKANG (BINTANG GLOBAL)
// ===================================================================
if (phase == 3 || (variable_instance_exists(id, "core_main_hp") && core_main_hp <= 0)) {
    var seed = 98765;
    random_set_seed(seed);
    draw_set_alpha(0.6);

    for (var i = 0; i < 50; i++) {
        var sx = random(room_width);
        var sy = random(room_height * 0.7);

        draw_set_color(c_white);
        draw_circle(sx, sy, 1, false); 
    }

    draw_set_alpha(1);
    random_set_seed(current_time);
}

if (flash_alpha > 0.02 && !boss_fully_dead) {
    draw_set_alpha(flash_alpha * 0.35);
    draw_set_color(c_white);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);