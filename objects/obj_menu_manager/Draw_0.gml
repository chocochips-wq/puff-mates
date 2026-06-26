// 1. Gambar Langit Gradasi (Sunny Retro Day: Biru ke Peach/Kuning Hangat)
var col_top = make_color_rgb(80, 150, 240); // Biru Langit Retro
var col_bottom = make_color_rgb(253, 218, 175); // Peach Sunset Hangat
draw_rectangle_color(0, 0, room_width, room_height, col_top, col_top, col_bottom, col_bottom, false);

// 1.2 Gambar Matahari Hangat & Glow Melingkar
var sun_x = room_width - 200;
var sun_y = 120;
// Glow Luar (lembut)
draw_set_alpha(0.08);
draw_circle_color(sun_x, sun_y, 140, c_white, c_yellow, false);
draw_set_alpha(0.18);
draw_circle_color(sun_x, sun_y, 90, c_white, c_yellow, false);
// Badan Matahari
draw_set_alpha(0.9);
draw_circle_color(sun_x, sun_y, 45, c_white, make_color_rgb(255, 252, 210), false);
draw_set_alpha(1.0);

// 1.3 Siluet Bukit/Pegunungan Parallax (Sebelum Ground & Awan)
var hill_color = make_color_rgb(125, 160, 210); // Pastel lavender blue
draw_set_color(hill_color);
// Bukit Kiri jauh
draw_circle(200, room_height - 60, 340, false);
// Bukit Kanan jauh
draw_circle(room_width - 250, room_height - 40, 420, false);
// Bukit Tengah (sedikit lebih dekat dan gelap)
var hill_color_dark = make_color_rgb(105, 140, 190);
draw_set_color(hill_color_dark);
draw_circle(room_width / 2, room_height, 290, false);
draw_set_color(c_white);

// 1.4 Gambar Semua Awan Parallax
for (var i = 0; i < cloud_count; i++) {
    draw_set_alpha(cloud_alpha[i]);
    draw_set_color(c_white);
    var cx = cloud_x[i];
    var cy = cloud_y[i];
    var cs = cloud_scale[i];
    
    // Menggambar awan puffy dari lingkaran bertumpuk
    draw_circle(cx, cy, 24 * cs, false);
    draw_circle(cx - 20 * cs, cy + 4 * cs, 16 * cs, false);
    draw_circle(cx + 20 * cs, cy + 4 * cs, 16 * cs, false);
    draw_circle(cx - 10 * cs, cy - 8 * cs, 20 * cs, false);
    draw_circle(cx + 10 * cs, cy - 8 * cs, 20 * cs, false);
}
draw_set_alpha(1.0);

// 1.5 Gambar Gelembung Puff Mengambang
for (var i = 0; i < puff_count; i++) {
    draw_set_alpha(puff_alpha[i]);
    draw_set_color(make_color_rgb(255, 250, 220)); // Kuning cream lembut
    draw_circle(puff_x[i], puff_y[i], puff_radius[i], false);
    
    // Kilatan cahaya kecil
    draw_set_color(c_white);
    draw_circle(puff_x[i] - puff_radius[i] * 0.3, puff_y[i] - puff_radius[i] * 0.3, puff_radius[i] * 0.25, false);
}
draw_set_alpha(1.0);

// 2. Gambar Semua Tanah & Platform (obj_ground) dengan Gaya Bata Cokelat Retro
with (obj_ground) {
    var left = x;
    var top = y;
    var right = x + (sprite_get_width(sprite_index) * image_xscale);
    var bottom = y + (sprite_get_height(sprite_index) * image_yscale);
    
    // Warna Cokelat Bata Retro
    var c_brick = make_color_rgb(182, 115, 60);
    var c_border = make_color_rgb(120, 75, 35);
    
    // Gambar badan ubin cokelat
    draw_set_color(c_brick);
    draw_rectangle(left, top, right, bottom, false);
    
    // Gambar grid 32x32 di dalamnya
    draw_set_color(c_border);
    for (var xx = left; xx <= right; xx += 32) {
        draw_line(xx, top, xx, bottom);
    }
    for (var yy = top; yy <= bottom; yy += 32) {
        draw_line(left, yy, right, yy);
    }
    
    // Garis luar pembatas tanah
    draw_rectangle(left, top, right, bottom, true);
    
    // Garis sorot atas tanah (highlight top-border)
    draw_set_color(make_color_rgb(220, 160, 100));
    draw_line(left, top + 1, right, top + 1);
}

// 2.2 Gambar Rumput & Bunga Prosedural di atas Ground
var grass_len = array_length(grass_list);
for (var i = 0; i < grass_len; i++) {
    var g = grass_list[i];
    var sway = sin(current_time * g.sway_speed + g.angle_offset) * 4;
    
    // Bilah rumput utama (Hijau Cerah)
    draw_set_color(make_color_rgb(120, 200, 80));
    draw_triangle(g.x - 2, g.y, g.x + 2, g.y, g.x + sway, g.y - g.height, false);
    
    // Bilah rumput sekunder (Hijau Tua)
    draw_set_color(make_color_rgb(85, 155, 55));
    draw_triangle(g.x - 4, g.y, g.x, g.y, g.x - 1 + sway * 0.7, g.y - g.height * 0.7, false);
    
    // Gambar bunga kecil bergoyang
    if (g.flower) {
        var fx = g.x + sway;
        var fy = g.y - g.height;
        
        // Kelopak bunga (Pink manis)
        draw_set_color(make_color_rgb(255, 120, 160));
        draw_circle(fx - 2, fy, 1.8, false);
        draw_circle(fx + 2, fy, 1.8, false);
        draw_circle(fx, fy - 2, 1.8, false);
        draw_circle(fx, fy + 2, 1.8, false);
        
        // Putik bunga tengah (Kuning)
        draw_set_color(make_color_rgb(255, 230, 80));
        draw_circle(fx, fy, 1.2, false);
    }
}
draw_set_color(c_white);

// 2.3 Gambar Partikel Debu Pemain yang Sedang Bergerak
var dust_len = array_length(dust_list);
for (var i = 0; i < dust_len; i++) {
    var d = dust_list[i];
    draw_set_alpha(d.alpha);
    draw_set_color(make_color_rgb(235, 245, 255)); // Debu pastel putih-biru
    draw_circle(d.x, d.y, d.radius, false);
}
draw_set_alpha(1.0);
draw_set_color(c_white);

// 3. Gambar Floating Title "PUFF MATES" Per-Karakter Wavy
var title_text = "PUFF MATES";
var len = string_length(title_text);
var char_w = 40; // Jarak horizontal antar huruf
var scale_t = 2.2;
var start_x = (room_width / 2) - ((len - 1) * char_w) / 2;
var title_base_y = 110;

draw_set_font(fnt_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 1; i <= len; i++) {
    var char = string_char_at(title_text, i);
    if (char == " ") continue;
    
    var char_x = start_x + (i - 1) * char_w;
    var wave_y = title_base_y + sin(current_time * 0.0035 - i * 0.45) * 10;
    var rot = sin(current_time * 0.0025 + i * 0.6) * 6;
    
    // Shadow Teks (Cokelat Tua)
    draw_set_color(make_color_rgb(70, 40, 20));
    draw_text_transformed(char_x + 4, wave_y + 4, char, scale_t, scale_t, rot);
    
    // Teks Utama (Gradasi Kuning Emas Cerah)
    var col_top = make_color_rgb(255, 245, 160);
    var col_bot = make_color_rgb(255, 180, 50);
    draw_text_transformed_color(char_x, wave_y, char, scale_t, scale_t, rot, 
                                col_top, col_top, col_bot, col_bot, 1.0);
}

// 4. Gambar Papan Gantung Kayu Petunjuk (Co-op Welcome Sign)
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var box_w = 440;
var box_h = 36;
var bx = room_width / 2;
var by = 225;

// Gambar rantai gantung besi ke langit lobi
draw_set_color(make_color_rgb(85, 85, 85));
draw_line_width(bx - 160, by - 60, bx - 160, by, 3);
draw_line_width(bx + 160, by - 60, bx + 160, by, 3);

// Bayangan papan gantung
draw_set_color(c_black);
draw_set_alpha(0.25);
draw_roundrect_ext(bx - box_w/2 + 5, by - box_h/2 + 5, bx + box_w/2 + 5, by + box_h/2 + 5, 10, 10, false);

// Badan papan kayu
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(95, 55, 25)); // Kayu cokelat tua
draw_roundrect_ext(bx - box_w/2, by - box_h/2, bx + box_w/2, by + box_h/2, 10, 10, false);

// Garis serat kayu horizontal sederhana
draw_set_color(make_color_rgb(75, 40, 15));
draw_line(bx - box_w/2 + 15, by - 6, bx + box_w/2 - 15, by - 6);
draw_line(bx - box_w/2 + 25, by + 8, bx + box_w/2 - 25, by + 8);

// Border kuning emas retro
draw_set_color(make_color_rgb(255, 220, 80));
draw_roundrect_ext(bx - box_w/2, by - box_h/2, bx + box_w/2, by + box_h/2, 10, 10, true);

// Teks petunjuk masuk
draw_set_color(make_color_rgb(255, 250, 230)); // Krem putih hangat
draw_text(bx, by + 1, "MASUK PINTU BERSAMA UNTUK MEMULAI LEVEL");

// Reset semua pengaturan menggambar
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
