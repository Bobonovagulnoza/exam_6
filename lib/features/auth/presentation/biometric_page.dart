import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class BiometricPage extends StatelessWidget {
  const BiometricPage({super.key});

  Future<void> _auth(BuildContext context) async {
    final auth = LocalAuthentication();
    final didAuth = await auth.authenticate(
      localizedReason: 'Biometrik tasdiqlang',
    );

    if (didAuth) context.go('/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Biometrik',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Button background
            foregroundColor: Colors.white, // Text color
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
