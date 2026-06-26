function scr_respawn() {
    with(obj_player) {
        x = spawn_x; y = spawn_y;
        vsp = 0; hsp = 0;
        is_hanging = false;
        in_cannon = false;
        cannon_exit_timer = 0;
        image_alpha = 0.5;
    }
    with(obj_key) {
        collected = false; holder = noone;
        x = xstart; y = ystart;
    }
    with(obj_lift) {
        y = start_y; state = "wait";
        players_on = 0; delay_timer = 90;
    }
    with(obj_stalactite) {
        x = start_x; y = start_y;
        fall_speed = 0; state = "idle";
        shake_timer = 0; reset_timer = 0;
        idle_timer = irandom_range(60, 180);
        impact_particles = false;
        part_timer = 0;
    }
    with(obj_umbrella) {
        holder = noone;
        x = xstart; y = ystart;
    }
    with(obj_umbrella_side) {
        holder = noone;
        x = xstart; y = ystart;
    }

    var cam   = view_camera[0];
    var cam_w = camera_get_view_width(cam);
    var p1    = noone;
    with(obj_player) { if(p_id == 0) p1 = id; }
    var snap_x = clamp(
        (p1 != noone ? p1.spawn_x : 0) - cam_w / 2,
        0, room_width - cam_w
    );
    var fixed_y = 0;
    with(obj_player) { if(p_id == 0) { fixed_y = cam_y_fixed; break; } }
    camera_set_view_pos(cam, snap_x, fixed_y);

    with(obj_player) { has_umbrella = false; }
}
