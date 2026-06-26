// `obj_fortress_boss` draws the boss, HP bar, and handles phase background transitions.
draw_set_color(c_white);

// ==========================================
// 1. SAFETY VARIABLE
// ==========================================
if (!variable_instance_exists(id, "top_turret_x")) {
    top_turret_x    = x + 80;
    bottom_turret_x = x - 80;
    turret_y        = y + 80;
}

// ==========================================
// 2. WARNA PALETTE BOSS
// ==========================================
var c_body   = make_color_rgb(190, 195, 200);
var c_dark   = make_color_rgb(90, 95, 100);
var c_shadow = make_color_rgb(60, 63, 68);

if (hit_flash > 0 && (hit_flash div 2) mod 2 == 0) {
    c_body = c_white;
    c_dark = make_color_rgb(200, 200, 200);
}

// ==========================================
// 3. POSISI BOSS
// ==========================================
var bob = sin(bob_time) * 5;

var bx = x;
var by = y + bob;

var rtx = top_turret_x;
var ltx = bottom_turret_x;
var ty  = turret_y + bob;

// ==========================================
// 4. SAMBUNGAN KE TURRET
// ==========================================
draw_set_color(c_dark);

draw_rectangle(rtx - 10, by + 35, rtx + 10, ty + 20, false);
draw_rectangle(ltx - 10, by + 35, ltx + 10, ty + 20, false);

// ==========================================
// 5. BADAN UTAMA HORIZONTAL
// ==========================================
draw_set_color(c_body);
draw_rectangle(bx - 90, by - 45, bx + 90, by + 40, false);

draw_set_color(c_dark);
draw_rectangle(bx - 30, by - 40, bx + 30, by + 35, false);

draw_set_color(c_body);
draw_rectangle(bx - 25, by - 35, bx + 25, by + 30, false);

draw_set_color(make_color_rgb(220, 225, 230));
draw_rectangle(bx - 90, by - 45, bx + 90, by - 37, false);

// ==========================================
// 6. TURRET KANAN
// ==========================================
draw_set_color(c_dark);
draw_rectangle(rtx - 35, ty - 35, rtx + 35, ty + 40, false);

draw_set_color(c_body);
draw_rectangle(rtx - 30, ty - 30, rtx + 30, ty + 35, false);

draw_set_color(c_dark);

var top_start_x = rtx;
var top_start_y = ty + 40;

var turret_tip_x = top_start_x + lengthdir_x(55, top_angle);
var turret_tip_y = top_start_y + lengthdir_y(55, top_angle);

draw_line_width(top_start_x, top_start_y, turret_tip_x, turret_tip_y, 12);

draw_set_color(c_body);
draw_line_width(top_start_x, top_start_y, turret_tip_x, turret_tip_y, 7);

if (!top_destroyed) {
    var pulse = sin(pulse_time * 3) * 3;

    draw_set_alpha(0.3);
    draw_set_color(make_color_rgb(255, 60, 60));
    draw_circle(rtx, ty, 18 + pulse, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(230, 40, 40));
    draw_circle(rtx, ty, 10, false);

    draw_set_color(make_color_rgb(255, 120, 120));
    draw_circle(rtx - 3, ty - 3, 4, false);

    if (phase >= 2 && top_stomp_timer > 0) {
        var prog = top_stomp_timer / STOMP_WINDOW;

        draw_set_color(make_color_rgb(255, 220, 0));
        draw_set_alpha(prog);
        draw_circle(rtx, ty, 22, true);
        draw_set_alpha(1);
    }
} else {
    draw_set_color(c_shadow);
    draw_circle(rtx, ty, 12, false);

    draw_set_color(make_color_rgb(40, 40, 40));
    draw_circle(rtx, ty, 7, false);
}

// ==========================================
// 7. TURRET KIRI
// ==========================================
draw_set_color(c_dark);
draw_rectangle(ltx - 35, ty - 35, ltx + 35, ty + 40, false);

draw_set_color(c_body);
draw_rectangle(ltx - 30, ty - 30, ltx + 30, ty + 35, false);

draw_set_color(c_dark);

var bottom_start_x = ltx;
var bottom_start_y = ty + 40;

var bturret_tip_x = bottom_start_x + lengthdir_x(55, bottom_angle);
var bturret_tip_y = bottom_start_y + lengthdir_y(55, bottom_angle);

draw_line_width(bottom_start_x, bottom_start_y, bturret_tip_x, bturret_tip_y, 12);

draw_set_color(c_body);
draw_line_width(bottom_start_x, bottom_start_y, bturret_tip_x, bturret_tip_y, 7);

if (!bottom_destroyed) {
    var pulse2 = sin(pulse_time * 3 + 1.5) * 3;

    draw_set_alpha(0.3);
    draw_set_color(make_color_rgb(255, 60, 60));
    draw_circle(ltx, ty, 18 + pulse2, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(230, 40, 40));
    draw_circle(ltx, ty, 10, false);

    draw_set_color(make_color_rgb(255, 120, 120));
    draw_circle(ltx - 3, ty - 3, 4, false);

    if (phase >= 2 && bottom_stomp_timer > 0) {
        var prog2 = bottom_stomp_timer / STOMP_WINDOW;

        draw_set_color(make_color_rgb(255, 220, 0));
        draw_set_alpha(prog2);
        draw_circle(ltx, ty, 22, true);
        draw_set_alpha(1);
    }
} else {
    draw_set_color(c_shadow);
    draw_circle(ltx, ty, 12, false);

    draw_set_color(make_color_rgb(40, 40, 40));
    draw_circle(ltx, ty, 7, false);
}

// ==========================================
// 8. INTI UTAMA
// ==========================================
if (top_destroyed && bottom_destroyed) {
    var pulse3 = sin(pulse_time * 5) * 5;

    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(255, 30, 30));
    draw_circle(bx, by + 5, 35 + pulse3, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(220, 40, 40));
    draw_circle(bx, by + 5, 22, false);

    draw_set_color(make_color_rgb(255, 100, 100));
    draw_circle(bx - 6, by - 1, 9, false);

    if (main_stomp_timer > 0) {
        var prog3 = main_stomp_timer / STOMP_WINDOW;

        draw_set_color(make_color_rgb(255, 220, 0));
        draw_set_alpha(prog3);
        draw_circle(bx, by + 5, 40, true);
        draw_set_alpha(1);
    }
}

// ==========================================
// 9. HEALTH BAR
// ==========================================
if (hp > 0) {
    var bar_w = 400;
    var bar_h = 20;
    var bar_x = (room_width / 2) - bar_w / 2;
    var bar_y = 30;

    draw_set_alpha(0.4);
    draw_set_color(c_black);
    draw_rectangle(bar_x + 3, bar_y + 3, bar_x + bar_w + 3, bar_y + bar_h + 3, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(60, 60, 60));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

    var fill_w = (hp / max_hp) * (bar_w - 4);

    var bar_color;

    if (phase == 1) {
        bar_color = make_color_rgb(80, 200, 80);
    } else if (phase == 2) {
        bar_color = make_color_rgb(255, 160, 30);
    } else {
        bar_color = make_color_rgb(220, 40, 40);
    }

    draw_set_color(bar_color);
    draw_rectangle(bar_x + 2, bar_y + 2, bar_x + 2 + fill_w, bar_y + bar_h - 2, false);

    draw_set_color(c_white);
    draw_set_alpha(0.25);
    draw_rectangle(bar_x + 2, bar_y + 2, bar_x + 2 + fill_w, bar_y + 8, false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text(bar_x + bar_w / 2, bar_y - 4, "MEGA BOT-9000");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ==========================================
// 10. BACKGROUND OVERLAYS
// ==========================================
if (phase == 3) {
    var seed = 98765;

    random_set_seed(seed);

    draw_set_alpha(0.6);

    for (var i = 0; i < 50; i++) {
        var sx = random(room_width);
        var sy = random(room_height * 0.7);

        draw_set_color(c_white);
        draw_circle(sx, sy, 1, false);
    }

    draw_set_alpha(1);
    random_set_seed(current_time);
}

if (flash_alpha > 0.02) {
    draw_set_alpha(flash_alpha * 0.35);
    draw_set_color(c_white);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);