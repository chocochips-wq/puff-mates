// Set depth di belakang instansi lain tapi di depan background
depth = 50;

// 1. Inisialisasi Awan Parallax
cloud_count = 6;
cloud_x = array_create(cloud_count);
cloud_y = array_create(cloud_count);
cloud_speed = array_create(cloud_count);
cloud_scale = array_create(cloud_count);
cloud_alpha = array_create(cloud_count);

for (var i = 0; i < cloud_count; i++) {
    cloud_x[i] = random_range(-100, room_width + 100);
    cloud_y[i] = random_range(40, 240);
    cloud_speed[i] = random_range(0.2, 0.8);
    cloud_scale[i] = random_range(0.8, 1.6);
    cloud_alpha[i] = random_range(0.3, 0.65);
}

// 2. Inisialisasi Gelembung Puff (Partikel background mengambang bertema)
puff_count = 15;
puff_x = array_create(puff_count);
puff_y = array_create(puff_count);
puff_speed_y = array_create(puff_count);
puff_speed_x = array_create(puff_count);
puff_radius = array_create(puff_count);
puff_alpha = array_create(puff_count);

for (var i = 0; i < puff_count; i++) {
    puff_x[i] = random(room_width);
    puff_y[i] = random(room_height);
    puff_speed_y[i] = random_range(0.4, 1.2);
    puff_speed_x[i] = random_range(0.3, 0.8);
    puff_radius[i] = random_range(3, 8);
    puff_alpha[i] = random_range(0.15, 0.45);
}

// 3. Inisialisasi Rumput Prosedural
grass_list = [];

// Cari ground dan tumbuhkan rumput secara prosedural di atas permukaan tanah lantai
with (obj_ground) {
    if (y > 400 && image_xscale > 1) {
        var gw = sprite_get_width(sprite_index) * image_xscale;
        var step = 20; // Jarak antar rumput
        for (var gx = x + 10; gx < x + gw - 10; gx += step) {
            // Cek apakah tidak ada ground lain di atasnya
            if (!position_meeting(gx, y - 8, obj_ground)) {
                array_push(other.grass_list, {
                    x: gx + random_range(-4, 4),
                    y: y,
                    height: random_range(8, 14),
                    angle_offset: random(100),
                    sway_speed: random_range(0.015, 0.035),
                    flower: (random(100) < 15) // 15% kesempatan tumbuh bunga kecil
                });
            }
        }
    }
}

// 4. Inisialisasi Debu Langkah Kaki (Footstep Dust)
dust_list = [];

// 5. Variabel Transisi Fade
fade_alpha = 0.0;
fade_target = 0.0;
fade_speed = 0.04;
fade_room = noone;

// 6. Variabel Circle Wipe
circle_origin_x = room_width / 2;
circle_origin_y = room_height / 2;

// Hitung radius maksimal (cukup untuk menutupi seluruh layar dari titik manapun)
circle_radius_max = sqrt(power(room_width, 2) + power(room_height, 2));
circle_radius = 0;
circle_target_radius = 0;
circle_speed = 10; // seberapa cepat circle tumbuh/menyusut per step
circle_active = false;