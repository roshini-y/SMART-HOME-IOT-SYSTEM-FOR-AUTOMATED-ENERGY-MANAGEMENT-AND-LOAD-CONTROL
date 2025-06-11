import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';
import '../models/energy_data.dart';

class ApiService {
  static const String baseUrl = 'http://172.24.113.45';

  static Future<List<Device>> fetchDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      final data = _extractHtmlJson(response.body);
      List<Device> devices =
          (data['devices'] as List)
              .map((item) => Device.fromJson(item))
              .toList();
      return devices;
    } else {
      throw Exception('Failed to load devices');
    }
  }

  static Future<EnergyData> fetchEnergyData() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      final data = _extractHtmlJson(response.body);
      return EnergyData.fromJson(data);
    } else {
      throw Exception('Failed to load energy data');
    }
  }

  static Future<PowerBudget> fetchBudget() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      final data = _extractHtmlJson(response.body);
      return PowerBudget.fromJson(data['budget_status']);
    } else {
      throw Exception('Failed to load budget info');
    }
  }

  static Future<void> controlDevice(String deviceId, bool turnOn) async {
    final action = turnOn ? 'on' : 'off';
    await http.get(Uri.parse('$baseUrl/control/$deviceId/$action'));
  }

  static Future<void> measureDevicePower(String deviceId) async {
    await http.get(Uri.parse('$baseUrl/measure_power/$deviceId'));
  }

  static Future<void> updateBudget(double maxBill) async {
    await http.post(
      Uri.parse('$baseUrl/set_budget'),
      body: {'max_bill': maxBill.toString()},
    );
  }

  static Future<void> addDevice(String deviceName) async {
    await http.post(
      Uri.parse('$baseUrl/add_device'),
      body: {'device_name': deviceName},
    );
  }

  static Map<String, dynamic> _extractHtmlJson(String html) {
    final start = html.indexOf('{');
    final end = html.lastIndexOf('}');
    final jsonStr = html.substring(start, end + 1);
    return json.decode(jsonStr);
  }
}
