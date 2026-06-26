// Simpan posisi sebelum bergerak secara manual
// karena lerp membuat xprevious GML tidak reliable
xprev_manual = x;

var btn = instance_nearest(x, y, obj_button);
active = (btn != noone && btn.pressed);

if(active) {
    x = lerp(x, target_x, 0.05); // lebih lambat = lebih enak dipijak
} else {
    x = lerp(x, hidden_x, 0.05);
}