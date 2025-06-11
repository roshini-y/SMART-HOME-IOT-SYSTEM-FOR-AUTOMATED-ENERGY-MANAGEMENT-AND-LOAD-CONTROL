import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/energy_data.dart';
import '../widgets/device_tile.dart';
import '../widgets/energy_card.dart';
import '../widgets/budget_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Device> devices = [];
  PowerBudget? budget;
  final TextEditingController _budgetController = TextEditingController();
  String selectedDeviceName = '';

  final List<String> availableDevices = [
    'Light-5W',
    'Fan-9W',
    'Geyser-12W',
    'AC-90W',
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final deviceSnapshot =
        await FirebaseFirestore.instance.collection('Devices').get();
    final budgetDoc =
        await FirebaseFirestore.instance
            .collection('SystemSettings')
            .doc('power_budget')
            .get();

    setState(() {
      devices =
          deviceSnapshot.docs.map((doc) {
            final data = doc.data();
            return Device(
              id: doc.id,
              name: data['device_name'] ?? '',
              status: data['device_status'] ?? 'OFF',
              watt: (data['device_watt'] ?? 0).toDouble(),
              priority: data['priority'] ?? 2,
            );
          }).toList();

      if (budgetDoc.exists) {
        final b = budgetDoc.data()!;
        budget = PowerBudget(
          used: (b['today_usage'] ?? 0).toDouble(),
          budget: (b['daily_budget'] ?? 1).toDouble(),
          percentage:
              ((b['today_usage'] ?? 0) / (b['daily_budget'] ?? 1)) * 100,
          exceeded: (b['today_usage'] ?? 0) > (b['daily_budget'] ?? 1),
          maxBill: (b['max_bill'] ?? 1000).toDouble(),
          rate: (b['rate'] ?? 1.45).toDouble(),
        );
      }
    });
  }

  Future<void> _updateBudget() async {
    final bill = double.tryParse(_budgetController.text);
    if (bill == null) return;

    // Use your backend calculation logic here if needed
    final rate = 1.45;
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

    _budgetController.clear();
    await _fetchData();
  }

  Future<void> _addDevice() async {
    if (selectedDeviceName.isEmpty) return;

    await FirebaseFirestore.instance.collection('Devices').add({
      'device_name': selectedDeviceName,
      'device_status': 'OFF',
      'device_watt': 0.0,
      'priority': 2,
      'system_id': 'mock-mac-address',
      'created_at': FieldValue.serverTimestamp(),
    });

    selectedDeviceName = '';
    await _fetchData();
  }

  Widget _buildEnergyOverview() {
    // ignore: avoid_types_as_parameter_names
    final totalPower = devices.fold<double>(0, (sum, d) => sum + d.watt);
    final voltage = 230.0;
    final current = totalPower / voltage;
    final energy = (totalPower / 1000.0) * (5 / 60); // for 5-minute average

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        EnergyCard(
          label: "Voltage",
          value: "$voltage V",
          icon: Icons.bolt,
          color: Colors.blue,
        ),
        EnergyCard(
          label: "Current",
          value: "${current.toStringAsFixed(2)} A",
          icon: Icons.electrical_services,
          color: Colors.orange,
        ),
        EnergyCard(
          label: "Power",
          value: "${totalPower.toStringAsFixed(2)} W",
          icon: Icons.flash_on,
          color: Colors.green,
        ),
        EnergyCard(
          label: "Energy",
          value: "${energy.toStringAsFixed(3)} kWh",
          icon: Icons.energy_savings_leaf,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildBudgetSection() {
    if (budget == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BudgetBar(
          used: budget!.used,
          total: budget!.budget,
          percent: budget!.percentage,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Set Max Bill (Rs)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _updateBudget,
              child: const Text("Update"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceList() {
    if (devices.isEmpty) return const Text("No devices found.");

    return Column(
      children:
          devices
              .map(
                (device) => DeviceTile(device: device, onRefresh: _fetchData),
              )
              .toList(),
    );
  }

  Widget _buildAddDevice() {
    return Row(
      children: [
        DropdownButton<String>(
          value: selectedDeviceName.isEmpty ? null : selectedDeviceName,
          hint: const Text("Select Device"),
          onChanged: (val) => setState(() => selectedDeviceName = val ?? ''),
          items:
              availableDevices.map((name) {
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
        ),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _addDevice, child: const Text("Add")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Home Energy Dashboard")),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEnergyOverview(),
              const SizedBox(height: 20),
              _buildBudgetSection(),
              const SizedBox(height: 20),
              const Text(
                "Device Control",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildDeviceList(),
              const SizedBox(height: 20),
              const Divider(),
              _buildAddDevice(),
            ],
          ),
        ),
      ),
    );
  }
}
