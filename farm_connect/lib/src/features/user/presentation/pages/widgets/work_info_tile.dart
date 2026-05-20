import 'package:flutter/material.dart';

class WorkerInfoTile extends StatelessWidget {
  final String value;

  const WorkerInfoTile({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132238),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}