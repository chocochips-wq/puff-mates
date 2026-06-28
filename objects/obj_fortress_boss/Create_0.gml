/// @description Inisialisasi Variabel Boss Juggernaut (Original + Hitbox Satelit)

hp        = 9;
max_hp    = 9;
phase     = 1;
phase1_timer   = 0;
phase1_timeout = 1 * room_speed; // FIX: Pemain wajib survival murni selama 40 detik di Fase 1
hit_flash = 0;

// ==========================================
// POSISI BOSS MENGHADAP KE BAWAH
// ==========================================
var bossX = x;
var bossY = y;

jeda_fase3 = -1; // Timer khusus untuk jeda transisi ke fase 3

// Body ada di atas, turret menggantung ke bawah
top_turret_x    = bossX + 80; // turret kanan
bottom_turret_x = bossX - 80; // turret kiri
turret_y        = bossY + 80;

// Arah tembakan ke bawah
top_angle    = 270;
bottom_angle = 270;

// ==========================================
// TIMER & ANIMASI
// ==========================================
shoot_timer = 100;
pulse_time  = 0;
bob_time    = 0;
transisi_timer = -1;
burst_count = 0;
burst_timer = 0;
phase2_pause_timer = 0;
phase2_flash_alpha = 0;

// ==========================================
// STATUS BOSS
// ==========================================
top_destroyed    = false;
bottom_destroyed = false;

core_top_hp    = 1;   // FIX: Butuh 5 roket untuk menghancurkan turret atas/kanan
core_bottom_hp = 1;   // FIX: Butuh 5 roket untuk menghancurkan turret bawah/kiri
core_main_hp   = 100; // FIX: Diatur ke 100 agar pas dengan pengurangan persentase siklus Fase 3

// ==========================================
// KILAT FASE 3
// ==========================================
lightning_timer  = 120;
lightning_active = false;
flash_alpha      = 0;

// ===================================================================
// INITIALIZATION VARIABEL SURVIVAL 30 DETIK (FASE 3)
// ===================================================================
fase3_mode          = 1;   // Mulai dari serangan 1
fase3_timer         = 240; // Timer internal perpindahan jenis serangan
sweep_angle         = 180;
sweep_direction     = 1;
rhythm_angle_offset = 0;
rhythm_dir          = 1;
laser_already_spawned = false;
giga_drop_timer     = 0;   

// TIMER BERTAHAN HIDUP GLOBAL FASE 3 (30 Detik * room_speed)
survival_timer      = 10 * room_speed; 

// ==========================================
// DEATH
// ==========================================
death_timer = -1;

// Boss selalu di depan
depth = -9999;

// ==========================================
// BACKGROUND LERPING VARIABLES
// ==========================================
bg_sky_r = 135;
bg_sky_g = 206;
bg_sky_b = 250;

bg_target_sky_r = bg_sky_r;
bg_target_sky_g = bg_sky_g;
bg_target_sky_b = bg_sky_b;

bg_lerp_speed = 0.02;

// --- TIMER RESPAWN JEDA PEMAIN (FASE 2) ---
p1_respawn_timer = -1;
p2_respawn_timer = -1;
respawn_delay_time = 180; 

// --- PENGUNCI ID PERMANEN (FIX SKENARIO A) ---
real_p1 = noone;
real_p2 = noone;

// Cari dan kunci ID instance murni berdasarkan p_id aslinya saat room baru mulai
for (var i = 0; i < instance_number(obj_player); i++) {
    var p_inst = instance_find(obj_player, i);
    if (p_inst.p_id == 0) real_p1 = p_inst;
    if (p_inst.p_id == 1) real_p2 = p_inst;
}

// ===================================================================
// UTALITAS HITBOX MATEMATIKA (TANPA OBJEK TAMBAHAN)
// ===================================================================
// Kita definisikan ukuran kotak turet untuk dicek saat peluru player datang
turret_hitbox_w = 150; // Lebar area sensitif turet
turret_hitbox_h = 110; // Tinggi area sensitif turet