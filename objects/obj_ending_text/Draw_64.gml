// ==========================================
// DESAIN TEXT SHADOW LAYAR ENDING TAMAT
// ==========================================

// Ambil koordinat tengah layar GUI otomatis
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var center_x = gui_w / 2;
var center_y = gui_h / 2;

// Set teks rata tengah
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 1. GUNAKAN FONT UTAMA KAMU (fnt_title atau fnt_boss_name)
draw_set_font(fnt_title); 

// Teks yang ingin ditampilkan
var txt_title  = "VICTORY!";
var txt_sub    = "THE JUGGERNAUT HAS BEEN DESTROYED";
var txt_thanks = "THANK YOU FOR PLAYING";
var txt_reset  = "Press 'ENTER' to Return to Lobby";

// 🔘 PROSES DRAW 1: GAMBAR BAYANGAN HITAM (SHADOW) - Digeser +3 pixel ke kanan bawah
draw_set_color(c_black);
draw_text_transformed(center_x + 3, center_y - 80 + 3, txt_title, 2.0, 2.0, 0);       // Judul Gede
draw_text_transformed(center_x + 2, center_y - 20 + 2, txt_sub, 0.8, 0.8, 0);         // Sub-judul
draw_text_transformed(center_x + 2, center_y + 40 + 2, txt_thanks, 1.0, 1.0, 0);      // Ucapan terima kasih

// Khusus teks petir/tombol reset, bayangannya tipis saja
draw_text_transformed(center_x + 1, center_y + 120 + 1, txt_reset, 0.6, 0.6, 0);


// 🟡 PROSES DRAW 2: GAMBAR TEKS UTAMA DI ATASNYA
// Warna Judul Utama: Emas/Kuning Menyala
draw_set_color(c_yellow);
draw_text_transformed(center_x, center_y - 80, txt_title, 2.0, 2.0, 0);

// Warna Sub-Judul: Merah Soft (mengingatkan pada kekalahan bos)
draw_set_color(make_color_rgb(240, 80, 80));
draw_text_transformed(center_x, center_y - 20, txt_sub, 0.8, 0.8, 0);

// Warna Ucapan: Putih Bersih
draw_set_color(c_white);
draw_text_transformed(center_x, center_y + 40, txt_thanks, 1.0, 1.0, 0);

// Warna Tombol: Berkedip-kedip Abu-abu/Putih biar interaktif
var blink = (current_time div 400) mod 2 == 0;
if (blink) draw_set_color(c_white);
else       draw_set_color(c_silver);
draw_text_transformed(center_x, center_y + 120, txt_reset, 0.6, 0.6, 0);


// RE-SET STANDAR GAMEMAKER (Penting agar tidak merusak UI di room lain!)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);