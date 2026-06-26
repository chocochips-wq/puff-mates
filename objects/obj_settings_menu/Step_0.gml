/// @description Logika Input - Final

if (!variable_instance_exists(id, "is_closing")) {
    is_closing = false;
}

if (menu_scale < menu_target_scale) {
    menu_scale += anim_speed;
    if (menu_scale > menu_target_scale) menu_scale = menu_target_scale;
}

if (menu_scale >= 0.95 && !is_closing) {

    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);
    var mouse_click   = mouse_check_button(mb_left);
    var mouse_pressed = mouse_check_button_pressed(mb_left);
    var clicked = false;

    // SLIDER
    for (var i = 0; i < total_sliders; i++) {
        var s_x1 = x - (slider_w / 2);
        var s_y  = y + slider_yy[i];

        var current_vol = variable_global_get(slider_global_var[i]);
        if (is_undefined(current_vol)) current_vol = 1.0;

        if (mouse_pressed && !clicked
        &&  mouse_gui_x >= s_x1 && mouse_gui_x <= s_x1 + slider_w
        &&  mouse_gui_y >= s_y - 16 && mouse_gui_y <= s_y + 16) {
            slider_is_dragging[i] = true;
            clicked = true;
        }

        if (slider_is_dragging[i]) {
            if (!mouse_click) {
                slider_is_dragging[i] = false;
                scr_save_settings();
            } else {
                var new_vol = clamp((mouse_gui_x - s_x1) / slider_w, 0.0, 1.0);
                variable_global_set(slider_global_var[i], new_vol);
                scr_apply_settings();
            }
        }
    }

    // TOMBOL MUTE ALL
    var m_x1 = x - (btn_mute_w / 2);
    var m_x2 = x + (btn_mute_w / 2);
    var m_y1 = y + btn_mute_y - (btn_mute_h / 2);
    var m_y2 = y + btn_mute_y + (btn_mute_h / 2);

    if (mouse_pressed && !clicked
    &&  mouse_gui_x >= m_x1 && mouse_gui_x <= m_x2
    &&  mouse_gui_y >= m_y1 && mouse_gui_y <= m_y2) {
        global.mute_all = !global.mute_all;
        scr_apply_settings();
        scr_save_settings();
        clicked = true;
    }

    // TOMBOL BACK
    var b_x1 = x - (btn_back_w / 2);
    var b_x2 = x + (btn_back_w / 2);
    var b_y1 = y + btn_back_y - (btn_back_h / 2);
    var b_y2 = y + btn_back_y + (btn_back_h / 2);

    if (mouse_pressed && !clicked && !is_closing
    &&  mouse_gui_x >= b_x1 && mouse_gui_x <= b_x2
    &&  mouse_gui_y >= b_y1 && mouse_gui_y <= b_y2) {
        clicked = true;
        is_closing = true;
        scr_save_settings();

        if (!audio_is_playing(sound_menu)) {
            audio_play_sound(sound_menu, 10, false);
        }

        instance_destroy();
    }
}