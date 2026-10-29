/*
Nama : Fathur Ali Algifari
NRP  : 162024009
Program : Halaman profil interaktif 
*/

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
}

// ======= MyApp =======
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Akhir Week 2 - Profile Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ProfilePage(),
    );
  }
}

// ====== Data sederhana untuk item menu sidebar ======
class MenuData {
  final IconData icon;
  final String label;

  const MenuData(this.icon, this.label);
}

// ======Halaman Profil =======
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ---------- Konstanta ukuran ----------
  static const double avatarSize = 92;
  static const double addButtonSize = 40;
  static const double actionButtonHeight = 36;
  static const double sidebarWidth = 220;
  static const double indicatorWidth = 28;
  static const double indicatorHeight = 2;

  // ---------- Konstanta warna ----------
  static final Color placeholderColor = Colors.grey.shade700;
  static final Color inactiveColor = Colors.grey.shade500;

  // ---------- Konstanta gaya teks ----------
  static const TextStyle usernameStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: Colors.black,
  );
  static const TextStyle statValueStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static const TextStyle statLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
  static const TextStyle actionButtonStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );
  static const TextStyle menuStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  // ---------- Data ----------
  // Item menu sidebar
  static const List<MenuData> menuItems = [
    MenuData(Icons.person, 'Profile'),
    MenuData(Icons.settings, 'Settings'),
    MenuData(Icons.logout, 'Log Out'),
  ];

  // Ikon tab konten: grid, bookmark, hashtag
  static const List<IconData> tabIcons = [
    Icons.grid_on,
    Icons.bookmark,
    Icons.tag,
  ];

  // ---------- State ----------
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedTab = 0; 
  int selectedMenu = 0; 

  // ---------- Fungsi aksi ----------
  void toggleSidebar() {
    final scaffoldState = _scaffoldKey.currentState!;
    if (scaffoldState.isEndDrawerOpen) {
      scaffoldState.closeEndDrawer();
    } else {
      scaffoldState.openEndDrawer();
    }
  }

  void closeSidebar() {
    _scaffoldKey.currentState!.closeEndDrawer();
  }

  void selectTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  void selectMenu(int index) {
    setState(() {
      selectedMenu = index;
    });
    closeSidebar();

    // Menu selain Profile hanya menampilkan pesan singkat
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu ${menuItems[index].label} dipilih'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // ====== Widget kecil ======

  // Satu kolom statistik (angka + label)
  Widget buildStat(String angka, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(angka, style: statValueStyle),
        const SizedBox(height: 4),
        Text(label, style: statLabelStyle),
      ],
    );
  }

  // Satu tombol aksi (Edit Profile / Share Profile)
  Widget buildActionButton(String text) {
    return Expanded(
      child: Container(
        height: actionButtonHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(text, style: actionButtonStyle)),
      ),
    );
  }

  // Satu tombol tab (ikon + garis bawah jika aktif)
  Widget buildTabButton(int index) {
    final bool isActive = selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () => selectTab(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tabIcons[index],
                color: isActive ? Colors.black : inactiveColor,
              ),
              const SizedBox(height: 4),
              Container(
                width: indicatorWidth,
                height: indicatorHeight,
                color: isActive ? Colors.black : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Satu item menu di sidebar
  Widget buildMenuItem(int index) {
    return ListTile(
      leading: Icon(menuItems[index].icon, color: Colors.black),
      title: Text(menuItems[index].label, style: menuStyle),
      selected: selectedMenu == index,
      selectedTileColor: Colors.grey.shade400,
      onTap: () => selectMenu(index),
    );
  }

  // ======= Bagian halaman ======

  // Sidebar (muncul dari sisi kanan)
  Widget buildSidebar() {
    return Drawer(
      width: sidebarWidth,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol X untuk menutup sidebar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: closeSidebar,
              ),
            ),
            for (int i = 0; i < menuItems.length; i++) buildMenuItem(i),
          ],
        ),
      ),
    );
  }

  // Baris atas: username + ikon hamburger
  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('_algifarl', style: usernameStyle),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: toggleSidebar,
          ),
        ],
      ),
    );
  }

  // Header: foto profil 
  Widget buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: placeholderColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: buildStat('400', 'Posts')),
                Expanded(child: buildStat('679M', 'Followers')),
                Expanded(child: buildStat('637', 'Following')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Baris tombol aksi
  Widget buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          buildActionButton('Edit Profile'),
          buildActionButton('Share Profile'),
        ],
      ),
    );
  }

  // Ikon tambah (+)
  Widget buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: addButtonSize,
        height: addButtonSize,
        decoration: BoxDecoration(
          color: placeholderColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Baris tombol navigasi konten
  Widget buildTabBar() {
    return Row(
      children: List.generate(tabIcons.length, buildTabButton),
    );
  }

  // Galeri postingan (3 kolom)
  Widget buildGallery() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return Container(color: placeholderColor);
        },
      ),
    );
  }

  // ====== build() ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: buildSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTopBar(),
            buildProfileHeader(),
            const SizedBox(height: 16),
            buildActionButtons(),
            const SizedBox(height: 24),
            buildAddButton(),
            const SizedBox(height: 12),
            buildTabBar(),
            const SizedBox(height: 8),
            buildGallery(),
          ],
        ),
      ),
    );
  }
}