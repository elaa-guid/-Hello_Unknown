import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatefulWidget {
  const HelloUI({super.key});
  @override
  State<HelloUI> createState() => _HelloUIState();
}

class _HelloUIState extends State<HelloUI> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contract = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Hello DApp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: contract.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Contract name: ${contract.deployedName}',
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter name to set',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final name = _controller.text.trim();
                      if (name.isNotEmpty) {
                        await contract.setName(name);
                        _controller.clear();
                      }
                    },
                    child: const Text('Set Name on Contract'),
                  ),
                  const SizedBox(height: 24),
                  Text('RPC status: ${contract.rpcUrl}'),
                  const SizedBox(height: 8),
                  Text('Contract address: ${contract.contractAddressHex ?? "not loaded"}'),
                ],
              ),
      ),
    );
  }
}
