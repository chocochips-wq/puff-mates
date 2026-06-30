/// @description Gambar Langit Dinamis Per Fase

var _cam    = view_camera[0];
var _cam_x  = camera_get_view_x(_cam);
var _cam_y  = camera_get_view_y(_cam);
var _cam_w  = camera_get_view_width(_cam);
var _cam_h  = camera_get_view_height(_cam);

draw_set_color(make_color_rgb(bg_sky_r, bg_sky_g, bg_sky_b));
draw_rectangle(_cam_x, _cam_y, _cam_x + _cam_w, _cam_y + _cam_h, false);
draw_set_color(c_white);