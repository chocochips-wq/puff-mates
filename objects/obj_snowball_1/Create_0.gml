hsp = 0;
vsp = 0;
grv = 0.25;

bullet_type = "ball";

// Warna proyektil
proj_color_r = 255;
proj_color_g = 0;
proj_color_b = 0;

// Ukuran dan rotasi
proj_size = 1.0;
proj_angle = 0;

// Lifetime
lifetime = 800;
lifetime_max = 800;

// Biar boss bullet bisa pakai life juga
life = lifetime;

// Spread effect
spread_amount = 0;
spread_timer = 0;
max_spread_distance = 0;

// Default snowball lama tetap pakai gravity
use_gravity = true;

// Bounce/reflect
bounce_count = 0;
max_bounces = 1;

// === REFLECT / INTERCEPT SYSTEM ===
owned_by_player = false;   // true = sudah diambil player, bergerak ke arah boss
owner_id        = noone;   // siapa yang intercept
intercept_timer = 0;       // cooldown setelah di-reflect agar tidak langsung kena player lagi
throw_speed     = 14;      // kecepatan saat dilempar balik