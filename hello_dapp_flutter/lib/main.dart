// lib/main.dart
import 'package:flutter/material.dart'; 
import 'package:geeks_for_geeks/contract_linking.dart'; 
import 'package:geeks_for_geeks/helloUI.dart'; 
import 'package:provider/provider.dart'; 
import 'contract_sim.dart';
 
void main() { 
  runApp(MyApp()); 
} 
 
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    // Inserting Provider as a parent of HelloUI() 
    return ChangeNotifierProvider<ContractLinking>( 
      create: (_) => ContractLinking(), 
      child: MaterialApp( 
        title: "Hello World", 
        theme: ThemeData(
          brightness: Brightness.dark, 
          primaryColor: Colors.cyan[400], 
          hintColor: Colors.deepOrange[200]), 
        home: HelloUI(), 
      ), 
     ); 
   } 
}

