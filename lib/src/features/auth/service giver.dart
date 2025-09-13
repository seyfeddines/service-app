import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceGiverRegisterScreen extends StatefulWidget {
  final VoidCallback onRegistered;
  const ServiceGiverRegisterScreen({Key? key, required this.onRegistered}) : super(key: key);

  @override
  State<ServiceGiverRegisterScreen> createState() => _ServiceGiverRegisterScreenState();
}

class _ServiceGiverRegisterScreenState extends State<ServiceGiverRegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final skill = _skillController.text.trim();
    final experience = _experienceController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || skill.isEmpty) {
      setState(() {
        _error = "Please fill all required fields";
        _loading = false;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('giver_name', name);
    await prefs.setString('giver_email', email);
    await prefs.setString('giver_password', password);
    await prefs.setString('giver_skill', skill);
    await prefs.setString('giver_experience', experience);
    await prefs.setString('giver_location', location);
    await prefs.setBool('is_service_giver', true);

    widget.onRegistered();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(Icons.build_rounded, size: 60, color: theme.primaryColor),
              const SizedBox(height: 12),
              Text(
                "Register as Service Giver",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Input fields
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _skillController,
                decoration: const InputDecoration(labelText: "Main Skill", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: "Experience (years)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location", border: OutlineInputBorder()),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("REGISTER"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
