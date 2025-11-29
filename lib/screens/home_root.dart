import 'package:flutter/material.dart';
import 'register_page.dart';
import 'user_status_page.dart';
import 'staff_home_page.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _currentIndex = 0;

  // Windows için geçici UID
  final String fakeUid = "windows-test-user";
  final String role = "admin";
  // admin yapıyoruz ki tüm menüler açılsın

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      RegisterPage(ownerUid: fakeUid),
      UserStatusPage(ownerUid: fakeUid),
      StaffHomePage(currentUid: fakeUid, role: role),
    ];

    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_add),
        label: 'Kayıt',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.info),
        label: 'Durumum',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Yetkili',
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: items,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}
