
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  /// Roller:
  /// roles/{uid} belgelerinde 'role': 'user' | 'staff' | 'admin'
  static Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('roles').doc(uid).get();
    if (!doc.exists) {
      return 'user';
    }
    final data = doc.data() as Map<String, dynamic>;
    return data['role'] as String? ?? 'user';
  }

  static Future<void> createApplication({
    required String ownerUid,
    required String name,
    required String surname,
    required String gender,
    required String school,
    required String job,
    required String instagram,
    required int group,
  }) async {
    await _db.collection('users').add({
      'ownerUid': ownerUid,
      'name': name,
      'surname': surname,
      'gender': gender,
      'school': school,
      'job': job,
      'instagram': instagram,
      'group': group,
      'approved': false,
      'private': true,
      'qrData': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Onaylama mantığı:
  /// - Aynı grupta approved=true olanlardan gender say
  /// - Toplam 100'ü, cinsiyette 50'yi geçmesin
  /// UYARI: Bu çözüm basit ve küçük ölçek içindir.
  static Future<bool> tryApproveUser(QueryDocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final gender = data['gender'] as String? ?? 'Erkek';
    final group = data['group'] as int? ?? 1;

    final approvedQuery = await _db
        .collection('users')
        .where('approved', isEqualTo: true)
        .where('group', isEqualTo: group)
        .get();

    int male = 0;
    int female = 0;

    for (final d in approvedQuery.docs) {
      final g = (d.data()['gender'] as String? ?? '').toLowerCase();
      if (g == 'erkek') {
        male++;
      } else if (g == 'kadın' || g == 'kadin') {
        female++;
      }
    }

    final total = male + female;

    if (total >= 100) {
      return false;
    }

    if (gender.toLowerCase() == 'erkek' && male >= 50) {
      return false;
    }
    if ((gender.toLowerCase() == 'kadın' || gender.toLowerCase() == 'kadin') &&
        female >= 50) {
      return false;
    }

    final docId = doc.id;
    final qrData = "USER:$docId;GROUP:$group";

    await _db.collection('users').doc(docId).update({
      'approved': true,
      'qrData': qrData,
    });

    return true;
  }
}
