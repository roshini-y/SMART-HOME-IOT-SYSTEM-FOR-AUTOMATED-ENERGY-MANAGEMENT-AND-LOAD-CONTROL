import 'package:flutter/material.dart';
import 'package:hems_app/models/energy_data.dart';
import 'package:hems_app/services/firestore_service.dart';
import 'package:hems_app/widgets/energy_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnergyLogsScreen extends StatelessWidget {
  const EnergyLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    const systemId = 'your-system-id'; // Replace with actual system ID

    return Scaffold(
      appBar: AppBar(title: const Text('Energy Logs')),
      body: StreamBuilder<List<EnergyData>>(
        stream: firestoreService.getEnergyLogs(systemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No energy logs available'));
          }

          final logs = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: EnergyChart(data: logs),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return ListTile(
                      title: Text(log.deviceName ?? 'System'),
                      subtitle: Text(
                        '${log.power.toStringAsFixed(2)}W - ${DateFormat('MMM dd, HH:mm').format(log.timestamp)}',
                      ),
                      trailing: Text('${log.energy.toStringAsFixed(3)} kWh'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
