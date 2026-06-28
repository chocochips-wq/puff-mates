/// @description Logika Pergerakan & Animasi Mengambang Kunci

// JARING PENGAMAN: Jika is_dropped belum terdaftar, otomatis buat jadi false
if (!variable_instance_exists(id, "is_dropped")) {
    is_dropped = false;
}

if (!collected) {
    
    // ⚡ 1. KONDISI FISIK (JATUH VS MENGAMBANG ANIMASI)
    if (is_dropped) {
        // --- JALUR KUNCI BOSS: Aktif Gravitasi ---
        vsp += grv;
        
        // Kolisi Vertikal dengan Lantai/Tanah (obj_ground)
        if (place_meeting(x, y + vsp, obj_ground)) {
            while (!place_meeting(x, y + sign(vsp), obj_ground)) {
                y += sign(vsp);
            }
            vsp = 0; // Berhenti pas kena lantai
        }
        y += vsp;
    } else {
        // --- JALUR ROOM 1 - 4: Diam & Aktifkan Animasi Naik-Turun Gemoy ---
        vsp = 0;
        
        // Rumus Sinus: Membuat koordinat Y bergerak naik turun secara halus dari posisi awal (ystart)
        y = ystart + sin(current_time * 0.005) * 3;
    }

    // ⚡ 2. LOGIC DETEKSI DIPIKUL PLAYER
    var p = instance_place(x, y, obj_player);

    if (p != noone) {
        collected = true;
        holder = p;
        audio_play_sound(sound_key, 1, false);
    }
    
} else {
    // Kunci nempel di atas kepala/belakang player saat dibawa
    if (instance_exists(holder)) {
        x = holder.x + (10 * -holder.image_xscale);
        y = holder.y - 50;
        vsp = 0; // Reset kecepatan jatuh
    } else {
        collected = false;
        holder = noone;
        x = xstart;
        y = ystart;
    }
}