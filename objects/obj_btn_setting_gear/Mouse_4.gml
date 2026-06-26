/// @description Triger Pembukaan Menu Settings

// Mencegah menu terbuka ganda jika tombol diklik berulang kali
if (instance_number(obj_settings_menu) == 0) {
    var gui_x = display_get_gui_width() / 2;
    var gui_y = display_get_gui_height() / 2;
    
    // Munculkan menu settings tepat di tengah layar koordinat GUI
    instance_create_layer(gui_x, gui_y, "Instances_1", obj_settings_menu);
}