# TODO — Perbaikan Fitur Upload File di Edit Panel

## Plan
- [x] Analisis masalah upload file
- [x] Perbaiki `_uploadMediaFile` di `lib/screens/edit_panel_screen.dart`
  - [x] Konfirmasi API benar: `FilePicker.pickFiles(...)` (static) di file_picker 11.x
  - [x] Tambah `SnackBar` feedback (uploading / sukses / gagal)
  - [x] Auto-save entry setelah upload sukses (URL media langsung ter-persist)
  - [x] Guard jika Firebase belum dikonfigurasi (pesan jelas ke user)
  - [x] Tangkap exception `FilePicker.pickFiles` agar tidak crash
  - [x] Validasi bytes null/empty dengan pesan jelas
  - [x] Validasi ukuran file max 25 MB dengan helper `_formatBytes`
  - [x] Perluas mapping content-type (svg, bmp, heic, mkv, avi, csv, rar)
- [x] Jalankan `flutter analyze` — 0 error (hanya 5 info style existing)
- [ ] Test di Chrome dengan `flutter run -d chrome` (opsional)
