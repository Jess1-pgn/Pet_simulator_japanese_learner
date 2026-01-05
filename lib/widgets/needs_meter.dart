import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class NeedsMeter extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const NeedsMeter({
    Key? key,
    required this.label,
    required this.value,
    required this. color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: AppTheme.smallRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Icon avec background circulaire
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color. withOpacity(0.2),
              shape: BoxShape. circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),

          // Label
          Text(
            label,
            style: AppTheme. captionStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Progress bar circulaire
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: value / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 6,
                ),
              ),
              Text(
                '${value.toInt()}',
                style: AppTheme. subheadingStyle. copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}