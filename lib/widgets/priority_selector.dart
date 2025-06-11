import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final int currentPriority;
  final ValueChanged<int> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.currentPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority Level'),
        const SizedBox(height: 8),
        ToggleButtons(
          isSelected: [
            currentPriority == 1,
            currentPriority == 2,
            currentPriority == 3,
          ],
          onPressed: (index) {
            onPriorityChanged(index + 1);
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('High (1)'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Medium (2)'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Low (3)'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'High: Critical devices (never turned off automatically)\n'
          'Medium: Normal priority\n'
          'Low: First to be turned off when budget exceeded',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
