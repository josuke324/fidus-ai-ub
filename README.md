## 4. Setup Environment & Deployment Sederhana

Project ini dirancang menggunakan **Docker Containerization** untuk memastikan isolasi *environment* yang konsisten, aman, dan *reproducible* (berjalan sama persis di OS Linux, macOS, maupun Windows tanpa konflik dependensi lokal).

---

### A. Komponen Arsitektur Deployment

Sistem dideploy menggunakan **Docker Compose** yang membagi aplikasi menjadi dua container utama dalam satu jaringan virtual internal (`ub-wellness-network`):

1. **Container Backend (`fidus_app`)**
   Menggunakan image *Node.js 18-alpine* yang ringan, bertugas menjalankan server Express dan melayani file statis UI.

2. **Container Database (`db`)**
   Menggunakan image *MySQL 8.0*, bertugas mengelola data persisten mahasiswa dan konselor secara aman dan terisolasi.

---

### B. Prasyarat Sistem (Prerequisites)

Sebelum melakukan deployment, pastikan perangkat Anda sudah terinstall tools berikut sesuai dengan Operating System yang Anda gunakan:

- **Windows / macOS**: [Docker Desktop](https://www.docker.com/products/docker-desktop/) (**Wajib dipastikan aplikasi Docker Desktop sudah dibuka/Running** sampai ikon paus di taskbar berwarna hijau).
- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/) & [Docker Compose](https://docs.docker.com/compose/install/) (Minimal versi 2.0).
- **Git**: [Git CLI](https://git-scm.com/downloads) (Untuk melakukan cloning repository).

---

### C. Konfigurasi Environment & Keamanan API Key

Untuk mematuhi standar keamanan industri, kredensial sensitif dan LLM API Key dilarang keras di-push langsung ke repositori publik demi menghindari eksploitasi oleh bot crawler otomatis. 

Oleh karena itu, sistem ini di-deploy menggunakan **Script Wrapper (`run.sh` / `run.bat`)** yang berfungsi menyuntikkan *Environment Variables* dan API Key secara dinamis langsung ke memori lokal kontainer saat inisialisasi awal. Juri **tidak perlu** membuat atau mengonfigurasi file `.env` secara manual (Zero-Configuration Deployment).

---

### D. Langkah-Langkah Deployment (Step-by-Step)

Juri hanya perlu mengikuti panduan spesifik per Sistem Operasi berikut ini agar aplikasi beserta fitur AI dapat berjalan secara instan:

**Langkah 1: Persiapan Terminal (Sangat Penting)**
- **Khusus Pengguna Windows:** Buka Start Menu, ketik **CMD**, lalu klik kanan dan wajib pilih **"Run as Administrator"**.
- **Khusus Pengguna Linux / macOS:** Buka aplikasi Terminal bawaan Anda.

**Langkah 2: Clone & Masuk ke Direktori Project**
Jalankan perintah ini di dalam terminal Anda:
```bash
git clone [https://github.com/josuke324/fidus-ai-ub.git](https://github.com/josuke324/fidus-ai-ub.git)
cd fidus-ai-ub
```

**Langkah 3: Jalankan Otomatisasi Sistem**
- **Bagi Pengguna Windows:** Jalankan perintah berikut di dalam CMD Anda:
```cmd
run.bat
```
- **Bagi Pengguna Linux / macOS:** Jalankan perintah berikut di terminal Anda:
```bash
bash run.sh
```

> ⚠️ **PENTING: JIKA MUNCUL ERROR DOCKER API / SOCKET / DAEMON**
> 
> Jika proses gagal dengan pesan *“failed to connect to the docker API”*, artinya service Docker di perangkat Anda belum aktif. 
> - **Windows**: Buka aplikasi **Docker Desktop** secara manual lewat Start Menu.
> - **Linux (Standard)**: Ketik `sudo systemctl start docker`
> - **Linux (Podman)**: Ketik `systemctl --user enable --now podman.socket`
> Setelah aktif, jalankan kembali perintah pada **Langkah 3**.

**Langkah 4: Verifikasi Status Container**
Pastikan seluruh layanan penunjang sistem telah berjalan dengan status `Up`:
```bash
docker-compose ps
```
*Catatan: Jika container mendadak `Exit`, pastikan Port 3000 atau Port 33306 di perangkat Anda tidak sedang digunakan oleh aplikasi lokal lain.*

**Langkah 5: Akses Aplikasi (Testing)**
Buka browser web Anda dan gunakan tautan berikut untuk masuk ke sistem:
- **Dashboard Utama**: `http://localhost:3000`
- **Bypass Akses Konselor (Direct Link)**: `http://localhost:3000/doctor.html?role=psikiater`

---

### E. Manajemen Layanan & Pembersihan (Troubleshooting)

- **Melihat Log Aplikasi secara Real-time**
  Jika juri ingin memantau aktivitas request API atau proses analisis kognitif AI:
  ```bash
  docker-compose logs -f fidus_app
  ```

- **Membersihkan Kesalahan (Wipe & Reset)**
  Jika terjadi error fatal saat *running*, matikan dan hapus seluruh sisa container yang *corrupt* dengan perintah ini, lalu ulangi kembali **Langkah 3**:
  ```bash
  docker-compose down -v
  ```
