import 'package:exam_6/features/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class BiometricPage extends StatelessWidget {
  const BiometricPage({super.key});

  Future<void> _auth(BuildContext context) async {
    final auth = LocalAuthentication();

    try {
      final isAvailable = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) {
        _showSnackBar(context, "Biometrik autentifikatsiya qurilmada mavjud emas");
        return;
      }

      final didAuth = await auth.authenticate(
        localizedReason: 'Iltimos, biometrik ma\'lumot bilan tasdiqlang',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuth) {
        context.go('/profile');
      } else {
        _showSnackBar(context, "Biometrik autentifikatsiya muvaffaqiyatsiz tugadi");
      }
    } catch (e) {
      _showSnackBar(context, "Xatolik yuz berdi: $e");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Biometrik ma'lumot",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go("/login");
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: () => _auth(context),
          child: const Text('Biometrik kirish'),
        ),
      ),
    );
  }
}
