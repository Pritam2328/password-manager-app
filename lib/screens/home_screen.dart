import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../utils/app_colors.dart';
import 'create_vault_screen.dart';
import 'vault_list_screen.dart';
import 'view_vault_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final vaultProvider = context.watch<VaultProvider>();
    final recentItems = vaultProvider.items.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Dark Header Background
          Container(
            height: 350,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.headerDark, AppColors.headerDarkEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Top Bar (Greeting & Notification)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello ${vaultProvider.userName} 👋", 
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Welcome back again!", 
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Health Score / Shield Circle
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.accentGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Health Score", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 5),
                          const Text("75%", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                            child: const Icon(CupertinoIcons.heart_fill, color: Colors.white, size: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 4. White Body Container overlapping the dark header
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35), 
                        topRight: Radius.circular(35)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // 5. Overlapping Search Bar
                          Transform.translate(
                            offset: const Offset(0, -25),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5)
                                  )
                                ],
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search your vaults",
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  prefixIcon: const Icon(CupertinoIcons.search, color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                                ),
                              ),
                            ),
                          ),

                          // 6. Categories Section
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildCategoryCard("Browser", "${vaultProvider.items.where((i) => i.category == 'Browser').length} Passwords", CupertinoIcons.globe),
                                _buildCategoryCard("Mobile App", "${vaultProvider.items.where((i) => i.category == 'Mobile App').length} Passwords", CupertinoIcons.device_phone_portrait),
                                _buildCategoryCard("Payment", "${vaultProvider.items.where((i) => i.category == 'Payment').length} Passwords", CupertinoIcons.creditcard),
                                _buildCategoryCard("Secure Note", "${vaultProvider.items.where((i) => i.category == 'Secure Note').length} Passwords", CupertinoIcons.lock_shield),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 7. Recently Used Section Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Recently Used", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => const VaultListScreen()),
                                  );
                                },
                                child: Text("See More", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // 8. Recently Used List
                          if (recentItems.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text("No items yet.", style: TextStyle(color: Colors.grey.shade500)),
                              ),
                            )
                          else
                            ...recentItems.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => ViewVaultScreen(vaultItem: item)),
                                  );
                                },
                                child: _buildRecentItem(
                                  item.title, 
                                  item.username.isNotEmpty ? item.username : "No username", 
                                  item.title.isNotEmpty ? item.title[0].toUpperCase() : "?", 
                                  AppColors.accent
                                ),
                              );
                            }).toList(),
                          
                          const SizedBox(height: 80), // FAB padding
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 9. Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const CreateVaultScreen()),
          );
        },
        backgroundColor: AppColors.accent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(CupertinoIcons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Category Card UI Component
  Widget _buildCategoryCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 105,
      height: 115,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
            ],
          )
        ],
      ),
    );
  }

  // Recently Used List Item UI Component
  Widget _buildRecentItem(String title, String subtitle, String initial, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Text(initial, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: iconColor)),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          const Icon(CupertinoIcons.heart_fill, color: AppColors.accent, size: 18),
        ],
      ),
    );
  }
}