hp        = 9;
max_hp    = 9;
phase     = 1;
hit_flash = 0;

// ==========================================
// POSISI BOSS MENGHADAP KE BAWAH
// ==========================================
var bossX = x;
var bossY = y;

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

// ==========================================
// STATUS BOSS
// ==========================================
top_destroyed    = false;
bottom_destroyed = false;

core_top_hp    = 3;
core_bottom_hp = 3;
core_main_hp   = 3;

// ==========================================
// SIMULTANEOUS STOMP
// ==========================================
top_stomp_timer    = 0;
bottom_stomp_timer = 0;
main_stomp_timer   = 0;

top_stomped_by    = [];
bottom_stomped_by = [];
main_stomped_by   = [];

STOMP_WINDOW = 30;

// ==========================================
// KILAT FASE 3
// ==========================================
lightning_timer  = 120;
lightning_active = false;
flash_alpha      = 0;

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