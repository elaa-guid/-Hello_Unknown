// lib/contract_sim.dart
import 'package:flutter/material.dart';

class HelloSimPage extends StatefulWidget {
  const HelloSimPage({super.key});
  @override
  State<HelloSimPage> createState() => _HelloSimPageState();
}

class _HelloSimPageState extends State<HelloSimPage> {
  String deployedName = "Unknown"; 
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> _setNameSim(String name) async {
    setState(() => isLoading = true);
    // Simule le délai d'une transaction
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      deployedName = name;
      isLoading = false;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello DApp')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text('Hello $deployedName',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Entrez votre nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      final name = _controller.text.trim();
                      if (name.isNotEmpty) {
                        _setNameSim(name);
                        _controller.clear();
                      }
                    },
              child: isLoading ? const SizedBox(width:18, height:18, child: CircularProgressIndicator(strokeWidth:2)) : const Text('Définir le nom'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


