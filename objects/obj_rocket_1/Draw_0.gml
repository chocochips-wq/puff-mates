// 1. GAMBAR TRAIL ASAP BELAKANG (Ukuran asap diperbesar)
var i = 0;
repeat (8) {
    var age   = (trail_idx - i + 8) mod 8;
    var alpha = (8 - age) / 8 * 0.4;
    var size  = (8 - age) * 1.5; // Ukuran asap dinaikkan ke 1.5
    if (size > 0) {
        draw_set_alpha(alpha);
        draw_set_color(make_color_rgb(255, 140, 50));
        draw_circle(trail_x[i], trail_y[i], size, false);
    }
    i++;
}
draw_set_alpha(1);

// Tentukan orientasi sudut visual roket
var draw_angle = point_direction(0, 0, hsp, vsp);
if (status == 1 || status == 2 || status == 3) {
    draw_angle = 90; 
}

// 2. SEMBURAN API ROKET (Diperbesar)
if (status == 0 || status == 3) {
    var tail_x = x + lengthdir_x(16, draw_angle + 180);
    var tail_y = y + lengthdir_y(16, draw_angle + 180);
    var fire_len = 14 + irandom(10);
    var fire_tip_x = tail_x + lengthdir_x(fire_len, draw_angle + 180);
    var fire_tip_y = tail_y + lengthdir_y(fire_len, draw_angle + 180);
    var fx1 = tail_x + lengthdir_x(8, draw_angle + 90);
    var fy1 = tail_y + lengthdir_y(8, draw_angle + 90);
    var fx2 = tail_x + lengthdir_x(8, draw_angle - 90);
    var fy2 = tail_y + lengthdir_y(8, draw_angle - 90);

    draw_set_color(make_color_rgb(255, 90, 20));
    draw_triangle(fire_tip_x, fire_tip_y, fx1, fy1, fx2, fy2, false);
    draw_set_color(make_color_rgb(255, 230, 110));
    draw_circle(tail_x, tail_y, 5, false);
}

// 3. SIRIP SAYAP EKOR ROKET JUMBO
var base_x = x + lengthdir_x(12, draw_angle + 180);
var base_y = y + lengthdir_y(12, draw_angle + 180);
var fin1_x = base_x + lengthdir_x(16, draw_angle + 90);
var fin1_y = base_y + lengthdir_y(16, draw_angle + 90);
var fin2_x = base_x + lengthdir_x(16, draw_angle - 90);
var fin2_y = base_y + lengthdir_y(16, draw_angle - 90);

draw_set_color(make_color_rgb(190, 40, 40));
draw_triangle(x, y, base_x, base_y, fin1_x, fin1_y, false);
draw_triangle(x, y, base_x, base_y, fin2_x, fin2_y, false);

// 4. BADAN SILINDER TABUNG ROKET (Dipertebal & Diperpanjang)
var body_front_x = x + lengthdir_x(10, draw_angle);
var body_front_y = y + lengthdir_y(10, draw_angle);
var body_back_x  = x + lengthdir_x(16, draw_angle + 180);
var body_back_y  = y + lengthdir_y(16, draw_angle + 180);

draw_set_color(make_color_rgb(100, 100, 110));
draw_line_width(body_back_x, body_back_y, body_front_x, body_front_y, 14); // Ketebalan tabung dinaikkan dari 7 ke 14 pixel

// 5. KEPALA KERUCUT ROKET JUMBO
var tip_x = body_front_x + lengthdir_x(20, draw_angle); // Diperpanjang ke depan
var tip_y = body_front_y + lengthdir_y(20, draw_angle);
var hx1   = body_front_x + lengthdir_x(7, draw_angle + 90);
var hy1   = body_front_y + lengthdir_y(7, draw_angle + 90); 
var hx2   = body_front_x + lengthdir_x(7, draw_angle - 90);
var hy2   = body_front_y + lengthdir_y(7, draw_angle - 90); 

draw_set_color(make_color_rgb(230, 50, 40));
draw_triangle(tip_x, tip_y, hx1, hy1, hx2, hy2, false);

// Kembalikan warna default draw GML
draw_set_color(c_white);