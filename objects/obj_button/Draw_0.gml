// Gambar bayangan atau base-nya tetap di posisi asli
// Tapi gambar sprite-nya turun kalau ditekan
var _draw_y = y;
if (pressed) _draw_y += 4; // Terlihat turun 4 pixel secara visual saja

draw_sprite(sprite_index, image_index, x, _draw_y);