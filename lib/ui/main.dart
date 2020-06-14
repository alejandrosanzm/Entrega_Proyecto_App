import 'package:flutter/material.dart';
import 'package:palabras_por_sonrisas/ui/lettersList/lettersList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palabras por Sonrisas',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.redAccent,
      ),
      home: LetterList(),
    );
  }
}
