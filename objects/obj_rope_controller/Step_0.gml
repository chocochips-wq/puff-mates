if(global.level_complete) exit;

depth = -9999;

var p1 = noone;
var p2 = noone;
with(obj_player) {
    if(p_id == 0) p1 = id;
    if(p_id == 1) p2 = id;
}
if(p1 == noone || p2 == noone) exit;

// =======================
// GROUNDING
// =======================
var p1_grounded = scr_is_grounded(p1);
var p2_grounded = scr_is_grounded(p2);

if(p1_grounded) p1.is_hanging = false;
if(p2_grounded) p2.is_hanging = false;

// =======================
// ROPE CONSTRAINT
// =======================
var max_dist = 120;
var dist     = point_distance(p1.x, p1.y, p2.x, p2.y);

if(dist <= max_dist) {
    p1.is_hanging = false;
    p2.is_hanging = false;
    exit;
}

var dir     = point_direction(p1.x, p1.y, p2.x, p2.y);
var overlap = dist - max_dist;

// === RATIO ===
var ratio1, ratio2;
if(p1_grounded && !p2_grounded) {
    ratio1 = 0.2;
    ratio2 = 0.8;
} else if(p2_grounded && !p1_grounded) {
    ratio1 = 0.8;
    ratio2 = 0.2;
} else {
    ratio1 = 0.5;
    ratio2 = 0.5;
}

var fx1 = lengthdir_x(overlap * ratio1, dir);
var fy1 = lengthdir_y(overlap * ratio1, dir);
var fx2 = lengthdir_x(overlap * ratio2, dir + 180);
var fy2 = lengthdir_y(overlap * ratio2, dir + 180);

// =======================
// HORIZONTAL DRAG
// player hanging ikut gerak horizontal player grounded
// =======================
var drag_x = 0;
if(p1_grounded && !p2_grounded) {
    drag_x = p1.x - p1.xprevious;
} else if(p2_grounded && !p1_grounded) {
    drag_x = -(p2.x - p2.xprevious);
}

// =======================
// KOREKSI POSISI P1
// =======================
with(p1) {
    var sx = sign(fx1);
    if(sx != 0) {
        repeat(abs(round(fx1))) {
            if(!place_meeting(x+sx, y, obj_ground)
            && !place_meeting(x+sx, y, obj_button)
            && !place_meeting(x+sx, y, obj_box)
            && !place_meeting(x+sx, y, obj_block_tinggi)
            && !place_meeting(x+sx, y, obj_platform_lr)
            && !place_meeting(x+sx, y, obj_moving_platform)) {
                x += sx;
            } else { break; }
        }
    }
    var sy = sign(fy1);
    if(sy != 0) {
        repeat(abs(round(fy1))) {
            if(!place_meeting(x, y+sy, obj_ground)
            && !place_meeting(x, y+sy, obj_button)
            && !place_meeting(x, y+sy, obj_box)
            && !place_meeting(x, y+sy, obj_block_tinggi)
            && !place_meeting(x, y+sy, obj_platform_lr)
            && !place_meeting(x, y+sy, obj_moving_platform)) {
                y += sy;
                if(sy < 0) vsp = min(vsp, 0);
            } else {
                if(sy < 0) is_hanging = false;
                break;
            }
        }
    }
}

// =======================
// KOREKSI POSISI P2
// =======================
with(p2) {
    var sx = sign(fx2);
    if(sx != 0) {
        repeat(abs(round(fx2))) {
            if(!place_meeting(x+sx, y, obj_ground)
            && !place_meeting(x+sx, y, obj_button)
            && !place_meeting(x+sx, y, obj_box)
            && !place_meeting(x+sx, y, obj_block_tinggi)
            && !place_meeting(x+sx, y, obj_platform_lr)
            && !place_meeting(x+sx, y, obj_moving_platform)) {
                x += sx;
            } else { break; }
        }
    }
    var sy = sign(fy2);
    if(sy != 0) {
        repeat(abs(round(fy2))) {
            if(!place_meeting(x, y+sy, obj_ground)
            && !place_meeting(x, y+sy, obj_button)
            && !place_meeting(x, y+sy, obj_box)
            && !place_meeting(x, y+sy, obj_block_tinggi)
            && !place_meeting(x, y+sy, obj_platform_lr)
            && !place_meeting(x, y+sy, obj_moving_platform)) {
                y += sy;
                if(sy < 0) vsp = min(vsp, 0);
            } else {
                if(sy < 0) is_hanging = false;
                break;
            }
        }
    }
}

// =======================
// TERAPKAN HORIZONTAL DRAG
// setelah koreksi posisi, sebelum hanging state
// =======================
if(drag_x != 0) {
    var drag_target = noone;
    if(p1_grounded && !p2_grounded && p2.is_hanging) drag_target = p2;
    if(p2_grounded && !p1_grounded && p1.is_hanging) drag_target = p1;

    if(drag_target != noone) {
        with(drag_target) {
            var dsx = sign(drag_x);
            repeat(abs(round(drag_x))) {
                if(!place_meeting(x+dsx, y, obj_ground)
                && !place_meeting(x+dsx, y, obj_button)
                && !place_meeting(x+dsx, y, obj_box)
                && !place_meeting(x+dsx, y, obj_block_tinggi)
                && !place_meeting(x+dsx, y, obj_platform_lr)
                && !place_meeting(x+dsx, y, obj_moving_platform)) {
                    x += dsx;
                } else { break; }
            }
        }
    }
}

// =======================
// HANGING STATE
// =======================
if(!p1_grounded && p2_grounded) {
    if(fy1 < 0) {
        p1.vsp        = min(p1.vsp, 0);
        p1.is_hanging = true;
    } else {
        p1.is_hanging = false;
    }
} else if(!p2_grounded && p1_grounded) {
    if(fy2 < 0) {
        p2.vsp        = min(p2.vsp, 0);
        p2.is_hanging = true;
    } else {
        p2.is_hanging = false;
    }
} else if(!p1_grounded && !p2_grounded) {
    p1.is_hanging = false;
    p2.is_hanging = false;
}