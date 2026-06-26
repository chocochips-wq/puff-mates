var tiles = platform_width / tile_w;
for (var i = 0; i < tiles; i++) {
    draw_sprite(spr_box_moving, 0, x + (i * tile_w), y);
} 