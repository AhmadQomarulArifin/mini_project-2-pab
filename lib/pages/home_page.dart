import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pet.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/pet_service.dart';
import 'add_pet_page.dart';
import 'detail_pet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PetService petService = PetService();
  final AuthService authService = AuthService();
  final TextEditingController searchController = TextEditingController();

  List<Pet> allPets = [];
  List<Pet> filteredPets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchPets() async {
    setState(() => isLoading = true);

    try {
      final data = await petService.getPets();
      if (!mounted) return;
      setState(() {
        allPets = data;
        filteredPets = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
    }
  }

  void searchPets(String query) {
    final hasil = allPets.where((pet) {
      return pet.namaHewan.toLowerCase().contains(query.toLowerCase()) ||
          pet.pemilik.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredPets = hasil;
    });
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PetStay Manager'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            onPressed: themeProvider.toggleTheme,
            icon: Icon(
              themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPetPage()),
          );

          if (result == true) {
            fetchPets();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchPets,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: searchPets,
                decoration: InputDecoration(
                  labelText: 'Cari nama hewan / pemilik',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            searchPets('');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredPets.isEmpty
                        ? const Center(
                            child: Text('Belum ada data penitipan'),
                          )
                        : ListView.separated(
                            itemCount: filteredPets.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final pet = filteredPets[index];

                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailPetPage(pet: pet),
                                    ),
                                  );

                                  if (result == true) {
                                    fetchPets();
                                  }
                                },
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: BorderSide(
                                      color: Colors.black.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                          ),
                                          child: const Icon(Icons.pets),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      pet.namaHewan,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    pet.jenis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.65),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Pemilik: ${pet.pemilik}',
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Masuk: ${formatDate(pet.tanggalMasuk)} • Ambil: ${formatDate(pet.tanggalAmbil)}',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  Chip(
                                                    label: Text(pet.status),
                                                    avatar: Icon(
                                                      pet.status == 'Selesai'
                                                          ? Icons.check_circle
                                                          : Icons.timelapse,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  if (pet.noHp.trim().isNotEmpty)
                                                    Chip(
                                                      label: Text(pet.noHp),
                                                      avatar: const Icon(
                                                        Icons.phone,
                                                        size: 18,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
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
      ),
    );
  }
}