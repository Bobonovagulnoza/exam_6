import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();

  DateTime? birthDate;
  String? region;
  String? district;

  bool isSaved = false;

  final List<String> regions = ['Toshkent', 'Samarqand', 'Farg‘ona'];
  final Map<String, List<String>> districtsByRegion = {
    'Toshkent': ['Yunusobod', 'Chilonzor', 'Olmazor'],
    'Samarqand': ['Urgut', 'Kattaqo‘rg‘on', 'Narpay'],
    'Farg‘ona': ['Qo‘qon', 'Marg‘ilon', 'Farg‘ona sh.'],
  };

  void _pickBirthDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (selected != null) {
      setState(() {
        birthDate = selected;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() == true &&
        birthDate != null &&
        region != null &&
        district != null) {
      setState(() {
        isSaved = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barcha maydonlarni to‘ldiring")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (isSaved) ...[
                _buildInfoRow("Ism", nameController.text),
                _buildInfoRow("Familiya", surnameController.text),
                _buildInfoRow("Tug‘ilgan sana", DateFormat.yMMMMd().format(birthDate!)),
                _buildInfoRow("Viloyat", region!),
                _buildInfoRow("Tuman", district!),
                _buildInfoRow("Telefon", phoneController.text),
                const SizedBox(height: 20),
              ],
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ismingiz'),
                validator: (value) => value == null || value.isEmpty ? 'Ismni kiriting' : null,
              ),
              TextFormField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'Familiyangiz'),
                validator: (value) => value == null || value.isEmpty ? 'Familiyani kiriting' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  birthDate == null
                      ? 'Tug‘ilgan sanani tanlang'
                      : DateFormat.yMMMMd().format(birthDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickBirthDate,
              ),
              DropdownButtonFormField<String>(
                value: region,
                decoration: const InputDecoration(labelText: "Viloyatni tanlang"),
                items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (value) {
                  setState(() {
                    region = value;
                    district = null;
                  });
                },
                validator: (value) => value == null ? 'Viloyatni tanlang' : null,
              ),
              if (region != null)
                DropdownButtonFormField<String>(
                  value: district,
                  decoration: const InputDecoration(labelText: "Tumanni tanlang"),
                  items: districtsByRegion[region]!
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      district = value;
                    });
                  },
                  validator: (value) => value == null ? 'Tumanni tanlang' : null,
                ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefon raqam'),
                validator: (value) =>
                value == null || value.length < 9 ? 'To‘g‘ri raqam kiriting' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Saqlash"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
