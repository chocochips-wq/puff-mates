spd   = 2.5;
grv   = 0.5;
jump  = -10;
vsp   = 0;
hsp   = 0;
scale = 2;
image_xscale = scale;
image_yscale = scale;

p_id    = 0;
spawn_x = x;
spawn_y = y;

// Configure camera dynamically based on the current room
var room_name = room_get_name(room);
var cam = view_camera[0];

if (room_name == "rm_menu" || room_name == "Room5") {
    // Zoomed out view for lobby and Room 5 (Boss level)
    camera_set_view_size(cam, 1366, 768);
    cam_y_fixed = 0;
} else {
    // Zoomed in view for Level 1, 2, 3, 4
    camera_set_view_size(cam, 640, 360);
    cam_y_fixed = 210;
}
camera_set_view_pos(cam, camera_get_view_x(cam), cam_y_fixed);

is_hanging = false;

in_cannon         = false;
cannon_exit_timer = 0;

jump_hold_timer = 0;
jump_delay      = 10;

depth = 0;

has_umbrella = false;

