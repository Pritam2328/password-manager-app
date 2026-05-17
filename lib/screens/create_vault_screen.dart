import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
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
    CupertinoIcons.padlock_solid,
  ];

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _obscurePassword = true;

  List<CustomField> _customFields = [];

  @override
  void initState() {
    super.initState();
    isEditMode = widget.vaultItem != null;

    if (isEditMode) {
      _passwordController.text = widget.vaultItem!.password;
      _noteController.text = widget.vaultItem!.note;
      _selectedCategory = widget.vaultItem!.category;
      
      int iconIndex = _icons.indexOf(widget.vaultItem!.icon);
      if (iconIndex != -1) {
        _selectedIconIndex = iconIndex;
      }
      
      _customFields = List.from(widget.vaultItem!.customFields);
    } else {
      _customFields.add(CustomField(title: 'Title', value: ''));
      _customFields.add(CustomField(title: 'Username', value: ''));
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addCustomField() {
    String tempTitle = '';
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add Custom Field'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CupertinoTextField(
            placeholder: 'Field Title (e.g., URL, PIN)',
            onChanged: (val) => tempTitle = val,
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
              if (tempTitle.isNotEmpty) {
                setState(() {
                  _customFields.add(CustomField(title: tempTitle, value: ''));
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
    // Basic validation
    if (_passwordController.text.isEmpty || _customFields.isEmpty || _customFields[0].value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Password are required'), backgroundColor: AppColors.error),
      );
      return;
    }

    final newItem = VaultItem(
      id: isEditMode ? widget.vaultItem!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _customFields.firstWhere((f) => f.title.toLowerCase() == 'title' || f.title.toLowerCase().contains('name'), orElse: () => _customFields[0]).value,
      category: _selectedCategory,
      username: _customFields.length > 1 ? _customFields[1].value : '',
      password: _passwordController.text,
      note: _noteController.text,
      icon: _icons[_selectedIconIndex],
      customFields: _customFields,
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
          isEditMode ? 'Edit the Password' : 'Create New Vault',
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Change Icon',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...List.generate(_icons.length, (index) {
                            final isSelected = _selectedIconIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedIconIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                width: 60,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.accent : AppColors.cardLight,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? AppColors.accent : AppColors.border,
                                  ),
                                ),
                                child: Icon(
                                  _icons[index],
                                  color: isSelected ? Colors.white : AppColors.textGrey,
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.cardLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(CupertinoIcons.photo, color: AppColors.textGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Details',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.add_circled_solid, color: AppColors.accent),
                          onPressed: _addCustomField,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _customFields.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildInputField(
                            title: _customFields[index].title,
                            initialValue: _customFields[index].value,
                            onChanged: (val) {
                              _customFields[index] = CustomField(title: _customFields[index].title, value: val);
                            },
                            onDelete: () {
                              setState(() {
                                _customFields.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 24),

                    const Text(
                      'Mandatory Fields',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      title: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      isMandatory: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      title: 'Note (Optional)',
                      controller: _noteController,
                      isMandatory: true,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      'Category',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ...categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.cardLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : AppColors.border,
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? AppColors.accent : AppColors.textGrey,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Add Category Button
                        GestureDetector(
                          onTap: _addCategory,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.cardLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.add, size: 16, color: AppColors.accent),
                                SizedBox(width: 4),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveVault,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    isEditMode ? 'Save Changes' : 'Create the vault',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    String? initialValue,
    TextEditingController? controller,
    bool isPassword = false,
    bool isMandatory = false,
    VoidCallback? onDelete,
    Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isMandatory && onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: const Icon(CupertinoIcons.minus_circle, color: AppColors.error, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            obscureText: isPassword && _obscurePassword,
            maxLines: isPassword ? 1 : maxLines,
            onChanged: onChanged,
            style: const TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}