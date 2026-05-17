import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/vault_provider.dart';
import '../widgets/vault_list_tile.dart';
import 'vault_list_screen.dart';
import 'create_vault_screen.dart';
import 'view_vault_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vaultProvider = context.watch<VaultProvider>();
    final recentItems = vaultProvider.items.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const CreateVaultScreen()),
          );
        },
        backgroundColor: AppColors.accent,
        elevation: 4,
        child: const Icon(CupertinoIcons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          // Dark Curved Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
            decoration: const BoxDecoration(
              color: AppColors.headerDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vaultProvider.userName,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.bell, color: AppColors.textLight, size: 22),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Search Bar inside header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const TextField(
                    style: TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: 'Search passwords, notes...',
                      hintStyle: TextStyle(color: AppColors.textGrey),
                      prefixIcon: Icon(CupertinoIcons.search, color: AppColors.textGrey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Compact Categories Layout (Grid)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildCategoryCard('Browser', CupertinoIcons.globe, 12),
                      _buildCategoryCard('Mobile App', CupertinoIcons.device_phone_portrait, 8),
                      _buildCategoryCard('Payment', CupertinoIcons.creditcard, 4),
                      _buildCategoryCard('Secure Note', CupertinoIcons.lock_shield, 2),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recently Used',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => const VaultListScreen()),
                          );
                        },
                        child: const Text(
                          'See More',
                          style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (recentItems.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'No recent items found.',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentItems.length,
                      itemBuilder: (context, index) {
                        final item = recentItems[index];
                        return VaultListTile(
                          item: item,
                          onEdit: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CreateVaultScreen(vaultItem: item),
                              ),
                            );
                          },
                          onDelete: () {
                            context.read<VaultProvider>().deleteVault(item.id);
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ViewVaultScreen(vaultItem: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.accent, size: 20),
              ),
              Text(
                '$count',
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}