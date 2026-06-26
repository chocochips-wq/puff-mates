if (global.level_complete) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    
    txt_x = lerp(txt_x, txt_target_x, 0.08);
    
    draw_set_font(fnt_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // ── OUTLINE (gambar 8 arah) ──
    var ox = 2; // tebal outline, naikkan jika mau lebih tebal
    draw_set_colour(make_colour_rgb(0, 60, 120));
    draw_set_alpha(1);
    draw_text(txt_x - ox, gh/2 - ox, "Level Selesai!");
    draw_text(txt_x,      gh/2 - ox, "Level Selesai!");
    draw_text(txt_x + ox, gh/2 - ox, "Level Selesai!");
    draw_text(txt_x - ox, gh/2,      "Level Selesai!");
    draw_text(txt_x + ox, gh/2,      "Level Selesai!");
    draw_text(txt_x - ox, gh/2 + ox, "Level Selesai!");
    draw_text(txt_x,      gh/2 + ox, "Level Selesai!");
    draw_text(txt_x + ox, gh/2 + ox, "Level Selesai!");
    
    // ── TEKS UTAMA di atas outline ──
    draw_set_colour(c_yellow);
    draw_text(txt_x, gh/2, "Level Selesai!");
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}