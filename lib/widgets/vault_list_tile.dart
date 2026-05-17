import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/vault_item.dart';
import '../utils/app_colors.dart';

class VaultListTile extends StatelessWidget {
  final VaultItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const VaultListTile({
    Key? key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
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
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.45,
          children: [
            CustomSlidableAction(
              onPressed: (_) => onEdit(),
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
              onPressed: (_) => onDelete(),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: AppColors.textDark, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.username,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Swipe Hint
                Row(
                  children: [
                    const Text(
                      'Swipe',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: AppColors.textGrey.withOpacity(0.5),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}