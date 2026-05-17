import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/vault_item.dart';
import '../utils/app_colors.dart';
import '../widgets/vault_list_tile.dart';
import 'create_vault_screen.dart';

class VaultListScreen extends StatefulWidget {
  const VaultListScreen({Key? key}) : super(key: key);

  @override
  State<VaultListScreen> createState() => _VaultListScreenState();
}

class _VaultListScreenState extends State<VaultListScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Recent', 'Favourite', 'Last Edit'];

  final List<VaultItem> _items = [
    VaultItem(
      id: '1',
      title: 'Netflix',
      category: 'Browser',
      username: 'alex.carter@mail.com',
      password: 'dummy_password_123',
      icon: Icons.movie_creation_rounded,
    ),
    VaultItem(
      id: '2',
      title: 'Dribbble',
      category: 'Browser',
      username: 'designer_alex',
      password: 'dribbble_password_456',
      icon: Icons.sports_basketball_rounded,
    ),
    VaultItem(
      id: '3',
      title: 'Bank App',
      category: 'Payment',
      username: 'card ending **92',
      password: 'bank_password_789',
      icon: Icons.account_balance_rounded,
    ),
    VaultItem(
      id: '4',
      title: 'Twitter',
      category: 'Mobile App',
      username: '@alex_designs',
      password: 'twitter_password_000',
      icon: CupertinoIcons.chat_bubble_text,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Vaults',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add, color: AppColors.accent),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const CreateVaultScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search vaults...',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(CupertinoIcons.search,
                      color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilter == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withOpacity(0.15)
                          : AppColors.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.border.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return VaultListTile(
                  item: item,
                  onEdit: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CreateVaultScreen(
                          vaultItem: item,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}