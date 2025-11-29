import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class RegisterPage extends StatefulWidget {
  final String ownerUid;

  const RegisterPage({super.key, required this.ownerUid});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final surnameC = TextEditingController();
  final schoolC = TextEditingController();
  final jobC = TextEditingController();
  final instaC = TextEditingController();

  String gender = "Erkek";
  int group = 1;

  bool loading = false;

  @override
  void dispose() {
    nameC.dispose();
    surnameC.dispose();
    schoolC.dispose();
    jobC.dispose();
    instaC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirestoreService.createApplication(
        ownerUid: widget.ownerUid,
        name: nameC.text.trim(),
        surname: surnameC.text.trim(),
        gender: gender,
        school: schoolC.text.trim(),
        job: jobC.text.trim(),
        instagram: instaC.text.trim(),
        group: group,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Başvurunuz Alındı"),
          content: const Text("Size geri dönüş yapılacaktır."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Formu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Ad"),
                validator: (v) => v == null || v.isEmpty ? "Ad gerekli" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: surnameC,
                decoration: const InputDecoration(labelText: "Soyad"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Soyad gerekli" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(value: "Erkek", child: Text("Erkek")),
                  DropdownMenuItem(value: "Kadın", child: Text("Kadın")),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => gender = v);
                },
                decoration: const InputDecoration(labelText: "Cinsiyet"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: schoolC,
                decoration:
                    const InputDecoration(labelText: "Son Mezun Olunan Okul"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: jobC,
                decoration: const InputDecoration(labelText: "Meslek"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: instaC,
                decoration:
                    const InputDecoration(labelText: "Instagram Kullanıcı Adı"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: group,
                items: List.generate(
                  10,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text("Grup ${i + 1}"),
                  ),
                ),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => group = v);
                },
                decoration: const InputDecoration(labelText: "Grup Seç"),
              ),
              const SizedBox(height: 24),
              loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text("Başvuruyu Gönder"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
