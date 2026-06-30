/// @description Inisialisasi State Awal Giga Rocket

if (!variable_instance_exists(id, "bullet_type")) {
    bullet_type = "normal";
}

dir_angle  = 180;
hsp        = 0;
vsp        = 0;
life_timer = 300;

// Sistem State Ambil & Lempar
status  = 0; // 0 = Jatuh, 1 = Di Tanah, 2 = Dipegang, 3 = Dilempar Balik
carrier = noone;

// Setup Efek Ekor Asap
trail_x   = array_create(8, 0);
trail_y   = array_create(8, 0);
trail_idx = 0;

// Pastikan variabel internal GameMaker aman
image_angle = 270;
depth = -10000;