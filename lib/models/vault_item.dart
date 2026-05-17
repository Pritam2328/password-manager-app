import 'package:flutter/material.dart';

class VaultItem {
  final String id;
  final String title;
  final String category;
  final String username;
  final String password;
  final String note;
  final IconData icon;
  final List<CustomField> customFields;

  VaultItem({
    required this.id,
    required this.title,
    required this.category,
    required this.username,
    required this.password,
    this.note = '',
    required this.icon,
    this.customFields = const [],
  });
}

class CustomField {
  final String title;
  final String value;

  CustomField({required this.title, required this.value});
}