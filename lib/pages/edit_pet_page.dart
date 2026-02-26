import 'package:flutter/material.dart';
import '../models/pet.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;
  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  late final TextEditingController namaC;
  late final TextEditingController jenisC;
  late final TextEditingController pemilikC;
  late final TextEditingController noHpC;

  late DateTime tanggalMasuk;
  late DateTime tanggalAmbil;
  late String status;

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.pet.namaHewan);
    jenisC = TextEditingController(text: widget.pet.jenis);
    pemilikC = TextEditingController(text: widget.pet.pemilik);
    noHpC = TextEditingController(text: widget.pet.noHp);

    tanggalMasuk = widget.pet.tanggalMasuk;
    tanggalAmbil = widget.pet.tanggalAmbil;
    status = widget.pet.status;
  }

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
      initialDate: tanggalMasuk,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => tanggalMasuk = picked);
  }

  Future<void> pickTanggalAmbil() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalAmbil,
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
    if (tanggalAmbil.isBefore(tanggalMasuk)) {
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
        tanggalMasuk: tanggalMasuk,
        tanggalAmbil: tanggalAmbil,
        status: status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Data')),
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
                  const Text('Update Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                      labelText: 'Jenis Hewan',
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
                  const Text('Periode & Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login),
                    title: const Text('Tanggal Masuk'),
                    subtitle: Text(fmt(tanggalMasuk)),
                    trailing: const Icon(Icons.date_range),
                    onTap: pickTanggalMasuk,
                  ),
                  const Divider(height: 1),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout),
                    title: const Text('Tanggal Ambil'),
                    subtitle: Text(fmt(tanggalAmbil)),
                    trailing: const Icon(Icons.date_range),
                    onTap: pickTanggalAmbil,
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: status,
                    items: const [
                      DropdownMenuItem(value: "Dititip", child: Text("Dititip")),
                      DropdownMenuItem(value: "Selesai", child: Text("Selesai")),
                    ],
                    onChanged: (v) => setState(() => status = v ?? "Dititip"),
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      prefixIcon: Icon(Icons.fact_check),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.update),
            label: const Text('Update'),
          ),
        ],
      ),
    );
  }

  String fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
}