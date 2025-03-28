-- Query untuk database bernama responsi_uts
CREATE DATABASE responsi_uts;

---------------------------------------------------------------------------------------------------

/* 1. a. i */
CREATE TABLE Anggota (
    id_anggota varchar(10) NOT NULL PRIMARY KEY,
    nama varchar(50) NOT NULL,
    jurusan varchar(20) DEFAULT "Umum",
    tgl_daftar date NOT NULL
);

/* 1. a. ii */
CREATE TABLE Buku (
    id_buku varchar(10) NOT NULL PRIMARY KEY,
    judul varchar(100) NOT NULL,
    penerbit varchar(50),
    tahun_terbit int
);

ALTER TABLE Buku
ADD CHECK (tahun_terbit BETWEEN 1900 AND 2025);

/* 1. a. iii */
CREATE TABLE Peminjaman (
    id_peminjaman int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_anggota varchar(10) NOT NULL,
    id_buku varchar(10) NOT NULL,
    tgl_pinjam date NOT NULL,
    tgl_kembali date,
    FOREIGN KEY (id_anggota) REFERENCES Anggota(id_anggota),
    FOREIGN KEY (id_buku) REFERENCES Buku(id_buku)
);

-- Tambahkan check supaya tanggal kembali tidak dapat diisi dengan tanggal sebelum tanggal pinjam
ALTER TABLE Peminjaman
ADD CHECK (tgl_pinjam < tgl_kembali);

/* 1. b. ii */
ALTER TABLE Peminjaman
ADD denda int DEFAULT 0
ADD CHECK (denda >= 0); -- Tambahkan check supaya denda tidak dapat diisi dengan bilangan negatif

---------------------------------------------------------------------------------------------------

/* 2. a. i */
-- Tambahkan 1 anggota umum (tanpa jurusan)
INSERT INTO Anggota (id_anggota, nama, tgl_daftar) VALUES
("0000000001", "Carl Johnson", "Umum", "2025-03-27");

-- Tambahkan 2 anggota dengan jurusan
INSERT INTO Anggota VALUES
("0000000002", "John Doe", "Teknik Mesin", "2025-02-01"),
("0000000003", "Ahmad B.", "Teknik Elektro", "2024-01-03");

INSERT INTO Buku VALUES
("0000000001", "Refactoring: Improving the Design of Existing Code", "Addison-Wesley Professional", 1999),
("0000000002", "Minecraft Redstone Handbook UPDATED EDITION", "Mojang", 2015),
("0000000003", "Programming in Lua", "Lua.Org", 2013),
("0000000004", "Principles of Nuclear Reactor Engineering", "D. Van Nostrand Company, Inc.", 1955),
("0000000005", "Ultimate American V-8 Engine Data Book: 2nd Edition", "Motorbooks", 2010);

/* 2. a. ii */
INSERT INTO Peminjaman (id_anggota, id_buku, tgl_pinjam, tgl_kembali, denda) VALUES
("0000000002", "0000000005", "2025-03-20", "2025-03-24", 0),
("0000000003", "0000000004", "2025-03-22", NULL, 0), -- tgl_kembali = NULL, belum dikembalikan
("0000000003", "0000000005", "2025-03-19", "2025-03-21", 0);

/* 2. a. iii */
-- Peminjaman paling lama 3 hari. Jika peminjaman melebihi 3 hari, denda akan dihitung mulai hari ke-4
UPDATE Peminjaman
SET denda = 2000 * DATEDIFF(CURRENT_DATE(), DATE_ADD(tgl_pinjam, INTERVAL 3 DAY))
WHERE tgl_kembali IS NULL AND DATE_ADD(tgl_pinjam, INTERVAL 3 DAY) < CURRENT_DATE();

---------------------------------------------------------------------------------------------------

/* 3. a. i */
SELECT anggota.nama, COUNT(*) AS "Jumlah Buku"
FROM peminjaman
JOIN anggota ON peminjaman.id_anggota = anggota.id_anggota
GROUP BY anggota.nama;

/* 3. a. ii */
SELECT buku.judul, AVG(DATEDIFF(peminjaman.tgl_kembali, peminjaman.tgl_pinjam)) AS "Rata-Rata Hari"
FROM peminjaman
JOIN buku ON peminjaman.id_buku = buku.id_buku
WHERE peminjaman.tgl_kembali IS NOT NULL
GROUP BY buku.judul;

/* 3. a. iii */
SELECT buku.judul, COUNT(*) AS "Jumlah Peminjaman"
FROM peminjaman
JOIN buku ON peminjaman.id_buku = buku.id_buku
GROUP BY buku.judul
ORDER BY COUNT(*) DESC
LIMIT 1;

---------------------------------------------------------------------------------------------------

/* 4. a */
CREATE TABLE Penerbit (
    id_penerbit int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nama_penerbit varchar(50) NOT NULL,
    alamat varchar(100) NOT NULL
);

INSERT INTO penerbit (nama_penerbit, alamat) VALUES
("Addison-Wesley Professional", "Boston"),
("Mojang", "Stockholm, Swedia"),
("Lua.Org", "Rio de Janeiro"),
("D. Van Nostrand Company, Inc.", "New York City"),
("Motorbooks", "Boston");

/* 4. b */
-- Buat kolom id_penerbit (belum menjadi foreign key)
ALTER TABLE buku
ADD id_penerbit int NOT NULL;

-- Setiap buku memiliki id_penerbit yang sama dengan id_buku
UPDATE buku
SET id_penerbit = CAST(id_buku AS int);

-- Setelah semua buku memiliki id_penerbit, sekarang buat id_penerbit menjadi foreign key
ALTER TABLE buku
ADD FOREIGN KEY (id_penerbit) REFERENCES penerbit(id_penerbit);

-- Hapus kolom penerbit
ALTER TABLE buku
DROP COLUMN penerbit;

/* 4. c */
SELECT *
FROM buku
INNER JOIN penerbit ON buku.id_penerbit = penerbit.id_penerbit;

---------------------------------------------------------------------------------------------------

-- Penambahan data sebelum eksekusi query untuk soal nomor 6
INSERT INTO anggota VALUES
("0000000004", "Andi", "Teknologi Informasi", "2025-03-27");

INSERT INTO penerbit (nama_penerbit, alamat) VALUES
("Penerbit 6", "Jakarta");

INSERT INTO buku VALUES
("0000000006", "Basis Data", 2025, 6);

INSERT INTO peminjaman (id_anggota, id_buku, tgl_pinjam, tgl_kembali, denda) VALUES
("0000000004", "0000000006", "2025-03-27", NULL, 0);

/* 6. a */
SELECT anggota.nama
FROM anggota
WHERE anggota.id_anggota IN
(SELECT peminjaman.id_anggota
 FROM peminjaman
 WHERE peminjaman.id_buku = "0000000006";)

/* 6. b */
SELECT buku.judul
FROM buku
WHERE buku.id_buku NOT IN
(SELECT peminjaman.id_buku FROM peminjaman);

/* 6. c */
-- Coba beri denda untuk menguji query untuk mengupdate denda
-- Anggota dengan id 0000000003 dipilih karena terdapat 2 baris dengan tipe data tgl_kembali yang berbeda, yang satu berisi NULL dan yang lainnya berisi date
UPDATE peminjaman
SET denda = 20000
WHERE id_anggota = "0000000003";

-- Query untuk mengupdate denda
UPDATE peminjaman
SET denda = 0
WHERE tgl_kembali IN
(SELECT tgl_kembali
 FROM peminjaman
 WHERE tgl_kembali IS NOT NULL AND DATE_ADD(tgl_pinjam, INTERVAL 3 DAY) < CURRENT_DATE());