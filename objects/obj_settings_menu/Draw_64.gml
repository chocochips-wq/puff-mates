/// @description Render Visual Tema Kayu Pastel Imut (HD)

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

// Pastikan fungsi interpolasi tekstur aktif agar font tidak pecah/bergerigi saat ditarik fullscreen
gpu_set_texfilter(true);

if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
if (!variable_global_exists("vol_music"))  global.vol_music  = 1.0;
if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;

// 📸 Gambar Screenshot Background Game
if (sprite_exists(pause_sprite)) {
    draw_sprite_ext(pause_sprite, 0, 0, 0, display_get_gui_width() / sprite_get_width(pause_sprite), display_get_gui_height() / sprite_get_height(pause_sprite), 0, c_white, 1.0);
}

// Overlay Redup Lembut Estetik (Transparan)
draw_set_color(make_color_rgb(24, 28, 36));
draw_set_alpha(0.4); 
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.0);

// ==========================================
// PANELLING BARU: TEMA KAMPUNG HALAMAN DINO (COKELAT KAYU)
// ==========================================
var x1 = x - (menu_width  / 2) * menu_scale;
var y1 = y - (menu_height / 2) * menu_scale;
var x2 = x + (menu_width  / 2) * menu_scale;
var y2 = y + (menu_height / 2) * menu_scale;

// Efek Bayangan Belakang Panel Gemoy
draw_set_color(make_color_rgb(41, 29, 20));
draw_roundrect_ext(x1 + 8, y1 + 8, x2 + 8, y2 + 8, 32, 32, false);

// Badan Utama Panel (Cokelat Susu/Kayu Manis Hangat)
draw_set_color(make_color_rgb(115, 87, 66));
draw_roundrect_ext(x1, y1, x2, y2, 32, 32, false);

// Garis Pembatas Dalam Panel (Cokelat Cream Cerah)
draw_set_color(make_color_rgb(229, 193, 154));
draw_roundrect_ext(x1 + 6, y1 + 6, x2 - 6, y2 - 6, 24, 24, true);

if (menu_scale >= 0.95) {

    // Judul Menu (Teks Kuning Lemon Ceria khas Puff Mates)
    draw_set_font(fnt_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(254, 240, 138)); 
    draw_text(x, y1 + 25, "OPTIONS");
    draw_set_font(-1);
    draw_set_valign(fa_middle);

    // ==========================================
    // RENDER SLIDER VOLUME (GAYA KARTUN/GEMOY)
    // ==========================================
    for (var i = 0; i < total_sliders; i++) {
        var s_x1 = x - (slider_w / 2);
        var s_x2 = x + (slider_w / 2);
        var s_y  = y + slider_yy[i];

        var current_vol = variable_global_get(slider_global_var[i]);
        if (is_undefined(current_vol)) current_vol = 1.0;
        var knob_x = s_x1 + (current_vol * slider_w);

        // Nama Kategori Volume (Teks Putih Cream)
        draw_set_color(make_color_rgb(254, 243, 199));
        draw_set_halign(fa_left);
        draw_text(s_x1, s_y - 22, slider_name[i]);

        // Angka Persentase (Warna Hijau Mint Daun Muda)
        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(134, 239, 172));
        draw_text(s_x2, s_y - 22, string(round(current_vol * 100)) + "%");

        // Selongsong Batang Slider (Warna Cokelat Gelap Pekat)
        draw_set_color(make_color_rgb(59, 41, 29));
        draw_roundrect_ext(s_x1, s_y - (slider_h/2), s_x2, s_y + (slider_h/2), 8, 8, false);

        // Batang Slider yang Terisi (Warna Hijau Toska Cerah Segar)
        if (current_vol > 0) {
            draw_set_color(make_color_rgb(20, 184, 166));
            draw_roundrect_ext(s_x1, s_y - (slider_h/2), knob_x, s_y + (slider_h/2), 8, 8, false);
        }

        // Bulatan Knob Slider Gendut (Putih Bersih Bergaris Emas Kuning)
        draw_set_color(c_white);
        draw_circle(knob_x, s_y, knob_r, false);
        draw_set_color(make_color_rgb(253, 224, 71));
        draw_circle(knob_x, s_y, knob_r, true);
    }

    // ==========================================
    // RENDER TOMBOL FULLSCREEN (GAYA TOMBOL KAYU)
    // ==========================================
    var fs_x1 = x - (btn_fs_w / 2);
    var fs_x2 = x + (btn_fs_w / 2);
    var fs_y1 = y + btn_fs_y - (btn_fs_h / 2);
    var fs_y2 = y + btn_fs_y + (btn_fs_h / 2);
    var fs_hover = (mouse_gui_x >= fs_x1 && mouse_gui_x <= fs_x2 && mouse_gui_y >= fs_y1 && mouse_gui_y <= fs_y2);

    // Warna tombol berubah lebih cerah jika kursor mouse mendekat
    draw_set_color(fs_hover ? make_color_rgb(143, 109, 83) : make_color_rgb(74, 53, 38));
    draw_roundrect_ext(fs_x1, fs_y1, fs_x2, fs_y2, 12, 12, false);
    draw_set_color(make_color_rgb(229, 193, 154));
    draw_roundrect_ext(fs_x1, fs_y1, fs_x2, fs_y2, 12, 12, true);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var fs_text = window_get_fullscreen() ? "WINDOWED" : "FULLSCREEN";
    draw_text(x, y + btn_fs_y, fs_text);

    // ==========================================
    // RENDER TOMBOL BACK (KONTRAST MERAH AMBER KASTROL)
    // ==========================================
    var b_x1 = x - (btn_back_w / 2);
    var b_x2 = x + (btn_back_w / 2);
    var b_y1 = y + btn_back_y - (btn_back_h / 2);
    var b_y2 = y + btn_back_y + (btn_back_h / 2);
    var back_hover = (mouse_gui_x >= b_x1 && mouse_gui_x <= b_x2 && mouse_gui_y >= b_y1 && mouse_gui_y <= b_y2);

    draw_set_color(back_hover ? make_color_rgb(220, 38, 38) : make_color_rgb(153, 27, 27));
    draw_roundrect_ext(b_x1, b_y1, b_x2, b_y2, 12, 12, false);
    draw_set_color(make_color_rgb(248, 113, 113));
    draw_roundrect_ext(b_x1, b_y1, b_x2, b_y2, 12, 12, true);
    
    draw_set_color(make_color_rgb(254, 243, 199));
    draw_text(x, y + btn_back_y, "BACK");
}

// Matikan kembali filter interpolasi agar tidak mempengaruhi rendering sprite pixel art game utamamu
gpu_set_texfilter(false);

// Reset standard drawing state GameMaker
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);