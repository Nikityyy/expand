// lib/ui/widgets/exp_progress_bar.dart
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class ExpProgressBar extends StatelessWidget {
  final double percent; // 0.0 to 100.0
  final String? label;
  final bool showPercent;
  final double height;

  const ExpProgressBar({
    super.key,
    required this.percent,
    this.label,
    this.showPercent = true,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0, 100) / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercent)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null) Text(label!, style: AppTextStyles.label),
                if (showPercent)
                  Text(
                    _formatPercent(percent),
                    style: AppTextStyles.dataLabel.copyWith(
                      color: AppColors.styrianForest,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(99)),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height,
            backgroundColor: AppColors.border,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.styrianForest),
          ),
        ),
      ],
    );
  }

  String _formatPercent(double p) {
    if (p == 0) return '0.00%';
    if (p >= 1) return '${p.toStringAsFixed(2)}%';
    if (p >= 0.001) return '${p.toStringAsFixed(3)}%';
    return '<0.01%';
  }
}
