import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;

  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final PetService petService = PetService();

  late final TextEditingController namaC;
  late final TextEditingController jenisC;
  late final TextEditingController pemilikC;
  late final TextEditingController noHpC;

  late DateTime tanggalMasuk;
  late DateTime tanggalAmbil;
  late String status;

  bool isLoading = false;

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
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalMasuk,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        tanggalMasuk = picked;
        if (tanggalAmbil.isBefore(tanggalMasuk)) {
          tanggalAmbil = tanggalMasuk;
        }
      });
    }
  }

  Future<void> pickTanggalAmbil() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalAmbil,
      firstDate: tanggalMasuk,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => tanggalAmbil = picked);
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> updatePet() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final pet = Pet(
      id: widget.pet.id,
      userId: widget.pet.userId,
      namaHewan: namaC.text.trim(),
      jenis: jenisC.text.trim(),
      pemilik: pemilikC.text.trim(),
      noHp: noHpC.text.trim(),
      tanggalMasuk: tanggalMasuk,
      tanggalAmbil: tanggalAmbil,
      status: status,
      createdAt: widget.pet.createdAt,
    );

    try {
      await petService.updatePet(pet);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update data: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Hewan',
                      prefixIcon: Icon(Icons.pets),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama hewan wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: jenisC,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Hewan',
                      prefixIcon: Icon(Icons.category),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Jenis hewan wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: pemilikC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pemilik',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama pemilik wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: noHpC,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'No HP',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'No HP wajib diisi';
                      }
                      if (value.length < 10) {
                        return 'No HP minimal 10 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login),
                    title: const Text('Tanggal Masuk'),
                    subtitle: Text(formatDate(tanggalMasuk)),
                    trailing: const Icon(Icons.date_range),
                    onTap: pickTanggalMasuk,
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout),
                    title: const Text('Tanggal Ambil'),
                    subtitle: Text(formatDate(tanggalAmbil)),
                    trailing: const Icon(Icons.date_range),
                    onTap: pickTanggalAmbil,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      prefixIcon: Icon(Icons.flag),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Dititip',
                        child: Text('Dititip'),
                      ),
                      DropdownMenuItem(
                        value: 'Selesai',
                        child: Text('Selesai'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isLoading ? null : updatePet,
                      icon: const Icon(Icons.update),
                      label: Text(isLoading ? 'Loading...' : 'Update'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}