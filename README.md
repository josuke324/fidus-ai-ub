## 4. Setup Environment & Deployment Sederhana

Project ini dirancang menggunakan **Docker Containerization** untuk memastikan isolasi *environment* yang konsisten, aman, dan *reproducible* (berjalan sama persis di komputer juri maupun di server produksi tanpa konflik dependensi lokal).

---

### A. Komponen Arsitektur Deployment

Sistem dideploy menggunakan **Docker Compose** yang membagi aplikasi menjadi dua container utama dalam satu jaringan virtual internal (`ub-wellness-network`):

1. **Container Backend (`fidus_app`)**
   Menggunakan image *Node.js 18-alpine* yang ringan, bertugas menjalankan server Express dan melayani file statis UI.

2. **Container Database (`fidus_db`)**
   Menggunakan image *MySQL 8.0*, bertugas mengelola data persisten mahasiswa dan konselor.

---

### B. Prasyarat Sistem (Prerequisites)

Sebelum melakukan deployment, pastikan perangkat Anda sudah terinstall beberapa tools berikut:

- [Docker Engine](https://docs.docker.com/engine/install/) (Minimal versi 20.10)
- [Docker Compose](https://docs.docker.com/compose/install/) (Minimal versi 2.0)

---

### C. Konfigurasi Environment Variable (`.env`)

Untuk keamanan, kredensial database dipisahkan melalui *Environment Variables*. Buatlah file bernama `.env` pada root direktori project sebelum menjalankan container (file ini tidak di-push ke GitHub demi keamanan):

```env
# Database Configuration
DB_HOST=fidus_db
DB_USER=root
DB_PASSWORD=rahasia_fidus_2026
DB_NAME=ub_wellness_db
DB_PORT=3306

# Server Configuration
PORT=3000
```

---

### D. Langkah-Langkah Deployment (Step-by-Step)

Juri hanya perlu mengeksekusi rangkaian perintah sederhana berikut di terminal untuk mendepolifikasi sistem secara lokal:

1. **Clone Repository**
   Buka terminal, arahkan ke direktori kerja Anda, lalu jalankan perintah:
   ```bash
   git clone [https://github.com/josuke324/fidus-ai-ub.git](https://github.com/josuke324/fidus-ai-ub.git)
   cd fidus-ai-ub
   ```

2. **Setup Konfigurasi Environment**
   Salin baris konfigurasi `.env` yang tertera pada **Poin C** di atas, buat file baru bernama `.env` di root folder project, lalu paste isinya ke sana. Anda bisa menggunakan command line berikut:
   ```bash
   nano .env
   # Paste konfigurasi dari Poin C, lalu simpan (Ctrl+O, Enter, Ctrl+X)
   ```

3. **Build dan Jalankan Layanan dengan Docker Compose**
   Eksekusi perintah di bawah ini untuk mengunduh base image (*Node.js* & *MySQL*), mengonfigurasi virtual network internal, menginisialisasi skema database `init.sql` secara otomatis, dan menyalakan server di latar belakang (*detached mode*):
   ```bash
   docker-compose up -d --build
   ```

4. **Verifikasi Status Container**
   Pastikan seluruh container penunjang sistem (Backend & Database) telah berjalan dengan status `Up`:
   ```bash
   docker-compose ps
   ```
   *Catatan: Jika container mendadak `Exit`, pastikan port 3000 atau port 3306 di perangkat Anda tidak sedang digunakan oleh aplikasi lokal lain.*

5. **Akses Aplikasi (Testing)**
   Buka browser web Anda dan gunakan tautan berikut untuk masuk ke sistem:
   - **Dashboard Utama**: `http://localhost:3000`
   - **Bypass Akses Konselor (Direct Link)**: `http://localhost:3000/doctor.html?role=psikiater`

---

### E. Manajemen Layanan & Pembersihan (Troubleshooting)

- **Melihat Log Aplikasi secara Real-time**
  Jika juri ingin memantau aktivitas request API atau proses autentikasi backend yang sedang berjalan di dalam container:
  ```bash
  docker-compose logs -f fidus_app
  ```

- **Menghentikan Layanan (Teardown)**
  Untuk mematikan sistem dan membersihkan network virtual tanpa menghapus data persisten:
  ```bash
  docker-compose down
  ```

- **Membersihkan Total (Reset Environment)**
  Jika ingin menghapus seluruh container, network, hingga isi database dummy untuk melakukan deployment ulang dari awal:
  ```bash
  docker-compose down -v
  ```
