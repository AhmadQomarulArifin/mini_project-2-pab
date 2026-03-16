# Mini Project 2 
## 🐾 PetStay Manager
### Deskripsi Aplikasi

PetStay Manager adalah aplikasi mobile berbasis Flutter yang digunakan untuk mengelola data penitipan hewan. Aplikasi ini membantu pengguna untuk mencatat hewan yang sedang dititipkan di tempat penitipan hewan (pet hotel / pet care). Aplikasi ini memungkinkan pengguna untuk Menambahkan data hewan yang dititipkan, Melihat daftar hewan yang sedang dititip, Melihat detail informasi penitipan, Mengubah data penitipan jika ada kesalahan, Menghapus data jika penitipan sudah selesai

### Fitur Aplikasi
#### Create (Tambah Data)

Fitur Create digunakan untuk menambahkan data hewan yang dititipkan ke dalam sistem. Pengguna dapat menambahkan data melalui halaman Add Pet Page dengan mengisi form input yang tersedia Field yang tersedia pada form input antara lain:
- Nama Hewan: Nama hewan yang dititipkan.
- Jenis Hewan: Jenis hewan seperti kucing, anjing, kelinci, dan lain-lain.
- Nama Pemilik: Nama pemilik dari hewan yang dititipkan.
- Nomor HP Pemilik: Nomor telepon yang dapat dihubungi.
- Tanggal Masuk: Tanggal ketika hewan mulai dititipkan.
- Tanggal Ambil: Tanggal ketika hewan akan diambil kembali oleh pemilik.
- Status Penitipan: Status penitipan seperti: Dititip, Selesai

Ketika pengguna menekan tombol Simpan, data akan langsung dikirim ke database Supabase menggunakan query insert. Contoh kode yang digunakan: supabase.from('pets').insert({...});

#### Read (Menampilkan Data)

Fitur Read digunakan untuk menampilkan data hewan yang tersimpan di database Supabase. Data diambil dari tabel pets menggunakan query select. Contoh kode pengambilan data: supabase.from('pets').select();. Data yang diambil kemudian ditampilkan pada Home Page menggunakan widget ListView.builder. Informasi yang ditampilkan pada halaman utama antara lain:
- Nama hewan
- Jenis hewan
- Nama pemilik
- Status penitipan
Pengguna juga dapat mengklik salah satu item pada daftar untuk melihat detail data pada halaman Detail Pet Page.

#### Update (Edit Data)

Fitur Update digunakan untuk memperbarui data yang sudah ada. Jika terdapat kesalahan data atau perubahan informasi, pengguna dapat membuka halaman Edit Pet Page untuk memperbarui data. Data yang dapat diubah antara lain:
- Nama hewan
- Jenis hewan
- Nama pemilik
- Nomor HP
- Tanggal penitipan
- Status penitipan

Perubahan data akan disimpan ke Supabase menggunakan query: supabase.from('pets').update({...});, Setelah berhasil diperbarui, data pada halaman utama akan langsung diperbarui.

#### Delete (Hapus Data)

Fitur Delete digunakan untuk menghapus data hewan dari database. Penghapusan data dilakukan dari halaman Detail Pet Page. Ketika pengguna menekan tombol Hapus, aplikasi akan menampilkan konfirmasi terlebih dahulu sebelum data benar-benar dihapus. Contoh query yang digunakan:
supabase.from('pets').delete();, Setelah data dihapus, daftar pada halaman utama akan diperbarui secara otomatis.

### Tampilan Halaman Aplikasi dan penjelasan

Aplikasi ini terdiri dari beberapa halaman utama.

#### Login Page

Halaman ini digunakan untuk login ke dalam aplikasi menggunakan email dan password yang terdaftar di Supabase. Jika login berhasil, pengguna akan diarahkan ke halaman utama aplikasi. jika belum mempunyai akun atau aku belum terdaftar disupabase makan tampilan akan seperti ini, dan harus registrasi terlebih dahulu.


#### Register Page

Halaman ini digunakan untuk membuat akun baru. Pengguna dapat mendaftarkan akun dengan memasukkan Email dan Password Akun yang dibuat akan disimpan di Supabase Authentication.

#### Home Page

Halaman utama aplikasi yang menampilkan daftar hewan yang sedang dititipkan. Fitur pada halaman ini antara lain:

Menampilkan daftar hewan

Mencari data berdasarkan nama hewan atau pemilik

Menambahkan data baru

Mengubah tema aplikasi

#### Add Pet Page

Halaman yang digunakan untuk menambahkan data hewan baru ke dalam database. Data yang dimasukkan melalui halaman ini akan langsung tersimpan di Supabase.

#### Detail Pet Page

Halaman ini menampilkan informasi lengkap mengenai data penitipan hewan. Dari halaman ini pengguna dapat Mengedit data, Menghapus data

#### Edit Pet Page

Halaman ini digunakan untuk mengubah data yang sudah ada. Semua field yang tersedia dapat diperbarui sesuai kebutuhan.

### Struktur Folder Project

Struktur folder pada project Flutter ini adalah sebagai berikut:

lib
│
├── models
│   pet.dart
│
├── pages
│   home_page.dart
│   add_pet_page.dart
│   edit_pet_page.dart
│   detail_pet_page.dart
│   login_page.dart
│   register_page.dart
│
├── providers
│   theme_provider.dart
│
├── services
│   pet_service.dart
│   auth_service.dart
│
└── main.dart


### Database Supabase

Aplikasi menggunakan tabel pets pada database Supabase.

Struktur tabel:

Column, Type
id, uuid
created_at, timestamptz
user_id, uuid
nama_hewan, text
jenis, text
pemilik, text
no_hp, text
tanggal_masuk, date
tanggal_ambil, date
status, text

### Widget yang Digunakan

Widget Flutter yang digunakan dalam aplikasi ini antara lain:
- MaterialApp
- Scaffold
- AppBar
- ListView.builder
- Card
- TextField
- TextFormField
- ElevatedButton
- IconButton
- Column
- Row
- Navigator
- SnackBar
- DropdownButton
- FutureBuilder

### Nilai Tambah
#### Login & Register (Supabase Auth)

Aplikasi menggunakan Supabase Authentication untuk sistem login dan register. Setiap pengguna harus login terlebih dahulu sebelum dapat mengakses data penitipan.

#### Light Mode & Dark Mode

Aplikasi mendukung perubahan tema antara Light Mode dan Dark Mode. Pengaturan tema ini menggunakan Provider (ChangeNotifier). Pengguna dapat mengubah tema melalui tombol pada AppBar.

#### Penggunaan File .env

Supabase URL dan API Key tidak disimpan langsung di dalam kode aplikasi. Sebagai gantinya, informasi tersebut disimpan di dalam file .env.
Contoh isi .env: SUPABASE_URL=https://your-project-url.supabase.co, SUPABASE_KEY=your-anon-key. File .env dimasukkan ke dalam .gitignore agar tidak ikut ter-upload ke GitHub.

### Teknologi yang Digunakan

Aplikasi ini dibuat menggunakan beberapa teknologi berikut:
- Flutter
- Dart
- Supabase
- Supabase Authentication
- Provider (State Management)
- flutter_dotenv

