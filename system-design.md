
## 1. Overview
Aplikasi **Kumpulan Sholawat Offline** adalah aplikasi berbasis Android yang dibuat menggunakan **Flutter**, yang menyediakan kumpulan sholawat populer lengkap dengan **teks Arab, latin, arti**, serta **audio MP3 offline**.

Aplikasi mendukung fitur pemutaran audio seperti music player modern, termasuk **playlist, repeat, background play, media notification**, serta **dark mode** untuk kenyamanan pengguna.

---

## 2. Goals (Tujuan Sistem)
- Menyediakan kumpulan sholawat dalam bentuk teks dan audio offline.
- Memudahkan pengguna mendengarkan sholawat tanpa koneksi internet.
- Menyediakan pengalaman pemutar audio modern (playlist, repeat, next/prev).
- Menyediakan UI sederhana dan nyaman untuk semua usia.
- Menyediakan fitur favorit agar pengguna dapat menyimpan sholawat pilihan.
- Meningkatkan retensi pengguna melalui fitur background play dan sleep timer.

---

## 3. Target Users
### Primary Users
- Pengguna muslim yang ingin membaca dan mendengarkan sholawat.
- Pengguna yang ingin memutar sholawat saat aktivitas sehari-hari.

### Secondary Users
- Majelis taklim, pengurus masjid, komunitas sholawat.

---

## 4. Key Features
### 4.1 Sholawat Library (Kumpulan Sholawat)
- List sholawat populer.
- Data sholawat berisi:
  - Judul
  - Teks Arab
  - Latin
  - Arti Bahasa Indonesia
  - Audio MP3 offline

### 4.2 Audio Player Offline
- Pemutar audio offline dengan kontrol:
  - Play / Pause
  - Next / Previous
  - Seek bar (durasi audio)
  - Auto play next

### 4.3 Playlist Management
Playlist yang disediakan:
- Semua Sholawat
- Favorit ❤️
- Playlist pilihan (opsional)

### 4.4 Repeat & Shuffle Mode
- Repeat one (ulang 1 sholawat)
- Repeat all (ulang semua sholawat)
- Shuffle (acak lagu)

### 4.5 Favorites (Favorit)
- Pengguna dapat menandai sholawat favorit.
- Favorit disimpan secara lokal.

### 4.6 Search & Filter
- Pencarian berdasarkan judul sholawat.
- Filter kategori (opsional):
  - Sholawat pendek
  - Sholawat populer
  - Sholawat majelis

### 4.7 Dark Mode (Mode Malam)
- Toggle dark mode dari settings.
- Tema otomatis mengikuti sistem (opsional).

### 4.8 Background Audio Playback
- Audio tetap berjalan meskipun aplikasi diminimize.
- Audio tetap berjalan meskipun layar mati.

### 4.9 Media Notification Controls
Saat audio berjalan, muncul notifikasi media:
- Play / Pause
- Next / Previous
- Stop

### 4.10 Sleep Timer
Pengguna dapat mengatur timer:
- 10 menit
- 20 menit
- 30 menit
- 60 menit

Setelah timer selesai, audio otomatis berhenti.

### 4.11 Share Sholawat
- Share teks sholawat (arab/latin/arti) ke WhatsApp, Telegram, dll.

---

## 5. App Flow (User Flow)
### 5.1 Splash Screen
- Logo aplikasi
- Inisialisasi data sholawat
- Load theme settings

### 5.2 Home Screen
Komponen utama:
- Search bar
- List sholawat
- Quick menu:
  - Favorit
  - Playlist
  - Settings
- Mini Player di bagian bawah (jika audio sedang berjalan)

### 5.3 Detail Sholawat Screen
Menampilkan:
- Judul sholawat
- Teks Arab
- Latin
- Arti
- Audio Player Controls
- Tombol Favorite
- Tombol Share

### 5.4 Playlist Screen
- Menampilkan list audio sholawat sesuai playlist
- Tombol play all
- Tombol shuffle

### 5.5 Favorites Screen
- Menampilkan daftar sholawat favorit pengguna
- Bisa play langsung dari daftar favorit

### 5.6 Settings Screen
Pengaturan:
- Dark mode on/off
- Sleep timer
- Tentang aplikasi
- Privacy policy
- Rate aplikasi

---

## 6. Non-Functional Requirements
### 6.1 Performance
- Aplikasi ringan dan responsif.
- Loading list sholawat cepat.
- Pemutaran audio stabil tanpa lag.
- Konsumsi baterai dan RAM efisien.

### 6.2 Reliability
- Tidak crash ketika audio berjalan background.
- Progress audio berjalan normal meskipun aplikasi di-minimize.

### 6.3 Usability
- UI sederhana, minimalis, islami modern, dan mudah digunakan.
- Font jelas dan besar untuk teks Arab.
- Tombol player (play/pause/seek) mudah dijangkau.

### 6.4 Compatibility
- Smartphone dan Tablet Android.
- Minimal Android 6.0 (API 23).
- Optimal Android 8.0+ untuk background audio.

### 6.5 Security
- Tidak mengumpulkan data sensitif pengguna.
- Semua data favorit disimpan lokal.
- Tidak ada login atau akun.

---

## 7. System Architecture
### 7.1 Architecture Pattern
Disarankan menggunakan:
- **Clean Architecture** (opsional)
atau
- **MVVM-like Flutter Structure** (lebih simple)

Lapisan sistem:
- Presentation Layer (UI Screens, Widgets)
- Business Logic Layer (Provider/Riverpod/BLoC)
- Data Layer (Local JSON + Hive/SharedPreferences)
- Service Layer (Audio Player Service)

### 7.2 High Level Components
1. UI Screens
2. Audio Player Service
3. Local Data Loader
4. Local Storage (Favorites + Settings)
5. Ads Service (Optional)

---

## 8. Technology Stack
### 8.1 Framework
- Flutter (Dart)

### 8.2 State Management
Pilihan:
- Provider (simple)
- Riverpod (recommended)
- BLoC (jika aplikasi besar)

### 8.3 Audio Packages
- `just_audio` (audio player)
- `audio_service` (background playback + notification)
- `just_audio_background` (media notification integration)

### 8.4 Local Storage
- `hive` (recommended) untuk favorit dan data lokal
atau
- `shared_preferences` untuk settings sederhana

### 8.5 UI Components
- Material Design
- Custom Theme (Light/Dark)

### 8.6 Ads (Optional)
- `google_mobile_ads` (AdMob)

---

## 9. Data Design
### 9.1 Data Source
Data sholawat disimpan dalam format JSON offline.

Lokasi:
- `assets/data/sholawat.json`

Audio disimpan dalam assets:
- `assets/audio/*.mp3`

### 9.2 JSON Structure Example
```json
[
  {
    "id": 1,
    "title": "Sholawat Badar",
    "arabic": "صَلَاةُ اللهِ سَلَامُ اللهِ...",
    "latin": "Sholatullah salamullah...",
    "translation": "Semoga rahmat Allah...",
    "audio": "assets/audio/sholawat_badar.mp3",
    "category": "populer"
  }
]
```

### 9.3 Local Storage Structure (Hive)
- **Favorites**: `sholawat_id: boolean`
- **Settings**:
  - `dark_mode: boolean`
  - `sleep_timer: int` (minutes)
  - `last_played: int` (sholawat_id)
  - `last_position: int` (milliseconds)

---

## 10. UI/UX Design Principles
- **Aesthetic**: Modern Islamic UI, clean and elegant.
- **Micro-animations**: Subtle transitions between screens.
- **Layout**: Card-based list, Spotify-like mini player.
- **Typography**: Clear Arabic fonts for better readability.

---

## 11. Monetization (Optional)
### 11.1 AdMob Strategy
- **Banner Ads**: Home screen bottom.
- **Interstitial Ads**: Displayed when switching sholawat (limited frequency).
- **Rewarded Ads**: Optional for premium features or themes.

### 11.2 Premium Features
- Remove Ads.
- Exclusive themes/colors.

---

## 12. Compliance & Privacy
- **Disclaimer**: Included in "About" page.
- **Privacy Policy**: Explains no sensitive data collection and AdMob data usage.

---

## 13. Testing Plan
- **Functional**: Play/Pause, Seek, Next/Prev, Favorite, Dark Mode, Sleep Timer.
- **Background**: Playback when screen off, minimize app, media notification controls.
- **Performance**: Test on low-end devices, memory leak checks.

---

## 14. Future Development
- **Audio Download**: External storage to reduce APK size.
- **Custom Playlists**: Allow users to create their own lists.
- **Sync Online**: Firebase for content updates without app update.
- **Lyrics Sync**: Karaoke-style text highlighting.
- **Multi-language**: Support for English, Melayu, etc.

---

## 15. Kesimpulan
Aplikasi **Kumpulan Sholawat Offline** dirancang untuk memberikan pengalaman religius yang nyaman bagi umat muslim dengan fitur audio modern yang dapat diakses tanpa internet.
