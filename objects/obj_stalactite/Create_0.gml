start_x      = x;
start_y      = y;
fall_speed   = 0;
state        = "idle";
shake_timer  = 0;
reset_timer  = 0;
shake_offset = 0;
idle_timer   = irandom_range(30, 180);

// Partikel asap es
part_timer = 0;
part_x     = array_create(30, 0);
part_y     = array_create(30, 0);
part_vx    = array_create(30, 0);
part_vy    = array_create(30, 0);
part_life  = array_create(30, 0);
part_size  = array_create(30, 0);
part_index = 0;

// Partikel impact (saat kena lantai)
impact_particles  = false;
imp_x    = array_create(20, 0);
imp_y    = array_create(20, 0);
imp_vx   = array_create(20, 0);
imp_vy   = array_create(20, 0);
imp_life = array_create(20, 0);
imp_size = array_create(20, 0);