class Pet {
  final String id;
  final String? userId;
  final String namaHewan;
  final String jenis;
  final String pemilik;
  final String noHp;
  final DateTime tanggalMasuk;
  final DateTime tanggalAmbil;
  final String status;
  final DateTime? createdAt;

  Pet({
    required this.id,
    this.userId,
    required this.namaHewan,
    required this.jenis,
    required this.pemilik,
    required this.noHp,
    required this.tanggalMasuk,
    required this.tanggalAmbil,
    required this.status,
    this.createdAt,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      namaHewan: map['nama_hewan']?.toString() ?? '',
      jenis: map['jenis']?.toString() ?? '',
      pemilik: map['pemilik']?.toString() ?? '',
      noHp: map['no_hp']?.toString() ?? '',
      tanggalMasuk: DateTime.parse(map['tanggal_masuk'].toString()),
      tanggalAmbil: DateTime.parse(map['tanggal_ambil'].toString()),
      status: map['status']?.toString() ?? 'Dititip',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toInsertMap({required String userId}) {
    return {
      'user_id': userId,
      'nama_hewan': namaHewan,
      'jenis': jenis,
      'pemilik': pemilik,
      'no_hp': noHp,
      'tanggal_masuk': tanggalMasuk.toIso8601String().split('T').first,
      'tanggal_ambil': tanggalAmbil.toIso8601String().split('T').first,
      'status': status,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'nama_hewan': namaHewan,
      'jenis': jenis,
      'pemilik': pemilik,
      'no_hp': noHp,
      'tanggal_masuk': tanggalMasuk.toIso8601String().split('T').first,
      'tanggal_ambil': tanggalAmbil.toIso8601String().split('T').first,
      'status': status,
    };
  }
}