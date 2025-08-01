import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/storage/storage_service.dart';

class PinEnterPage extends StatefulWidget {
  const PinEnterPage({super.key});

  @override
  State<PinEnterPage> createState() => _PinEnterPageState();
}

class _PinEnterPageState extends State<PinEnterPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kirish')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Kod kiriting"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final savedPin = await StorageService.getPin();
                if (savedPin == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Avval Login qiling")),
                  );
                } else if (savedPin == _controller.text) {
                  context.go('/profile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Noto'g'ri kod")),
                  );
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
