### D. Langkah-Langkah Deployment (Step-by-Step)

Juri hanya perlu mengeksekusi rangkaian perintah sederhana berikut untuk menjalankan seluruh sistem beserta modul analisis AI secara instan:

1. **Clone & Masuk ke Direktori Project**
   Buka terminal/command prompt Anda, arahkan ke direktori kerja, lalu jalankan:
   ```bash
   git clone [https://github.com/josuke324/fidus-ai-ub.git](https://github.com/josuke324/fidus-ai-ub.git)
   cd fidus-ai-ub
   ```

2. **Jalankan Otomatisasi Sistem (Sesuai OS)**
   - **Jika Anda menggunakan Windows**: 
     Cukup klik dua kali (*double-click*) file `run.bat` di dalam folder project, atau jalankan perintah berikut di CMD/PowerShell:
     ```cmd
     run.bat
     ```
   - **Jika Anda menggunakan Linux / macOS**: 
     Jalankan perintah berikut di terminal:
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
