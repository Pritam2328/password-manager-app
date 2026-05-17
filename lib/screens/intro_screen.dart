import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../providers/vault_provider.dart';
import 'home_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveAndContinue() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      if (mounted) {
        context.read<VaultProvider>().setUserName(name);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  CupertinoIcons.lock_shield_fill,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to\nVaultSecured',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your premium, secure offline password manager. Let\'s get started by knowing you.',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textDark),
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: AppColors.textGrey),
                    prefixIcon: Icon(CupertinoIcons.person, color: AppColors.textGrey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}