// =======================
// DRAW PARTIKEL ASAP ES (di belakang sprite)
// =======================
for(var i = 0; i < 30; i++) {
    if(part_life[i] > 0) {
        var lt       = part_life[i] / 30;
        var cur_size = part_size[i] * lt;

        // Asap luar biru muda
        draw_set_alpha(lt * 0.25);
        draw_set_color(make_color_rgb(180, 220, 255));
        draw_circle(part_x[i], part_y[i], cur_size, false);

        // Asap dalam putih
        draw_set_alpha(lt * 0.45);
        draw_set_color(c_white);
        draw_circle(part_x[i], part_y[i], cur_size * 0.5, false);
    }
}

// =======================
// DRAW SPRITE
// =======================
if(state != "reset") {
    draw_self();
}

// =======================
// WARNING SHADOW DI LANTAI
// =======================
if(state == "shaking" || state == "falling") {
    var ground_y = y;
    repeat(room_height) {
        if(place_meeting(x, ground_y, obj_ground)
        || place_meeting(x, ground_y, obj_block_tinggi)) break;
        ground_y++;
    }

    var shadow_dist  = ground_y - y;
    var shadow_alpha = clamp(1 - (shadow_dist / 400), 0.1, 0.6);

    // Makin dekat makin merah solid
    var sr = 255;
    var sg = round(lerp(50, 150, shadow_dist / 400));
    draw_set_color(make_color_rgb(sr, sg, 50));
    draw_set_alpha(shadow_alpha);
    var oy = 20;
    draw_ellipse(x - 50, ground_y - 10 + oy, x + 50, ground_y + 10 + oy, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}


// =======================
// PARTIKEL ES JATUH (saat falling)
// =======================
if(state == "falling") {
    var shard_count = 5;
    for(var i = 0; i < shard_count; i++) {
        var angle2   = (i * 72) + (current_time * 0.08);
        var dist3    = sin(current_time * 0.006 + i) * 5 + 7;
        var sx       = x + lengthdir_x(dist3, angle2);
        var sy       = y + lengthdir_y(dist3, angle2) + 6;
        draw_set_alpha(0.55);
        draw_set_color(make_color_rgb(200, 235, 255));
        draw_rectangle(sx - 2, sy - 3, sx + 2, sy + 3, false);
        draw_set_alpha(0.3);
        draw_set_color(c_white);
        draw_circle(sx, sy, 3, false);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// =======================
// PARTIKEL IMPACT (saat kena lantai)
// =======================
if(impact_particles) {
    for(var i = 0; i < 20; i++) {
        if(imp_life[i] > 0) {
            var lt2      = imp_life[i] / 30;
            var imp_sz   = imp_size[i] * lt2;

            // Serpihan es
            draw_set_alpha(lt2 * 0.8);
            draw_set_color(make_color_rgb(
                round(lerp(255, 180, 1 - lt2)),
                round(lerp(255, 220, 1 - lt2)),
                255
            ));
            draw_circle(imp_x[i], imp_y[i], imp_sz, false);

            // Kilap
            draw_set_alpha(lt2 * 0.5);
            draw_set_color(c_white);
            draw_circle(imp_x[i], imp_y[i], imp_sz * 0.4, false);
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}