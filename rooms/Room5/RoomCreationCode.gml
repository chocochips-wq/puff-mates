var tile_size = 32;

for(var i = 0; i < room_width; i += tile_size){

    // lubang 1
    if(i >= 800 && i <= 900) continue;

    // lubang 2
    if(i >= 1100 && i <= 1200) continue;

}


// BUGFIX: Room5 adalah room boss fight, BGM-nya dikendalikan penuh oleh
// obj_fortress_boss (sound_bgm_boss_phase1/2/3). sound_bgm_main TIDAK boleh
// diputar di sini karena menyebabkan dua musik bertumpuk (double sound)
// sepanjang fase 1-3. Cukup hentikan semua sound yang nyangkut dari room
// sebelumnya; boss akan memulai BGM-nya sendiri di event Create-nya.
audio_stop_all();

// Create backdrop controller to draw sky and ground (phase-driven)
var bd_index = asset_get_index("obj_boss_backdrop");
if (bd_index > 0) {
    if (!instance_exists(bd_index)) {
        var bd_inst = instance_create_layer(room_width/2, room_height/2, "Background", bd_index);
        if (instance_exists(bd_inst)) bd_inst.depth = 10000;
    }
}

// Hide large top-ground instances (they cover the sky) by disabling obj_ground placed near y=0
with (obj_ground) {
    if (y < room_height * 0.2) visible = false;
}