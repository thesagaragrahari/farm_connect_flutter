import 'package:flutter/material.dart';

class SkillChipPicker extends StatelessWidget {
  final List<String> skills;
  final List<String> selectedSkills;
  final ValueChanged<String> onChanged;

  const SkillChipPicker({
    super.key,
    required this.skills,
    required this.selectedSkills,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: skills.map((skill) {
        final selected = selectedSkills.contains(skill);
        return FilterChip(
          label: Text(skill),
          selected: selected,
          onSelected: (_) => onChanged(skill),
        );
      }).toList(),
    );
  }
}
