import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/vault_item.dart';
import '../utils/app_colors.dart';

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

  final List<String> _categories = [
    'Browser',
    'Mobile App',
    'Payment',
    'Secure Note'
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
      if (_customFields.isEmpty) {
        _customFields.add(CustomField(title: 'Website / App Name', value: widget.vaultItem!.title));
        _customFields.add(CustomField(title: 'Username / Email', value: widget.vaultItem!.username));
      }
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
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
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
        title: Text(
          isEditMode ? 'Edit the Password' : 'Create New Vault',
          style: const TextStyle(
            color: AppColors.textPrimary,
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
                        color: AppColors.textPrimary,
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
                                  color: isSelected ? AppColors.accent : AppColors.cardDark,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? AppColors.accent : AppColors.border,
                                  ),
                                ),
                                child: Icon(
                                  _icons[index],
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () {
                              // Gallery upload mock
                            },
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.cardDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                              ),
                              child: const Icon(CupertinoIcons.photo, color: AppColors.textSecondary),
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
                            color: AppColors.textPrimary,
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
                        color: AppColors.textPrimary,
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
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.cardDark,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.accent : AppColors.border.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.5))),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isMandatory && onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: const Icon(CupertinoIcons.minus_circle, color: Colors.redAccent, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            obscureText: isPassword && _obscurePassword,
            maxLines: isPassword ? 1 : maxLines,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                        color: AppColors.textSecondary,
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