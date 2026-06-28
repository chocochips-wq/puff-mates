/// @description Deteksi Klik Kursor GUI Kiri Atas & Tombol ESC

// ⚡ KOORDINAT RADAR: Di-set ke Pojok Kiri Atas (Sesuai Posisi Gambar Game Kamu)
var gx = 24; // Jarak dari ujung kiri layar ke tengah tombol gerigi (atur angka ini jika ingin digeser kanan/kiri)
var gy = 24; // Jarak dari ujung atas layar ke tengah tombol gerigi (atur angka ini jika ingin digeser atas/bawah)

var mx = device_mouse_x_to_gui(0); // Membaca posisi X kursor mouse di layar GUI
var my = device_mouse_y_to_gui(0); // Membaca posisi Y kursor mouse di layar GUI

// Area klik toleransi 24x24 pixel di sekitar tombol gerigi hitam
var gear_diklik = false;
if (mouse_check_button_pressed(mb_left)) {
    if (mx >= gx - 24 && mx <= gx + 24 && my >= gy - 24 && my <= gy + 24) {
        gear_diklik = true; // Kursor sukses mengeklik tombol gerigi!
    }
}

// Deteksi jika pemain memencet tombol ESC di keyboard
var esc_dipencet = keyboard_check_pressed(vk_escape);

// JIKA GEAR DIKLIK ATAU TOMBOL ESC DIPENCET
if (gear_diklik || esc_dipencet) {
    
    // Pastikan menu setting BELUM BUKA biar gak tumpang tindih/double popup
    if (instance_number(obj_settings_menu) == 0) {
        
        // 1. Munculkan menu settings tepat di tengah layar koordinat GUI
        var gui_x = display_get_gui_width() / 2;
        var gui_y = display_get_gui_height() / 2;
        var menu_inst = instance_create_layer(gui_x, gui_y, "Instances_1", obj_settings_menu);
        
        // 2. ⚡ AKTIFKAN PAUSE MASSAL: Tidurkan semua objek lain di room seketika
        // (true artinya objek tombol gear ini TIDAK IKUT tidur, jadi logika radar di atas tetap aktif)
        instance_deactivate_all(true);
        
        // 3. Bangunkan khusus si menu settings tadi agar dia bisa mendeteksi klik kursor di dalam panelnya
        if (menu_inst != noone) {
            instance_activate_object(menu_inst);
        }
    }
}