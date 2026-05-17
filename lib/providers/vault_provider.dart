import 'package:flutter/material.dart';
import '../models/vault_item.dart';

class VaultProvider with ChangeNotifier {
  List<VaultItem> _items = [];
  List<String> _categories = ['Browser', 'Mobile App', 'Payment', 'Secure Note'];
  String _userName = 'User';

  List<VaultItem> get items => _items;
  List<String> get categories => _categories;
  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void loadInitialData(String name) {
    _userName = name;
    // Load existing items from secure storage in real app
    notifyListeners();
  }

  void addVault(VaultItem item) {
    _items.insert(0, item); // Add to top
    notifyListeners();
  }

  void updateVault(VaultItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteVault(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      notifyListeners();
    }
  }
}