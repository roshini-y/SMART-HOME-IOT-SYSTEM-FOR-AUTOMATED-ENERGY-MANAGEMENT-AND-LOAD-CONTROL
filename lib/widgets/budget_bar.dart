import 'package:flutter/material.dart';

class BudgetBar extends StatelessWidget {
  final double used;
  final double total;
  final double percent;

  const BudgetBar({
    required this.used,
    required this.total,
    required this.percent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Power Budget", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent / 100,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(percent >= 100 ? Colors.red : Colors.green),
          minHeight: 12,
        ),
        const SizedBox(height: 6),
        Text("Used: \${used.toStringAsFixed(3)} kWh / \${total.toStringAsFixed(3)} kWh"),
      ],
    );
  }
}