import 'package:flutter/material.dart';
import 'package:hems_app/screens/dashboard/devices_screen.dart';
import 'package:hems_app/screens/dashboard/energy_logs_screen.dart';
import 'package:hems_app/screens/setup/set_budget_screen.dart';
import 'package:hems_app/services/auth_service.dart';
import 'package:hems_app/widgets/energy_chart.dart';
import 'package:hems_app/models/energy_data.dart';
import 'package:hems_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    const systemId = 'your-system-id'; // Replace with actual system ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Energy Summary Cards
            const EnergySummaryCards(),

            // Budget Status
            StreamBuilder<Map<String, dynamic>>(
              stream: firestoreService.getBudget(systemId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return BudgetStatusCard(budgetData: snapshot.data!);
                }
                return const CircularProgressIndicator();
              },
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DevicesScreen(),
                        ),
                      );
                    },
                    child: const Text('Manage Devices'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetBudgetScreen(),
                        ),
                      );
                    },
                    child: const Text('Set Budget'),
                  ),
                ],
              ),
            ),

            // Energy Chart
            StreamBuilder<List<EnergyData>>(
              stream: firestoreService.getEnergyLogs(systemId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return EnergyChart(data: snapshot.data!);
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EnergyLogsScreen(),
            ),
          );
        },
        child: const Icon(Icons.history),
      ),
    );
  }
}

class EnergySummaryCards extends StatelessWidget {
  const EnergySummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: EnergyCard(title: 'Voltage', value: '230', unit: 'V')),
        Expanded(child: EnergyCard(title: 'Current', value: '5.2', unit: 'A')),
        Expanded(child: EnergyCard(title: 'Power', value: '1200', unit: 'W')),
        Expanded(child: EnergyCard(title: 'Energy', value: '2.5', unit: 'kWh')),
      ],
    );
  }
}

class EnergyCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const EnergyCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(unit, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class BudgetStatusCard extends StatelessWidget {
  final Map<String, dynamic> budgetData;

  const BudgetStatusCard({super.key, required this.budgetData});

  @override
  Widget build(BuildContext context) {
    final used = budgetData['today_usage'] ?? 0.0;
    final budget = budgetData['daily_budget'] ?? 1.0;
    final percentage = (used / budget) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Power Budget Status',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: percentage > 100 ? Colors.red : Colors.green,
              minHeight: 20,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Used: ${used.toStringAsFixed(2)} kWh'),
                Text('Budget: ${budget.toStringAsFixed(2)} kWh'),
              ],
            ),
            if (percentage > 100)
              const Text('Budget exceeded!',
                  style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
