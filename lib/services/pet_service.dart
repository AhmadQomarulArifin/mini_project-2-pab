import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet.dart';

class PetService {
  final SupabaseClient supabase = Supabase.instance.client;

  String get currentUserId {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }
    return user.id;
  }

  Future<List<Pet>> getPets() async {
    final data = await supabase
        .from('pets')
        .select()
        .eq('user_id', currentUserId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((item) => Pet.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addPet(Pet pet) async {
    await supabase.from('pets').insert(
          pet.toInsertMap(userId: currentUserId),
        );
  }

  Future<void> updatePet(Pet pet) async {
    await supabase
        .from('pets')
        .update(pet.toUpdateMap())
        .eq('id', pet.id)
        .eq('user_id', currentUserId);
  }

  Future<void> deletePet(String id) async {
    await supabase
        .from('pets')
        .delete()
        .eq('id', id)
        .eq('user_id', currentUserId);
  }
}