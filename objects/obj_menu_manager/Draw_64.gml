// Circle Wipe Overlay
if (circle_active && circle_radius > 0) {
    
    // Konversi posisi world ke posisi GUI
    var cam = view_camera[0];
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    var scale_x = gui_w / cam_w;
    var scale_y = gui_h / cam_h;
    
    var origin_gui_x = (circle_origin_x - cam_x) * scale_x;
    var origin_gui_y = (circle_origin_y - cam_y) * scale_y;
    var radius_gui   = circle_radius * ((scale_x + scale_y) / 2);
    
    // Buat surface sementara
    var surf = surface_create(gui_w, gui_h);
    surface_set_target(surf);
    draw_clear_alpha(c_black, 1.0);
    
    // Lubangi circle dengan blend subtract
    gpu_set_blendmode(bm_subtract);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_circle(origin_gui_x, origin_gui_y, radius_gui, false);
    gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
    
    // Gambar surface ke GUI
    draw_surface(surf, 0, 0);
    surface_free(surf);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}