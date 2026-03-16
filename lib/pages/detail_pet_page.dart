import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';
import 'edit_pet_page.dart';

class DetailPetPage extends StatelessWidget {
  final Pet pet;

  const DetailPetPage({super.key, required this.pet});

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> deletePet(BuildContext context) async {
    final PetService petService = PetService();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Data?'),
        content: Text('Hapus data "${pet.namaHewan}" milik ${pet.pemilik}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await petService.deletePet(pet.id);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  Widget item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '$title: $value',
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Penitipan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                item('Nama Hewan', pet.namaHewan),
                item('Jenis Hewan', pet.jenis),
                item('Pemilik', pet.pemilik),
                item('No HP', pet.noHp.isEmpty ? '-' : pet.noHp),
                item('Tanggal Masuk', formatDate(pet.tanggalMasuk)),
                item('Tanggal Ambil', formatDate(pet.tanggalAmbil)),
                item('Status', pet.status),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => deletePet(context),
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPetPage(pet: pet),
                            ),
                          );

                          if (result == true && context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}