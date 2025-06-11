import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/energy_data.dart';
import '../widgets/budget_bar.dart';

class SetBillTile extends StatefulWidget {
  final PowerBudget budget;
  final VoidCallback onRefresh;

  const SetBillTile({required this.budget, required this.onRefresh, super.key});

  @override
  State<SetBillTile> createState() => _SetBillTileState();
}

class _SetBillTileState extends State<SetBillTile> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _updateBudget() async {
    final bill = double.tryParse(_controller.text);
    if (bill == null) return;

    const rate = 1.45;
    final maxUnits = bill / rate;
    final dailyBudget = maxUnits / 30;

    await FirebaseFirestore.instance
        .collection('SystemSettings')
        .doc('power_budget')
        .set({
          'max_bill': bill,
          'rate': rate,
          'daily_budget': dailyBudget,
          'today_usage': 0,
          'current_month_usage': 0,
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    _controller.clear();
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "⚡ Power Budget",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            BudgetBar(
              used: widget.budget.used,
              total: widget.budget.budget,
              percent: widget.budget.percentage,
            ),
            const SizedBox(height: 16),
            const Text(
              "💰 Update Max Monthly Bill (₹)",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "e.g., 500",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _updateBudget,
                  icon: const Icon(Icons.update),
                  label: const Text("Update"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
