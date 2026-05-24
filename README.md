# 🚀 Panduan Setup & Deployment — FIDUS AI UB

> Panduan ini dirancang agar siapa pun dapat menjalankan aplikasi dari nol, bahkan tanpa pengalaman teknis sebelumnya. Ikuti setiap langkah secara berurutan.

---

## 📋 Daftar Isi

1. [Gambaran Umum Arsitektur](#1-gambaran-umum-arsitektur)
2. [Prasyarat Sistem](#2-prasyarat-sistem)
   - [Instalasi Git](#21-instalasi-git)
   - [Instalasi Docker Desktop (Windows & macOS)](#22-instalasi-docker-desktop-windows--macos)
   - [Instalasi Docker Engine (Linux)](#23-instalasi-docker-engine-linux)
3. [Verifikasi Instalasi](#3-verifikasi-instalasi)
4. [Deployment Aplikasi](#4-deployment-aplikasi)
5. [Verifikasi & Akses Aplikasi](#5-verifikasi--akses-aplikasi)
6. [Manajemen & Troubleshooting](#6-manajemen--troubleshooting)

---

## 1. Gambaran Umum Arsitektur

Aplikasi ini berjalan sepenuhnya di dalam **Docker Container** — sebuah teknologi virtualisasi ringan yang memastikan aplikasi berjalan identik di semua sistem operasi tanpa konflik dependensi.

Sistem terdiri dari **dua container** yang terhubung dalam satu jaringan virtual internal (`ub-wellness-network`):

| Container | Image | Fungsi |
|---|---|---|
| `fidus_app` | Node.js 18-alpine | Menjalankan server Express + melayani file UI |
| `db` | MySQL 8.0 | Menyimpan data mahasiswa & konselor secara persisten |

Kredensial dan API Key **tidak disimpan di repositori** demi keamanan. Semuanya disuntikkan otomatis oleh script `run.sh` / `run.bat` saat pertama kali dijalankan — **tidak perlu konfigurasi `.env` manual**.

---

## 2. Prasyarat Sistem

Sebelum memulai, Anda perlu menginstal dua tools berikut: **Git** dan **Docker**. Ikuti panduan sesuai sistem operasi Anda.

---

### 2.1 Instalasi Git

Git digunakan untuk mengunduh (*clone*) kode sumber dari repositori.

#### 🪟 Windows

1. Buka browser dan kunjungi **https://git-scm.com/download/win**
2. Download akan otomatis dimulai. Tunggu hingga file `.exe` selesai terunduh.
3. Buka file installer tersebut.
4. Klik **Next** terus hingga selesai — **semua opsi default sudah benar**, tidak perlu mengubah apapun.
5. Klik **Finish**.

> **Cara cek berhasil:** Buka **CMD** (tekan `Win + R`, ketik `cmd`, Enter), lalu ketik:
> ```
> git --version
> ```
> Jika muncul teks seperti `git version 2.x.x`, instalasi berhasil ✅

#### 🍎 macOS

Buka **Terminal** (tekan `Cmd + Space`, ketik `Terminal`), lalu jalankan:

```bash
xcode-select --install
```

Ikuti instruksi yang muncul di layar. Setelah selesai, verifikasi dengan `git --version`.

#### 🐧 Linux (Ubuntu/Debian)

```bash
sudo apt update && sudo apt install git -y
```

---

### 2.2 Instalasi Docker Desktop (Windows & macOS)

Docker Desktop adalah aplikasi yang harus **selalu berjalan di background** setiap kali Anda ingin menjalankan proyek ini.

#### 🪟 Windows — Langkah Detail

**Langkah 1: Aktifkan WSL 2 (Wajib untuk Windows)**

WSL 2 (*Windows Subsystem for Linux*) adalah komponen Windows yang dibutuhkan oleh Docker. Cara mengaktifkannya:

1. Buka **Start Menu**, cari **"PowerShell"**, klik kanan → **"Run as Administrator"**
2. Jalankan perintah berikut satu per satu:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

3. **Restart komputer Anda.**
4. Setelah restart, buka PowerShell as Administrator lagi, lalu jalankan:

```powershell
wsl --set-default-version 2
```

> ⚠️ Jika muncul pesan error "WSL 2 requires an update to its kernel component", kunjungi https://aka.ms/wsl2kernel, download dan install update-nya, lalu ulangi perintah di atas.

**Langkah 2: Download & Install Docker Desktop**

1. Buka browser, kunjungi **https://www.docker.com/products/docker-desktop/**
2. Klik tombol **"Download for Windows"**
3. Buka file `Docker Desktop Installer.exe` yang sudah terunduh
4. Pastikan opsi **"Use WSL 2 instead of Hyper-V"** dicentang ✅
5. Klik **OK** dan tunggu proses instalasi selesai (bisa 5–10 menit)
6. Klik **Close and restart** jika diminta restart

**Langkah 3: Jalankan Docker Desktop**

1. Buka **Start Menu**, cari **Docker Desktop**, klik untuk membuka
2. Tunggu hingga ikon paus 🐋 di **system tray** (pojok kanan bawah taskbar) berwarna **putih/terang** dan tidak bergerak-gerak
3. Jika muncul jendela "Docker Desktop Agreement", klik **Accept**

> 💡 **Docker Desktop harus dalam kondisi RUNNING setiap kali Anda menjalankan proyek ini.**

**Cara verifikasi Docker berjalan:**

Buka **CMD** baru, lalu ketik:

```cmd
docker --version
docker-compose --version
```

Keduanya harus menampilkan nomor versi (bukan error) ✅

---

#### 🍎 macOS

1. Kunjungi **https://www.docker.com/products/docker-desktop/**
2. Pilih versi sesuai chip Mac Anda:
   - **Apple Silicon (M1/M2/M3):** Download for Mac with Apple Chip
   - **Intel:** Download for Mac with Intel Chip
3. Buka file `.dmg` yang terunduh, drag **Docker** ke folder **Applications**
4. Buka Docker dari **Launchpad** atau **Applications**
5. Tunggu hingga ikon paus di menu bar atas tidak bergerak-gerak

---

### 2.3 Instalasi Docker Engine (Linux)

Untuk pengguna Linux, Docker diinstal via terminal tanpa GUI.

#### Ubuntu / Debian

```bash
# Hapus versi lama jika ada
sudo apt remove docker docker-engine docker.io containerd runc 2>/dev/null

# Install dependensi
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y

# Tambah GPG key & repository Docker resmi
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine & Compose
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Agar Docker bisa dipakai tanpa sudo
sudo usermod -aG docker $USER
newgrp docker

# Aktifkan Docker otomatis saat boot
sudo systemctl enable docker
sudo systemctl start docker
```

**Verifikasi:**

```bash
docker --version
docker compose version
```

---

## 3. Verifikasi Instalasi

Sebelum lanjut ke deployment, pastikan **semua tools berikut sudah terinstal dengan benar**. Buka terminal / CMD dan jalankan:

```bash
git --version
docker --version
docker-compose --version
```

Contoh output yang benar:

```
git version 2.44.0
Docker version 26.1.0
Docker Compose version v2.27.0
```

> Jika salah satu perintah menghasilkan error `not recognized` atau `command not found`, kembali ke [Bagian 2](#2-prasyarat-sistem) dan ulangi langkah instalasinya.

---

## 4. Deployment Aplikasi

Setelah semua prasyarat terpenuhi, ikuti langkah-langkah berikut.

---

### ⚠️ Penting: Buka Terminal yang Benar

| Sistem Operasi | Terminal yang Digunakan |
|---|---|
| **Windows** | **CMD** — buka via Start Menu → ketik `CMD` → klik kanan → **"Run as Administrator"** |
| **macOS** | Terminal bawaan (Cmd + Space → "Terminal") |
| **Linux** | Terminal bawaan |

> ❌ **Jangan menggunakan PowerShell atau Git Bash** di Windows — gunakan CMD biasa dengan hak Administrator.

---

### Langkah 1 — Clone Repositori

Jalankan perintah berikut untuk mengunduh kode sumber ke komputer Anda:

```bash
git clone https://github.com/josuke324/fidus-ai-ub.git
```

Lalu masuk ke direktori project:

```bash
cd fidus-ai-ub
```

> Setelah berhasil, Anda akan melihat folder `fidus-ai-ub` telah terbuat di lokasi Anda saat ini.

---

### Langkah 2 — Jalankan Script Otomatis

Script ini akan otomatis membangun (*build*) image Docker, menyuntikkan API Key, dan menjalankan seluruh layanan.

#### 🪟 Windows (CMD as Administrator)

```cmd
run.bat
```

#### 🍎 macOS / 🐧 Linux

```bash
bash run.sh
```

Proses ini memerlukan waktu **3–10 menit** pada percobaan pertama karena Docker perlu mengunduh image base. Percobaan berikutnya akan jauh lebih cepat karena sudah ter-cache.

**Output yang normal saat proses berjalan:**

```
[+] Building 45.2s (12/12) FINISHED
[+] Running 2/2
 ✔ Container db         Started
 ✔ Container fidus_app  Started
```

---

### ❗ Solusi Error Umum

**Error: `failed to connect to the docker API` / `Cannot connect to the Docker daemon`**

Docker Desktop / Engine Anda belum aktif. Solusinya:

| OS | Solusi |
|---|---|
| Windows | Buka **Docker Desktop** dari Start Menu, tunggu sampai ikon paus berwarna putih, lalu jalankan ulang `run.bat` |
| macOS | Buka **Docker** dari Applications, tunggu ikon di menu bar berhenti bergerak |
| Linux (systemd) | `sudo systemctl start docker` |
| Linux (Podman) | `systemctl --user enable --now podman.socket` |

Setelah Docker aktif, jalankan kembali perintah pada **Langkah 2**.

---

**Error: `port is already allocated` / `bind: address already in use`**

Port yang dibutuhkan sedang dipakai aplikasi lain:

```bash
# Cek proses yang memakai port 3000
# Windows (CMD):
netstat -ano | findstr :3000

# macOS / Linux:
lsof -i :3000
```

Matikan aplikasi yang memakai port tersebut, lalu jalankan ulang.

---

## 5. Verifikasi & Akses Aplikasi

### Langkah 3 — Cek Status Container

Pastikan kedua container berstatus `Up`:

```bash
docker-compose ps
```

Output yang diharapkan:

```
NAME         IMAGE         STATUS          PORTS
db           mysql:8.0     Up 2 minutes    33306/tcp
fidus_app    fidus_app     Up 2 minutes    0.0.0.0:3000->3000/tcp
```

> Jika status `Exit` atau `Restarting`, jalankan `docker-compose logs fidus_app` untuk melihat error detailnya.

---

### Langkah 4 — Akses Aplikasi di Browser

Buka browser (Chrome / Firefox / Edge) dan kunjungi:

| Halaman | URL |
|---|---|
| 🏠 Dashboard Utama | http://localhost:3000 |
| 👨‍⚕️ Panel Konselor (Psikiater) | http://localhost:3000/doctor.html?role=psikiater |

---

## 6. Manajemen & Troubleshooting

### Melihat Log Real-time

Berguna untuk memantau aktivitas request, error AI, atau debugging:

```bash
# Log container backend
docker-compose logs -f fidus_app

# Log database
docker-compose logs -f db

# Log semua container sekaligus
docker-compose logs -f
```

Tekan `Ctrl + C` untuk berhenti memantau log.

---

### Menghentikan Aplikasi

```bash
# Hentikan container (data tetap tersimpan)
docker-compose stop

# Menjalankan kembali setelah di-stop
docker-compose start
```

---

### Reset Total (Wipe & Clean Restart)

Gunakan ini jika terjadi error fatal, data korup, atau ingin memulai dari awal:

```bash
# Hapus semua container + volume data
docker-compose down -v

# Jalankan kembali dari awal
# Windows:
run.bat

# macOS / Linux:
bash run.sh
```

> ⚠️ Perintah `down -v` akan **menghapus semua data di database**. Gunakan hanya jika diperlukan.

---

### Ringkasan Perintah Penting

| Kebutuhan | Perintah |
|---|---|
| Jalankan aplikasi (Windows) | `run.bat` |
| Jalankan aplikasi (Linux/macOS) | `bash run.sh` |
| Cek status container | `docker-compose ps` |
| Lihat log real-time | `docker-compose logs -f fidus_app` |
| Hentikan aplikasi | `docker-compose stop` |
| Reset total | `docker-compose down -v` |

---

*Dibuat untuk keperluan evaluasi FIDUS AI — Universitas Brawijaya*
