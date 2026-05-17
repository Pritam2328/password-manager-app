import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/vault_item.dart';
import '../utils/app_colors.dart';

class ViewVaultScreen extends StatelessWidget {
  final VaultItem vaultItem;

  const ViewVaultScreen({Key? key, required this.vaultItem}) : super(key: key);

  void _copyToClipboard(BuildContext context, String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fieldName copied to clipboard!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _shareDetails() async {
    String shareText = 'Vault Details - ${vaultItem.title}\n';
    shareText += 'Category: ${vaultItem.category}\n';
    shareText += 'Username: ${vaultItem.username}\n';
    shareText += 'Password: ${vaultItem.password}\n';
    if (vaultItem.note.isNotEmpty) shareText += 'Note: ${vaultItem.note}\n';
    
    for (var field in vaultItem.customFields) {
      shareText += '${field.title}: ${field.value}\n';
    }
    
    await Share.share(shareText);
  }

  Future<void> _downloadDetails(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${vaultItem.title}_vault.txt');
      
      String content = 'Vault Details - ${vaultItem.title}\n';
      content += 'Category: ${vaultItem.category}\n';
      content += 'Username: ${vaultItem.username}\n';
      content += 'Password: ${vaultItem.password}\n';
      if (vaultItem.note.isNotEmpty) content += 'Note: ${vaultItem.note}\n';
      for (var field in vaultItem.customFields) {
        content += '${field.title}: ${field.value}\n';
      }
      
      await file.writeAsString(content);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to: ${file.path}'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving file'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          vaultItem.title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.share, color: AppColors.textDark),
            onPressed: _shareDetails,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.cloud_download, color: AppColors.textDark),
            onPressed: () => _downloadDetails(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Icon(vaultItem.icon, size: 48, color: AppColors.headerDark),
              ),
            ),
            const SizedBox(height: 32),
            _buildReadOnlyField(context, 'Category', vaultItem.category),
            _buildReadOnlyField(context, 'Username', vaultItem.username),
            _buildReadOnlyField(context, 'Password', vaultItem.password, isPassword: true),
            if (vaultItem.note.isNotEmpty) _buildReadOnlyField(context, 'Note', vaultItem.note),
            ...vaultItem.customFields.map((field) => _buildReadOnlyField(context, field.title, field.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String title, String value, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isPassword ? '••••••••••••' : value,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyToClipboard(context, value, title),
                  child: const Icon(CupertinoIcons.doc_on_clipboard, color: AppColors.accent, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}