import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vault_item.dart';
import '../utils/app_colors.dart';
import '../providers/vault_provider.dart';

class CreateVaultScreen extends StatefulWidget {
  final VaultItem? vaultItem;

  const CreateVaultScreen({Key? key, this.vaultItem}) : super(key: key);

  @override
  State<CreateVaultScreen> createState() => _CreateVaultScreenState();
}

class _CreateVaultScreenState extends State<CreateVaultScreen> {
  late bool isEditMode;
  int _selectedIconIndex = 0;
  String _selectedCategory = 'Browser';

  final List<IconData> _icons = [
    CupertinoIcons.globe,
    CupertinoIcons.device_phone_portrait,
    CupertinoIcons.creditcard,
    CupertinoIcons.mail,
    CupertinoIcons.lock_fill,
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.vaultItem != null;

    if (isEditMode) {
      _titleController.text = widget.vaultItem!.title;
      _usernameController.text = widget.vaultItem!.username;
      _passwordController.text = widget.vaultItem!.password;
      _selectedCategory = widget.vaultItem!.category;
      
      int iconIndex = _icons.indexOf(widget.vaultItem!.icon);
      if (iconIndex != -1) {
        _selectedIconIndex = iconIndex;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _addCategory() {
    String newCategory = '';
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add Category'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CupertinoTextField(
            placeholder: 'New Category Name',
            onChanged: (val) => newCategory = val,
            style: const TextStyle(color: AppColors.textDark),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Add', style: TextStyle(color: AppColors.accent)),
            onPressed: () {
              if (newCategory.isNotEmpty) {
                context.read<VaultProvider>().addCategory(newCategory);
                setState(() {
                  _selectedCategory = newCategory;
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _saveVault() {
    if (_titleController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Password are required'), backgroundColor: AppColors.error),
      );
      return;
    }

    final newItem = VaultItem(
      id: isEditMode ? widget.vaultItem!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      category: _selectedCategory,
      username: _usernameController.text,
      password: _passwordController.text,
      note: '', // simplified for UI design
      icon: _icons[_selectedIconIndex],
      customFields: [], // simplified for UI design
    );

    if (isEditMode) {
      context.read<VaultProvider>().updateVault(newItem);
    } else {
      context.read<VaultProvider>().addVault(newItem);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<VaultProvider>().categories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? "Edit Vault" : "Create New Vaults",
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Selector
            Center(
              child: Column(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_icons[_selectedIconIndex], color: AppColors.accent, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text("Change Icon", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_icons.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIconIndex = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _selectedIconIndex == index 
                              ? Border.all(color: AppColors.accent, width: 1.5) 
                              : Border.all(color: Colors.transparent),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
                          ),
                          child: Icon(_icons[index], size: 20, color: Colors.grey.shade600),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Form Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Credential", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  
                  _buildInputField(
                    "Site Address / Title", 
                    "e.g., https://dribbble.com", 
                    CupertinoIcons.globe,
                    _titleController,
                  ),
                  const SizedBox(height: 15),
                  
                  _buildInputField(
                    "User Name / Email", 
                    "hello@designmonk.com", 
                    CupertinoIcons.person_fill,
                    _usernameController,
                  ),
                  const SizedBox(height: 15),
                  
                  _buildPasswordField(
                    "Password", 
                    "••••••••••••••",
                    _passwordController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Bottom Category Selector
            const Text("Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...categories.map((category) {
                    return _buildCategoryChip(category, _selectedCategory == category);
                  }).toList(),
                  GestureDetector(
                    onTap: _addCategory,
                    child: _buildCategoryChip("Add +", false, isAddButton: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveVault,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: AppColors.accent.withOpacity(0.5),
                ),
                child: Text(
                  isEditMode ? "Save Changes" : "Create the vault", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _obscurePassword,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        suffixIcon: TextButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          }, 
          child: Text(_obscurePassword ? "View" : "Hide", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold))
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildCategoryChip(String title, bool isSelected, {bool isAddButton = false}) {
    return GestureDetector(
      onTap: isAddButton ? null : () => setState(() => _selectedCategory = title),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? AppColors.accent : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title, 
          style: TextStyle(
            color: isSelected ? AppColors.accent : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}