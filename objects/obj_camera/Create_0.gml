// ========================
// INISIALISASI KAMERA
// ========================
cam = view_camera[0];

// Target posisi & zoom (diperhalus dengan lerp)
cam_x      = 0;
cam_y      = 0;
cam_w      = 1280;
cam_h      = 720;

// Nilai dasar
BASE_W     = 1280;
BASE_H     = 720;
ASPECT     = BASE_H / BASE_W;   // 0.5625 (16:9)

MIN_W      = 800;               // Zoom in maksimal
MAX_W      = room_width;        // Zoom out maksimal

MARGIN     = 300;               // Padding ekstra dari kedua player
LERP_SPD   = 0.08;              // Makin kecil = makin smooth (cocok buat es)

// Snap kamera ke posisi awal (tidak melayang)
snap = true;