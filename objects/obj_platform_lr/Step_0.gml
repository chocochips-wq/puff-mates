// =======================
// SIMPAN POSISI LAMA
// =======================
xprev = x;
yprev = y;

// =======================
// GERAK (CONTOH: HORIZONTAL)
// =======================
x += spd * dir;

if (x >= start_x + range) dir = -1;
if (x <= start_x - range) dir = 1;


// =======================
// COLLISION KE PLAYER (SOLID SEMUA SISI)
// =======================
with (obj_player) {
    
    if (place_meeting(x, y, other)) {

        var dx = other.x - other.xprev;
        var dy = other.y - other.yprev;

        // kalau platform gerak horizontal
        if (dx != 0) {
            while (place_meeting(x, y, other)) {
                x += sign(dx);
            }
        }

        // kalau platform gerak vertikal
        if (dy != 0) {
            while (place_meeting(x, y, other)) {
                y += sign(dy);
            }
        }
    }
}