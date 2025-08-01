import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _pinCode = '';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parol yaratish")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("4 xonali parol kiriting"),
            const SizedBox(height: 20),
            Pinput(
              length: 4,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (value) {
                setState(() {
                  _pinCode = value;
                });
              },
              onChanged: (value) {
                _pinCode = value;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _pinCode.length == 4
                  ? () {
                context.push('/pin-confirm', extra: _pinCode);
              }
                  : null,
              child: const Text('Davom etish'),
            ),
          ],
        ),
      ),
    );
  }
}
