hsp = 0;
vsp = 0;
grv = 0.25;
bullet_type = "ball"; // "ball" saja, roket pakai obj_rocket terpisah

// === BOSS RED PROJECTILE PROPERTIES ===
// Warna proyektil (untuk Draw_0)
proj_color_r = 255;
proj_color_g = 0;
proj_color_b = 0;

// Ukuran dan rotasi
proj_size = 1.0;
proj_angle = 0;

// Durasi lifetime (untuk fase 3 spread effect)
lifetime = 300;
lifetime_max = 300;

// Spread effect (fase 3)
spread_amount = 0;
spread_timer = 0;
max_spread_distance = 0;

// Gravitasi opsi (bisa diaktifkan untuk fase tertentu)
use_gravity = true;

// Bounce/reflect
bounce_count = 0;
max_bounces = 1;