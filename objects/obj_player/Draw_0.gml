if (!in_cannon) {
    draw_self();
} else {
    // Saat di cannon, draw player di posisi cannon juga
    draw_set_alpha(0.5);
    draw_self();
    draw_set_alpha(1);
}