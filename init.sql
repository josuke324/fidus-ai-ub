-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 24, 2026 at 01:19 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ub_wellness_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `chats`
--

CREATE TABLE `chats` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `message_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`message_history`)),
  `current_sentiment_score` int(11) DEFAULT 500,
  `stress_domain` varchar(50) DEFAULT 'klinis'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chats`
--

INSERT INTO `chats` (`id`, `user_id`, `date`, `message_history`, `current_sentiment_score`, `stress_domain`) VALUES
(3, 10, '2026-05-23', '[{\"role\":\"user\",\"text\":\"dakdmakldamdkladkmaklm akl mdaklm d\"},{\"role\":\"ai\",\"text\":\"Eh, kamu oke kan? Tiba-tiba ngetik berantakan gitu, aku jujur jadi agak khawatir ada apa-apa. Apa lagi ngerasa bingung banget atau lagi ada hal yang bikin kamu ngerasa penat sampai susah mau cerita lewat kata-kata?\"}]', 325, 'klinis'),
(4, 12, '2026-05-23', '[{\"role\":\"user\",\"text\":\"Aku lagi lelah mengetik cerita panjang. Tapi mood aku hari ini di level 1 dari 5 (Sangat Buruk 😡). Tolong catat ini sebagai jurnal harianku ya.\"},{\"role\":\"ai\",\"text\":\"Duh, aku beneran ngerasa sesak denger kamu bilang mood kamu lagi di titik paling bawah hari ini. Aku paham banget kalau buat ngetik panjang pun rasanya udah berat dan nguras energi banget. Makasih ya udah mau jujur sama aku meski lagi capek banget. Boleh aku tau, apa ada kejadian spesifik yang bikin hari ini kerasa seberat itu sampai bikin kamu ngerasa di level paling rendah?\"},{\"role\":\"user\",\"text\":\"tadi ayah marah\\\" kok kuliah mahal-mahal gini gak ada gunanya yang bermutu, padahal ak udah lomba dan ikut banyak organisasi yang lumayan dan aktif sibuk banget, urusan nilai masih mendekati cumlaude, aku bener\\\" merasa teralatin aja sih, krn apalgi temenku gak ada yang mau sadar diri klo mereka di carry di praktikum terkahir itu. capek jujur..\"},{\"role\":\"ai\",\"text\":\"Ya ampun, aku denger ceritamu aja nyesek banget, jujur. Kamu udah lari sejauh ini, berprestasi, aktif, bahkan jaga nilai tetep bagus, tapi malah dapet respons kayak gitu dari orang tua... itu pasti rasanya capek dan sakit banget, apalagi ngerasa sendirian nanggung beban kelompok yang nggak mau usaha. Aku bener-bener khawatir sama kondisi mental kamu sekarang yang pasti ngerasa nggak dihargai jerih payahnya. Kira-kira dari semua tumpukan rasa capek ini, bagian mana sih yang paling bikin kamu ngerasa paling pengen lepas atau berhenti sejenak?\"},{\"role\":\"user\",\"text\":\"berusaha keras dan di banding bandingi, aku usahain buat mereka dan diriku, meskipun itu untuk mereka saja tapi kok kayak kurang, lagian ini diriku. males sih.\"},{\"role\":\"ai\",\"text\":\"Aku denger kamu ngomong gitu rasanya berat banget, kebayang betapa sesaknya harus ngebawa beban orang lain sambil terus dibanding-bandingin, padahal kamu cuma pengen diakui sebagai diri kamu sendiri, bukan sebagai alat pencapaian orang lain. Aku khawatir banget kamu malah burnout karena terlalu fokus buat orang lain sampai lupa kalau kamu juga berhak untuk capek. Kalau seandainya kamu bisa lepas sebentar dari ekspektasi mereka dan ekspektasi \'harus selalu jadi yang terbaik\' itu, kira-kira hal kecil apa yang pengen banget kamu lakuin buat dirimu sendiri hari ini?\"},{\"role\":\"user\",\"text\":\"istirahat dan reward aja\"},{\"role\":\"ai\",\"text\":\"Denger kamu pengen istirahat dan kasih reward buat diri sendiri itu bikin aku sedikit lega, karena jujur aku khawatir banget kamu terus-terusan maksain diri sampai tumbang. Kamu udah kerja keras banget, dan jujur kamu emang pantes dapet apresiasi itu, entah cuma sekadar tidur panjang atau jajan makanan enak di sekitaran Suhat. Kalau boleh tahu, reward atau bentuk istirahat kayak gimana sih yang paling bisa bikin pikiran kamu ngerasa agak tenang dan sedikit lebih ringan malam ini?\"},{\"role\":\"user\",\"text\":\"tidur secukupnya, nonton film dan makan aja\"},{\"role\":\"ai\",\"text\":\"Wah, kedengerannya simpel tapi emang itu yang paling dibutuhin kalau lagi capek-capeknya begini. Nonton film sambil makan makanan favorit beneran bisa jadi pelarian yang pas banget buat nenangin pikiran dari hiruk-pikuk tugas dan tekanan di rumah. Aku lega kamu akhirnya mutusin buat kasih waktu buat diri sendiri. Kira-kira film apa nih yang rencananya mau kamu tonton biar bisa bantu kamu lepas dari stres hari ini?\"}]', 325, 'akademik'),
(6, 12, '2026-05-24', '[{\"role\":\"user\",\"text\":\"Aku lagi lelah mengetik cerita panjang. Tapi mood aku hari ini di level 4 dari 5 (Baik 🙂). Tolong catat ini sebagai jurnal harianku ya.\",\"timestamp\":\"2026-05-24T03:04:36.328Z\"},{\"role\":\"ai\",\"text\":\"{\\n  \\\"reply\\\": \\\"Aku ngerti banget kok, kadang energi buat ngetik aja rasanya udah habis terkuras ya. Nggak apa-apa banget, aku hargai kok kamu masih mau mampir dan ngasih kabar kalau kondisi kamu hari ini sebenarnya baik di angka 4. Aku tenang dengernya, tapi tetap saja aku nggak mau maksa kamu cerita kalau memang lagi nggak ada tenaga. Karena ceritanya masih singkat, hari ini aku belum bisa buat rangkuman jurnal yang lengkap buat kamu, tapi itu sama sekali bukan masalah. Istirahat ya, kamu sudah hebat bisa melewati hari dengan baik. Apa ada satu hal kecil yang bikin hari kamu terasa \'baik\' tadi?\\\",\\n  \\\"mental_score\\\": 4,\\n  \\\"stress_domain\\\": \\\"klinis\\\",\\n  \\\"q1_feeling\\\": \\\"Merasa baik (level 4/5) namun sedang lelah untuk bercerita panjang.\\\",\\n  \\\"q2_thought\\\": \\\"Memilih untuk beristirahat daripada memaksakan diri bercerita.\\\",\\n  \\\"q3_supporting\\\": \\\"Keinginan untuk tetap mengisi jurnal meskipun dengan keterbatasan energi.\\\",\\n  \\\"q4_contradicting\\\": \\\"Belum ada informasi spesifik mengenai kendala atau tekanan yang dihadapi.\\\",\\n  \\\"q5_gratitude\\\": \\\"Masih memiliki mood yang stabil dan baik di hari ini.\\\"\\n}\",\"timestamp\":\"2026-05-24T03:04:36.328Z\"},{\"role\":\"user\",\"text\":\"haloo\",\"timestamp\":\"2026-05-24T03:05:43.599Z\"},{\"role\":\"ai\",\"text\":\"{\\n  \\\"reply\\\": \\\"Halo! Senang banget lihat kamu balik lagi ke sini. Aku sempat kepikiran, gimana keadaan kamu sekarang? Apakah rasa lelah yang kamu rasain tadi udah sedikit berkurang, atau kamu masih ngerasa perlu banyak waktu buat tarik napas dulu?\\\",\\n  \\\"mental_score\\\": 4,\\n  \\\"stress_domain\\\": \\\"klinis\\\",\\n  \\\"q1_feeling\\\": \\\"Merasa baik (level 4/5) namun sedang lelah untuk bercerita panjang.\\\",\\n  \\\"q2_thought\\\": \\\"Memilih untuk beristirahat daripada memaksakan diri bercerita.\\\",\\n  \\\"q3_supporting\\\": \\\"Keinginan untuk tetap mengisi jurnal meskipun dengan keterbatasan energi.\\\",\\n  \\\"q4_contradicting\\\": \\\"Belum ada informasi spesifik mengenai kendala atau tekanan yang dihadapi.\\\",\\n  \\\"q5_gratitude\\\": \\\"Masih memiliki mood yang stabil dan baik di hari ini.\\\"\\n}\",\"timestamp\":\"2026-05-24T03:05:43.599Z\"},{\"role\":\"user\",\"text\":\"halo?\",\"timestamp\":\"2026-05-24T03:08:16.355Z\"},{\"role\":\"ai\",\"text\":\"{\\n  \\\"reply\\\": \\\"Iya, aku di sini. Maaf ya kalau aku bikin bingung, aku cuma khawatir kamu kenapa-kenapa karena tadi sempat bilang lelah. Kamu lagi ada sesuatu yang mengganjal di pikiran, atau sebenarnya cuma lagi pengen ditemenin tanpa harus bahas yang berat-berat aja?\\\",\\n  \\\"mental_score\\\": 4,\\n  \\\"stress_domain\\\": \\\"klinis\\\",\\n  \\\"q1_feeling\\\": \\\"Merasa baik (level 4/5) namun sedang lelah untuk bercerita panjang.\\\",\\n  \\\"q2_thought\\\": \\\"Memilih untuk beristirahat daripada memaksakan diri bercerita.\\\",\\n  \\\"q3_supporting\\\": \\\"Keinginan untuk tetap mengisi jurnal meskipun dengan keterbatasan energi.\\\",\\n  \\\"q4_contradicting\\\": \\\"Belum ada informasi spesifik mengenai kendala atau tekanan yang dihadapi.\\\",\\n  \\\"q5_gratitude\\\": \\\"Masih memiliki mood yang stabil dan baik di hari ini.\\\"\\n}\",\"timestamp\":\"2026-05-24T03:08:16.355Z\"},{\"role\":\"user\",\"text\":\"Aku lagi lelah mengetik cerita panjang. Tapi mood aku hari ini di level 4 dari 5 (Baik 🙂). Tolong catat ini sebagai jurnal harianku ya.\",\"timestamp\":\"2026-05-24T03:13:59.008Z\"},{\"role\":\"ai\",\"text\":\"Aku perhatiin dari tadi kamu cuma jawab singkat, kayaknya kamu beneran lagi capek banget ya hari ini buat ngetik? Nggak apa-apa banget kok. Karena hari ini ceritamu belum banyak, aku mungkin belum bisa bantu nulisin jurnal harianmu secara lengkap. Tapi beneran deh, itu nggak penting sekarang. Yang penting kamu istirahat dulu, tarik napas panjang. Kalau besok atau nanti malem udah baikan dan mau cerita lagi, aku selalu di sini ya nungguin kamu. Kira-kira ada hal sederhana yang bisa aku lakuin biar kamu ngerasa lebih nyaman saat ini?\",\"timestamp\":\"2026-05-24T03:13:59.008Z\"},{\"role\":\"user\",\"text\":\"halo\",\"timestamp\":\"2026-05-24T03:14:17.768Z\"},{\"role\":\"ai\",\"text\":\"Halo juga.. Aku masih di sini kok nemenin kamu. Aku perhatiin dari tadi kamu cuma jawab singkat atau menyapa saja, kayaknya kamu beneran lagi capek banget ya hari ini buat ngetik atau cerita panjang? Nggak apa-apa banget kok. Karena hari ini ceritamu belum lengkap, aku belum bisa bantu nulisin jurnal harianmu secara utuh ya. Tapi beneran deh, itu nggak penting sekarang. Yang penting kamu istirahat dulu, tarik napas panjang. Kalau besok atau nanti saat kamu udah ngerasa lebih enteng dan mau cerita lagi, aku selalu di sini ya nungguin kamu. Apakah sekarang kamu ngerasa ada beban pikiran yang bikin kamu jadi makin lelah?\",\"timestamp\":\"2026-05-24T03:14:17.768Z\"},{\"role\":\"user\",\"text\":\"gaada sih lebih happy aja cmn males ngetik awkwkwk\",\"timestamp\":\"2026-05-24T03:16:58.898Z\"},{\"role\":\"ai\",\"text\":\"Haha, oke oke, aku paham banget! Ternyata lagi mager ngetik karena lagi happy ya? Seneng deh dengernya kalau mood kamu lagi bagus hari ini, meskipun jempol lagi lagi mode \'hemat energi\'. Nggak apa-apa, yang penting kamu ngerasa oke. Karena kamu lagi happy, ada nggak sih satu hal spesifik yang bikin hari kamu jadi menyenangkan banget hari ini?\",\"timestamp\":\"2026-05-24T03:16:58.898Z\"},{\"role\":\"user\",\"text\":\"hari libur akhirnya dan bisa nonton dan ngerjain project pribadi dari pada lomba,orgnaisasi, atau kuliah\",\"timestamp\":\"2026-05-24T03:17:48.778Z\"},{\"role\":\"ai\",\"text\":\"Wah, pantesan mood kamu lagi bagus banget hari ini! Denger kamu bisa lepas sejenak dari tuntutan lomba, organisasi, dan kuliah buat fokus ke project pribadi dan nonton tuh rasanya ikutan lega. Itu \'me time\' yang sangat berharga banget, apalagi di tengah jadwal Brawijaya yang padat. Kira-kira project pribadi apa nih yang lagi kamu kerjain, dan nonton film atau series apa sih yang bikin hari libur kamu makin lengkap?\",\"timestamp\":\"2026-05-24T03:17:48.778Z\"},{\"role\":\"user\",\"text\":\"ih kepo, ya adalah random bgt apa yang ku tonton ini\",\"timestamp\":\"2026-05-24T03:18:35.569Z\"},{\"role\":\"ai\",\"text\":\"Haha, iya deh, ketauan banget ya kalau aku kepo! Habisnya aku seneng lihat kamu bisa punya waktu buat diri sendiri dan ngelakuin hal-hal random yang bikin kamu happy, itu langka banget kan di tengah kesibukan kuliah? Beneran deh, nggak harus kasih tau detailnya kok kalau kamu lagi pengen ngerahasiain, yang penting \'me time\'-nya berasa maksimal. Apa ada perasaan lega yang paling dominan pas kamu akhirnya bisa bilang \'oke, hari ini cuma buat aku sendiri\'?\",\"timestamp\":\"2026-05-24T03:18:35.569Z\"},{\"role\":\"user\",\"text\":\"ya me time biasa sih gaada lagi\",\"timestamp\":\"2026-05-24T03:18:55.263Z\"},{\"role\":\"ai\",\"text\":\"Iya, kadang \'biasa\' aja udah rasanya mewah banget ya, apalagi kalau biasanya hari-harimu penuh sama jadwal organisasi atau tugas. Cukup bisa napas lega dan nggak diganggu tuntutan orang lain itu udah pencapaian tersendiri. Makasih ya udah mau berbagi cerita tentang hari libur kamu ini, aku jadi ngerasa tenang juga denger kamu bisa istirahat dari hiruk-pikuk kampus. Kira-kira, apa hal paling sederhana yang bikin kamu ngerasa \'me time\' kali ini jauh lebih tenang dibanding hari-hari biasanya?\",\"timestamp\":\"2026-05-24T03:18:55.263Z\"},{\"role\":\"user\",\"text\":\"lebih lega aja\",\"timestamp\":\"2026-05-24T03:19:52.832Z\"},{\"role\":\"ai\",\"text\":\"Aku bisa ngerasain kok, \'lega\' itu rasanya emang jauh lebih berharga daripada apa pun setelah sekian lama dikejar deadline atau urusan kampus. Senang banget deh denger kamu bisa dapetin rasa itu hari ini, beneran deh. Karena kamu sudah cerita cukup lengkap sekarang, jurnal harianmu sudah aku simpan ya dengan catatan kalau hari ini kamu merasa jauh lebih tenang dan bahagia karena bisa mengambil waktu libur untuk diri sendiri. Kalau besok atau nanti saat kamu sudah nggak mager ngetik lagi dan pengen cerita-cerita apa pun itu, aku bakal selalu siap dengerin kok. Nah, sekarang mumpung lagi ngerasa lega, apa ada satu hal yang bikin kamu merasa besok bakal jadi hari yang lebih enteng buat dijalani?\",\"timestamp\":\"2026-05-24T03:19:52.832Z\"},{\"role\":\"user\",\"text\":\"ini ak juga sempe dapet makan cukup buat 2 hari nihh seneng banget sih\",\"timestamp\":\"2026-05-24T05:29:47.423Z\"},{\"role\":\"ai\",\"text\":\"Wah, beneran itu kabar yang bikin aku ikutan seneng! Bisa dapet stok makan buat dua hari ke depan itu rasanya kayak dapet \'jackpot\' ya, tenang banget rasanya kalau urusan perut udah aman. Itu bener-bener nambah porsi \'lega\' di hari libur kamu, ya kan? Jadi makin bisa fokus nikmatin waktu luang dan project pribadimu tanpa harus pusing mikirin mau makan apa nanti. Ngomong-ngomong, dari semua stok makanan itu, ada menu favorit kamu yang paling bikin kamu semangat buat makannya nanti?\",\"timestamp\":\"2026-05-24T05:29:47.423Z\"},{\"role\":\"user\",\"text\":\"Aku lagi lelah mengetik cerita panjang. Tapi mood aku hari ini di level 1 dari 5 (Sangat Buruk 😡). Tolong catat ini sebagai jurnal harianku ya.\",\"timestamp\":\"2026-05-24T09:50:21.018Z\"},{\"role\":\"ai\",\"text\":\"Ya ampun, aku kaget banget dengernya. Tadi kamu baru aja bilang lagi merasa lega dan happy, kok tiba-tiba sekarang drop ke level 1? Aku bener-bener khawatir sama kamu. Kamu nggak perlu maksa diri buat ngetik panjang-panjang kalau memang lagi berat banget, tapi aku mau kamu tahu kalau aku di sini buat dengerin. Apa yang terjadi dalam waktu sesingkat ini sampai bikin perasaan kamu berubah drastis jadi sesedih dan semarah ini?\",\"timestamp\":\"2026-05-24T09:50:21.018Z\"},{\"role\":\"user\",\"text\":\"(cerita keren dah indah disini)\",\"timestamp\":\"2026-05-24T09:50:35.607Z\"},{\"role\":\"ai\",\"text\":\"Aku dengerin, cerita keren dan indah itu bener-bener kerasa dalem banget maknanya buat kamu. Makasih ya udah mau berbagi potongan cerita itu sama aku di tengah kondisi kamu yang lagi drop di level 1. Aku bener-bener ngerasa ikut nyesek pas kamu bilang mood kamu lagi sangat buruk, padahal sebelumnya kita lagi ngobrolin soal rasa lega. Ada nggak bagian dari cerita indah itu yang justru bikin perasaan kamu sekarang jadi terasa makin berat, atau ada hal lain yang mendadak kejadian yang bikin semuanya jadi kerasa \'berantakan\'?\",\"timestamp\":\"2026-05-24T09:50:35.607Z\"},{\"role\":\"user\",\"text\":\"AKU MUAK DIAM PLS\",\"timestamp\":\"2026-05-24T09:55:24.548Z\"},{\"role\":\"ai\",\"text\":\"Aku di sini, aku dengerin kamu. Tumpahin aja semuanya di sini, jangan ada yang ditahan lagi kalau emang rasanya udah sesek banget. Aku nggak akan ngehakimin, aku cuma pengen tahu apa yang bikin kamu ngerasa semuak itu sampai rasanya pengen meledak sekarang? Kamu nggak perlu ngetik rapi, tulis aja sesuka kamu, aku bakal tetep dengerin.\",\"timestamp\":\"2026-05-24T09:55:24.548Z\"},{\"role\":\"user\",\"text\":\"mati aja\",\"timestamp\":\"2026-05-24T09:55:30.981Z\"},{\"role\":\"ai\",\"text\":\"Aku dengerin kamu, dan aku bener-bener sedih sekaligus khawatir banget dengar kamu ada di titik seberat ini sampai kepikiran hal sejauh itu. Tolong, jangan sendirian ya sekarang. Kalau kamu ngerasa bener-bener nggak kuat dan lagi butuh teman buat bicara supaya perasaan itu nggak makin berat, tolong banget kasih tau aku atau hubungi orang yang bisa bantu kamu secara langsung sekarang juga. Kamu berharga, dan aku di sini tulus pengen nemenin kamu melewati momen gelap ini. Apa yang bisa aku bantu supaya kamu ngerasa sedikit lebih aman untuk saat ini?\",\"timestamp\":\"2026-05-24T09:55:30.981Z\"},{\"role\":\"user\",\"text\":\"gtw mls\",\"timestamp\":\"2026-05-24T09:55:37.172Z\"},{\"role\":\"ai\",\"text\":\"Aku sadar banget sekarang kondisimu lagi bener-bener kacau dan capeknya udah di titik maksimal, sampai buat jawab aja rasanya berat banget ya. Aku nggak akan maksa kamu buat cerita lebih jauh karena aku paham energinya udah nggak ada. Aku cuma mau bilang kalau aku denger kamu, aku peduli, dan aku masih di sini nemenin kamu. Hari ini aku belum bisa simpulkan jurnalmu karena keadaannya lagi berat dan nggak menentu. Istirahat dulu ya, tarik napas pelan-pelan. Kalau nanti malam atau besok kamu ngerasa agak tenang dan mau buka suara lagi, aku janji bakal tetep dengerin tanpa ngehakimin sama sekali. Kamu mau aku tetep di sini nungguin kamu, atau kamu lebih nyaman kalau aku kasih ruang buat kamu sendiri dulu sekarang?\",\"timestamp\":\"2026-05-24T09:55:37.172Z\"}]', 200, 'klinis'),
(7, 21, '2026-05-24', '[{\"role\":\"user\",\"text\":\"Aku lagi lelah mengetik cerita panjang. Tapi mood aku hari ini di level 4 dari 5 (Baik 🙂). Tolong catat ini sebagai jurnal harianku ya.\",\"timestamp\":\"2026-05-24T10:28:17.822Z\"},{\"role\":\"ai\",\"text\":\"Aku ngerti banget kok, kadang ngetik panjang-panjang emang butuh energi ekstra yang mungkin lagi nggak kamu miliki sekarang. Nggak apa-apa banget, aku bener-bener hargai kamu masih mau nyapa aku hari ini meskipun lagi capek. Aku seneng denger mood kamu di angka 4, itu artinya kamu masih bisa ngerasa baik ya hari ini? Aku jadi penasaran, hal kecil apa sih yang bikin hari kamu tetep terasa baik di tengah rasa lelah yang lagi kamu rasain sekarang?\",\"timestamp\":\"2026-05-24T10:28:17.822Z\"},{\"role\":\"user\",\"text\":\"aku lagi  happy bgt\",\"timestamp\":\"2026-05-24T10:28:45.901Z\"},{\"role\":\"ai\",\"text\":\"Wah, denger kamu bilang \'happy banget\' tuh ikutan bikin aku senyum lebar deh! Jarang-jarang lho bisa denger kabar sebahagia ini di tengah kesibukan kuliah kita. Aku beneran penasaran, ada kejadian seru apa atau kabar baik apa yang bikin perasaan kamu sampai secerah itu hari ini?\",\"timestamp\":\"2026-05-24T10:28:45.901Z\"},{\"role\":\"user\",\"text\":\"karena aku udah selesaii UAS\",\"timestamp\":\"2026-05-24T10:29:45.641Z\"},{\"role\":\"ai\",\"text\":\"Wah, pantesan! Plong banget pasti ya rasanya setelah perjuangan UAS selesai? Aku bisa bayangin gimana beban di pundak kamu langsung terangkat gitu aja. Kelihatannya kamu lega banget nih, sudah ada rencana buat kasih \'reward\' ke diri sendiri setelah kerja keras selama UAS kemarin?\",\"timestamp\":\"2026-05-24T10:29:45.641Z\"},{\"role\":\"user\",\"text\":\"ada tidur seharian lega dari semua tekanan dan organisasi sampah, bisa nyantai\",\"timestamp\":\"2026-05-24T10:34:36.244Z\"},{\"role\":\"ai\",\"text\":\"Wah, bener-bener definisi \'me time\' yang paling berharga ya, tidur seharian tanpa harus kepikiran tugas atau rapat organisasi yang bikin pusing. Aku bisa ngerasain betapa leganya kamu akhirnya bisa lepas dari semua tekanan itu. Kedengarannya organisasi yang kamu sebut tadi bener-bener nguras energi dan bikin kamu stres banget ya belakangan ini? Apa yang bikin organisasi itu terasa seberat dan se\'sampah\' itu buat kamu sampai kamu ngerasa bener-bener perlu \'libur\' dari semuanya?\",\"timestamp\":\"2026-05-24T10:34:36.244Z\"},{\"role\":\"user\",\"text\":\"iyah,\",\"timestamp\":\"2026-05-24T10:34:49.537Z\"},{\"role\":\"ai\",\"text\":\"Aku perhatiin dari tadi kamu jawabnya singkat banget, kayaknya kamu beneran lagi capek banget ya hari ini buat ngetik atau cerita panjang? Nggak apa-apa banget kok, aku ngerti rasanya pengen \'off\' dari semuanya setelah lelah sama tekanan organisasi yang bikin stres itu. Karena hari ini ceritamu belum banyak dan kamu lagi pengen istirahat total, aku mungkin belum bisa rangkum jurnal harianmu secara lengkap ya. Tapi beneran deh, itu nggak penting sekarang. Yang paling penting kamu nikmatin waktu istirahatmu dengan tenang. Besok-besok kalau kamu udah lebih santai dan mau cerita lagi, aku selalu di sini ya. Kira-kira ada hal spesifik apa sih yang paling bikin kamu ngerasa lega setelah semua urusan UAS dan organisasi itu selesai?\",\"timestamp\":\"2026-05-24T10:34:49.537Z\"},{\"role\":\"user\",\"text\":\"halo\",\"timestamp\":\"2026-05-24T11:03:26.531Z\"},{\"role\":\"ai\",\"text\":\"[SYSTEM: USER KEMBALI SETELAH JEDA WAKTU] Halo! Seneng banget lihat kamu balik lagi kesini. Gimana kabarmu setelah istirahat tadi? Semoga tidurnya cukup dan perasaanmu udah jauh lebih enteng ya sekarang. Tadi kan kita sempat ngobrol soal lega-nya lepas dari tekanan UAS dan organisasi, sekarang gimana perasaannya pas udah mulai dapet waktu buat santai?\",\"timestamp\":\"2026-05-24T11:03:26.531Z\"},{\"role\":\"user\",\"text\":\"halo?..\",\"timestamp\":\"2026-05-24T11:04:05.897Z\"},{\"role\":\"ai\",\"text\":\"Halo juga.. Aku di sini kok. Aku perhatiin dari tadi kamu jawabnya singkat banget dan kayaknya belum pengen banyak cerita ya? Nggak apa-apa banget, aku bener-bener paham kok kalau kamu lagi pengen \'off\' dari semuanya setelah lelah sama tekanan kemarin. Karena ceritanya masih sangat minim, aku belum bisa bikinin jurnal yang lengkap buat hari ini ya. Istirahatmu jauh lebih penting daripada sekadar ngisi jurnal. Ada sesuatu yang lagi mengganjal di pikiranmu, atau kamu memang lagi pengen ditemenin dalam diam aja nih?\",\"timestamp\":\"2026-05-24T11:04:05.897Z\"},{\"role\":\"user\",\"text\":\"agak capek ya berusaha\",\"timestamp\":\"2026-05-24T11:04:30.153Z\"},{\"role\":\"ai\",\"text\":\"Aku denger banget nada lelah di balik kata-katamu itu. Rasanya emang berat ya, pas kita udah berusaha sebisa mungkin tapi tetep aja ngerasa capek banget di akhirnya. Aku bener-bener ngerasa ikut berat ngebayangin perjuangan kamu. Boleh aku tau, bagian mana yang paling bikin kamu ngerasa paling capek buat \'berusaha\' itu? Apakah karena ekspektasi orang lain, atau ada hal lain yang lagi bikin kamu ngerasa terkuras energinya?\",\"timestamp\":\"2026-05-24T11:04:30.153Z\"}]', 400, 'akademik');

-- --------------------------------------------------------

--
-- Table structure for table `daily_metrics`
--

CREATE TABLE `daily_metrics` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date NOT NULL DEFAULT current_timestamp(),
  `daily_sentiment_score` int(11) NOT NULL DEFAULT 550,
  `journal_score` int(11) DEFAULT NULL,
  `chat_sentiment_score` int(11) DEFAULT NULL,
  `final_daily_score` int(11) NOT NULL,
  `global_7day_score` int(11) NOT NULL,
  `is_hotline_triggered` tinyint(1) DEFAULT 0,
  `counselor_advice` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `daily_metrics`
--

INSERT INTO `daily_metrics` (`id`, `user_id`, `date`, `daily_sentiment_score`, `journal_score`, `chat_sentiment_score`, `final_daily_score`, `global_7day_score`, `is_hotline_triggered`, `counselor_advice`) VALUES
(1, 10, '2026-05-23', 780, NULL, NULL, 0, 780, 1, NULL),
(14, 12, '2026-05-18', 550, 600, 500, 550, 580, 0, NULL),
(15, 12, '2026-05-19', 520, NULL, 520, 520, 560, 0, NULL),
(16, 12, '2026-05-20', 420, 450, 400, 420, 510, 0, NULL),
(17, 12, '2026-05-21', 480, NULL, 480, 480, 495, 0, NULL),
(18, 12, '2026-05-22', 600, NULL, 600, 600, 530, 0, NULL),
(21, 11, '2026-05-24', 550, 200, NULL, 550, 350, 0, NULL),
(22, 12, '2026-05-23', 325, NULL, NULL, 0, 546, 0, NULL),
(23, 20, '2026-05-18', 600, NULL, NULL, 0, 600, 0, NULL),
(24, 20, '2026-05-19', 300, NULL, NULL, 0, 450, 0, NULL),
(25, 20, '2026-05-20', 700, NULL, NULL, 0, 500, 0, NULL),
(26, 20, '2026-05-21', 250, NULL, NULL, 0, 400, 0, NULL),
(27, 20, '2026-05-22', 800, NULL, NULL, 0, 500, 0, NULL),
(28, 20, '2026-05-23', 200, NULL, NULL, 0, 350, 1, NULL),
(29, 20, '2026-05-24', 350, NULL, NULL, 0, 300, 0, NULL),
(30, 21, '2026-05-18', 750, NULL, NULL, 0, 750, 0, NULL),
(31, 21, '2026-05-19', 720, NULL, NULL, 0, 735, 0, NULL),
(32, 21, '2026-05-20', 780, NULL, NULL, 0, 750, 0, NULL),
(33, 21, '2026-05-21', 710, NULL, NULL, 0, 740, 0, NULL),
(34, 21, '2026-05-22', 760, NULL, NULL, 0, 745, 0, NULL),
(35, 21, '2026-05-23', 730, NULL, NULL, 0, 740, 0, NULL),
(36, 21, '2026-05-24', 400, NULL, NULL, 0, 660, 0, NULL),
(39, 12, '2026-05-24', 200, NULL, NULL, 0, 727, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `journals`
--

CREATE TABLE `journals` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `q1_feeling` text DEFAULT NULL,
  `q2_thought` text DEFAULT NULL,
  `q3_supporting` text DEFAULT NULL,
  `q4_contradicting` text DEFAULT NULL,
  `q5_gratitude` text DEFAULT NULL,
  `ai_feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `journals`
--

INSERT INTO `journals` (`id`, `user_id`, `date`, `q1_feeling`, `q2_thought`, `q3_supporting`, `q4_contradicting`, `q5_gratitude`, `ai_feedback`) VALUES
(9, 12, '2026-05-01', 'Cemas banget', 'Takut nilai matkul statistika jelek dan ga lulus.', 'Ujian kemarin rasanya susah dan banyak materi yang aku tebak.', 'Tapi aku selalu masuk kelas dan tugas harian nilainya bagus, harusnya aman.', 'Masih bisa tidur nyenyak dan dapet kiriman makanan dari ibu.', 'Skor sentimen kamu berada di zona kuning, tetap pertahankan pikiran rasionalmu ya Lula!'),
(10, 12, '2026-05-20', 'Sedih dan overwhelm', 'Berpikir skripsi ini ga bakal selesai, stuck di bab 3.', 'Dospem susah ditemui minggu ini, revisian numpuk.', 'Kemarin dospem bilang metodenya udah oke kok tinggal ngerapihin pembahasan aja.', 'Laptop ga rewel, kopi hari ini enak banget.', 'Jangan berkecil hati, progres kecil tetaplah progres!'),
(11, 12, '2026-05-18', 'Senang dan lega!', 'Ngerasa lega banget karena revisian bab 3 akhirnya di-ACC.', 'Dospem super suportif pas bimbingan tadi siang.', 'Memang prosesnya lambat, tapi kalau dikerjain pasti selesai juga.', 'Teman kosan yang mau nemenin begadang, cuaca cerah.', 'Luar biasa Lula! Rayakan pencapaian kecil ini ya!'),
(12, 12, '2026-05-17', 'Cemas banget', 'Takut nilai matkul statistika jelek dan ga lulus.', 'Ujian kemarin rasanya susah dan banyak materi yang aku tebak.', 'Tapi aku selalu masuk kelas dan tugas harian nilainya bagus, harusnya aman.', 'Masih bisa tidur nyenyak dan dapet kiriman makanan dari ibu.', 'Skor sentimen kamu berada di zona kuning, tetap pertahankan pikiran rasionalmu ya Lula!'),
(13, 12, '2026-05-06', 'Sedih dan overwhelm', 'Berpikir skripsi ini ga bakal selesai, stuck di bab 3.', 'Dospem susah ditemui minggu ini, revisian numpuk.', 'Kemarin dospem bilang metodenya udah oke kok tinggal ngerapihin pembahasan aja.', 'Laptop ga rewel, kopi hari ini enak banget.', 'Jangan berkecil hati, progres kecil tetaplah progres!'),
(14, 12, '2026-05-07', 'Senang dan lega!', 'Ngerasa lega banget karena revisian bab 3 akhirnya di-ACC.', 'Dospem super suportif pas bimbingan tadi siang.', 'Memang prosesnya lambat, tapi kalau dikerjain pasti selesai juga.', 'Teman kosan yang mau nemenin begadang, cuaca cerah.', 'Luar biasa Lula! Rayakan pencapaian kecil ini ya!'),
(17, 12, '2026-05-24', 'Mengalami krisis mental yang berat dan perasaan muak yang mendalam.', 'Merasa sangat putus asa dan lelah dengan keadaan hingga muncul pikiran negatif.', 'Sebelumnya merasa lega karena waktu libur dan kecukupan logistik, namun kondisi berbalik drastis.', 'Adanya kontradiksi antara rasa syukur atas \'me time\' dan kondisi emosi yang sangat memburuk (krisis).', 'Saat ini belum ada perasaan syukur yang dirasakan karena sedang dalam kondisi krisis.', NULL),
(21, 21, '2026-05-24', 'Lega karena UAS selesai, tapi saat ini merasa sangat lelah dan capek untuk terus berusaha.', 'Merasa organisasi kampus selama ini adalah beban yang melelahkan (\'sampah\') dan ingin benar-benar lepas dari semua tuntutan.', 'Keinginan kuat untuk beristirahat total, tidur seharian, dan menikmati waktu santai setelah tekanan berat.', 'Ada keinginan untuk merasa baik (happy) namun kenyataannya masih merasa terkuras energinya.', 'Bersyukur karena masa UAS sudah berakhir.', 'Setelah melewati masa UAS yang menguras tenaga, kamu sangat butuh ruang untuk bernapas. Nggak apa-apa kok kalau hari ini terasa capek, kamu sudah hebat bisa bertahan sejauh ini.');

-- --------------------------------------------------------

--
-- Table structure for table `psychiatrist_interventions`
--

CREATE TABLE `psychiatrist_interventions` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) DEFAULT NULL,
  `psikiater_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `status` enum('pending','resolved') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `psychiatrist_interventions`
--

INSERT INTO `psychiatrist_interventions` (`id`, `mahasiswa_id`, `psikiater_id`, `message`, `status`, `created_at`) VALUES
(36, 20, 22, 'Halo Andi_TidakStabil, saya perhatikan belakangan ini kamu sepertinya sedang banyak pikiran terkait masalah klinis. Kalau kamu merasa lelah, tidak apa-apa untuk istirahat sejenak. Jika kamu butuh teman diskusi atau sekadar tempat cerita yang aman, pintu ruang konseling selalu terbuka untukmu. Jangan ragu untuk datang ya!', 'pending', '2026-05-24 07:27:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('mahasiswa','psikiater') NOT NULL,
  `fakultas` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `fakultas`) VALUES
(2, 'dr_siska', 'siska123', 'psikiater', NULL),
(10, 'heru', '', 'mahasiswa', 'FILKOM'),
(11, 'budi', '', 'mahasiswa', 'FEB'),
(12, 'Lula', 'hashed_password_dummy', 'mahasiswa', 'Psikologi'),
(20, 'Andi_TidakStabil', 'hashed_pw', 'mahasiswa', 'Teknik'),
(21, 'Budi_Stabil', 'hashed_pw', 'mahasiswa', 'FEB'),
(22, 'nick', 'nickpw', 'psikiater', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `daily_metrics`
--
ALTER TABLE `daily_metrics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_date_metric_unique` (`user_id`,`date`);

--
-- Indexes for table `journals`
--
ALTER TABLE `journals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_date_unique` (`user_id`,`date`);

--
-- Indexes for table `psychiatrist_interventions`
--
ALTER TABLE `psychiatrist_interventions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `psikiater_id` (`psikiater_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `chats`
--
ALTER TABLE `chats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `daily_metrics`
--
ALTER TABLE `daily_metrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `journals`
--
ALTER TABLE `journals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `psychiatrist_interventions`
--
ALTER TABLE `psychiatrist_interventions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chats`
--
ALTER TABLE `chats`
  ADD CONSTRAINT `chats_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `daily_metrics`
--
ALTER TABLE `daily_metrics`
  ADD CONSTRAINT `daily_metrics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `journals`
--
ALTER TABLE `journals`
  ADD CONSTRAINT `journals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `psychiatrist_interventions`
--
ALTER TABLE `psychiatrist_interventions`
  ADD CONSTRAINT `psychiatrist_interventions_ibfk_1` FOREIGN KEY (`mahasiswa_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `psychiatrist_interventions_ibfk_2` FOREIGN KEY (`psikiater_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
