// cek fase dari golem
var g = instance_find(obj_fortress_boss, 0);
if(g == noone) exit;

if(g.phase >= 3 && !active) {
    active = true;
}

if(active) {
    blink_timer++;
    // pola on-off: 40 frame muncul, 20 frame sembunyi
    var cycle = blink_timer mod 60;
    visible = (cycle < 40);

    // kalau visible dan kena player → respawn
    if(visible) {
        if(place_meeting(x, y, obj_player)) scr_respawn();
    }
}