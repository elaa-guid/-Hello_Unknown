// lib/contract_linking.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class ContractLinking extends ChangeNotifier {
  final String rpcUrl = "http://127.0.0.1:7545";
  final String _privateKey = "0x727a7f212b0f6ab1915e83beebe7b2d9776cf0e01a247563de91862d6629517c";

  late Web3Client _client;
  bool isLoading = true;
  String deployedName = "loading...";
  String? contractAddressHex;
  String? _abiCode;
  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;
  Credentials? _credentials;

  ContractLinking() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    try {
      debugPrint('initialSetup: creating Web3Client to $rpcUrl');
      _client = Web3Client(rpcUrl, http.Client());

      await _getAbi();
      debugPrint('initialSetup: ABI loaded, contractAddressHex=$contractAddressHex');

      await _getCredentials();
      debugPrint('initialSetup: credentials loaded');

      await _getDeployedContract();
      debugPrint('initialSetup: deployed contract loaded');
    } catch (e, st) {
      debugPrint('initialSetup error: $e\n$st');
      isLoading = false;
      deployedName = 'Error during setup: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> _getAbi() async {
    final abiString = await rootBundle.loadString("src/artifacts/HelloWorld.json");
    final jsonAbi = jsonDecode(abiString);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    if (jsonAbi['networks'] != null && (jsonAbi['networks'] as Map).isNotEmpty) {
      final networks = jsonAbi['networks'] as Map;
      final firstKey = networks.keys.first;
      final address = networks[firstKey]['address'] as String;
      contractAddressHex = address;
      debugPrint('Contract address found in ABI: $contractAddressHex');
    } else {
      debugPrint('No networks entry found in HelloWorld.json');
    }
  }

  Future<void> _getCredentials() async {
    if (_privateKey.isEmpty || _privateKey.contains('<METS_ICI')) {
      throw Exception('Private key not set in contract_linking.dart');
    }
    final cleaned = _privateKey.startsWith('0x') ? _privateKey.substring(2) : _privateKey;
    _credentials = EthPrivateKey.fromHex(cleaned);
  }

  Future<void> _getDeployedContract() async {
    if (_abiCode == null || contractAddressHex == null) {
      throw Exception('ABI or contract address missing');
    }

    final contractAddr = EthereumAddress.fromHex(contractAddressHex!);
    debugPrint('Constructed EthereumAddress: $contractAddr');

    _contract = DeployedContract(ContractAbi.fromJson(_abiCode!, 'HelloWorld'), contractAddr);
    _yourName = _contract.function('yourName');
    _setName = _contract.function('setName');
    await getName();
  }

  Future<void> getName() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await _client.call(contract: _contract, function: _yourName, params: []);
      deployedName = result.isNotEmpty ? result[0].toString() : 'No name';
      debugPrint('Read name from contract: $deployedName');
    } catch (e) {
      deployedName = 'Error reading name';
      debugPrint('getName error: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();
    try {
      final txHash = await _client.sendTransaction(
        _credentials!,
        Transaction.callContract(contract: _contract, function: _setName, parameters: [nameToSet]),
        fetchChainIdFromNetworkId: true,
      );
      debugPrint('Transaction hash: $txHash');
      await Future.delayed(const Duration(seconds: 2));
      await getName();
    } catch (e) {
      debugPrint('setName error: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  String get rpcUrlPublic => rpcUrl;
  String? get contractAddressHexPublic => contractAddressHex;
}
