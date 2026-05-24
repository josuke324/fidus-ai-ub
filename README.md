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

### C. Konfigurasi Environment & Keamanan API Key

Untuk mematuhi standar keamanan industri, kredensial sensitif dan LLM API Key dilarang keras di-push langsung ke repositori publik demi menghindari eksploitasi oleh bot crawler otomatis. 

Oleh karena itu, sistem ini di-deploy menggunakan **Script Wrapper (`run.sh`)** yang berfungsi menyuntikkan *Environment Variables* dan API Key secara dinamis langsung ke memori lokal kontainer saat inisialisasi awal. Juri **tidak perlu** membuat atau mengonfigurasi file `.env` secara manual (Zero-Configuration Deployment).

---

### D. Langkah-Langkah Deployment (Step-by-Step)

Juri hanya perlu mengeksekusi rangkaian perintah sederhana berikut di terminal untuk menjalankan seluruh sistem beserta modul analisis AI secara instan:

1. **Clone & Masuk ke Direktori Project**
   Buka terminal Anda, arahkan ke direktori kerja, lalu jalankan:
   ```bash
   git clone [https://github.com/josuke324/fidus-ai-ub.git](https://github.com/josuke324/fidus-ai-ub.git)
   cd fidus-ai-ub
   ```

2. **Jalankan Otomatisasi Sistem**
   Eksekusi script wrapper untuk memicu kompilasi container, penyiapan virtual network internal, injeksi aman API Key, dan inisialisasi otomatis skema database `init.sql`:
   ```bash
   bash run.sh
   ```

3. **Verifikasi Status Container**
   Pastikan seluruh layanan penunjang sistem telah berjalan dengan status `Up`:
   ```bash
   docker-compose ps
   ```
   *Catatan: Jika container mendadak `Exit`, pastikan port 3000 atau port 3306 di perangkat Anda tidak sedang digunakan oleh aplikasi lokal lain.*

4. **Akses Aplikasi (Testing)**
   Buka browser web Anda dan gunakan tautan berikut untuk masuk ke sistem:
   - **Dashboard Utama**: `http://localhost:3000`
   - **Bypass Akses Konselor (Direct Link)**: `http://localhost:3000/doctor.html?role=psikiater`

---

### E. Manajemen Layanan & Pembersihan (Troubleshooting)

- **Melihat Log Aplikasi secara Real-time**
  Jika juri ingin memantau aktivitas request API atau proses analisis kognitif AI backend yang sedang berjalan di dalam container:
  ```bash
  docker-compose logs -f fidus_app
  ```

- **Menghentikan Layanan (Teardown)**
  Untuk mematikan sistem dan membersihkan network virtual tanpa menghapus data persisten:
  ```bash
  docker-compose down
  ```

- **Membersihkan Total (Reset Environment)**
  Jika ingin menghapus seluruh container, network, hingga volume database dummy untuk melakukan deployment ulang dari awal:
  ```bash
  docker-compose down -v
  ```
