import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../shared/widgets/svg_icon.dart';
import '../../core/stores/auth_store.dart';

class DashboardProfilePage extends StatelessWidget {
  const DashboardProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(
      builder: (context, authStore, child) {
        final user = authStore.user;
        final firstName = user?.firstName ?? 'User';
        final lastName = user?.lastName ?? '';
        final fullName = lastName.isNotEmpty
            ? '$firstName $lastName'
            : firstName;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: Stack(
              children: [
                // Star animation background
                const StarsAnimation(
                  starCount: 50,
                  topColor: Color(0xFF5799D6),
                  bottomColor: Color(0xFFA4C6EB),
                ),

                // Main content
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Header
                        _buildHeader(context),

                        const SizedBox(height: 30),

                        // Profile picture and name
                        _buildProfileSection(fullName),

                        const SizedBox(height: 40),

                        // Content sections
                        _buildContentSections(),

                        const SizedBox(height: 30),

                        // Neuroplasticity button
                        _buildNeuroplasticityButton(),

                        const SizedBox(
                          height: 100,
                        ), // Space for bottom navigation
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Back arrow
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/dashboard'),
            ),
          ),
        ),

        const Spacer(),

        // App logo
        Image.asset('assets/img/logo.png', width: 60, height: 39),

        const Spacer(),

        // Settings icon with dropdown
        PopupMenuButton<String>(
          icon: const Icon(Icons.settings, color: Colors.white, size: 24),
          color: const Color.fromRGBO(164, 199, 234, 0.5),
          elevation: 0,
          offset: const Offset(0, 45),
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'logout',

              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'logout') {
              // Clear tokens and navigate to login
              final authStore = Provider.of<AuthStore>(context, listen: false);
              await authStore.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileSection(String fullName) {
    return Column(
      children: [
        // Profile picture
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Camera icon
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF152B56),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Name
        Text(
          fullName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Canela-Light',
          ),
        ),
      ],
    );
  }

  Widget _buildContentSections() {
    return Column(
      children: [
        // Life Vision and Goals in Progress row
        Row(
          children: [
            // Life Vision
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title outside the card
                  Row(
                    children: [
                      const Text(
                        'Life Vision',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Card without title
                  _buildContentCard(
                    title: 'Your North Star',
                    titleIcon: Icons.star_outline,
                    content:
                        'I feel most authentic when I embrace my true self. I am focused on pursuing my passions.',
                    showEditIcon: false,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Goals in Progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title outside the card
                  Row(
                    children: [
                      const Text(
                        'Goals in Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Card without title
                  _buildContentCard(
                    title: '',
                    content: '',
                    showEditIcon: false,
                    customContent: _buildGoalsList(),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Dreams Realized
        _buildContentCard(
          title: 'Dreams Realized',
          content:
              "You're becoming your trust self Embarking on a journey to realize my dreams has been transformative. I feel most alive when I chase my aspirations and stay true to who I am.",
          showEditIcon: true,
        ),
      ],
    );
  }

  Widget _buildContentCard({
    required String title,
    IconData? titleIcon,
    required String content,
    bool showEditIcon = false,
    Widget? customContent,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(164, 199, 234, 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row - only show if title is not empty
              if (title.isNotEmpty) ...[
                Row(
                  children: [
                    if (titleIcon != null) ...[
                      Icon(titleIcon, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (showEditIcon)
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Content
              if (customContent != null)
                customContent
              else
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsList() {
    final goals = [
      {'text': 'Daily meditation', 'completed': true},
      {'text': 'Authentic self', 'completed': false},
      {'text': 'Dream vision', 'completed': false},
    ];

    return Column(
      children: goals.map((goal) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Custom circle with checkmark for completed goals
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: goal['completed'] == true
                      ? const Color(0xFF3B6EAA)
                      : Colors.transparent,
                  border: goal['completed'] == true
                      ? null
                      : Border.all(color: Colors.white, width: 1),
                ),
                child: goal['completed'] == true
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goal['text'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNeuroplasticityButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B6EAA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            assetName: 'assets/icons/brain.svg',
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          const Text(
            'Neuroplasticity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
