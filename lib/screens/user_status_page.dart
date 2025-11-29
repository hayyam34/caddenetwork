
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserStatusPage extends StatelessWidget {
  final String ownerUid;

  const UserStatusPage({super.key, required this.ownerUid});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('users')
        .where('ownerUid', isEqualTo: ownerUid)
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text("Başvuru Durumum")),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Henüz bir başvurunuz yok."),
            );
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          final approved = data['approved'] == true;
          final qrData = data['qrData'] as String?;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ad: ${data['name'] ?? ''} ${data['surname'] ?? ''}"),
                const SizedBox(height: 8),
                Text("Grup: ${data['group'] ?? '-'}"),
                const SizedBox(height: 8),
                Text("Durum: ${approved ? 'ONAYLANDI' : 'Onay Bekliyor'}"),
                const SizedBox(height: 24),
                if (approved && qrData != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "QR Kodunuz",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: QrImageView(
                          data: qrData,
                          size: 220,
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    "Başvurunuz onaylandığında burada QR kodunuz görünecek.",
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
