if (!collected) {
    var p = instance_place(x, y, obj_player);

    if (p != noone) {
        collected = true;
        holder = p;
        audio_play_sound(sound_key, 1, false);
    }
} else {
    if (instance_exists(holder)) {
        x = holder.x + (10 * -holder.image_xscale);
        y = holder.y - 50;
    } else {
        collected = false;
        holder = noone;
        x = xstart;
        y = ystart;
    }
}