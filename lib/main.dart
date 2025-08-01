import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'shared/themes/app_theme.dart';
import 'core/stores/auth_store.dart';
import 'core/stores/meditation_store.dart';
import 'core/stores/like_store.dart';
import 'core/stores/check_in_store.dart';
import 'core/services/api_service.dart';
import 'pages/loading_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/dashboard/main.dart';
import 'pages/auth/starter_page.dart';
import 'pages/plan_page.dart';
import 'pages/generator/generator_page.dart';
import 'pages/vault_page.dart';
import 'pages/dashboard/my_meditations_page.dart';
import 'pages/dashboard/archive_page.dart';

// Global navigator key for API service
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize stores
  final authStore = AuthStore();
  final meditationStore = MeditationStore();
  final likeStore = LikeStore();
  final checkInStore = CheckInStore();
  
  await authStore.initialize();
  await meditationStore.initialize();
  
  // Check if user is authenticated and set initial route
  String initialRoute = '/loading';
  if (authStore.isAuthenticated) {
    initialRoute = '/dashboard';
  }
  
  runApp(MyApp(
    authStore: authStore, 
    meditationStore: meditationStore,
    likeStore: likeStore,
    checkInStore: checkInStore,
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final AuthStore authStore;
  final MeditationStore meditationStore;
  final LikeStore likeStore;
  final CheckInStore checkInStore;
  final String initialRoute;
  
  const MyApp({
    super.key, 
    required this.authStore, 
    required this.meditationStore,
    required this.likeStore,
    required this.checkInStore,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authStore),
          ChangeNotifierProvider.value(value: meditationStore),
          ChangeNotifierProvider.value(value: likeStore),
          ChangeNotifierProvider.value(value: checkInStore),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          routes: {
            '/loading': (context) => const LoadingScreen(),
            '/starter': (context) => const StarterPage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/plan': (context) => const PlanPage(),
            '/generator': (context) => const GeneratorPage(),
            '/vault': (context) => const VaultPage(),
            '/dashboard': (context) => const DashboardMainPage(),
            '/my-meditations': (context) => const MyMeditationsPage(),
            '/archive': (context) => const ArchivePage(),
          },
        ),
      ),
    );
  }
}
