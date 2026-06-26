// =======================
// RESET PUSH COUNTER
// =======================
push_left = 0;
push_right = 0;

// =======================
// HITUNG PEMAIN YANG MENDORONG
// =======================
with (obj_player) {
    var pushing_right = keyboard_check(p_id == 0 ? ord("D") : vk_right);
    var pushing_left  = keyboard_check(p_id == 0 ? ord("A") : vk_left);

    // Player nempel di sisi kiri kotak dan dorong kanan
    if (pushing_right
    && place_meeting(x + 1, y, other)
    && bbox_bottom > other.bbox_top + 4) {
        other.push_right++;
    }

    // Player nempel di sisi kanan kotak dan dorong kiri
    if (pushing_left
    && place_meeting(x - 1, y, other)
    && bbox_bottom > other.bbox_top + 4) {
        other.push_left++;
    }
}

// =======================
// GERAK HORIZONTAL (butuh 2 player)
// =======================
hsp = 0;
if (push_right >= 2) hsp = spd;
if (push_left  >= 2) hsp = -spd;

// =======================
// COLLISION HORIZONTAL BOX
// =======================
repeat(abs(hsp)) {
    var step = sign(hsp);
    if (!place_meeting(x + step, y, obj_ground)
    && !place_meeting(x + step, y, obj_box)) {
        x += step;
        // Geser player yang mendorong ikut bareng
        with (obj_player) {
            var pushing_right = keyboard_check(p_id == 0 ? ord("D") : vk_right);
            var pushing_left  = keyboard_check(p_id == 0 ? ord("A") : vk_left);
            if ((pushing_right && place_meeting(x + 1, y, other))
            ||  (pushing_left  && place_meeting(x - 1, y, other))) {
                x += step;
            }
        }
    } else {
        break;
    }
}

// =======================
// GRAVITASI BOX
// =======================
vsp += grv;

// =======================
// COLLISION VERTICAL BOX
// =======================
if (place_meeting(x, y + vsp, obj_ground)) {
    while (!place_meeting(x, y + sign(vsp), obj_ground)) {
        y += sign(vsp);
    }
    vsp = 0;
} else {
    y += vsp;
}