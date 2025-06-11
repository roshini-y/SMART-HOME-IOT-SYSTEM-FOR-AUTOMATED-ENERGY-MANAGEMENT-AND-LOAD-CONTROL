import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hems_app/services/auth_service.dart';
import 'package:hems_app/services/firestore_service.dart';
import 'package:hems_app/utils/helpers.dart';

class SystemSetupScreen extends StatefulWidget {
  const SystemSetupScreen({Key? key}) : super(key: key);

  @override
  State<SystemSetupScreen> createState() => _SystemSetupScreenState();
}

class _SystemSetupScreenState extends State<SystemSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  bool _isLoading = false;
  bool _useDirectConnection = false;

  bool _isValidIP(String ip) {
    return RegExp(
            r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')
        .hasMatch(ip);
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      final user = authService.getCurrentUser();

      if (user != null) {
        await firestoreService.updateUserSystem(
          user.uid,
          _nameController.text,
          _useDirectConnection ? _ipController.text : null,
        );

        if (mounted) {
          Navigator.pop(context);
          Helpers.showSnackBar(context, 'Configuration saved successfully');
        }
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'System Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter system name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Direct Connection (LAN)'),
                value: _useDirectConnection,
                onChanged: (value) {
                  setState(() => _useDirectConnection = value);
                },
              ),
              if (_useDirectConnection) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'Raspberry Pi IP Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_useDirectConnection &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter IP address';
                    }
                    if (_useDirectConnection && !_isValidIP(value!)) {
                      return 'Enter valid IP address';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveConfiguration,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Configuration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
