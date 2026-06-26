// Deteksi klik di posisi GUI
var gx = display_get_gui_width()  - 48;
var gy = 16;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Area klik 40x40 pixel di sekitar tombol
if (mouse_check_button_pressed(mb_left)) {
    if (mx >= gx - 20 && mx <= gx + 20
    &&  my >= gy - 20 && my <= gy + 20) {
        if (instance_number(obj_settings_menu) == 0) {
            instance_create_layer(
                display_get_gui_width()  / 2,
                display_get_gui_height() / 2,
                "Instances_1", obj_settings_menu
            );
        }
    }
}