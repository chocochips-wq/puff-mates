function scr_is_grounded(inst) {
    with(inst) {
        return place_meeting(x, y+1, obj_ground)
            || place_meeting(x, y+1, obj_button)
            || place_meeting(x, y+1, obj_box)
            || place_meeting(x, y+1, obj_block_tinggi)
            || place_meeting(x, y+1, obj_platform_lr)
            || place_meeting(x, y+1, obj_moving_platform)
            || place_meeting(x, y+1, obj_lift);
    }
}