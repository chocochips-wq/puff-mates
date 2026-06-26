// 1. Update posisi awan
for (var i = 0; i < cloud_count; i++) {
    cloud_x[i] += cloud_speed[i];
    if (cloud_x[i] > room_width + 120) {
        cloud_x[i] = -120;
        cloud_y[i] = random_range(40, 240);
    }
}

// 2. Update gelembung puff melayang ke atas
for (var i = 0; i < puff_count; i++) {
    puff_y[i] -= puff_speed_y[i];
    puff_x[i] += sin(current_time * 0.0015 + puff_y[i] * 0.01) * puff_speed_x[i];
    
    if (puff_y[i] < -20) {
        puff_y[i] = room_height + 20;
        puff_x[i] = random(room_width);
        puff_alpha[i] = random_range(0.15, 0.45);
    }
}

// 3. Update dan buat partikel debu langkah kaki pemain
var dust_len = array_length(dust_list);
for (var i = dust_len - 1; i >= 0; i--) {
    var d = dust_list[i];
    d.y -= d.speed_y;
    d.x += d.speed_x;
    d.radius -= 0.12;
    d.alpha -= 0.025;
    
    if (d.radius <= 0.4 || d.alpha <= 0) {
        array_delete(dust_list, i, 1);
    }
}

// Cari player untuk memicu debu saat lari
with (obj_player) {
    var on_ground = place_meeting(x, y + 1, obj_ground);
    if (on_ground && abs(x - xprevious) > 1.2) {
        if (random(100) < 20) {
            array_push(other.dust_list, {
                x: x + random_range(-6, 6),
                y: bbox_bottom,
                radius: random_range(2.5, 5.0),
                alpha: random_range(0.35, 0.6),
                speed_x: -sign(x - xprevious) * random_range(0.1, 0.4),
                speed_y: random_range(0.1, 0.3)
            });
        }
    }
}

// 4. Update transisi fade
if (fade_alpha < fade_target) {
    fade_alpha += fade_speed;
    if (fade_alpha >= fade_target) fade_alpha = fade_target;
} else if (fade_alpha > fade_target) {
    fade_alpha -= fade_speed;
    if (fade_alpha <= fade_target) fade_alpha = fade_target;
}

// Pindah room jika layar sudah gelap sepenuhnya

// 5. Update Circle Wipe
if (circle_active) {
    
    // Fase fade OUT — circle membesar dari posisi pintu
// Fase fade OUT — circle mengecil ke posisi pintu
if (fade_target >= 1.0 && circle_radius > 0) {
    circle_radius -= circle_speed;
       if (circle_radius <= 0) {
			circle_radius = 0;
            
            // Layar sudah tertutup penuh, pindah room
            if (fade_room != noone) {
                room_goto(fade_room);
                fade_room = noone;
                
                // Reset origin ke tengah layar untuk fade IN
                circle_origin_x = room_width / 2;
                circle_origin_y = room_height / 2;
                
                // Mulai fase fade IN
                fade_target = 0.0;
            }
        }
    }
    
    // Fase fade IN — circle mengecil dari tengah
    if (fade_target <= 0.0 && circle_radius > 0) {
        circle_radius -= circle_speed;
        if (circle_radius <= 0) {
            circle_radius = 0;
            circle_active = false;
            fade_alpha = 0.0;
        }
    }
}

// Aktifkan circle wipe saat fade_target diset ke 1.0 dari obj_door
if (fade_target >= 1.0 && !circle_active) {
    circle_active = true;
    circle_radius = circle_radius_max;
}
