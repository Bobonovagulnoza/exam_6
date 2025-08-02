import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLocked = true;
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

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final name = await _storage.read(key: 'name');
    final surname = await _storage.read(key: 'surname');
    final phone = await _storage.read(key: 'phone');
    final birth = await _storage.read(key: 'birthDate');
    final regionValue = await _storage.read(key: 'region');
    final districtValue = await _storage.read(key: 'district');

    if (name != null &&
        surname != null &&
        phone != null &&
        birth != null &&
        regionValue != null &&
        districtValue != null) {
      setState(() {
        nameController.text = name;
        surnameController.text = surname;
        phoneController.text = phone;
        birthDate = DateTime.parse(birth);
        region = regionValue;
        district = districtValue;
        isSaved = true;
      });
    }
  }

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

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() == true &&
        birthDate != null &&
        region != null &&
        district != null) {
      await _storage.write(key: 'name', value: nameController.text);
      await _storage.write(key: 'surname', value: surnameController.text);
      await _storage.write(key: 'phone', value: phoneController.text);
      await _storage.write(key: 'birthDate', value: birthDate!.toIso8601String());
      await _storage.write(key: 'region', value: region!);
      await _storage.write(key: 'district', value: district!);

      setState(() {
        isSaved = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barcha maydonlarni to‘ldiring")),
      );
    }
  }

  Future<void> _verifyWithBiometrics() async {
    final isBiometricSupported = await _auth.isDeviceSupported();
    final canCheck = await _auth.canCheckBiometrics;

    if (!isBiometricSupported || !canCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ushbu qurilmada biometrik autentifikatsiya mavjud emas")),
      );
      return;
    }

    final didAuthenticate = await _auth.authenticate(
      localizedReason: 'Profil ma’lumotlariga kirish uchun autentifikatsiya qiling',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    if (didAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Autentifikatsiya muvaffaqiyatli!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Autentifikatsiya bekor qilindi yoki muvaffaqiyatsiz")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: const Text("Profil", style: TextStyle(color: Colors.white))),

        actions: [
          IconButton(
            icon: Icon(
              Icons.lock_open,
              color: Colors.white,
            ),
            onPressed: () {
              context.go('/');
            },
          ),
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: isSaved ? _buildSavedView() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildSavedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Ism", nameController.text),
        _buildInfoRow("Familiya", surnameController.text),
        _buildInfoRow("Tug‘ilgan sana", DateFormat.yMMMMd().format(birthDate!)),
        _buildInfoRow("Viloyat", region!),
        _buildInfoRow("Tuman", district!),
        _buildInfoRow("Telefon", phoneController.text),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () => setState(() => isSaved = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text("Tahrirlash"),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Ismingiz'),
            validator: (value) =>
            value == null || value.isEmpty ? 'Ismni kiriting' : null,
          ),
          TextFormField(
            controller: surnameController,
            decoration: const InputDecoration(labelText: 'Familiyangiz'),
            validator: (value) =>
            value == null || value.isEmpty ? 'Familiyani kiriting' : null,
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
            items: regions
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: (value) => setState(() {
              region = value;
              district = null;
            }),
            validator: (value) => value == null ? 'Viloyatni tanlang' : null,
          ),
          if (region != null)
            DropdownButtonFormField<String>(
              value: district,
              decoration: const InputDecoration(labelText: "Tumanni tanlang"),
              items: districtsByRegion[region]!
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) => setState(() => district = value),
              validator: (value) => value == null ? 'Tumanni tanlang' : null,
            ),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Telefon raqam'),
            validator: (value) => value == null || value.length < 9
                ? 'To‘g‘ri raqam kiriting'
                : null,
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
