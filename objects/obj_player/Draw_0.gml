/// @description Render Player + Efek Kedip Kebal (I-Frames)

if (invincible_timer > 0) {
    // Karakter berkedip transparan setiap 4 frame sekali pas mode kebal aktif
    if ((invincible_timer div 4) mod 2 == 0) {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 0.25);
    } else {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 0.75);
    }
} else {
    // Gambar normal kalau gak kebal
    draw_self();
}