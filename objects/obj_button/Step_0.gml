pressed = false;

if (instance_place(x, y - 2, obj_box) != noone) pressed = true;
if (instance_place(x, y - 2, obj_player) != noone) pressed = true;

image_index = (pressed) ? 1 : 0;