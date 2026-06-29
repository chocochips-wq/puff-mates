/// @description Full Render Juggernaut + Partikel Ledakan Organik
// ===================================================================
// SOLUSI BYPASS MATRIX: GETARKAN MATRIX PROYEKSI SECARA PAKSA!
// ===================================================================
if (variable_instance_exists(id, "cam_shake_amount") && cam_shake_amount > 0.5) {
    var _x_offset = random_range(-cam_shake_amount, cam_shake_amount);
    var _y_offset = random_range(-cam_shake_amount, cam_shake_amount);
    
    // Tarik paksa matrix proyeksi dunia game (Bypass Lock Viewport Player!)
    var _mat = matrix_get(matrix_view);
    _mat[12] += _x_offset;
    _mat[13] += _y_offset;
    matrix_set(matrix_view, _mat);
}

if (!boss_fully_dead) {

    draw_set_color(c_white);

    if (!variable_instance_exists(id, "draw_hp_fase2")) draw_hp_fase2 = 10;
    var target_hp_fase2 = core_top_hp + core_bottom_hp;
    draw_hp_fase2 = lerp(draw_hp_fase2, target_hp_fase2, 0.1);

    var c_border      = c_black;
    var c_armor_dark  = make_color_rgb(60, 64, 67);
    var c_armor_mid   = make_color_rgb(98, 102, 105);
    var c_armor_light = make_color_rgb(140, 145, 148);

    if (is_enraged && (enrage_flash_timer div 4) mod 2 == 0) {
        c_armor_dark = make_color_rgb(80, 20, 20);
        c_armor_mid  = make_color_rgb(120, 40, 40);
    }
    if (hit_flash > 0 && (hit_flash div 2) mod 2 == 0) {
        c_armor_dark = c_white; c_armor_mid = c_white; c_armor_light = c_white;
    }

    var bob            = sin(bob_time) * 5;
    var bx             = xstart;
    var by             = ystart + bob;
    var lx             = bx - 185;
    var rx             = bx + 185;
    var laras_y_offset = by + 20;
    var core_target_y  = by + 45;

    // LAYER 1: PIPA HIDROLIK
    draw_set_color(c_border);     draw_rectangle(bx - 170, by - 24, bx + 170, by + 24, false);
    draw_set_color(c_armor_dark); draw_rectangle(bx - 166, by - 18, bx + 166, by + 18, false);

    // LAYER 2: BODI UTAMA
    var b_w = 115; var b_h = 100;
    draw_set_color(c_border);     draw_rectangle(bx - b_w - 2, by - b_h - 2, bx + b_w + 2, by + b_h + 2, false);
    draw_set_color(c_armor_dark); draw_rectangle(bx - b_w, by - b_h, bx + b_w, by + b_h, false);

    // CORE TENGAH
    var pulse3 = sin(pulse_time * 5) * 5;
    if (door_open_offset > 5 || (jeda_fase3 > 0 && jeda_fase3 <= 150)) {
        var core_r = is_enraged ? 255 : 220;
        var core_g = is_enraged ? 0   : 40;
        draw_set_color(c_border); draw_circle(bx, core_target_y, 38, false);
        draw_set_alpha(0.4); draw_set_color(make_color_rgb(core_r, core_g, 30)); draw_circle(bx, core_target_y, 34 + pulse3, false); draw_set_alpha(1);
        draw_set_color(make_color_rgb(core_r - 35, core_g + 10, 40)); draw_circle(bx, core_target_y, 26, false);
        draw_set_color(make_color_rgb(255, 120, 120)); draw_circle(bx - 6, core_target_y - 6, 9, false);
    }

    // PINTU GERBANG
    var p_kiri_x1 = bx - b_w + 8 - door_open_offset; var p_kiri_x2 = bx - door_open_offset;
    if (p_kiri_x2 > bx - b_w + 8) {
        draw_set_color(c_border); draw_rectangle(p_kiri_x1 - 2, by - b_h + 6, p_kiri_x2 + 2, by + b_h - 6, false);
        draw_set_color(c_armor_mid); draw_rectangle(p_kiri_x1, by - b_h + 8, p_kiri_x2, by + b_h - 8, false);
    }
// PINTU GERBANG (KANAN)
    var p_kanan_x1 = bx + door_open_offset; var p_kanan_x2 = bx + b_w - 8 + door_open_offset;
    if (p_kanan_x1 < bx + b_w - 8) {
        draw_set_color(c_border); draw_rectangle(p_kanan_x1 - 2, by - b_h + 6, p_kanan_x2 + 2, by + b_h - 6, false);
        draw_set_color(c_armor_mid); draw_rectangle(p_kanan_x1, by - b_h + 8, p_kanan_x2, by + b_h - 8, false);
    }
    if (door_open_offset <= 1) { draw_set_color(c_border); draw_line_width(bx, by - b_h + 18, bx, by + b_h - 18, 4); }

    // ===================================================================
    // LAYER 3: KOTAK TURRET
    // ===================================================================
    var t_width = 75; var t_height = 110;
    var x1_l = -t_width; var y1_l = -t_height / 2;
    var x2_l =  t_width; var y2_l =  t_height / 2;
    var ix1_l = -t_width + 20; var iy1_l = -t_height / 2 + 20;
    var ix2_l =  t_width - 20; var iy2_l =  t_height / 2 - 20;

    // KOTAK KIRI
    var target_l_y = (bottom_destroyed || phase == 3) ? puing_l_y : laras_y_offset;
    var c_l_base   = (phase == 3 || bottom_destroyed) ? make_color_rgb(30, 32, 35) : c_armor_dark;
    var c_l_panel  = (phase == 3 || bottom_destroyed) ? make_color_rgb(45, 48, 50) : c_armor_mid;
    var angle_l    = (bottom_destroyed || phase == 3) ? puing_l_angle : 0;
    if (jeda_fase3 > 450) target_l_y = laras_y_offset;
    if (phase == 3) draw_set_alpha(magnet_progress);

    var cos_l = dcos(angle_l); var sin_l = dsin(angle_l);
    var lx1 = lx + (x1_l*cos_l - y1_l*sin_l); var ly1 = target_l_y + (x1_l*sin_l + y1_l*cos_l);
    var lx2 = lx + (x2_l*cos_l - y1_l*sin_l); var ly2 = target_l_y + (x2_l*sin_l + y1_l*cos_l);
    var lx3 = lx + (x2_l*cos_l - y2_l*sin_l); var ly3 = target_l_y + (x2_l*sin_l + y2_l*cos_l);
    var lx4 = lx + (x1_l*cos_l - y2_l*sin_l); var ly4 = target_l_y + (x1_l*sin_l + y2_l*cos_l);
    draw_set_color(c_border);  draw_primitive_begin(pr_trianglefan); draw_vertex(lx1,ly1); draw_vertex(lx2,ly2); draw_vertex(lx3,ly3); draw_vertex(lx4,ly4); draw_primitive_end();
    draw_set_color(c_l_base);  draw_primitive_begin(pr_trianglefan); draw_vertex(lx1+2,ly1+2); draw_vertex(lx2-2,ly2+2); draw_vertex(lx3-2,ly3-2); draw_vertex(lx4+2,ly4-2); draw_primitive_end();
    var ilx1 = lx+(ix1_l*cos_l-iy1_l*sin_l); var ily1 = target_l_y+(ix1_l*sin_l+iy1_l*cos_l);
    var ilx2 = lx+(ix2_l*cos_l-iy1_l*sin_l); var ily2 = target_l_y+(ix2_l*sin_l+iy1_l*cos_l);
    var ilx3 = lx+(ix2_l*cos_l-iy2_l*sin_l); var ily3 = target_l_y+(ix2_l*sin_l+iy2_l*cos_l);
    var ilx4 = lx+(ix1_l*cos_l-iy2_l*sin_l); var ily4 = target_l_y+(ix1_l*sin_l+iy2_l*cos_l);
    draw_set_color(c_border);  draw_primitive_begin(pr_trianglefan); draw_vertex(ilx1,ily1); draw_vertex(ilx2,ily2); draw_vertex(ilx3,ily3); draw_vertex(ilx4,ily4); draw_primitive_end();
    draw_set_color(c_l_panel); draw_primitive_begin(pr_trianglefan); draw_vertex(ilx1+2,ily1+2); draw_vertex(ilx2-2,ily2+2); draw_vertex(ilx3-2,ily3-2); draw_vertex(ilx4+2,ily4-2); draw_primitive_end();

    // CRACK KIRI
    if (phase == 2 && !bottom_destroyed && core_bottom_hp < 5) {
        random_set_seed(crack_seed_l + core_bottom_hp);
        draw_set_color(c_black); draw_set_alpha(0.7);
        var crack_count = (5 - core_bottom_hp) * 2;
        for (var ci = 0; ci < crack_count; ci++) {
            var cx1 = lx + random_range(-50, 50); var cy1 = target_l_y + random_range(-40, 40);
            draw_line_width(cx1, cy1, cx1 + random_range(-20, 20), cy1 + random_range(-20, 20), 2);
            draw_line_width(cx1, cy1, cx1 + random_range(-15, 15), cy1 + random_range(-15, 15), 1);
        }
        draw_set_alpha(1.0); random_set_seed(current_time);
    }
    draw_set_alpha(1.0);

    // KOTAK KANAN
    var target_r_y = (top_destroyed || phase == 3) ? puing_r_y : laras_y_offset;
    var c_r_base   = (phase == 3 || top_destroyed) ? make_color_rgb(30, 32, 35) : c_armor_dark;
    var c_r_panel  = (phase == 3 || top_destroyed) ? make_color_rgb(45, 48, 50) : c_armor_mid;
    var angle_r    = (top_destroyed || phase == 3) ? puing_r_angle : 0;
    if (jeda_fase3 > 450) target_r_y = laras_y_offset;
    if (phase == 3) draw_set_alpha(magnet_progress);

    var cos_r = dcos(angle_r); var sin_r = dsin(angle_r);
    var rx1 = rx+(x1_l*cos_r-y1_l*sin_r); var ry1 = target_r_y+(x1_l*sin_r+y1_l*cos_r);
    var rx2 = rx+(x2_l*cos_r-y1_l*sin_r); var ry2 = target_r_y+(x2_l*sin_r+y1_l*cos_r);
    var rx3 = rx+(x2_l*cos_r-y2_l*sin_r); var ry3 = target_r_y+(x2_l*sin_r+y2_l*cos_r);
    var rx4 = rx+(x1_l*cos_r-y2_l*sin_r); var ry4 = target_r_y+(x1_l*sin_r+y2_l*cos_r);
    draw_set_color(c_border);  draw_primitive_begin(pr_trianglefan); draw_vertex(rx1,ry1); draw_vertex(rx2,ry2); draw_vertex(rx3,ry3); draw_vertex(rx4,ry4); draw_primitive_end();
    draw_set_color(c_r_base);  draw_primitive_begin(pr_trianglefan); draw_vertex(rx1+2,ry1+2); draw_vertex(rx2-2,ry2+2); draw_vertex(rx3-2,ry3-2); draw_vertex(rx4+2,ry4-2); draw_primitive_end();
    var irx1 = rx+(ix1_l*cos_r-iy1_l*sin_r); var iry1 = target_r_y+(ix1_l*sin_r+iy1_l*cos_r);
    var irx2 = rx+(ix2_l*cos_r-iy1_l*sin_r); var iry2 = target_r_y+(ix2_l*sin_r+iy2_l*cos_r);
    var irx3 = rx+(ix2_l*cos_r-iy2_l*sin_r); var iry3 = target_r_y+(ix2_l*sin_r+iy2_l*cos_r);
    var irx4 = rx+(ix1_l*cos_r-iy2_l*sin_r); var iry4 = target_r_y+(ix1_l*sin_r+iy2_l*cos_r);
    draw_set_color(c_border);  draw_primitive_begin(pr_trianglefan); draw_vertex(irx1,iry1); draw_vertex(irx2,iry2); draw_vertex(irx3,iry3); draw_vertex(irx4,iry4); draw_primitive_end();
    draw_set_color(c_r_panel); draw_primitive_begin(pr_trianglefan); draw_vertex(irx1+2,iry1+2); draw_vertex(irx2-2,iry2+2); draw_vertex(irx3-2,iry3-2); draw_vertex(irx4+2,iry4-2); draw_primitive_end();

    // CRACK KANAN
    if (phase == 2 && !top_destroyed && core_top_hp < 5) {
        random_set_seed(crack_seed_r + core_top_hp);
        draw_set_color(c_black); draw_set_alpha(0.7);
        var crack_count_r = (5 - core_top_hp) * 2;
        for (var ci = 0; ci < crack_count_r; ci++) {
            var crx1 = rx + random_range(-50, 50); var cry1 = target_r_y + random_range(-40, 40);
            draw_line_width(crx1, cry1, crx1 + random_range(-20, 20), cry1 + random_range(-20, 20), 2);
            draw_line_width(crx1, cry1, crx1 + random_range(-15, 15), cry1 + random_range(-15, 15), 1);
        }
        draw_set_alpha(1.0); random_set_seed(current_time);
    }
    draw_set_alpha(1.0);

    // ===================================================================
    // RENDER PARTIKEL LEDAKAN ORGANIK
    // ===================================================================
    for (var _pi = 0; _pi < expl_max; _pi++) {
        // PARTIKEL KIRI
        if (expl_l_life[_pi] > 0) {
            var _lratio = expl_l_life[_pi] / expl_l_maxlife[_pi];
            var _lalpha = _lratio;
            var _lsize  = expl_l_size[_pi] * _lratio;
            draw_set_alpha(_lalpha);

            if (expl_l_type[_pi] == 0) {
                draw_set_color(make_color_rgb(255, lerp(60, 220, _lratio), 0));
                draw_circle(expl_l_x[_pi], expl_l_y[_pi], max(1, _lsize), false);
                draw_set_alpha(_lalpha * 0.5);
                draw_line_width(expl_l_x[_pi], expl_l_y[_pi],
                    expl_l_x[_pi] - expl_l_hsp[_pi] * 2,
                    expl_l_y[_pi] - expl_l_vsp[_pi] * 2, max(1, _lsize * 0.6));
            } else if (expl_l_type[_pi] == 1) {
                draw_set_color(make_color_rgb(255, lerp(20, 140, _lratio), 0));
                draw_circle(expl_l_x[_pi], expl_l_y[_pi], max(1.5, _lsize * 1.3), false);
                draw_set_alpha(_lalpha * 0.2);
                draw_set_color(make_color_rgb(255, 100, 0));
                draw_circle(expl_l_x[_pi], expl_l_y[_pi], max(2, _lsize * 2.2), false);
            } else {
                draw_set_color(make_color_rgb(60, 55, 50));
                draw_set_alpha(_lalpha * 0.35);
                draw_circle(expl_l_x[_pi], expl_l_y[_pi], max(3, _lsize * 2.5), false);
            }
        }

        // PARTIKEL KANAN
        if (expl_r_life[_pi] > 0) {
            var _rratio = expl_r_life[_pi] / expl_r_maxlife[_pi];
            var _ralpha = _rratio;
            var _rsize  = expl_r_size[_pi] * _rratio;
            draw_set_alpha(_ralpha);

            if (expl_r_type[_pi] == 0) {
                draw_set_color(make_color_rgb(255, lerp(60, 220, _rratio), 0));
                draw_circle(expl_r_x[_pi], expl_r_y[_pi], max(1, _rsize), false);
                draw_set_alpha(_ralpha * 0.5);
                draw_line_width(expl_r_x[_pi], expl_r_y[_pi],
                    expl_r_x[_pi] - expl_r_hsp[_pi] * 2,
                    expl_r_y[_pi] - expl_r_vsp[_pi] * 2, max(1, _rsize * 0.6));
            } else if (expl_r_type[_pi] == 1) {
                draw_set_color(make_color_rgb(255, lerp(20, 140, _rratio), 0));
                draw_circle(expl_r_x[_pi], expl_r_y[_pi], max(1.5, _rsize * 1.3), false);
                draw_set_alpha(_ralpha * 0.2);
                draw_set_color(make_color_rgb(255, 100, 0));
                draw_circle(expl_r_x[_pi], expl_r_y[_pi], max(2, _rsize * 2.2), false);
            } else {
                draw_set_color(make_color_rgb(60, 55, 50));
                draw_set_alpha(_ralpha * 0.35);
                draw_circle(expl_r_x[_pi], expl_r_y[_pi], max(3, _rsize * 2.5), false);
            }
        }
    }

    // Inti flash ledakan
    if (expl_l_core_alpha > 0) {
        draw_set_alpha(expl_l_core_alpha * 0.9);
        draw_set_color(c_white);
        draw_circle(l_turret_x, laras_y_offset, expl_l_core_r, false);
        draw_set_alpha(expl_l_core_alpha * 0.5);
        draw_set_color(make_color_rgb(255, 200, 80));
        draw_circle(l_turret_x, laras_y_offset, expl_l_core_r * 1.8, false);
    }
    if (expl_r_core_alpha > 0) {
        draw_set_alpha(expl_r_core_alpha * 0.9);
        draw_set_color(c_white);
        draw_circle(r_turret_x, laras_y_offset, expl_r_core_r, false);
        draw_set_alpha(expl_r_core_alpha * 0.5);
        draw_set_color(make_color_rgb(255, 200, 80));
        draw_circle(r_turret_x, laras_y_offset, expl_r_core_r * 1.8, false);
    }

    draw_set_alpha(1.0);

    // ===================================================================
    // SAMBARAN PETIR (FRAME 100-0)
    // ===================================================================
    if (jeda_fase3 <= 100 && jeda_fase3 > 0) {
        draw_set_alpha(random_range(0.7, 1.0));
        var c_lc = make_color_rgb(0, 255, 240);
        var mid_lx1 = lerp(bx,lx,0.3)+irandom_range(-25,25); var mid_ly1 = lerp(core_target_y,target_l_y,0.3)+irandom_range(-25,25);
        var mid_lx2 = lerp(bx,lx,0.7)+irandom_range(-25,25); var mid_ly2 = lerp(core_target_y,target_l_y,0.7)+irandom_range(-25,25);
        draw_set_color(c_lc);
        draw_line_width(bx,core_target_y,mid_lx1,mid_ly1,5); draw_line_width(mid_lx1,mid_ly1,mid_lx2,mid_ly2,5); draw_line_width(mid_lx2,mid_ly2,lx,target_l_y,5);
        draw_set_color(c_white);
        draw_line_width(bx,core_target_y,mid_lx1,mid_ly1,2); draw_line_width(mid_lx1,mid_ly1,mid_lx2,mid_ly2,2); draw_line_width(mid_lx2,mid_ly2,lx,target_l_y,2);
        var mid_rx1 = lerp(bx,rx,0.3)+irandom_range(-25,25); var mid_ry1 = lerp(core_target_y,target_r_y,0.3)+irandom_range(-25,25);
        var mid_rx2 = lerp(bx,rx,0.7)+irandom_range(-25,25); var mid_ry2 = lerp(core_target_y,target_r_y,0.7)+irandom_range(-25,25);
        draw_set_color(c_lc);
        draw_line_width(bx,core_target_y,mid_rx1,mid_ry1,5); draw_line_width(mid_rx1,mid_ry1,mid_rx2,mid_ry2,5); draw_line_width(mid_rx2,mid_ry2,rx,target_r_y,5);
        draw_set_color(c_white);
        draw_line_width(bx,core_target_y,mid_rx1,mid_ry1,2); draw_line_width(mid_rx1,mid_ry1,mid_rx2,mid_ry2,2); draw_line_width(mid_rx2,mid_ry2,rx,target_r_y,2);
        draw_set_alpha(1.0);
    }

    // ===================================================================
    // PARTIKEL PUING MELAYANG
    // ===================================================================
    if (phase == 3 && magnet_progress < 1.0) {
        var seed_kid = 54321; random_set_seed(seed_kid);
        var ground_level = 710;
        for (var i = 0; i < 35; i++) {
            var start_x_l    = lx + random_range(-55, 55); var start_x_r = rx + random_range(-55, 55);
            var cur_puing_yl = lerp(ground_level-10, laras_y_offset+random_range(-20,20), magnet_progress);
            var cur_puing_yr = lerp(ground_level-10, laras_y_offset+random_range(-20,20), magnet_progress);
            draw_set_color(make_color_rgb(45, 48, 50));
            draw_rectangle(start_x_l-3, cur_puing_yl-5, start_x_l+3, cur_puing_yl+5, false);
            draw_rectangle(start_x_r-3, cur_puing_yr-5, start_x_r+3, cur_puing_yr+5, false);
        }
        random_set_seed(current_time);
    }

    // ===================================================================
    // PERBAIKAN: BLOK PENGGAMBARAN VOLT-TETHER (AYUNAN PERSEGI) DIHAPUS
    // ===================================================================

    // LARAS MERIAM
    draw_set_color(c_border);
    if (!bottom_destroyed && phase != 3 && jeda_fase3 <= 0) {
        var tl_x = lx+lengthdir_x(90,top_angle); var tl_y = laras_y_offset+lengthdir_y(90,top_angle);
        draw_line_width(lx,laras_y_offset,tl_x,tl_y,26); draw_set_color(c_armor_mid); draw_line_width(lx,laras_y_offset,tl_x,tl_y,16);
    }
    draw_set_color(c_border);
    if (!top_destroyed && phase != 3 && jeda_fase3 <= 0) {
        var tr_x = rx+lengthdir_x(90,bottom_angle); var tr_y = laras_y_offset+lengthdir_y(90,bottom_angle);
        draw_line_width(rx,laras_y_offset,tr_x,tr_y,26); draw_set_color(c_armor_mid); draw_line_width(rx,laras_y_offset,tr_x,tr_y,16);
    }
    if (phase != 3 && jeda_fase3 <= 0) {
        draw_set_color(!bottom_destroyed ? make_color_rgb(230,40,40) : make_color_rgb(40,40,40)); draw_circle(lx, laras_y_offset, 16, false);
        draw_set_color(!top_destroyed    ? make_color_rgb(230,40,40) : make_color_rgb(40,40,40)); draw_circle(rx, laras_y_offset, 16, false);
    }

    // ===================================================================
    // HEALTH BAR
    // ===================================================================
    if (hp > 0 || phase == 3 || jeda_fase3 > 0) {
        var bar_w = 400; var bar_h = 20;
        var bar_x = (room_width/2) - bar_w/2; var bar_y = 30;
        draw_set_alpha(0.4); draw_set_color(c_black); draw_rectangle(bar_x+3,bar_y+3,bar_x+bar_w+3,bar_y+bar_h+3,false); draw_set_alpha(1);
        draw_set_color(make_color_rgb(60,60,60)); draw_rectangle(bar_x,bar_y,bar_x+bar_w,bar_y+bar_h,false);

        var c_boss_gray   = make_color_rgb(175,180,185);
        var c_boss_orange = make_color_rgb(255,130,0);
        var c_boss_red    = make_color_rgb(220,40,40);

        if (phase == 1) {
            draw_set_color(c_boss_orange); draw_rectangle(bar_x+2,bar_y+2,bar_x+bar_w-2,bar_y+bar_h-2,false);
            var fill_w_gray = clamp(1.0-(phase1_timer/phase1_timeout),0,1)*(bar_w-4);
            draw_set_color(c_boss_gray); draw_rectangle(bar_x+2,bar_y+2,bar_x+2+fill_w_gray,bar_y+bar_h-2,false);
        } else if (phase == 2 || jeda_fase3 > 0) {
            draw_set_color(c_boss_red); draw_rectangle(bar_x+2,bar_y+2,bar_x+bar_w-2,bar_y+bar_h-2,false);
            var fill_w_orange = clamp(draw_hp_fase2/10,0,1)*(bar_w-4);
            draw_set_color(c_boss_orange); draw_rectangle(bar_x+2,bar_y+2,bar_x+2+fill_w_orange,bar_y+bar_h-2,false);
        } else if (phase == 3) {
            var fill_w_red = clamp(core_main_hp/100,0,1)*(bar_w-4);
            draw_set_color(c_boss_red); draw_rectangle(bar_x+2,bar_y+2,bar_x+2+fill_w_red,bar_y+bar_h-2,false);
        }

        draw_set_color(c_white); draw_rectangle(bar_x,bar_y,bar_x+bar_w,bar_y+bar_h,true);
        draw_set_halign(fa_center); draw_set_valign(fa_bottom); draw_set_font(fnt_boss_name);
        draw_text(bar_x+bar_w/2, bar_y-4, "JUGGERNAUT");
        draw_set_font(fnt_title); draw_set_halign(fa_left); draw_set_valign(fa_top);

        if (is_enraged) {
            var enrage_pulse = sin(enrage_flash_timer * 0.3) > 0;
            if (enrage_pulse) {
                draw_set_color(make_color_rgb(255,0,0));
                draw_rectangle(bar_x-2,bar_y-2,bar_x+bar_w+2,bar_y+bar_h+2,true);
                draw_rectangle(bar_x-3,bar_y-3,bar_x+bar_w+3,bar_y+bar_h+3,true);
            }
            draw_set_halign(fa_center); draw_set_valign(fa_top);
            draw_set_color(make_color_rgb(255,60,60)); draw_set_font(fnt_boss_name);
            draw_text(bar_x+bar_w/2, bar_y+bar_h+4, "!! ENRAGE !!");
            draw_set_halign(fa_left); draw_set_valign(fa_top);
        }

        // OVERLOAD WARNING di HP bar
        if (overload_active && overload_phase == 1) {
            var ol_pulse = sin(current_time * 0.02) > 0;
            if (ol_pulse) {
                draw_set_color(c_white);
                draw_rectangle(bar_x-4,bar_y-4,bar_x+bar_w+4,bar_y+bar_h+4,true);
            }
            draw_set_halign(fa_center); draw_set_valign(fa_top);
            draw_set_color(c_white); draw_set_font(fnt_boss_name);
            draw_text(bar_x+bar_w/2, bar_y+bar_h+20, "CORE OVERLOAD");
            draw_set_halign(fa_left); draw_set_valign(fa_top);
        }
    }

    // ===================================================================
    // SURVIVAL TIMER
    // ===================================================================
    if (phase == 3 && fase3_mode != 4 && survival_timer > 0 && !overload_active) {
        var max_surv = 30 * room_speed; var surv_ratio = survival_timer / max_surv;
        var surv_radius = 22; var surv_x = room_width - 55; var surv_y = 55;
        draw_set_color(make_color_rgb(40,40,40)); draw_set_alpha(0.6);
        draw_circle(surv_x, surv_y, surv_radius+3, false); draw_set_alpha(1.0);
        var c_surv = (surv_ratio > 0.4) ? make_color_rgb(255,200,0) : make_color_rgb(255,60,60);
        draw_set_color(c_surv);
        for (var seg = 0; seg < 36; seg++) {
            var seg_ratio = seg / 36;
            if (seg_ratio > (1 - surv_ratio)) {
                var a1 = -90+(seg_ratio*360); var a2 = -90+((seg+1)/36*360);
                draw_line_width(surv_x+lengthdir_x(surv_radius,a1), surv_y+lengthdir_y(surv_radius,a1),
                                surv_x+lengthdir_x(surv_radius,a2), surv_y+lengthdir_y(surv_radius,a2), 6);
            }
        }
        draw_set_color(c_white); draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_set_font(fnt_boss_name); draw_text(surv_x, surv_y, "4");
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        if (surv_ratio < 0.2 && (current_time div 150) mod 2 == 0) {
            draw_set_color(make_color_rgb(255,60,60)); draw_set_alpha(0.4);
            draw_circle(surv_x, surv_y, surv_radius+8, false); draw_set_alpha(1.0);
        }
    }

    // ===================================================================
    // WARNING INDICATOR
    // ===================================================================
    if (warning_active && warning_timer > 0) {
        var w_blink = (warning_timer div 5) mod 2 == 0;
        var w_alpha = clamp(warning_timer/45, 0.3, 1.0);
        draw_set_alpha(w_blink ? w_alpha : w_alpha * 0.3);
        draw_set_color(make_color_rgb(255,30,30)); draw_circle(warning_x, by+45, 30, true);
        var cx = warning_x; var cy = by+45;
        draw_set_color(make_color_rgb(255,60,60));
        draw_line_width(cx-18,cy-18,cx+18,cy+18,5); draw_line_width(cx+18,cy-18,cx-18,cy+18,5);
        draw_set_color(c_white);
        draw_line_width(cx-18,cy-18,cx+18,cy+18,2); draw_line_width(cx+18,cy-18,cx-18,cy+18,2);
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_set_font(fnt_boss_name); draw_text(cx, cy+42, "!!");
        draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_alpha(1.0);
    }

    // CORE CROSS-FIRE WARNING
    if (phase == 2 && crossfire_counter >= 2 && crossfire_cooldown <= 0
        && instance_exists(real_p1) && instance_exists(real_p2)) {
        var mid_x = (real_p1.x+real_p2.x)/2; var mid_y = (real_p1.y+real_p2.y)/2;
        var cf_blink = (current_time div 100) mod 2 == 0;
        draw_set_alpha(cf_blink ? 0.7 : 0.2);
        draw_set_color(make_color_rgb(255,80,255));
        draw_circle(mid_x, mid_y, 28, true);
        draw_line_width(mid_x-20,mid_y,mid_x+20,mid_y,3);
        draw_line_width(mid_x,mid_y-20,mid_x,mid_y+20,3);
        draw_set_alpha(1.0);
    }
}

// STARDUST
if (phase == 3 || (variable_instance_exists(id, "core_main_hp") && core_main_hp <= 0)) {
    var seed = 98765; random_set_seed(seed); draw_set_alpha(0.6);
    for (var i = 0; i < 50; i++) { draw_set_color(c_white); draw_circle(random(room_width), random(room_height*0.7), 1, false); }
    draw_set_alpha(1); random_set_seed(current_time);
}

if (flash_alpha > 0.02 && !boss_fully_dead) {
    draw_set_alpha(flash_alpha * 0.35); draw_set_color(c_white);
    draw_rectangle(0, 0, room_width, room_height, false); draw_set_alpha(1);
}