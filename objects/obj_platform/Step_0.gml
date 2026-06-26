xprev = x;

// gerak
x += speed * dir;

// balik arah
if (x >= start_x + range) dir = -1;
if (x <= start_x - range) dir = 1;