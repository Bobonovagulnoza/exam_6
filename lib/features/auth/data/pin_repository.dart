import 'package:shared_preferences/shared_preferences.dart';

abstract class IPinRepository {
  Future<void> savePin(String pin);
  Future<String?> getPin();
  Future<void> clearPin();
  Future<bool> hasPin();
}

class PinRepositoryImpl implements IPinRepository {
  static const _pinKey = 'user_pin';

  @override
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  @override
  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  @override
  Future<void> clearPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
  }

  @override
  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pinKey);
  }
}
