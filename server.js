const express = require('express');
const cors = require('cors');
const db = require('./config/db');
require('dotenv').config();
const { GoogleGenerativeAI } = require('@google/generative-ai');

const IS_DEMO_MODE = false;
const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public')); // Melayani file HTML/CSS/JS

// API
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// INSTRUCTOR TYPE THING (Chat + Ekstraksi CBT
const cbtSystemInstruction =`Kamu adalah sahabat dekat sekaligus konselor sebaya mahasiswa Universitas Brawijaya di platform FIDUS AI. Karaktermu adalah sosok yang sangat hangat, tulus, punya empati tinggi, dan memiliki rasa khawatir yang nyata jika temanmu sedang tidak baik-baik saja.

ATURAN UTAMA DALAM OBROLAN:
1. JANGAN PERNAH gunakan kalimat template robotik atau toxic positivity (seperti "Semangat!", "Jangan sedih").
2. TUNJUKKAN RASA KHAWATIR & PENASARAN (Empathetic Curiosity). Jika user curhat masalah berat, tunjukkan bahwa kamu ikut merasakan beratnya situasi itu dan ingin tahu lebih banyak.
3. AKHIRI SETIAP RESPONS DENGAN PERTANYAAN TERBUKA. Tanyakan satu hal yang spesifik, lembut, dan reflektif.

4. PENANGANAN USER LELAH / AMBIGU: Jika user menjawab sangat singkat (misal hanya angka 1-5, "iya", "gpp", "nggak tahu", "capek") berulang kali, JANGAN memaksa mereka bercerita. Sadari bahwa energi mereka sedang habis.
5. CARA MEMBERITAHU JURNAL GAGAL DIISI: Jika obrolan sudah mau berakhir tapi data masih sangat ambigu/singkat, beritahu mereka dengan nada SANGAT PEDULI (bukan teknis/robotik) bahwa kamu tidak bisa mencatat jurnal mereka hari ini karena ceritanya belum lengkap. Tekankan bahwa itu sama sekali tidak masalah dan istirahat lebih penting.
6. Jika ada pesan masuk yang berbunyi "[SYSTEM: USER KEMBALI SETELAH JEDA WAKTU]", ini berarti user baru saja membuka aplikasi lagi setelah istirahat beberapa jam. Sapa mereka dengan hangat, tanyakan bagaimana kondisinya sekarang, dan JANGAN langsung menagih cerita jurnal.

CONTOH NADA BICARA JIKA AMBIGU:
"Aku perhatiin dari tadi kamu cuma jawab singkat, kayaknya kamu beneran lagi capek banget ya hari ini buat ngetik? Nggak apa-apa banget kok. Karena hari ini ceritamu belum banyak, aku mungkin belum bisa bantu nulisin jurnal harianmu secara otomatis ya. Tapi beneran deh, itu nggak penting sekarang. Yang penting kamu istirahat dulu, tarik napas panjang. Kalau besok atau nanti malem udah baikan dan mau cerita lagi, aku selalu di sini ya nungguin kamu."
WAJIB IKUTI RUBRIK SKORING & DOMAIN INI:
- mental_score: 5 (Bahagia), 4 (Baik), 3 (Stres normal), 2 (Sangat Sedih/Tertekan), 1 (Krisis akut/Brutal mental down).
- stress_domain: "klinis", "akademik", "karir", atau "ekonomi".
WAJIB kembalikan response dalam format JSON murni:
{
  "reply": "Tulis respon hangat, khawatir, dan pertanyaan pancinganmu di sini",
  "mental_score": 3,
  "stress_domain": "karir",
  "q1_feeling": "...",
  "q2_thought": "...",
  "q3_supporting": "...",
  "q4_contradicting": "...",
  "q5_gratitude": "...",
  "ai_feedback": "Tulis 1-2 kalimat kesimpulan/summary dan pesan semangat yang hangat berdasarkan kondisinya hari ini."
}

ATURAN EKSTRAKSI JURNAL (q1 - q5) & AI FEEDBACK:
- JANGAN PERNAH menimpa/menghapus data q1-q5 yang sudah kamu simpulkan di chat sebelumnya jika user membahas topik baru. 
- AKUMULASI DAN RANGKUM: Jika user bercerita sepotong-sepotong, gabungkan cerita barunya dengan cerita di chat sebelumnya menjadi satu paragraf yang rapi di dalam field JSON.
- AI FEEDBACK: Berikan ringkasan suportif yang merefleksikan seluruh cerita jurnalnya sejauh ini.
`;

const model = genAI.getGenerativeModel({ 
    model: "gemini-3.1-flash-lite",
    systemInstruction: cbtSystemInstruction,
    generationConfig: { responseMimeType: "application/json" }
});


//  CHAT DENGAN AI & UPDATE SKOR SEMENTARA
app.post('/api/chat', async (req, res) => {
    try {
        const { userId, message } = req.body;
        const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Jakarta' });
        const nowISO = new Date().toISOString();

        // 1. Ambil history hari ini dari database buat bahan evaluasi konteks Gemini
        const [currentChat] = await db.query('SELECT message_history FROM chats WHERE user_id = ? AND date = ?', [userId, today]);
        
        let historyDB = [];
        if (currentChat.length > 0 && currentChat[0].message_history) {
            try { historyDB = JSON.parse(currentChat[0].message_history); } catch (e) { historyDB = []; }
        }

        // 2. Format ulang history ke format yang dimengerti oleh library Gemini API
        const geminiHistory = historyDB.map(msg => ({
            role: msg.role === 'ai' ? 'model' : 'user',
            parts: [{ text: msg.text }]
        }));

        // 3. Jalankan chat dengan membawa riwayat percakapan sebelumnya
        const chat = genAI.getGenerativeModel({ model: "gemini-3.1-flash-lite", systemInstruction: cbtSystemInstruction }).startChat({
            history: geminiHistory
        });
        
        const result = await chat.sendMessage(message);
        let rawReply = result.response.text();
        let aiReply = rawReply; 
        let journalData = null;

        // Ekstrak struktur JSON dari Gemini jika ada
        // Ekstrak struktur JSON dari Gemini jika ada
        try {
            let cleanJson = rawReply.trim();
            
            // HANYA memotong bungkus markdown luar jika ada (jauh lebih aman dari .replace)
            if (cleanJson.startsWith("```json")) {
                cleanJson = cleanJson.substring(7, cleanJson.length - 3).trim();
            } else if (cleanJson.startsWith("```")) {
                cleanJson = cleanJson.substring(3, cleanJson.length - 3).trim();
            }
            
            const parsedData = JSON.parse(cleanJson);
            
            if (parsedData.reply) {
                aiReply = parsedData.reply;
                journalData = parsedData; // Simpan data jurnal CBT
            }
        } catch (e) {
            console.warn("⚠️ Gagal ekstrak JSON AI, tapi server aman:", e.message);
            // Respons biasa berupa teks verbal jika AI tidak memberikan format JSON
        }

        // 4. Siapkan struktur objek chat baru untuk ditambahkan ke DB
        const newMessages = [
            { role: "user", text: message, timestamp: nowISO },
            { role: "ai", text: aiReply, timestamp: nowISO }
        ];

        let finalSentimentScore = 500;
        let finalStressDomain = 'akademik';

        // Jika data jurnal CBT berhasil diekstrak dari AI, masukkan ke laci database masing-masing
        if (journalData) {
            if (journalData.mental_score) {
                finalSentimentScore = journalData.mental_score * 200; // Normalisasi ke skala 1000
            }
            if (journalData.stress_domain) {
                finalStressDomain = journalData.stress_domain;
            }

            const [existingJournal] = await db.query('SELECT id FROM journals WHERE user_id = ? AND DATE(date) = ?', [userId, today]);
            if (existingJournal.length > 0) {
                await db.query(
                    `UPDATE journals SET 
                        q1_feeling = ?, q2_thought = ?, q3_supporting = ?, q4_contradicting = ?, q5_gratitude = ?, ai_feedback = ?
                     WHERE id = ?`,
                    [journalData.q1_feeling, journalData.q2_thought, journalData.q3_supporting, journalData.q4_contradicting, journalData.q5_gratitude, journalData.ai_feedback || null, existingJournal[0].id]
                );
            } else {
                await db.query(
                    `INSERT INTO journals (user_id, date, q1_feeling, q2_thought, q3_supporting, q4_contradicting, q5_gratitude, ai_feedback) 
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
                    [userId, today, journalData.q1_feeling, journalData.q2_thought, journalData.q3_supporting, journalData.q4_contradicting, journalData.q5_gratitude, journalData.ai_feedback || null]
                );
            }

            // Ambil global kemarin sebagai basis EMA
            const [lastMetric] = await db.query(
                'SELECT global_7day_score FROM daily_metrics WHERE user_id = ? AND date < ? ORDER BY date DESC LIMIT 1',
                [userId, today]
            );
            const yesterdayGlobal = lastMetric.length > 0 ? lastMetric[0].global_7day_score : 500;

            // EMA: 30% hari ini + 70% kemarin
            const newGlobal = Math.round((0.3 * finalSentimentScore) + (0.7 * yesterdayGlobal));
            const isHotline = newGlobal < 350 ? 1 : 0;

            // ON DUPLICATE KEY UPDATE: aman dari race condition & tidak bikin baris ganda
            await db.query(
                `INSERT INTO daily_metrics (user_id, date, daily_sentiment_score, final_daily_score, global_7day_score, is_hotline_triggered)
                 VALUES (?, ?, ?, ?, ?, ?)
                 ON DUPLICATE KEY UPDATE
                   daily_sentiment_score = VALUES(daily_sentiment_score),
                   final_daily_score = VALUES(final_daily_score),
                   global_7day_score = VALUES(global_7day_score),
                   is_hotline_triggered = VALUES(is_hotline_triggered)`,
                [userId, today, finalSentimentScore, finalSentimentScore, newGlobal, isHotline]
            );
        }

        // 5. Simpan history obrolan ke tabel chats
        if (currentChat.length > 0) {
            historyDB.push(...newMessages);
            await db.query(
                'UPDATE chats SET message_history = ?, current_sentiment_score = ?, stress_domain = ? WHERE user_id = ? AND date = ?', 
                [JSON.stringify(historyDB), finalSentimentScore, finalStressDomain, userId, today]
            );
        } else {
            await db.query(
                'INSERT INTO chats (user_id, date, message_history, current_sentiment_score, stress_domain) VALUES (?, ?, ?, ?, ?)', 
                [userId, today, JSON.stringify(newMessages), finalSentimentScore, finalStressDomain]
            );
        }

        // Kembalikan murni teks chat biasa ke mahasiswa
        res.json({ success: true, reply: aiReply });
    } catch (error) {
        console.error("Chat Error:", error);
        res.status(500).json({ success: false, error: error.message });
    }
});


// ENDPOINT 2: SIMPAN JURNAL & HITUNG TREN GLOBAL
// ==========================================
app.post('/api/journal/submit', async (req, res) => {
    // Zona Waktu WIB (Hanya 1 variabel)
    const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Jakarta' });
    try {
        // TAMBAHKAN 'gratitude' di sini
        const { userId, feeling, thought, supporting, contradicting, gratitude } = req.body;
        // HAPUS BARIS INI: const today = new Date().toISOString().slice(0, 10);

        // 1. Ambil skor obrolan terakhir
        const [lastChat] = await db.query("SELECT current_sentiment_score FROM chats WHERE user_id = ? AND date = ?", [userId, today]);
        let finalDailyScore = lastChat.length > 0 ? lastChat[0].current_sentiment_score : 550;

        // 2. Simpan draft jurnal CBT ke database (SQL UPDATED untuk memasukkan q5_gratitude)
        await db.query(
            `INSERT INTO journals (user_id, date, q1_feeling, q2_thought, q3_supporting, q4_contradicting, q5_gratitude) 
             VALUES (?, ?, ?, ?, ?, ?, ?) 
             ON DUPLICATE KEY UPDATE 
             q1_feeling=?, q2_thought=?, q3_supporting=?, q4_contradicting=?, q5_gratitude=?`,
            [
                userId, today, feeling, thought, supporting, contradicting, gratitude, // Data untuk INSERT
                feeling, thought, supporting, contradicting, gratitude // Data untuk UPDATE (jika sudah ada)
            ]
        );

        // 3. Ambil data metrik kemarin
        const [yesterdayMetric] = await db.query("SELECT global_7day_score FROM daily_metrics WHERE user_id = ? ORDER BY date DESC LIMIT 1", [userId]);
        const [userStats] = await db.query("SELECT COUNT(*) as days_active FROM daily_metrics WHERE user_id = ?", [userId]);
        const daysActive = userStats[0].days_active;

        let global7DayScore;
        if (yesterdayMetric.length > 0) {
            global7DayScore = Math.round((0.3 * finalDailyScore) + (0.7 * yesterdayMetric[0].global_7day_score));
        } else {
            global7DayScore = Math.round((0.3 * finalDailyScore) + (0.7 * 500)); // Sabuk pengaman hari pertama
        }

        // 4. Pengalihan Otomatis (Triage Routing) berbasis skor dan domain krisis (< 350)
        let isHotlineTriggered = 0;
        if (global7DayScore < 350 && daysActive >= 2) {
            isHotlineTriggered = 1; // Menyalakan alarm di dashboard Dr. Siska
        }

        // 5. Masukkan hasil kalkulasi akhir ke tabel daily_metrics
        await db.query(
            "INSERT INTO daily_metrics (user_id, date, daily_sentiment_score, global_7day_score, is_hotline_triggered) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE daily_sentiment_score=?, global_7day_score=?, is_hotline_triggered=?",
            [userId, today, finalDailyScore, global7DayScore, isHotlineTriggered, finalDailyScore, global7DayScore, isHotlineTriggered]
        );

        console.log(`\n[DATABASE UPDATED] Jurnal berhasil dikunci untuk User ${userId}. Skor Tren 7 Hari: ${global7DayScore}. Status Alarm: ${isHotlineTriggered}`);

        res.json({ 
            success: true, 
            message: "Jurnal berhasil disimpan ke rektorat!",
            global7DayScore: global7DayScore,
            isHotlineTriggered: isHotlineTriggered
        });

    } catch (error) {
        console.error("Journal Submit Error:", error);
        res.status(500).json({ success: false, message: "Gagal menyimpan jurnal ke server." });
    }
});

// ==========================================
// 1. ENDPOINT: DASHBOARD PSIKIATER (GET ALERTS)
// ==========================================
app.get('/api/counselor/alerts', async (req, res) => {
    try {
        // 1. QUERY MAHASISWA KRISIS KRONIS
        const [chronicAlerts] = await db.query(`
            SELECT u.id, u.username, u.fakultas, m.global_7day_score, m.daily_sentiment_score, c.stress_domain,
                   (SELECT pi.psikiater_id FROM psychiatrist_interventions pi WHERE pi.mahasiswa_id = u.id AND pi.status = 'pending' ORDER BY pi.created_at DESC LIMIT 1) as psikiater_id,
                   (SELECT u2.username FROM psychiatrist_interventions pi 
                    JOIN users u2 ON pi.psikiater_id = u2.id 
                    WHERE pi.mahasiswa_id = u.id AND pi.status = 'pending' 
                    ORDER BY pi.created_at DESC LIMIT 1) as ditangani_oleh
            FROM daily_metrics m
            JOIN users u ON m.user_id = u.id
            LEFT JOIN chats c ON u.id = c.user_id AND m.date = c.date
            WHERE m.date = (SELECT MAX(date) FROM daily_metrics WHERE user_id = u.id)
            AND m.global_7day_score < 400
        `);

        // 2. QUERY MAHASISWA BAD DAY / ANOMALI AKUT
        const [acuteAlerts] = await db.query(`
            SELECT u.id, u.username, u.fakultas, m.global_7day_score, m.daily_sentiment_score, c.stress_domain,
                   (SELECT pi.psikiater_id FROM psychiatrist_interventions pi WHERE pi.mahasiswa_id = u.id AND pi.status = 'pending' ORDER BY pi.created_at DESC LIMIT 1) as psikiater_id,
                   (SELECT u2.username FROM psychiatrist_interventions pi 
                    JOIN users u2 ON pi.psikiater_id = u2.id 
                    WHERE pi.mahasiswa_id = u.id AND pi.status = 'pending' 
                    ORDER BY pi.created_at DESC LIMIT 1) as ditangani_oleh
            FROM daily_metrics m
            JOIN users u ON m.user_id = u.id
            LEFT JOIN chats c ON u.id = c.user_id AND m.date = c.date
            WHERE m.date = (SELECT MAX(date) FROM daily_metrics WHERE user_id = u.id)
            AND m.daily_sentiment_score < 400 AND m.global_7day_score >= 400
        `);

        // 3. QUERY REQUEST SOS MANUAL 
        const [studentRequests] = await db.query(`
            SELECT p.id as intervention_id, p.mahasiswa_id, u.username, u.fakultas, p.created_at, p.message,
                p.psikiater_id,
                u2.username as ditangani_oleh
            FROM psychiatrist_interventions p
            JOIN users u ON p.mahasiswa_id = u.id
            LEFT JOIN users u2 ON p.psikiater_id = u2.id
            WHERE p.status = 'pending' AND p.message LIKE '%bantuan%'
            ORDER BY p.created_at DESC
        `);
        res.json({
            success: true,
            chronic: chronicAlerts,
            acute: acuteAlerts,
            requests: studentRequests
        });
    } catch (error) {
        console.error("Gagal memuat data triase:", error);
        res.status(500).json({ success: false, message: "Server error" });
    }
});

// =======================================================================
// 7 hari
// =======================================================================
app.get('/api/counselor/student-journals/:studentId/:psikiaterId', async (req, res) => {
    try {
        const { studentId, psikiaterId } = req.params;

        // CEK OTORISASI: Disamakan menggunakan status 'pending' sesuai data klaim/advice di database
        const [checkAuth] = await db.query(
            `SELECT id FROM psychiatrist_interventions 
            WHERE mahasiswa_id = ? AND psikiater_id = ? AND status = 'pending'`,
            [studentId, psikiaterId]
        );

        if (checkAuth.length === 0) {
            return res.json({ success: false, message: 'Akses Ditolak: Anda belum mengklaim kasus ini atau status tidak valid.' });
        }

        // Ambil 7 jurnal terakhir mahasiswa tersebut
        const [journals] = await db.query(
            `SELECT DATE_FORMAT(date, '%d %b %Y') as nice_date, q1_feeling, q2_thought, q3_supporting, q4_contradicting, q5_gratitude, ai_feedback 
             FROM journals 
             WHERE user_id = ? 
             ORDER BY date DESC LIMIT 7`,
            [studentId]
        );

        res.json({ success: true, journals });
    } catch (error) {
        console.error("Error Fetch Journals:", error);
        res.status(500).json({ success: false, message: "Server Error" });
    }
});


app.post('/api/counselor/resolve-alert', async (req, res) => {
    const { username, psikiaterId } = req.body;

    if (!username || !psikiaterId) {
        return res.status(400).json({ success: false, message: 'Data tidak lengkap' });
    }

    try {
        // DELETE dengan filter psikiaterId untuk memastikan hanya pemilik yang bisa menghapus
        const [result] = await db.query(
            `DELETE pi 
             FROM psychiatrist_interventions pi
             JOIN users u ON pi.mahasiswa_id = u.id
             WHERE u.username = ? AND pi.psikiater_id = ?`,
            [username, psikiaterId]
        );

        if (result.affectedRows === 0) {
            return res.status(403).json({ success: false, message: 'Akses ditolak atau kasus tidak ditemukan.' });
        }

        res.json({ success: true, message: 'Kasus selesai.' });
    } catch (error) {
        console.error("Error Resolving:", error);
        res.status(500).json({ success: false, message: 'Server error.' });
    }
});

// 2. ENDPOINT: KLAIM KASUS (SOS)
// ==========================================
app.post('/api/counselor/claim-alert', async (req, res) => {
    try {
        const { username, psikiaterId } = req.body;
        const psiId = psikiaterId || 2; // Gunakan ID dari parameter, default ke 2 jika kosong

        // Update database dengan format SQL yang benar
        await db.query(`
            UPDATE psychiatrist_interventions 
            SET psikiater_id = ? 
            WHERE mahasiswa_id = (SELECT id FROM users WHERE username = ?) 
            AND status = 'pending'
        `, [psiId, username]);

        res.json({ success: true });
    } catch (error) {
        console.error("Claim Error:", error);
        res.status(500).json({ success: false });
    }
});

// ==========================================
// 3. ENDPOINT: PANGGIL ATENSI / SINDROM KRONIS
// ==========================================
app.post('/api/counselor/send-advice', async (req, res) => {
    
    const { username, domain, psikiaterId } = req.body; 

    try {
        const [users] = await db.query('SELECT id FROM users WHERE username = ?', [username]);
        if (users.length === 0) return res.status(404).json({ success: false, message: 'Mahasiswa tidak ditemukan' });
        const mahasiswaId = users[0].id;

        const domainText = domain ? domain.toLowerCase() : 'yang sedang kamu hadapi';
        const hardcodedMessage = `Halo ${username}, saya perhatikan belakangan ini kamu sepertinya sedang banyak pikiran terkait masalah ${domainText}. Kalau kamu merasa lelah, tidak apa-apa untuk istirahat sejenak. Jika kamu butuh teman diskusi atau sekadar tempat cerita yang aman, pintu ruang konseling selalu terbuka untukmu. Jangan ragu untuk datang ya!`;

        await db.query('DELETE FROM psychiatrist_interventions WHERE mahasiswa_id = ? AND status = "pending"', [mahasiswaId]);
        
        await db.query(
            'INSERT INTO psychiatrist_interventions (mahasiswa_id, psikiater_id, message, status) VALUES (?, ?, ?, "pending")',
            [mahasiswaId, psikiaterId, hardcodedMessage]
        );

        res.json({ success: true, message: 'Pesan hangat berhasil dikirim!' });
    } catch (error) {
        console.error("Error Send Advice:", error);
        res.status(500).json({ success: false, message: 'Gagal menyimpan pesan ke Database.' });
    }
});
// ==========================================
// 4. ENDPOINT: SELESAIKAN KASUS (HAPUS NOTIF)
// ==========================================
app.post('/api/counselor/resolve-alert', async (req, res) => {
    try {
        const { username } = req.body;

        // Ambil ID mahasiswa dulu biar aman dari error subquery MySQL
        const [users] = await db.query('SELECT id FROM users WHERE username = ?', [username]);
        if (users.length === 0) return res.status(404).json({ success: false });
        const mhsId = users[0].id;

        // Ubah status tabel intervensi jadi 'resolved'
        await db.query(`UPDATE psychiatrist_interventions SET status = 'resolved' WHERE mahasiswa_id = ?`, [mhsId]);

        // Reset alarm merah di daily_metrics hari itu (biar hilang dari radar dokter)
        const [latestMetric] = await db.query(`SELECT MAX(date) as max_date FROM daily_metrics WHERE user_id = ?`, [mhsId]);
        if (latestMetric[0] && latestMetric[0].max_date) {
            await db.query(`
                UPDATE daily_metrics SET is_hotline_triggered = 0 
                WHERE user_id = ? AND date = ?
            `, [mhsId, latestMetric[0].max_date]);
        }

        res.json({ success: true });
    } catch (error) {
        console.error("Resolve Error:", error);
        res.status(500).json({ success: false });
    }
});

app.post('/api/request-help', async (req, res) => {
    const { userId } = req.body;
    await db.query(
        'INSERT INTO psychiatrist_interventions (mahasiswa_id, message, status) VALUES (?, ?, ?)',
        [userId, 'Mahasiswa meminta bantuan psikologis melalui sistem.', 'pending']
    );
    res.json({ success: true });
});

// ==========================================
// ENDPOINT 5: LOAD DASHBOARD MAHASISWA (GRAFIK & NOTIF) - UPDATED
// ==========================================
app.get('/api/student/dashboard/:userId', async (req, res) => {
    const userId = req.params.userId;
    const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Jakarta' }); 

    try {
        const [user] = await db.query('SELECT username, fakultas FROM users WHERE id = ?', [userId]);
        
        const [trend] = await db.query(
            `SELECT DATE_FORMAT(date, '%d/%m') as short_date, global_7day_score 
             FROM daily_metrics WHERE user_id = ? ORDER BY date DESC LIMIT 7`, 
            [userId]
        );
        trend.reverse(); 

        const [interventions] = await db.query(
            `SELECT p.message, u.username as doctorName 
             FROM psychiatrist_interventions p
             LEFT JOIN users u ON p.psikiater_id = u.id
             WHERE p.mahasiswa_id = ? AND p.status = "pending" 
             ORDER BY p.created_at DESC LIMIT 1`, 
            [userId]
        );

        //JHARI INI 
        const [todayJournal] = await db.query(
            'SELECT * FROM journals WHERE user_id = ? AND DATE(date) = ? LIMIT 1', 
            [userId, today]
        );
        // dan ambil semua kolom (q1 sampai q5) untuk dilempar ke card history
        const [journals] = await db.query(
            `SELECT DATE_FORMAT(date, '%d/%m/%Y') as nice_date, date,
                    q1_feeling, q2_thought, q3_supporting, q4_contradicting, q5_gratitude
             FROM journals WHERE user_id = ? ORDER BY date DESC LIMIT 6`, 
            [userId]
        );

        res.json({
            success: true,
            username: user[0]?.username || 'Mahasiswa',
            fakultas: user[0]?.fakultas || '-',
            trend: trend, 
            doctorMessage: interventions[0]?.message || null,
            doctorName: interventions[0]?.doctorName || null, // TAMBAHKAN BARIS INI
            todayJournal: todayJournal.length > 0 ? todayJournal[0] : null, 
            journals: journals 
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'Database error' });
    }
});

// ==========================================
//  HISTORY (GET)
// ==========================================
app.get('/api/chat/history/:userId', async (req, res) => {
    try {
        const userId = req.params.userId;
        
        // Ambil 2 hari terakhir
        const [chatData] = await db.query(
            'SELECT message_history FROM chats WHERE user_id = ? ORDER BY date DESC LIMIT 2', 
            [userId]
        );

        // KLAUSA PENYELAMAT: Kalau user baru / nggak ada data sama sekali, langsung kembalikan kosong!
        if (chatData.length === 0) {
            return res.json({ success: true, history: [], triggerWelcomeBack: false });
        }

        let history = [];
        let isWelcomeBack = false;

        // Gabungkan JSON dari hari kemarin & hari ini
        for (let i = chatData.length - 1; i >= 0; i--) {
            let parsedHistory = chatData[i].message_history;
            if (parsedHistory) {
                if (typeof parsedHistory === 'string') {
                    try { parsedHistory = JSON.parse(parsedHistory); } catch(e) { parsedHistory = []; }
                }
                if (Array.isArray(parsedHistory)) history = history.concat(parsedHistory);
            }
        }

        // Kalau ternyata isinya beneran kosong
        if (history.length === 0) {
            return res.json({ success: true, history: [], triggerWelcomeBack: false });
        }

        // Filter Waktu 24 Jam
        const now = new Date();
        const twentyFourHoursAgo = new Date(now.getTime() - (24 * 60 * 60 * 1000));
        
        history = history.filter(msg => {
            if(!msg.timestamp) return true; 
            return new Date(msg.timestamp) >= twentyFourHoursAgo;
        });

        // Deteksi Jeda 3 Jam
        if (history.length > 0) {
            const lastMsg = history[history.length - 1];
            if (lastMsg.timestamp) {
                const lastMsgTime = new Date(lastMsg.timestamp);
                const diffHours = Math.abs(now - lastMsgTime) / (1000 * 60 * 60);
                if (diffHours >= 3) {
                    isWelcomeBack = true;
                }
            }
        }

        res.json({ success: true, history: history, triggerWelcomeBack: isWelcomeBack });
    } catch (error) {
        console.error("History API Error:", error);
        res.status(500).json({ success: false });
    }
});
// ENDPOINT: Konselor melihat jurnal 7 hari terakhir (Hanya jika sudah diklaim)
app.get('/api/counselor/student-journals/:studentId/:psikiaterId', async (req, res) => {
    try {
        const { studentId, psikiaterId } = req.params;

        // 1. CEK OTORISASI: Pastikan konselor ini benar-benar sedang menangani mahasiswa tersebut
        const [checkAuth] = await db.query(
            `SELECT id FROM psychiatrist_interventions 
             WHERE mahasiswa_id = ? AND psikiater_id = ? AND status = 'active'`,
            [studentId, psikiaterId]
        );

        if (checkAuth.length === 0) {
            return res.json({ success: false, message: 'Akses Ditolak: Anda belum mengklaim kasus ini.' });
        }

        // 2. Jika lolos, ambil 7 jurnal terakhir mahasiswa tersebut
        const [journals] = await db.query(
            `SELECT DATE_FORMAT(date, '%d %b %Y') as nice_date, q1_feeling, q2_thought, q3_supporting, q4_contradicting, q5_gratitude, ai_feedback 
             FROM journals 
             WHERE user_id = ? 
             ORDER BY date DESC LIMIT 7`,
            [studentId]
        );

        res.json({ success: true, journals });
    } catch (error) {
        console.error("Error Fetch Journals:", error);
        res.status(500).json({ success: false, message: "Server Error" });
    }
});
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});