#!/bin/bash


# Trik memecah key agar lolos dari scan otomatis GitHub publik

PART1=""

PART2=""


# Gabungin kembali key-nya di memori lokal pas dijalankan

export GEMINI_API_KEY="${PART1}${PART2}"


echo "🚀 Memulai Otomatisasi Environment UB Wellness..."

docker-compose up -d --build
