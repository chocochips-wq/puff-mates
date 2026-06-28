// ==========================================
// CREATE EVENT: obj_laser_fase3 (TELEGRAF FIX)
// ==========================================
laser_timer = 210; // Ditambah jadi 3.5 detik (1.5 detik peringatan lantai + 2 detik laser aktif)
is_lethal = false; 

laser_angle = 180; 
sweep_dir = 1;     
laser_length = 1000; 
target_stop_angle = 270; 

// Variabel animasi untuk efek kedip lantai merah
flash_alpha = 0;
flash_speed = 0.1;