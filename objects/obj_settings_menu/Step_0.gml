/// @description Logika Input - Responsif & Steril Sound Menu

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
    
    var slider_clicked_this_frame = false;

    // ==========================================
    // 1. LOGIKA SLIDER VOLUME
    // ==========================================
    for (var i = 0; i < total_sliders; i++) {
        var s_x1 = x - (slider_w / 2);
        var s_y  = y + slider_yy[i];

        var current_vol = variable_global_get(slider_global_var[i]);
        if (is_undefined(current_vol)) current_vol = 1.0;

        if (mouse_pressed
        &&  mouse_gui_x >= s_x1 - 15 && mouse_gui_x <= s_x1 + slider_w + 15
        &&  mouse_gui_y >= s_y - 15 && mouse_gui_y <= s_y + 15) {
            slider_is_dragging[i] = true;
            slider_clicked_this_frame = true;
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

    var any_slider_active = false;
    for (var j = 0; j < total_sliders; j++) {
        if (slider_is_dragging[j] == true) {
            any_slider_active = true;
        }
    }

    // ==========================================
    // 2. LOGIKA TOMBOL (STERIL DARI LEAK SOUND)
    // ==========================================
    if (!any_slider_active && !slider_clicked_this_frame) {
        
        // --- LOGIKA TOMBOL FULLSCREEN ---
        var fs_x1 = x - (btn_fs_w / 2);
        var fs_x2 = x + (btn_fs_w / 2);
        var fs_y1 = y + btn_fs_y - (btn_fs_h / 2);
        var fs_y2 = y + btn_fs_y + (btn_fs_h / 2);

        if (mouse_pressed
        &&  mouse_gui_x >= fs_x1 && mouse_gui_x <= fs_x2
        &&  mouse_gui_y >= fs_y1 && mouse_gui_y <= fs_y2) {
            
            var current_fs = window_get_fullscreen();
            window_set_fullscreen(!current_fs);
            
            // ⚡ FIX: Hanya bunyikan sound_menu jika sedang berada di room menu utama
            if (room == rm_menu) {
                if (!audio_is_playing(sound_menu)) {
                    audio_play_sound(sound_menu, 10, false);
                }
            }
        }

        // --- LOGIKA TOMBOL BACK & INPUT ESC ---
        var b_x1 = x - (btn_back_w / 2);
        var b_x2 = x + (btn_back_w / 2);
        var b_y1 = y + btn_back_y - (btn_back_h / 2);
        var b_y2 = y + btn_back_y + (btn_back_h / 2);

        var esc_ditutup = keyboard_check_pressed(vk_escape);

        if ((mouse_pressed && mouse_gui_x >= b_x1 && mouse_gui_x <= b_x2 && mouse_gui_y >= b_y1 && mouse_gui_y <= b_y2) || esc_ditutup) {
            is_closing = true;
            scr_save_settings();

            // Sesuai perbaikan kemarin, tombol back hanya berbunyi di rm_menu
            if (room == rm_menu) {
                if (!audio_is_playing(sound_menu)) {
                    audio_play_sound(sound_menu, 10, false);
                }
            }

            instance_activate_all();
            instance_destroy();
        }
    }
}