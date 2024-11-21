import 'package:shared_preferences/shared_preferences.dart';

class CityService {
  static const String cityKey = 'selected_city';

  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cityKey, city);
  }

  Future<String?> getSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(cityKey);
  }
}
