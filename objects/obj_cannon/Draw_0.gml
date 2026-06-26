draw_sprite(spr_cannon_base, 0, x, y);
draw_sprite_ext(
    spr_cannon_barrel, 0,
    x, y,
    image_xscale, image_yscale,
    -angle_dir,
    c_white, 1
);
if (flash_timer > 0) {
    var flash_len = 40;
    var tip_x = x + lengthdir_x(flash_len, -angle_dir);
    var tip_y = y + lengthdir_y(flash_len, -angle_dir);
    draw_set_colour(c_yellow);
    draw_set_alpha(flash_timer / 8);
    draw_triangle(
        tip_x + lengthdir_x(20, -angle_dir),
        tip_y + lengthdir_y(20, -angle_dir),
        tip_x + lengthdir_x(10, -angle_dir + 90),
        tip_y + lengthdir_y(10, -angle_dir + 90),
        tip_x + lengthdir_x(10, -angle_dir - 90),
        tip_y + lengthdir_y(10, -angle_dir - 90),
        false
    );
    draw_set_colour(c_white);
    draw_set_alpha(1);
}
draw_text(x, y - 60, string(player_count));