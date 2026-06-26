function scr_meet_spike(inst, cx, cy){
    with(obj_spike){
        var s_left = x;
        var s_right = x + width - 1;
        var s_top = y;
        var s_bottom = y + height - 1;

        var inst_left = cx + (inst.bbox_left - inst.x);
        var inst_right = cx + (inst.bbox_right - inst.x);
        var inst_top = cy + (inst.bbox_top - inst.y);
        var inst_bottom = cy + (inst.bbox_bottom - inst.y);

        if(inst_right > s_left
        && inst_left < s_right
        && inst_bottom > s_top
        && inst_top < s_bottom){
            return true;
        }
    }
    return false;
}