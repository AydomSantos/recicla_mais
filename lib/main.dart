import 'package:flutter/material.dart';

// importação das Paginas do App Recicla

import 'features/user/presentation/pages/user_home_page.dart';

// função principal responsavel por execulta o app
void main() {
  runApp(const MyApp());
}

// Classe principal do App Recicla
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const UserHomePage());
  }
}
