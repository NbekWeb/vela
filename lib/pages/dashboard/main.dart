import 'package:flutter/material.dart';
import 'home.dart';
import 'vault.dart';
import 'check_in.dart';
import 'profile.dart';
import 'components/home_icon.dart';
import 'components/vault_icon.dart';
import 'components/check_icon.dart';
import 'components/profile_icon.dart';
import '../generator/generator_page.dart';
import 'dart:io' show Platform;

class DashboardMainPage extends StatefulWidget {
  const DashboardMainPage({super.key});

  @override
  State<DashboardMainPage> createState() => _DashboardMainPageState();
}

class _DashboardMainPageState extends State<DashboardMainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    DashboardHomePage(),
    DashboardVaultPage(),
    DashboardCheckInPage(),
    DashboardProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Color(0xFFA4C6EB)),

        Scaffold(
          body: _pages[_selectedIndex],
          backgroundColor: Colors.transparent, // Scaffold background transparent bo‘lsin
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(bottom: 0),
            padding: Platform.isIOS
              ? EdgeInsets.only(
                  top: 10,
                  bottom: 20 + MediaQuery.of(context).viewPadding.bottom,
                  left: 20,
                  right: 20,
                )
              : const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavItem(
                  icon: HomeIcon(filled: _selectedIndex == 0, opacity: _selectedIndex == 0 ? 1.0 : 0.5),
                  label: 'Home',
                  selected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                _NavItem(
                  icon: VaultIcon(filled: _selectedIndex == 1, opacity: _selectedIndex == 1 ? 1.0 : 0.5),
                  label: 'Vault',
                  selected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                // Center star button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GeneratorPage()),
                    );
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(60, 110, 171, 1),
                          Color.fromRGBO(164, 198, 235, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/img/star.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                _NavItem(
                  icon: CheckIcon(filled: _selectedIndex == 2, opacity: _selectedIndex == 2 ? 1.0 : 0.5),
                  label: 'Check-in',
                  selected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _NavItem(
                  icon: ProfileIcon(filled: _selectedIndex == 3, opacity: _selectedIndex == 3 ? 1.0 : 0.5),
                  label: 'Profile',
                  selected: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Color(0xFF3B6EAA) : Color(0xFF3B6EAA).withValues(alpha: 0.5),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 