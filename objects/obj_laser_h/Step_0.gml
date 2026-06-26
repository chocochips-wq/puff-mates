pulse_timer++;

var my_length  = laser_length;
var my_x       = x;
var my_y       = y;
var seg_width  = 6;
var zag_height = 5;
var anim_speed = 2;
var anim_offset = (pulse_timer * anim_speed) mod (seg_width * 2);

// =======================
// BANGUN ARRAY TITIK ZIGZAG
// =======================
var pts_x = [];
var pts_y = [];
var cur_x   = my_x + anim_offset;
var go_down = true;

array_push(pts_x, cur_x);
array_push(pts_y, my_y);

while(cur_x > my_x - my_length - seg_width) {
    cur_x  -= seg_width;
    var zy  = go_down ? my_y + zag_height : my_y - zag_height;
    array_push(pts_x, cur_x);
    array_push(pts_y, zy);
    go_down = !go_down;
}

// =======================
// CARI SHIELD
// =======================
var shield_holder = noone;
var shield_x      = -1;
with(obj_umbrella_side) {
    if(holder != noone && instance_exists(holder)) {
        shield_holder = holder;
        shield_x      = x;
    }
}

var hit_threshold = 10;
var hit = false;

// =======================
// CEK SEMUA obj_player
// =======================
with(obj_player) {
    var pl_x = x;
    var pl_y = y;
    var prot = false;

    if(shield_holder != noone) {
        if(id == shield_holder) {
            // Yang pegang payung selalu terlindungi
            prot = true;
        } else {
            // Yang tidak pegang — terlindungi kalau di kiri payung
            if(pl_x < shield_x) prot = true;
        }
    }

    if(!prot) {
        var seg_count = array_length(pts_x) - 1;
        for(var i = 0; i < seg_count; i++) {
            var ax = clamp(pts_x[i],   my_x - my_length, my_x);
            var ay = pts_y[i];
            var bx = clamp(pts_x[i+1], my_x - my_length, my_x);
            var by = pts_y[i+1];
            var ddx = bx - ax;
            var ddy = by - ay;
            var len = sqrt(ddx*ddx + ddy*ddy);
            if(len > 0) {
                var t = clamp(
                    ((pl_x-ax)*ddx + (pl_y-ay)*ddy) / (len*len),
                    0, 1
                );
                var dist_to_seg = point_distance(
                    pl_x, pl_y,
                    ax + t*ddx,
                    ay + t*ddy
                );
                if(dist_to_seg < hit_threshold) hit = true;
            }
        }
    }
}

if(hit) scr_respawn();