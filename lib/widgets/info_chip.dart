import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const InfoChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) => onTap?.call(),
    );
  }
}
