import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// importação das Paginas do App Recicla

import 'features/auth/presentation/pages/login_page.dart';

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
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'), // Português do Brasil
        Locale('en', 'US'), // English
      ],
      home: LoginPage(),
    );
  }
}
