// lib/ui/widgets/exp_stat_card.dart
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

enum ExpStatCardVariant { primary, secondary }

class ExpStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData? icon;
  final ExpStatCardVariant variant;

  const ExpStatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.variant = ExpStatCardVariant.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == ExpStatCardVariant.primary;
    final bg = isPrimary ? AppColors.styrianForest : AppColors.pebble;
    final labelColor = isPrimary ? Colors.white70 : AppColors.slateLight;
    final valueColor = isPrimary ? Colors.white : AppColors.slate;
    final unitColor = isPrimary ? Colors.white60 : AppColors.slateLight;
    final iconColor = isPrimary ? Colors.white60 : AppColors.slateLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: isPrimary
            ? null
            : const Border.fromBorderSide(
                BorderSide(color: AppColors.border, width: 1),
              ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, size: 14, color: iconColor),
              if (icon != null) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.label.copyWith(
                    color: labelColor,
                    letterSpacing: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: AppTextStyles.dataMedium.copyWith(color: valueColor),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit!,
                    style: AppTextStyles.label.copyWith(color: unitColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
