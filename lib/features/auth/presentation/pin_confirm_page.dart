import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/storage/storage_service.dart';

class PinConfirmPage extends StatefulWidget {
  const PinConfirmPage({super.key});

  @override
  State<PinConfirmPage> createState() => _PinConfirmPageState();
}

class _PinConfirmPageState extends State<PinConfirmPage> {
  String _confirmPin = '';
  late final String initialPin;

  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialPin = GoRouterState.of(context).extra as String;
  }

  @override
  Widget build(BuildContext context) {
    final isMatch = _confirmPin == initialPin;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Kod qayta kiriting",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Avvalgi PIN kodni qayta kiriting",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Pinput(
              length: 4,
              defaultPinTheme: defaultPinTheme,
              onChanged: (value) {
                setState(() {
                  _confirmPin = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isMatch
                  ? () async {
                await StorageService.savePin(initialPin);
                context.go('/biometric');
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isMatch ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Saqlash'),
            ),
          ],
        ),
      ),
    );
  }
}
