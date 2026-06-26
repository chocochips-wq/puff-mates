depth = -9999;
// Fisika tali
rope_segments = 12;    // jumlah titik di sepanjang tali
rope_sag = 0.0;        // seberapa dalam tali melengkung (0 = lurus)
rope_sag_target = 0.0;
rope_swing = 0.0;      // osilasi goyang kiri-kanan
rope_swing_vel = 0.0;  // kecepatan osilasi

// Array posisi tiap segmen tali (buat goyang)
rope_ox = array_create(rope_segments, 0); // offset x tiap segmen
rope_oy = array_create(rope_segments, 0); // offset y tiap segmen
rope_vx = array_create(rope_segments, 0); // velocity x
rope_vy = array_create(rope_segments, 0); // velocity y