/// @description Paksa Gempa Layar Sebelum Render Visual

// Cari apakah objek boss Juggernaut sedang hidup di dalam room
var boss_inst = instance_find(obj_fortress_boss, 0);
if (boss_inst != noone) {
    // Cek apakah boss punya variabel cam_shake_amount dan nilainya aktif
    if (variable_instance_exists(boss_inst, "cam_shake_amount") && boss_inst.cam_shake_amount > 0.5) {
        
        // Acak pergeseran koordinat visual layar (Dinaikkan biar makin brutal jirr!)
        var _fx = random_range(-1, 1) * boss_inst.cam_shake_amount;
        var _fy = random_range(-1, 1) * boss_inst.cam_shake_amount;
        
        // TIMPA POSISI KAMERA SECARA PAKSA TEPAT SEBELUM CANVAS DIGAMBAR!
        var _cam = view_camera[0];
        camera_set_view_pos(_cam, camera_get_view_x(_cam) + _fx, camera_get_view_y(_cam) + _fy);
    }
}