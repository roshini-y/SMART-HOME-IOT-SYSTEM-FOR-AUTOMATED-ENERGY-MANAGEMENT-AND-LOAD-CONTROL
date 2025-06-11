import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hems_app/models/energy_data.dart';
import 'package:intl/intl.dart';

class EnergyChart extends StatelessWidget {
  final List<EnergyData> data;

  const EnergyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<EnergyData, DateTime>(
        id: 'Power',
        data: data,
        domainFn: (EnergyData log, _) => log.timestamp,
        measureFn: (EnergyData log, _) => log.power,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Power Consumption (W)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: charts.TimeSeriesChart(
                series,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                domainAxis: const charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    hour: charts.TimeFormatterSpec(
                      format: 'HH:mm',
                      transitionFormat: 'HH:mm',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM dd').format(data.last.timestamp)),
                Text(DateFormat('MMM dd').format(data.first.timestamp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
