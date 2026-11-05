import 'package:flutter/material.dart';
import 'screens/tela_coleta.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Localizações',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaColeta(),
      debugShowCheckedModeBanner: false,
    );
  }
}