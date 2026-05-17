import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/vault_provider.dart';
import '../utils/app_colors.dart';
import '../models/vault_item.dart';
import 'create_vault_screen.dart';
import 'view_vault_screen.dart';

class VaultListScreen extends StatefulWidget {
  const VaultListScreen({Key? key}) : super(key: key);

  @override
  _VaultListScreenState createState() => _VaultListScreenState();
}

class _VaultListScreenState extends State<VaultListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Recent", "Favourite", "Last Edit"];

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
          icon: const Icon(CupertinoIcons.back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Vaults",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                autofocus: false, // Prevents keyboard auto-open
                decoration: InputDecoration(
                  hintText: "Search your vaults",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(CupertinoIcons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Filter Chips
            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [
                          BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                        ] : [],
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Vaults List
            Expanded(
              child: items.isEmpty
                ? Center(
                    child: Text('No vaults created yet.', style: TextStyle(color: AppColors.textGrey)),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // Simple hash function to generate consistent color per item if desired
                      final colors = [Colors.orange, Colors.redAccent, Colors.blue, Colors.purple, Colors.green];
                      final iconColor = colors[item.title.hashCode % colors.length];

                      return _buildVaultItem(context, item, iconColor);
                    },
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVaultItem(BuildContext context, VaultItem item, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.45,
          children: [
            CustomSlidableAction(
              onPressed: (_) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateVaultScreen(vaultItem: item),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              foregroundColor: const Color(0xFF3B82F6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded),
              ),
            ),
            CustomSlidableAction(
              onPressed: (_) {
                context.read<VaultProvider>().deleteVault(item.id);
              },
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.error,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline_rounded),
              ),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => ViewVaultScreen(vaultItem: item)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                // Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      Text(item.username.isNotEmpty ? item.username : "No username", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(8, (index) => const Padding(
                          padding: EdgeInsets.only(right: 3.0),
                          child: Icon(CupertinoIcons.circle_fill, size: 6, color: Colors.black38),
                        )),
                      )
                    ],
                  ),
                ),
                // Subtle Swipe Hint & Heart
                Row(
                  children: [
                    const Icon(CupertinoIcons.heart_fill, color: AppColors.accent, size: 18),
                    const SizedBox(width: 12),
                    Text("< Swipe", style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}