// === RED PROJECTILE VISUAL (Pico Park Style) ===
// Hitung alpha berdasarkan lifetime (fade saat akan hilang)
var alpha_fade = 1.0;
if (lifetime < 30) {
    alpha_fade = lifetime / 30; // Fade out di 30 frame terakhir
}

draw_set_alpha(alpha_fade);

// === OUTER GLOW ===
// Glow di sekitar bola untuk efek energi
draw_set_color(make_color_rgb(255, 80, 80));
draw_set_alpha(alpha_fade * 0.25);
draw_circle(x, y, 12, false);

// === BOLA UTAMA ===
// Warna merah cerah (Pico Park style)
draw_set_color(make_color_rgb(255, 40, 40));
draw_set_alpha(alpha_fade);
draw_circle(x, y, 8, false);

// === HIGHLIGHT/SHINE ===
// Shine effect (cahaya kecil untuk dimensi)
draw_set_color(make_color_rgb(255, 120, 100));
draw_set_alpha(alpha_fade * 0.7);
draw_circle(x - 3, y - 3, 3, false);

// === INNER CORE ===
// Dark core untuk depth
draw_set_color(make_color_rgb(200, 20, 20));
draw_set_alpha(alpha_fade * 0.5);
draw_circle(x + 2, y + 2, 2, false);

// === TRAIL EFFECT (motion blur) ===
if (sqrt(hsp*hsp + vsp*vsp) > 0.5) {
    // Gambar shadow kecil di belakang proyektil
    draw_set_alpha(alpha_fade * 0.15);
    draw_set_color(make_color_rgb(200, 20, 20));
    var trail_length = 3;
    for (var i = 1; i <= trail_length; i++) {
        var trail_x = x - (hsp * i * 0.4);
        var trail_y = y - (vsp * i * 0.4);
        var trail_size = 8 * (1 - i / trail_length);
        draw_circle(trail_x, trail_y, trail_size, false);
    }
}

// === RESET DRAW STATE ===
draw_set_color(c_white);
draw_set_alpha(1);