import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pet_profile.dart';

class PetProfileService {
  static const String _profileKey = 'pet_profile';

  // Sauvegarder le profil
  Future<void> saveProfile(PetProfile profile) async {
    final prefs = await SharedPreferences. getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
    print('💾 Pet profile saved:  ${profile.name}');
  }

  // Charger le profil
  Future<PetProfile? > loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileData = prefs.getString(_profileKey);

      if (profileData != null) {
        final profile = PetProfile.fromJson(json.decode(profileData));
        print('📖 Pet profile loaded: ${profile. name}');
        return profile;
      }
      print('⚠️ No pet profile found');
      return null;
    } catch (e) {
      print('❌ Error loading profile: $e');
      return null;
    }
  }

  // Vérifier si un profil existe
  Future<bool> hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_profileKey);
  }

  // Supprimer le profil (pour reset)
  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    print('🗑️ Pet profile deleted');
  }
}