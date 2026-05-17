import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'utils/app_colors.dart';
import 'providers/vault_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  final prefs = await SharedPreferences.getInstance();
  final String? savedName = prefs.getString('userName');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VaultProvider()),
      ],
      child: PasswordManagerApp(savedName: savedName),
    ),
  );
}

class PasswordManagerApp extends StatelessWidget {
  final String? savedName;
  const PasswordManagerApp({Key? key, this.savedName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (savedName != null) {
      context.read<VaultProvider>().loadInitialData(savedName!);
    }

    return MaterialApp(
      title: 'VaultSecured',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.accent,
        colorScheme: const ColorScheme.light(
          primary: AppColors.accent,
          secondary: AppColors.accentDark,
          background: AppColors.background,
        ),
      ),
      home: savedName == null ? const IntroScreen() : const HomeScreen(),
    );
  }
}