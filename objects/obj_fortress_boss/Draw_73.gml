/// @description Paksa Aplikasi Geter Visual Layar (Bypass Lock Y=0)

if (variable_instance_exists(id, "cam_shake_amount") && cam_shake_amount > 0.5) {
    
    // Bikin acakan guncangan (Dinaikkan dimensinya biar makin kelihatan)
    var _gx = irandom_range(-1, 1) * cam_shake_amount;
    var _gy = irandom_range(-1, 1) * cam_shake_amount;
    
    // Geser permukaan viewport secara paksa lewat matriks rendering GameMaker
    var _cam = view_camera[0];
    camera_set_view_pos(_cam, camera_get_view_x(_cam) + _gx, camera_get_view_y(_cam) + _gy);
}