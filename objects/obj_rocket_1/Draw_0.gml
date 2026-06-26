// Trail asap
var i = 0;
repeat (8) {
    var age   = (trail_idx - i + 8) mod 8;
    var alpha = (8 - age) / 8 * 0.5;
    var size  = (8 - age) * 0.8;
    if (size > 0) {
        draw_set_alpha(alpha);
        draw_set_color(make_color_rgb(255, 160, 60));
        draw_circle(trail_x[i], trail_y[i], size, false);
    }
    i++;
}
draw_set_alpha(1);

// Badan roket
var angle = point_direction(0, 0, hsp, vsp);
draw_set_color(make_color_rgb(80, 80, 90));
draw_circle(x, y, 7, false);

// Kepala
draw_set_color(make_color_rgb(220, 60, 40));
var tip_x = x + lengthdir_x(10, angle);
var tip_y = y + lengthdir_y(10, angle);
var lx1   = x + lengthdir_x(7, angle + 120);
var ly1   = y + lengthdir_y(7, angle + 120);
var lx2   = x + lengthdir_x(7, angle - 120);
var ly2   = y + lengthdir_y(7, angle - 120);
draw_triangle(tip_x, tip_y, lx1, ly1, lx2, ly2, false);

// Api belakang
var tail_x = x + lengthdir_x(10, angle + 180);
var tail_y = y + lengthdir_y(10, angle + 180);
draw_set_color(make_color_rgb(255, 200, 50));
draw_set_alpha(0.8);
draw_circle(tail_x, tail_y, 5, false);
draw_set_alpha(1);
draw_set_color(c_white);