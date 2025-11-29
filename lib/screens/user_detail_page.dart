
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot userDoc;

  const UserDetailPage({super.key, required this.userDoc});

  @override
  Widget build(BuildContext context) {
    final data = userDoc.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Detayı")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Ad: ${data['name'] ?? ''} ${data['surname'] ?? ''}"),
            const SizedBox(height: 8),
            Text("Cinsiyet: ${data['gender'] ?? ''}"),
            const SizedBox(height: 8),
            Text("Grup: ${data['group'] ?? ''}"),
            const SizedBox(height: 8),
            Text("Okul: ${data['school'] ?? ''}"),
            const SizedBox(height: 8),
            Text("Meslek: ${data['job'] ?? ''}"),
            const SizedBox(height: 8),
            Text("Instagram: ${data['instagram'] ?? ''}"),
          ],
        ),
      ),
    );
  }
}
