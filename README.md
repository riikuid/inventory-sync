# 🚀 Flutter Boilerplate with Auth

Boilerplate ini dibuat untuk mempercepat pengembangan aplikasi **Flutter** yang dilengkapi dengan sistem **Authentication** (login, register, profile, dsb.).  
Struktur sudah disiapkan agar mudah dikembangkan lebih lanjut sesuai kebutuhan proyek.

---

## 📱 Tech Stack

### Flutter

- **Versi:** `3.35.2` (channel stable)
- **Repo:** [Flutter GitHub](https://github.com/flutter/flutter.git)
- **Framework Revision:** `05db968908` — _2025-08-25 10:21:35 -0700_
- **Engine:** `abb725c9a5211af2a862b83f74b7eaf2652db083` (rev `a8bfdfc394`) — _2025-08-22 23:51:12 UTC_
- **Tools:** Dart `3.9.0` • DevTools `2.48.0`

---

## ⚙️ Persiapan Environment

1. **Clone repository** ini ke local machine:

   ```bash
   git clone <url-repo-kamu>
   cd nama-folder
   ```

2. **Setup environment Flutter**

   Buat file .env-production dan .env-development berdasarkan .env-example.

   Gunakan file ini untuk memisahkan konfigurasi production dan development.

   ```bash
   cp .env-example .env-development
   cp .env-example .env-production
   ```

3. **Setup Firebase**
   Generate ulang firebase_options.dart dan google-services.json dengan perintah:

   ```bash
   flutterfire configure
   ```

## 🧩 Catatan Penting

- Pastikan model User atau response Auth sudah disesuaikan dengan struktur API backend yang kamu gunakan.

- Jika menggunakan Laravel, cek kembali field pada endpoint Auth (misalnya login, register, profile) agar sesuai dengan model di Flutter.

- Gunakan adb reverse atau IP LAN untuk menghubungkan device Android ke API backend saat development.
