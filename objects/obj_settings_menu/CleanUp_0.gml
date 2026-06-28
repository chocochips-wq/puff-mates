/// @description Jaring Pengaman Akhir & Anti Kebocoran RAM

// 1. UNPAUSE MASSAL
instance_activate_all();

// 2. Bersihkan sampah sprite dari memori RAM
if (sprite_exists(pause_sprite)) {
    sprite_delete(pause_sprite);
}