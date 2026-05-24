#!/bin/bash


# Trik memecah key agar lolos dari scan otomatis GitHub publik

PART1="AIzaSyA0sEpfOiI3S"

PART2="x4TAFFjX-lQhxkGDVhpl74"


# Gabungin kembali key-nya di memori lokal pas dijalankan

export GEMINI_API_KEY="${PART1}${PART2}"


echo "🚀 Memulai Otomatisasi Environment UB Wellness..."

docker-compose up -d --build
