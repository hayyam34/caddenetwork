
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'user_detail_page.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  bool _processing = false;

  Future<void> _handleCode(String rawValue) async {
    if (_processing) return;
    setState(() => _processing = true);

    try {
      // Beklenen format: USER:<docId>;GROUP:<group>
      if (!rawValue.startsWith("USER:")) {
        throw Exception("Geçersiz QR formatı");
      }

      final parts = rawValue.split(";");
      final userPart = parts[0];
      final docId = userPart.replaceFirst("USER:", "");

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .get();

      if (!doc.exists) {
        throw Exception("Kullanıcı bulunamadı");
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserDetailPage(
            userDoc: doc as dynamic,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    } finally {
      setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            final rawValue = barcode.rawValue;
            if (rawValue != null) {
              _handleCode(rawValue);
            }
          },
        ),
        if (_processing)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
