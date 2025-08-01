import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/storage/storage_service.dart';

class PinEnterPage extends StatefulWidget {
  const PinEnterPage({super.key});

  @override
  State<PinEnterPage> createState() => _PinEnterPageState();
}

class _PinEnterPageState extends State<PinEnterPage> {
  String _enteredPin = '';

  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xatolik'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPin() async {
    final savedPin = await StorageService.getPin();
    if (savedPin == null) {
      _showDialog("Avval Login sahifasidan ro'yxatdan o'ting.");
    } else if (_enteredPin == savedPin) {
      context.go('/profile'); // yoki pushReplacement('/profile') agar stackdan chiqarish kerak bo‘lsa
    } else {
      _showDialog("Noto'g'ri parol. Qaytadan urinib ko'ring.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kirish')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "PIN kodni kiriting",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Pinput(
              length: 4,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (value) {
                _enteredPin = value;
              },
              onChanged: (value) {
                _enteredPin = value;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_enteredPin.length == 4) {
                  _checkPin();
                } else {
                  _showDialog("Iltimos, 4 xonali PIN kod kiriting.");
                }
              },
              child: const Text('Kirish'),
            ),
          ],
        ),
      ),
    );
  }
}
