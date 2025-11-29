
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'user_detail_page.dart';

class PendingUsersPage extends StatelessWidget {
  const PendingUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('users')
        .where('approved', isEqualTo: false)
        .orderBy('createdAt', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Onay bekleyen başvuru yok."));
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final name = data['name'] ?? '';
            final surname = data['surname'] ?? '';
            final gender = data['gender'] ?? '';
            final group = data['group'] ?? '';

            return ListTile(
              title: Text("$name $surname"),
              subtitle: Text("Cinsiyet: $gender - Grup: $group"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailPage(userDoc: doc),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () async {
                  final ok = await FirestoreService.tryApproveUser(doc);
                  if (!context.mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Bu grup için cinsiyet veya kişi limiti dolu olabilir.",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kullanıcı onaylandı.")),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
