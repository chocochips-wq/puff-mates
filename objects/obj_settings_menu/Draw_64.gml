/// @description Render Visual Interface Settings

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
if (!variable_global_exists("vol_music"))  global.vol_music  = 1.0;
if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;
if (!variable_global_exists("mute_all"))   global.mute_all   = false;

// Overlay gelap
draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.0);

// Panel
var x1 = x - (menu_width  / 2) * menu_scale;
var y1 = y - (menu_height / 2) * menu_scale;
var x2 = x + (menu_width  / 2) * menu_scale;
var y2 = y + (menu_height / 2) * menu_scale;

draw_set_color(make_color_rgb(20, 22, 26));
draw_rectangle(x1 + 6, y1 + 6, x2 + 6, y2 + 6, false);
draw_set_color(make_color_rgb(33, 37, 43));
draw_rectangle(x1, y1, x2, y2, false);
draw_set_color(make_color_rgb(92, 99, 112));
draw_rectangle(x1, y1, x2, y2, true);

if (menu_scale >= 0.95) {

    // Judul
    draw_set_font(fnt_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(224, 108, 117));
    draw_text(x, y1 + 20, "AUDIO SETTINGS");
    draw_set_font(-1);
    draw_set_valign(fa_middle);

    // Slider
    for (var i = 0; i < total_sliders; i++) {
        var s_x1 = x - (slider_w / 2);
        var s_x2 = x + (slider_w / 2);
        var s_y  = y + slider_yy[i];

        var current_vol = variable_global_get(slider_global_var[i]);
        if (is_undefined(current_vol)) current_vol = 1.0;
        var knob_x = s_x1 + (current_vol * slider_w);

        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_text(s_x1, s_y - 20, slider_name[i]);

        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(152, 195, 121));
        draw_text(s_x2, s_y - 20, string(round(current_vol * 100)) + "%");

        draw_set_color(make_color_rgb(44, 49, 56));
        draw_rectangle(s_x1, s_y - (slider_h/2), s_x2, s_y + (slider_h/2), false);

        if (current_vol > 0) {
            draw_set_color(make_color_rgb(0, 220, 220));
            draw_rectangle(s_x1, s_y - (slider_h/2), knob_x, s_y + (slider_h/2), false);
        }

        draw_set_color(c_white);
        draw_circle(knob_x, s_y, knob_r, false);
        draw_set_color(make_color_rgb(92, 99, 112));
        draw_circle(knob_x, s_y, knob_r, true);
    }

    // TOMBOL MUTE ALL
    var m_x1 = x - (btn_mute_w / 2);
    var m_x2 = x + (btn_mute_w / 2);
    var m_y1 = y + btn_mute_y - (btn_mute_h / 2);
    var m_y2 = y + btn_mute_y + (btn_mute_h / 2);
    var mute_hover = (mouse_gui_x >= m_x1 && mouse_gui_x <= m_x2
                   && mouse_gui_y >= m_y1 && mouse_gui_y <= m_y2);

    draw_set_color(global.mute_all ? make_color_rgb(200, 60, 60) : (mute_hover ? make_color_rgb(92, 99, 112) : make_color_rgb(44, 49, 56)));
    draw_rectangle(m_x1, m_y1, m_x2, m_y2, false);
    draw_set_color(make_color_rgb(151, 161, 177));
    draw_rectangle(m_x1, m_y1, m_x2, m_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x, y + btn_mute_y, global.mute_all ? "UNMUTE ALL" : "MUTE ALL");

    // TOMBOL BACK
    var b_x1 = x - (btn_back_w / 2);
    var b_x2 = x + (btn_back_w / 2);
    var b_y1 = y + btn_back_y - (btn_back_h / 2);
    var b_y2 = y + btn_back_y + (btn_back_h / 2);
    var back_hover = (mouse_gui_x >= b_x1 && mouse_gui_x <= b_x2
                   && mouse_gui_y >= b_y1 && mouse_gui_y <= b_y2);

    draw_set_color(back_hover ? make_color_rgb(224, 108, 117) : make_color_rgb(44, 49, 56));
    draw_rectangle(b_x1, b_y1, b_x2, b_y2, false);
    draw_set_color(make_color_rgb(151, 161, 177));
    draw_rectangle(b_x1, b_y1, b_x2, b_y2, true);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x, y + btn_back_y, "BACK");
}

// Reset
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);