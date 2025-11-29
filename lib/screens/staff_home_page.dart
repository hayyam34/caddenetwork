
import 'package:flutter/material.dart';
import 'pending_users_page.dart';
import 'qr_scan_page.dart';

class StaffHomePage extends StatefulWidget {
  final String currentUid;
  final String role;

  const StaffHomePage({
    super.key,
    required this.currentUid,
    required this.role,
  });

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const PendingUsersPage(),
      const QrScanPage(),
    ];

    final titles = [
      "Onay Bekleyen Başvurular",
      "QR Okut",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Yetkili Paneli - ${titles[_tabIndex]}"),
      ),
      body: pages[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Başvurular",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "QR Okut",
          ),
        ],
      ),
    );
  }
}
