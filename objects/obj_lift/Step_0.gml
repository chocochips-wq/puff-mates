// =======================
// HITUNG PLAYER YANG NAIK
// Pakai bbox overlap langsung, lebih reliable dari place_meeting
// =======================
players_on = 0;

with(obj_player) {
    var on_lift = (bbox_right  > other.bbox_left)
               && (bbox_left   < other.bbox_right)
               && (bbox_bottom >= other.bbox_top - 4)
               && (bbox_bottom <= other.bbox_top + 16);
    if(on_lift) other.players_on++;
}

// =======================
// STATE MACHINE
// =======================
var prev_y = y;

switch(state) {

    case "wait":
        if(players_on >= 2) {
            state = "moving_down";
        }
    break;

    case "moving_down":
        if(players_on < 2) {
            state = "moving_up";
            break;
        }
        y = min(y + speed_lift, target_y);
        if(y >= target_y) {
            // Sudah di bawah, tunggu player lepas
        }
    break;

    case "moving_up":
        if(players_on >= 2) {
            state = "moving_down";
            break;
        }
        y = max(y - speed_lift, start_y);
        if(y <= start_y) {
            state = "wait";
        }
    break;
}

// =======================
// BAWA PLAYER IKUT BERGERAK
// =======================
var dy = y - prev_y;
if(dy != 0) {
    with(obj_player) {
        var on_lift = (bbox_right  > other.bbox_left)
                   && (bbox_left   < other.bbox_right)
                   && (bbox_bottom >= other.bbox_top - 4)
                   && (bbox_bottom <= other.bbox_top + 16);
        if(on_lift) y += dy;
    }
}