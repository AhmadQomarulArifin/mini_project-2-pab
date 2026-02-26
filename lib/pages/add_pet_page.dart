import 'package:flutter/material.dart';
import '../models/pet.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final namaC = TextEditingController();
  final jenisC = TextEditingController();
  final pemilikC = TextEditingController();
  final noHpC = TextEditingController();

  DateTime? tanggalMasuk;
  DateTime? tanggalAmbil;

  @override
  void dispose() {
    namaC.dispose();
    jenisC.dispose();
    pemilikC.dispose();
    noHpC.dispose();
    super.dispose();
  }

  Future<void> pickTanggalMasuk() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalMasuk ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => tanggalMasuk = picked);
  }

  Future<void> pickTanggalAmbil() async {
    final now = DateTime.now();
    final base = tanggalMasuk ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalAmbil ?? base,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => tanggalAmbil = picked);
  }

  void submit() {
    final nama = namaC.text.trim();
    final jenis = jenisC.text.trim();
    final pemilik = pemilikC.text.trim();
    final noHp = noHpC.text.trim();

    if (nama.isEmpty || jenis.isEmpty || pemilik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, jenis, dan pemilik wajib diisi!')),
      );
      return;
    }
    if (tanggalMasuk == null || tanggalAmbil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal masuk & tanggal ambil wajib dipilih!')),
      );
      return;
    }
    if (tanggalAmbil!.isBefore(tanggalMasuk!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal ambil tidak boleh sebelum tanggal masuk!')),
      );
      return;
    }

    
    Navigator.pop(
      context,
      Pet(
        namaHewan: nama,
        jenis: jenis,
        pemilik: pemilik,
        noHp: noHp,
        tanggalMasuk: tanggalMasuk!,
        tanggalAmbil: tanggalAmbil!,
        status: "Dititip",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Data')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data Hewan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  TextField(
                    controller: namaC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Hewan',
                      prefixIcon: Icon(Icons.pets),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: jenisC,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Hewan (Kucing/Anjing/dll)',
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: pemilikC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pemilik',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: noHpC,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'No HP (opsional)',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Periode Titip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login),
                    title: const Text('Tanggal Masuk'),
                    subtitle: Text(tanggalMasuk == null ? '-' : fmt(tanggalMasuk!)),
                    trailing: const Icon(Icons.date_range),
                    onTap: pickTanggalMasuk,
                  ),
                  const Divider(height: 1),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout),
                    title: const Text('Tanggal Ambil'),
                    subtitle: Text(tanggalAmbil == null ? '-' : fmt(tanggalAmbil!)),
                    trailing: const Icon(Icons.date_range),
                    onTap: pickTanggalAmbil,
                  ),

                  const SizedBox(height: 8),

                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text('Status otomatis: Dititip (ubah menjadi Selesai di halaman Edit)'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  String fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
}