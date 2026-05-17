import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/vault_provider.dart';
import '../widgets/vault_list_tile.dart';
import 'create_vault_screen.dart';
import 'view_vault_screen.dart';

class VaultListScreen extends StatefulWidget {
  const VaultListScreen({Key? key}) : super(key: key);

  @override
  State<VaultListScreen> createState() => _VaultListScreenState();
}

class _VaultListScreenState extends State<VaultListScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Recent', 'Favourite', 'Last Edit'];

  @override
  Widget build(BuildContext context) {
    final vaultProvider = context.watch<VaultProvider>();
    final items = vaultProvider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Vaults',
          style: TextStyle(
            color: AppColors.textDark,
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
              child: const TextField(
                autofocus: false, // Critical Fix
                style: TextStyle(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: 'Search vaults...',
                  hintStyle: TextStyle(color: AppColors.textGrey),
                  prefixIcon: Icon(CupertinoIcons.search, color: AppColors.textGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      color: isSelected ? AppColors.headerDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.headerDark : AppColors.border,
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textGrey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('No vaults created yet.', style: TextStyle(color: AppColors.textGrey)),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
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
          ),
        ],
      ),
    );
  }
}