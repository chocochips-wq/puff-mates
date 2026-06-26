// Cegah duplikat saat ganti room
if (instance_number(obj_audio_manager) > 1) {
    instance_destroy();
    exit;
}

// Inisialisasi progress level dari file lokal
ini_open("save_data.ini");
global.max_unlocked_level = ini_read_real("Progress", "max_unlocked", 1);
ini_close();