// =======================
// GROUNDING CHECK
// =======================
var grounded = scr_is_grounded(id);

var other_below = instance_place(x, y+1, obj_player);
if(other_below != noone && other_below != id) {
    if(bbox_bottom <= other_below.bbox_top + 4) grounded = true;
}

// =======================
// RESET HANGING
// =======================
if(grounded) is_hanging = false;
if(is_hanging) vsp = 0;

// =======================
// INPUT
// =======================
var h        = 0;
var key_jump = false;

if(p_id == 0) {
    if(!is_hanging) h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    key_jump = keyboard_check(vk_space);
} else {
    if(!is_hanging) h = keyboard_check(vk_right) - keyboard_check(vk_left);
    key_jump = keyboard_check(vk_up);
}

// =======================
// CANNON TIMER
// =======================
if(cannon_exit_timer > 0) cannon_exit_timer--;

// =======================
// MASUK CANNON
// =======================
if(!in_cannon && cannon_exit_timer <= 0) {
    var c = instance_nearest(x, y, obj_cannon);
    if(c != noone && point_distance(x, y, c.x, c.y) < 40) {
        in_cannon = true;
        x = c.x;
        y = c.y;
        vsp = 0;
        hsp = 0;
    }
}

// Tambahkan pengkondisian visible sebelum exit
if(in_cannon) {
    visible = false; // Menghilangkan player saat berada di dalam cannon
    exit;
}

// =======================
// CANNON HSP
// =======================
if(hsp != 0) {
    var hsp_sign = sign(hsp);
    repeat(abs(round(hsp))) {
        if(!place_meeting(x+hsp_sign, y, obj_ground)
        && !place_meeting(x+hsp_sign, y, obj_button)
        && !place_meeting(x+hsp_sign, y, obj_box)
        && !place_meeting(x+hsp_sign, y, obj_block_tinggi)
        && !place_meeting(x+hsp_sign, y, obj_platform_lr)
        && !place_meeting(x+hsp_sign, y, obj_moving_platform)
        && !place_meeting(x+hsp_sign, y, obj_lift)) {
            x += hsp_sign;
        } else { hsp = 0; break; }
    }
    hsp *= 0.85;
    if(abs(hsp) < 0.5) hsp = 0;
}

// =======================
// GERAK HORIZONTAL
// =======================
if(!is_hanging && h != 0) {
    var sx = sign(h);
    repeat(abs(h * spd)) {
        if(!place_meeting(x+sx, y, obj_ground)
        && !place_meeting(x+sx, y, obj_button)
        && !place_meeting(x+sx, y, obj_box)
        && !place_meeting(x+sx, y, obj_block_tinggi)
        && !place_meeting(x+sx, y, obj_platform_lr)
        && !place_meeting(x+sx, y, obj_moving_platform)
        && !place_meeting(x+sx, y, obj_lift)) {
            x += sx;
        } else { break; }
    }
}

// =======================
// GRAVITASI + COLLISION VERTIKAL
// =======================
if(!is_hanging) {
    vsp += grv;

    var hit_v = place_meeting(x, y+vsp, obj_ground)
             || place_meeting(x, y+vsp, obj_button)
             || place_meeting(x, y+vsp, obj_box)
             || place_meeting(x, y+vsp, obj_block_tinggi)
             || place_meeting(x, y+vsp, obj_platform_lr)
             || place_meeting(x, y+vsp, obj_moving_platform)
             || place_meeting(x, y+vsp, obj_lift);

    var ov = instance_place(x, y+vsp, obj_player);
    if(ov != noone && ov != id) {
        if(bbox_bottom <= ov.bbox_top + 4) hit_v = true;
    }

    if(hit_v) {
        while(!place_meeting(x, y+sign(vsp), obj_ground)
           && !place_meeting(x, y+sign(vsp), obj_button)
           && !place_meeting(x, y+sign(vsp), obj_box)
           && !place_meeting(x, y+sign(vsp), obj_block_tinggi)
           && !place_meeting(x, y+sign(vsp), obj_platform_lr)
           && !place_meeting(x, y+sign(vsp), obj_moving_platform)
           && !place_meeting(x, y+sign(vsp), obj_lift)) {
            var ov2 = instance_place(x, y+sign(vsp), obj_player);
            if(ov2 != noone && ov2 != id) {
                if(bbox_bottom <= ov2.bbox_top + 4) break;
            }
            y += sign(vsp);
        }
        vsp = 0;
    } else {
        y += vsp;
    }
}

// =======================
// MOVING PLATFORM — pakai xprev_manual, dengan collision check
// =======================
var plat = instance_place(x, y+1, obj_moving_platform);
if(plat != noone) {
    var dx  = plat.x - plat.xprev_manual;
    var psx = sign(dx);
    repeat(abs(round(dx))) {
        if(!place_meeting(x+psx, y, obj_ground)
        && !place_meeting(x+psx, y, obj_button)
        && !place_meeting(x+psx, y, obj_box)
        && !place_meeting(x+psx, y, obj_block_tinggi)
        && !place_meeting(x+psx, y, obj_platform_lr)) {
            x += psx;
        } else { break; }
    }
}

// =======================
// LOMPAT
// =======================
if(jump_hold_timer > 0) jump_hold_timer--;

if(key_jump && grounded && jump_hold_timer <= 0) {
    vsp = jump;
    is_hanging = false;
    scr_play_sound_safe(sound_lompat, 1, false);
    jump_hold_timer = jump_delay;
}

// =======================
// ANIMASI
// =======================
if(!is_hanging) {
    var target_spr = (h != 0) ? spr_player_walk : spr_player_idle;
    if(sprite_index != target_spr) {
        sprite_index = target_spr;
        image_index  = 0;
    }
}
if(h > 0) image_xscale =  scale;
if(h < 0) image_xscale = -scale;

// =======================
// CAMERA — hanya p_id 0 yang ngitung
// =======================
if(p_id == 0) {
    var cam   = view_camera[0];
    var cam_w = camera_get_view_width(cam);
    var other_p = noone;
    with(obj_player) { if(p_id == 1) other_p = id; }
    var mid_x    = (other_p != noone) ? (x + other_p.x) / 2 : x;
    var target_x = clamp(mid_x - cam_w/2, 0, room_width - cam_w);
    var target_y = cam_y_fixed;
    if (room_height > 1000) {
        var cam_h = camera_get_view_height(cam);
        var mid_y = (other_p != noone) ? (y + other_p.y) / 2 : y;
        target_y = lerp(camera_get_view_y(cam), clamp(mid_y - cam_h/2, 0, room_height - cam_h), 0.1);
    }
    camera_set_view_pos(cam,
        lerp(camera_get_view_x(cam), target_x, 0.1),
        target_y
    );
}

// =======================
// DEATHTRAP COLLISION → RESPAWN
// =======================
var hit_laser = false;
with(obj_laser) {
    var in_x = (other.x > x - laser_width && other.x < x + laser_width);
    var in_y = (other.y > y && other.y < y + laser_length);
    var umbrella = instance_find(obj_umbrella, 0);
    var prot = false;
    if(umbrella != noone && umbrella.holder != noone) {
        if(abs(other.x - umbrella.x) < 80) prot = true;
    }
    if(in_x && in_y && !prot) hit_laser = true;
}

if(y > room_height 
|| place_meeting(x, y, obj_spike) 
|| place_meeting(x, y, obj_spike_retract) 
|| place_meeting(x, y, obj_stalactite) 
|| place_meeting(x, y, obj_lava)
|| hit_laser) {
    if (place_meeting(x, y, obj_lava)) {
        audio_play_sound(sound_lava_hit, 1, false);
    }
    scr_respawn();
}

// =======================
// RESET ALPHA
// =======================
image_alpha = lerp(image_alpha, 1, 0.1);