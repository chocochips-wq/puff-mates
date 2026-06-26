var g = instance_find(obj_fortress_boss, 0);
if(g == noone) exit;

if(g.phase != last_phase) {
    last_phase = g.phase;

    if(g.phase == 2) {
        // aktifkan laser
        with(obj_laser)   { active = true; }
        with(obj_laser_h) { active = true; }
        // stalaktit lebih cepat
        with(obj_stalactite) { idle_timer = irandom_range(20, 60); }
    }

    if(g.phase == 3) {
        // spike mulai aktif
        with(obj_spike_retract) { active = true; }
        // stalaktit makin gila
        with(obj_stalactite) { idle_timer = irandom_range(10, 30); }
    }
}