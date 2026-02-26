import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'add_pet_page.dart';
import 'edit_pet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Pet> pets = [];
  String query = "";

  void addPet(Pet pet) => setState(() => pets.add(pet));
  void updatePet(int index, Pet updated) => setState(() => pets[index] = updated);
  void deletePet(int index) => setState(() => pets.removeAt(index));

  @override
  Widget build(BuildContext context) {
    final filtered = pets.where((p) {
      final q = query.toLowerCase();
      return p.namaHewan.toLowerCase().contains(q) || p.pemilik.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PetStay Manager'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<Pet>(
            context,
            MaterialPageRoute(builder: (_) => const AddPetPage()),
          );
          if (result != null) addPet(result);
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // SEARCH BAR
            TextField(
              decoration: InputDecoration(
                labelText: 'Cari (nama hewan / pemilik)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => query = ""),
                      ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 14),

            
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ${pets.length} • Ditampilkan: ${filtered.length}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus semua (demo)',
                  onPressed: pets.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Semua?'),
                              content: const Text('Semua data akan dihapus. Lanjutkan?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    setState(() => pets.clear());
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                  icon: const Icon(Icons.delete_sweep),
                ),
              ],
            ),
            const SizedBox(height: 8),

            
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyState(
                      isSearch: query.trim().isNotEmpty,
                      onAdd: () async {
                        final result = await Navigator.push<Pet>(
                          context,
                          MaterialPageRoute(builder: (_) => const AddPetPage()),
                        );
                        if (result != null) addPet(result);
                      },
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final pet = filtered[i];

                        
                        final realIndex = pets.indexWhere((x) => identical(x, pet));

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () async {
                            final updated = await Navigator.push<Pet>(
                              context,
                              MaterialPageRoute(builder: (_) => EditPetPage(pet: pet)),
                            );
                            if (updated != null) updatePet(realIndex, updated);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.black.withOpacity(0.08)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: const Icon(Icons.pets),
                                  ),
                                  const SizedBox(width: 12),

                                  
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                pet.namaHewan,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              pet.jenis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black.withOpacity(0.65),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),

                                        
                                        Text('Pemilik: ${pet.pemilik}'),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Masuk: ${fmt(pet.tanggalMasuk)} • Ambil: ${fmt(pet.tanggalAmbil)}',
                                          style: TextStyle(color: Colors.black.withOpacity(0.7)),
                                        ),

                                        const SizedBox(height: 10),

                                        
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            Chip(
                                              label: Text(pet.status),
                                              avatar: Icon(
                                                pet.status == "Selesai"
                                                    ? Icons.check_circle
                                                    : Icons.timelapse,
                                                size: 18,
                                              ),
                                            ),
                                            if (pet.noHp.trim().isNotEmpty)
                                              Chip(
                                                label: Text(pet.noHp),
                                                avatar: const Icon(Icons.phone, size: 18),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  
                                  IconButton(
                                    tooltip: 'Hapus',
                                    onPressed: () => _confirmDelete(realIndex),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    final pet = pets[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Data?'),
        content: Text('Hapus data "${pet.namaHewan}" milik ${pet.pemilik}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              deletePet(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
}

class _EmptyState extends StatelessWidget {
  final bool isSearch;
  final VoidCallback onAdd;

  const _EmptyState({required this.isSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSearch ? Icons.search_off : Icons.inbox, size: 42),
              const SizedBox(height: 10),
              Text(
                isSearch ? 'Data tidak ditemukan' : 'Belum ada data penitipan',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                isSearch
                    ? 'Coba kata kunci lain ya.'
                    : 'Klik tombol Tambah untuk membuat data pertama.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              if (!isSearch)
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Data'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}