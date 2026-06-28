// ==========================================
// DRAW EVENT: obj_laser_fase3
// ==========================================
var x_end = x + lengthdir_x(laser_length, laser_angle);
var y_end = y + lengthdir_y(laser_length, laser_angle);

// Ambil ukuran room untuk menggambar indikator lantai merah
var half_room = room_width / 2;
var floor_y = room_height - 32; // Sesuaikan tinggi lantai map kamu (misal tebal ground 32px)

// -----------------------------------------------------------
// FASE 1: GAMBAR PERINGATAN LANTAI MERAH BERKEDIP (1.5 DETIK)
// -----------------------------------------------------------
if (!is_lethal) {
    draw_set_alpha(flash_alpha);
    draw_set_color(c_red);
    
    // Jika laser bergerak dari Kiri ke Tengah (Membakar sisi Kiri)
    if (sweep_dir == 1) {
        draw_rectangle(0, floor_y - 20, half_room, room_height, false); 
    } 
    // Jika laser bergerak dari Kanan ke Tengah (Membakar sisi Kanan)
    else {
        draw_rectangle(half_room, floor_y - 20, room_width, room_height, false);
    }
    
    // Ditambah garis bidik laser tipis di udara sebagai ancaman tambahan
    draw_set_alpha(0.3);
    draw_line_width(x, y, x_end, y_end, 2);
} 
// -----------------------------------------------------------
// FASE 2: GAMBAR SEMBURAN LASER AKTIF MEMBARA
// -----------------------------------------------------------
else {
    draw_set_alpha(1.0);
    draw_set_color(c_red);
    draw_line_width(x, y, x_end, y_end, 14); // Lapisan merah tebal
    
    draw_set_color(c_white);
    draw_line_width(x, y, x_end, y_end, 4);  // Inti cahaya putih
}

draw_set_alpha(1.0); // Reset alpha GameMaker