/// @description Renders Dynamic Screen Warning (Phase 2 & Final Phase)

// ==========================================
// DYNAMIC WARNING TEXT (JEDA FASE 2 & FASE 3)
// ==========================================
var is_transisi_f1_to_f2 = (transisi_timer > 0 && hp > 0);
var is_transisi_f2_to_f3 = (variable_instance_exists(id, "jeda_fase3") && jeda_fase3 > 0);

if (is_transisi_f1_to_f2 || is_transisi_f2_to_f3) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    // Tentukan teks warning secara dinamis berdasarkan transisi mana yang aktif
    var warning_text = "WARNING: PHASE 2 STARTED!";
    if (is_transisi_f2_to_f3) {
        warning_text = "WARNING: FINAL PHASE STARTED!";
    }
    
    // Logika animasi berkedip menggunakan current_time div 300
    var blink = (current_time div 300) mod 2 == 0;
    if (blink) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fnt_title);
        
        // Shadow teks hitam biar kebaca di background apapun
        draw_set_color(c_black);
        draw_text(gui_w / 2 + 2, gui_h / 2 + 2, warning_text);
        
        // Teks utama merah menyala (Ulu Hati Kematian)
        draw_set_color(c_red);
        draw_text(gui_w / 2, gui_h / 2, warning_text);
    }
    
    // Reset kembali standarisasi draw state GameMaker biar gak bocor ke font lain
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}