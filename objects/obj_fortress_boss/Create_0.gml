/// @description Inisialisasi Variabel Boss Juggernaut

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
// FISIKA JATUH TURRET
// ===================================================================
puing_l_y            = 0;
puing_r_y            = 0;
puing_l_vsp          = 0;
puing_r_vsp          = 0;
puing_l_grounded     = false;
puing_r_grounded     = false;
puing_gravity        = 0.4;
puing_l_angle        = 0;
puing_r_angle        = 0;
puing_l_rot_speed    = 0;
puing_r_rot_speed    = 0;
puing_l_bounce_count = 0;
puing_r_bounce_count = 0;
puing_l_initialized  = false;
puing_r_initialized  = false;

// ===================================================================
// SISTEM LEDAKAN PARTIKEL BARU
// ===================================================================
expl_l_count  = 0;
expl_r_count  = 0;
expl_max      = 40;

expl_l_x      = array_create(expl_max, 0);
expl_l_y      = array_create(expl_max, 0);
expl_l_hsp    = array_create(expl_max, 0);
expl_l_vsp    = array_create(expl_max, 0);
expl_l_life   = array_create(expl_max, 0);
expl_l_maxlife= array_create(expl_max, 0);
expl_l_size   = array_create(expl_max, 0);
expl_l_arc    = array_create(expl_max, 0);
expl_l_type   = array_create(expl_max, 0);

expl_r_x      = array_create(expl_max, 0);
expl_r_y      = array_create(expl_max, 0);
expl_r_hsp    = array_create(expl_max, 0);
expl_r_vsp    = array_create(expl_max, 0);
expl_r_life   = array_create(expl_max, 0);
expl_r_maxlife= array_create(expl_max, 0);
expl_r_size   = array_create(expl_max, 0);
expl_r_arc    = array_create(expl_max, 0);
expl_r_type   = array_create(expl_max, 0);

expl_spawn_timer = 0;

expl_l_core_alpha = 0;
expl_r_core_alpha = 0;
expl_l_core_r     = 0;
expl_r_core_r     = 0;

// ===================================================================
// VARIABEL LEDAKAN LAMA (kompatibilitas)
// ===================================================================
ledakan_timer    = 0;
ledakan_radius_l = 0;
ledakan_radius_r = 0;
ledakan_aktif    = false;

// ===================================================================
// CONFIG POSISI & SUDUT
// ===================================================================
top_turret_x    = bossX + 80;
bottom_turret_x = bossX - 80;
turret_y        = bossY + 80;
top_angle       = 270;
bottom_angle    = 270;

// ===================================================================
// TIMER & CORE HP
// ===================================================================
shoot_timer        = 100;
pulse_time         = 0;
bob_time           = 0;
transisi_timer     = -1;
burst_count        = 0;
burst_timer        = 0;
phase2_pause_timer = 0;
phase2_flash_alpha = 0;
top_destroyed      = false;
bottom_destroyed   = false;
core_top_hp        = 5;
core_bottom_hp     = 5;
core_main_hp       = 100;
door_open_offset   = 0;

// ===================================================================
// KILAT & BACKGROUND WEATHER
// ===================================================================
lightning_timer  = 120;
lightning_active = false;
flash_alpha      = 0;
bg_sky_r = 135; bg_sky_g = 206; bg_sky_b = 250;
bg_target_sky_r = 135; bg_target_sky_g = 206; bg_target_sky_b = 250;
bg_lerp_speed = 0.02;

// ===================================================================
// FASE 3 CONFIG
// ===================================================================
fase3_mode            = 1;
fase3_timer           = 240;
sweep_angle           = 180;
sweep_direction       = 1;
rhythm_angle_offset   = 0;
rhythm_dir            = 1;
laser_already_spawned = false;
giga_drop_timer       = 0;
survival_timer        = 30 * room_speed;
spiral_angle          = 0;
spiral_speed          = 3.5;
spiral_arms           = 4;

overload_active     = false;
overload_phase      = 0;
overload_timer      = 0;
overload_ring_count = 0;
overload_ring_timer = 0;

// ===================================================================
// RESPAWN CO-OP & UTILS
// ===================================================================
death_timer        = -1;
depth              = -9999;
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

// FIX TYPO DI SINI JIRR (Menggunakan bossX dan bossY bawaan asli kamu):
l_turret_x = bossX - 185; 
r_turret_x = bossX + 185;
turret_base_y = bossY + 20;

turret_hitbox_w = 150;
turret_hitbox_h = 110;
magnet_progress    = 0;
laser_tether_y     = 0;
laser_tether_timer = 0;

// ===================================================================
// ENRAGE SYSTEM
// ===================================================================
is_enraged         = false;
enrage_speed_mult  = 1.0;
enrage_flash_timer = 0;

// ===================================================================
// WARNING INDICATOR
// ===================================================================
warning_timer  = -1;
warning_x      = 0;
warning_active = false;

// ===================================================================
// CROSS-FIRE SYSTEM
// ===================================================================
crossfire_counter  = 0;
crossfire_cooldown = 0;

// ===================================================================
// CRACK VISUAL TURRET
// ===================================================================
crack_seed_l = irandom(9999);
crack_seed_r = irandom(9999);

// ===================================================================
// FASE 2 SERANGAN BARU
// ===================================================================
scatter_state      = 0;
scatter_hold_timer = 0;
scatter_bullets    = ds_list_create();
mortar_timer       = 0;

// ===================================================================
// SCREENSHAKE & INTERAL CONFIG AUDIO MANAGER
// ===================================================================
cam_shake_amount = 0;
cam_shake_decay  = 0.92; 

current_bgm = sound_bgm_boss_phase1;
audio_play_sound(current_bgm, 1, true);