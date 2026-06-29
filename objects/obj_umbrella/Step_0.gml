/// @description Logika Pergerakan & Mask Kolisi Payung

// Memaksa mask kolisi fisik mengikuti image_xscale/yscale dari Room Editor
mask_index = spr_umbrella;

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
    x = holder.x;
    y = holder.y + offset_y;
    
    // Opsional: Jika ingin arah hadap payung otomatis mengikuti player
    if (holder.image_xscale != 0) {
        image_xscale = sign(holder.image_xscale) * abs(image_xscale);
    }
}