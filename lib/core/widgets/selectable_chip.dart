// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SelectableChip extends StatelessWidget {
  const SelectableChip({
    Key? key,
    required this.isSelected,
    required this.onSelectChange,
  }) : super(key: key);
  final bool isSelected;
  final VoidCallback onSelectChange;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
