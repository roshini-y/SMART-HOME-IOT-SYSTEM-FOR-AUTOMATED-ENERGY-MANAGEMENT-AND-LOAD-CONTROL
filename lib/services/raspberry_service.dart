import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hems_app/models/device.dart';
import 'package:hems_app/models/energy_data.dart';

class RaspberryService {
  final String baseUrl;

  RaspberryService(this.baseUrl);

  Future<List<Device>> getDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/api/devices'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Device.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<void> toggleDevice(String deviceId, String action) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/control/$deviceId/$action'));
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle device');
    }
  }

  Future<EnergyData> measurePower(String deviceId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/measure_power/$deviceId'));
    if (response.statusCode == 200) {
      return EnergyData.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to measure power');
    }
  }

  Future<List<EnergyData>> getEnergyLogs() async {
    final response = await http.get(Uri.parse('$baseUrl/api/energy_logs'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => EnergyData.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load energy logs');
    }
  }
}
