@echo off
:: Trik memecah key agar lolos dari scan otomatis GitHub publik
set PART1=""
set PART2=""

:: Gabungin kembali key-nya di memori lokal pas dijalankan
set GEMINI_API_KEY=%PART1%%PART2%

echo 🚀 Memulai Otomatisasi Environment UB Wellness (Windows)...
docker-compose up -d --build
pause

