/// @description Inisialisasi Variabel Boss Juggernaut (Lebay Overload Edition)

boss_fully_dead = false;
hp              = 9;
max_hp          = 9;
phase           = 1;
phase1_timer    = 0;
phase1_timeout  = 1 * room_speed; 
hit_flash       = 0;

var bossX = x;
var bossY = y;

jeda_fase3      = -1;       
explosion_burst = 0;  

// ===================================================================
// 🌟 VARIABEL FISIKA JATUH + JUICE (ROTASI & BOUNCE ELASTIC)
// ===================================================================
puing_l_y           = 0;     
puing_r_y           = 0;     
puing_l_vsp         = 0;     
puing_r_vsp         = 0;     
puing_l_grounded    = false; 
puing_r_grounded    = false; 
puing_gravity       = 0.4;   

puing_l_angle        = 0;     
puing_r_angle        = 0;     
puing_l_rot_speed    = 0;     
puing_r_rot_speed    = 0;     
puing_l_bounce_count = 0;    
puing_r_bounce_count = 0;    

puing_l_initialized = false;
puing_r_initialized = false;

// Variabel Tambahan untuk Animasi Ledakan Lebay Berantai (Matematika)
ledakan_timer = 0;
ledakan_radius_l = 0;
ledakan_radius_r = 0;
ledakan_aktif = false;

// ==========================================
// CONFIG POSISI & SUDUT LARAS ORIGINAL
// ==========================================
top_turret_x    = bossX + 80; 
bottom_turret_x = bossX - 80; 
turret_y        = bossY + 80;

top_angle    = 270; 
bottom_angle = 270;

// ==========================================
// TIMER TIMING SERANGAN & CORE NYAWA
// ==========================================
shoot_timer        = 100;
pulse_time         = 0;
bob_time           = 0;
transisi_timer     = -1;
burst_count        = 0;
burst_timer        = 0;
phase2_pause_timer = 0;
phase2_flash_alpha = 0;

top_destroyed    = false;
bottom_destroyed = false;

core_top_hp    = 1;   
core_bottom_hp = 1;   
core_main_hp   = 100; 

// ==========================================
// KILAT & BACKGROUND WEATHER SYSTEM
// ==========================================
lightning_timer  = 120;
lightning_active = false;
flash_alpha      = 0;

// ==========================================
// SYSTEM CONFIG SERANGAN FASE 3
// ==========================================
fase3_mode            = 1;   
fase3_timer           = 240; 
sweep_angle           = 180;
sweep_direction       = 1;
rhythm_angle_offset   = 0;
rhythm_dir            = 1;
laser_already_spawned = false;
giga_drop_timer       = 0;   

survival_timer        = 30 * room_speed; 

// ==========================================
// SYSTEM RESPAWN CO-OP MULTIPLAYER
// ==========================================
death_timer        = -1;
depth              = -9999; 

bg_sky_r = 135;
bg_sky_g = 206;
bg_sky_b = 250;
bg_target_sky_r = bg_sky_r;
bg_target_sky_g = bg_sky_g;
bg_target_sky_b = bg_sky_b;
bg_lerp_speed = 0.02;

p1_respawn_timer   = -1;
p2_respawn_timer   = -1;
respawn_delay_time = 180; 

real_p1 = noone;
real_p2 = noone;

for (var i = 0; i < instance_number(obj_player); i++) {
    var p_inst = instance_find(obj_player, i);
    if (p_inst.p_id == 0) real_p1 = p_inst;
    if (p_inst.p_id == 1) real_p2 = p_inst;
}

turret_hitbox_w = 150; 
turret_hitbox_h = 110; 

magnet_progress    = 0;       
laser_tether_y     = 0;       
laser_tether_timer = 0;

// CROSS-FIRE SYSTEM
crossfire_counter  = 0;
crossfire_cooldown = 0;

// SPIRAL MODE 5
spiral_angle      = 0;
spiral_speed      = 3.5;
spiral_arms       = 6;

// CRACK VISUAL TURRET
crack_seed_l = irandom(9999);
crack_seed_r = irandom(9999);

// ENRAGE SYSTEM
is_enraged         = false;
enrage_speed_mult  = 1.0;
enrage_flash_timer = 0;

// WARNING INDICATOR
warning_timer  = -1;
warning_x      = 0;
warning_active = false;

door_open_offset = 0;

