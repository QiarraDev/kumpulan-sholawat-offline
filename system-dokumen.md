
## 1. Pendahuluan
### 1.1 Latar Belakang
Sholawat merupakan amalan yang sangat dianjurkan dalam Islam dan banyak dibaca oleh umat muslim dalam kegiatan sehari-hari, majelis, maupun saat waktu luang. Namun, tidak semua pengguna memiliki akses internet stabil untuk mendengarkan sholawat melalui platform online.

Oleh karena itu, dibutuhkan aplikasi yang menyediakan **kumpulan sholawat lengkap dalam bentuk teks dan audio** yang dapat digunakan secara **offline**, sehingga lebih praktis dan mudah diakses kapan saja.

### 1.2 Deskripsi Sistem
Aplikasi **Kumpulan Sholawat Offline** adalah aplikasi berbasis Android yang dibangun menggunakan **Flutter**, berisi kumpulan sholawat populer lengkap dengan:
- teks Arab
- latin
- arti bahasa Indonesia
- audio MP3 offline

Aplikasi juga dilengkapi dengan fitur pemutar musik seperti playlist, repeat, shuffle, background play, media notification, serta mode malam (dark mode).

### 1.3 Tujuan Sistem
Tujuan sistem ini adalah:
- Menyediakan kumpulan sholawat dalam bentuk teks dan audio offline.
- Memudahkan pengguna mendengarkan sholawat tanpa koneksi internet.
- Menyediakan pengalaman pemutar audio modern (playlist, repeat, next/prev).
- Menyediakan UI sederhana dan nyaman untuk semua usia.
- Menyediakan fitur favorit agar pengguna dapat menyimpan sholawat pilihan.
- Meningkatkan retensi pengguna melalui fitur background play dan sleep timer.

### 1.4 Ruang Lingkup Sistem
Ruang lingkup aplikasi mencakup:
- penyajian teks sholawat (Arab, latin, arti)
- audio sholawat offline
- fitur player (play/pause/seek/next/prev)
- playlist dan favorit
- mode malam
- background playback dan notifikasi media
- pengaturan aplikasi (settings)
- monetisasi iklan (opsional)

---

## 2. Informasi Umum Sistem
### 2.1 Target Pengguna
#### Pengguna Utama (Primary)
- Umat muslim yang ingin membaca dan mendengarkan sholawat.
- Pengguna yang ingin memutar sholawat saat aktivitas harian.

#### Pengguna Sekunder (Secondary)
- Majelis taklim, komunitas sholawat, dan pengurus masjid.

### 2.2 Platform
- Android Smartphone dan Tablet
- Minimal Android 6.0 (API 23)
- Direkomendasikan Android 8.0+ untuk performa background audio lebih stabil

### 2.3 Bahasa Aplikasi
- Bahasa Indonesia (utama)
- Penambahan multi bahasa dapat dilakukan di versi berikutnya

---

## 3. Fitur Utama Sistem
### 3.1 Kumpulan Sholawat
Sistem menyediakan daftar sholawat populer yang dapat diakses pengguna.

Setiap sholawat memiliki konten:
- Judul Sholawat
- Teks Arab
- Latin
- Arti Bahasa Indonesia
- File audio MP3 offline

### 3.2 Audio Player Offline
Sistem menyediakan pemutar audio offline dengan fitur:
- Play dan Pause
- Seek audio (geser durasi)
- Next dan Previous
- Progress bar durasi audio
- Auto play audio berikutnya

### 3.3 Playlist
Sistem menyediakan playlist untuk mempermudah pengguna memutar sholawat secara berurutan, terdiri dari:
- Playlist semua sholawat
- Playlist favorit
- Playlist kategori (opsional)

### 3.4 Repeat dan Shuffle
Sistem mendukung mode pemutaran:
- Repeat one (ulang 1 sholawat)
- Repeat all (ulang playlist)
- Shuffle (acak sholawat)

### 3.5 Favorit
Pengguna dapat menyimpan sholawat favorit dengan fitur:
- tambah favorit
- hapus favorit
- daftar favorit

Data favorit tersimpan secara lokal.

### 3.6 Search (Pencarian)
Sistem menyediakan fitur pencarian berdasarkan judul sholawat agar pengguna cepat menemukan sholawat yang diinginkan.

### 3.7 Mode Malam (Dark Mode)
Sistem menyediakan fitur:
- Light Mode
- Dark Mode

Mode dapat dipilih melalui menu settings.

### 3.8 Background Playback
Sistem mendukung pemutaran audio di background sehingga audio tetap berjalan meskipun:
- aplikasi ditutup/minimize
- pengguna membuka aplikasi lain
- layar dimatikan

### 3.9 Media Notification
Sistem menyediakan notifikasi media saat audio diputar, berisi:
- judul sholawat
- tombol play/pause
- tombol next/previous
- tombol stop

### 3.10 Sleep Timer
Sistem menyediakan fitur sleep timer untuk menghentikan audio otomatis setelah waktu tertentu:
- 10 menit
- 20 menit
- 30 menit
- 60 menit

### 3.11 Share Sholawat
Pengguna dapat membagikan teks sholawat (Arab/Latin/Arti) melalui:
- WhatsApp
- Telegram
- Facebook
- aplikasi lainnya

---

## 4. Struktur Menu Aplikasi
### 4.1 Home Screen
Menu utama terdiri dari:
- Search bar
- Daftar sholawat
- Tombol cepat:
  - Favorit
  - Settings
- Mini player (muncul saat audio berjalan)

### 4.2 Detail Sholawat
Menampilkan:
- judul sholawat
- teks Arab
- latin
- arti
- tombol play/pause
- tombol favorite
- tombol share

### 4.3 Favorites Screen
Menampilkan daftar sholawat yang sudah ditandai favorit.

### 4.4 Settings Screen
Menampilkan pengaturan:
- mode malam
- sleep timer
- privacy policy
- about aplikasi
- rate aplikasi

---

## 5. Alur Kerja Sistem (Workflow)
### 5.1 Splash Screen
- sistem menampilkan logo aplikasi
- sistem melakukan inisialisasi data
- sistem membaca pengaturan (theme dan favorit)

### 5.2 Home Screen
- pengguna memilih sholawat dari daftar
- pengguna dapat menggunakan search untuk menemukan sholawat

### 5.3 Detail Sholawat
- sistem menampilkan teks sholawat lengkap
- pengguna dapat memutar audio
- pengguna dapat menyimpan ke favorit

### 5.4 Player Flow
- ketika audio diputar, sistem memunculkan mini player
- jika pengguna minimize aplikasi, audio tetap berjalan
- sistem menampilkan media notification

### 5.5 Favorites
- pengguna dapat melihat list favorit
- pengguna dapat memutar sholawat favorit secara berurutan

---

## 6. Kebutuhan Sistem (System Requirements)
### 6.1 Functional Requirements
Sistem harus mampu:
- menampilkan daftar sholawat
- menampilkan detail sholawat (Arab/Latin/Arti)
- memutar audio MP3 offline
- menjalankan audio di background
- menampilkan media notification control
- menyimpan favorit secara lokal
- menjalankan playlist dan repeat
- mendukung dark mode
- menyediakan sleep timer
- membagikan teks sholawat

### 6.2 Non-Functional Requirements
#### Performance
- Aplikasi ringan dan responsif.
- Loading list sholawat cepat.
- Pemutaran audio stabil tanpa lag.
- Konsumsi baterai dan RAM efisien.

#### Reliability
- Tidak crash ketika audio berjalan background.
- Progress audio berjalan normal meskipun aplikasi di-minimize.

#### Usability
- UI sederhana, minimalis, islami modern, dan mudah digunakan.
- Font jelas dan besar untuk teks Arab.
- Tombol player (play/pause/seek) mudah dijangkau.

---

## 7. Arsitektur Sistem
### 7.1 Framework dan Tools
- Flutter (Dart)
- Android platform build

### 7.2 Pola Arsitektur
Disarankan menggunakan:
- MVVM-like structure (Flutter)
atau
- Clean Architecture (untuk pengembangan lebih besar)

### 7.3 Komponen Sistem
Komponen utama:
1. Presentation Layer (UI Screen & Widgets)
2. State Management Layer (Provider/Riverpod/BLoC)
3. Data Layer (JSON & Local Storage)
4. Audio Service Layer (Audio Background Player)

---

## 8. Teknologi dan Library
### 8.1 Audio Playback
- `just_audio` untuk audio player
- `audio_service` untuk background audio
- `just_audio_background` untuk notifikasi media

### 8.2 Local Storage
- `hive` untuk menyimpan favorit dan setting
atau
- `shared_preferences` untuk setting sederhana

### 8.3 State Management
- `provider` atau `riverpod` (recommended)

### 8.4 Ads (Optional)
- `google_mobile_ads` (AdMob)

---

## 9. Data Management
### 9.1 Penyimpanan Data Sholawat
Data sholawat disimpan dalam file JSON offline:
- `assets/data/sholawat.json`

Audio disimpan dalam assets:
- `assets/audio/*.mp3`

### 9.2 Struktur Data JSON
Setiap sholawat memiliki data:
- id
- title
- arabic
- latin
- translation
- audio
- category

### 9.3 Penyimpanan Favorit dan Settings
Favorit disimpan secara lokal menggunakan Hive:
- sholawat_id: true/false

Settings disimpan:
- dark_mode: true/false
- sleep_timer: minutes
- last_played: id
- last_position: milliseconds

---

## 10. Desain UI/UX
### 10.1 Prinsip Desain
- UI islami modern, sederhana dan elegan
- font besar untuk teks Arab
- navigasi mudah
- tombol player mudah diakses

### 10.2 Komponen UI Utama
- List sholawat dengan card layout
- Mini player seperti Spotify
- Detail view teks sholawat dengan scroll
- Tab atau section untuk Arab/Latin/Arti (opsional)

---

## 11. Monetisasi (Opsional)
### 11.1 AdMob Strategy
Jika menggunakan iklan:
- banner ads di home screen
- interstitial ads dibatasi agar tidak mengganggu pengguna
- rewarded ads untuk fitur premium (opsional)

### 11.2 Premium Plan
Versi premium dapat mencakup:
- remove ads
- audio kualitas lebih tinggi
- unlock tema tambahan

---

## 12. Compliance dan Kebijakan Play Store
### 12.1 Konten dan Klaim
- aplikasi tidak boleh mengklaim "resmi" tanpa otoritas
- wajib mencantumkan disclaimer di halaman about

### 12.2 Privacy Policy
Aplikasi harus memiliki privacy policy:
- menjelaskan bahwa aplikasi tidak menyimpan data sensitif
- jika menggunakan AdMob, menjelaskan data yang mungkin dikumpulkan oleh pihak ketiga

---

## 13. Testing Plan
### 13.1 Functional Testing
- test audio play/pause/seek
- test next/prev playlist
- test favorite save/load
- test dark mode switch
- test sleep timer

### 13.2 Background Testing
- audio tetap jalan saat layar mati
- audio tetap jalan saat aplikasi minimize
- notifikasi media tampil normal

### 13.3 Performance Testing
- aplikasi berjalan lancar pada device low-end
- tidak ada lag saat membuka list sholawat

---

## 14. Pengembangan Lanjutan
Pengembangan sistem di masa depan:
- fitur download audio (mengurangi ukuran APK)
- playlist custom
- kategori sholawat lebih lengkap
- multi bahasa
- fitur lirik mengikuti audio (karaoke mode)
- fitur update konten online (Firebase)

---

## 15. Kesimpulan
Aplikasi **Kumpulan Sholawat Offline** merupakan aplikasi islami yang bermanfaat bagi umat muslim untuk membaca dan mendengarkan sholawat kapan saja tanpa internet. Dengan fitur audio player modern, background playback, favorit, playlist, dan dark mode, aplikasi ini dapat memberikan pengalaman terbaik serta berpotensi mendapatkan rating tinggi di Play Store.

