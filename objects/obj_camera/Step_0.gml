// ========================
// AMBIL SEMUA PLAYER
// ========================
var players = [];
with (obj_player) {
    array_push(players, id);
}

var count = array_length(players);
if (count == 0) exit;

// ========================
// HITUNG BOUNDING BOX SEMUA PLAYER
// ========================
var min_x = players[0].x;
var max_x = players[0].x;
var min_y = players[0].y;
var max_y = players[0].y;

for (var i = 1; i < count; i++) {
    min_x = min(min_x, players[i].x);
    max_x = max(max_x, players[i].x);
    min_y = min(min_y, players[i].y);
    max_y = max(max_y, players[i].y);
}

// ========================
// TITIK TENGAH SEMUA PLAYER
// ========================
var mid_x = (min_x + max_x) / 2;
var mid_y = (min_y + max_y) / 2;

// ========================
// HITUNG ZOOM DARI JARAK
// ========================
var spread_x = (max_x - min_x) + MARGIN;
var spread_y = (max_y - min_y) + MARGIN;

// Sesuaikan zoom agar semua player muat
var target_w = max(spread_x, spread_y / ASPECT);
target_w     = clamp(target_w, MIN_W, MAX_W);
var target_h = target_w * ASPECT;

// ========================
// SMOOTH KAMERA (LERP)
// Pakai nilai kecil supaya cocok dengan fisika es yang licin
// ========================
if (snap) {
    // Frame pertama: langsung snap tanpa animasi
    cam_w = target_w;
    cam_h = target_h;
    cam_x = mid_x - cam_w / 2;
    cam_y = mid_y - cam_h / 2;
    snap  = false;
} else {
    cam_w = lerp(cam_w, target_w, LERP_SPD);
    cam_h = lerp(cam_h, target_h, LERP_SPD);
    cam_x = lerp(cam_x, mid_x - cam_w / 2, LERP_SPD);
    cam_y = lerp(cam_y, mid_y - cam_h / 2, LERP_SPD);
}

// ========================
// CLAMP AGAR TIDAK KELUAR ROOM
// ========================
cam_x = clamp(cam_x, 0, max(0, room_width  - cam_w));
cam_y = clamp(cam_y, 0, max(0, room_height - cam_h));

// ========================
// TERAPKAN KE KAMERA
// ========================
camera_set_view_size(cam, cam_w, cam_h);
camera_set_view_pos(cam,  cam_x, cam_y);