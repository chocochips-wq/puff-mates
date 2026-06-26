if(holder == noone) {
    with(obj_player) {
        if(!has_umbrella && place_meeting(x, y, other)) {
            other.holder = id;
            has_umbrella = true;
            break;
        }
    }
}

if(holder != noone && instance_exists(holder)) {
    x = holder.x + offset_x; // selalu di kanan, tidak ikut flip
    y = holder.y + offset_y;
}