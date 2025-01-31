import 'package:chat_bot/screens/bienvenida_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Definir las rutas para la navegación
      routes: {
          '/': (context) => ChatScreen(),
      },
      initialRoute: '/', // Ruta inicial
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla Principal')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar a la pantalla de bienvenida
            Navigator.pushNamed(context, '/Bienvenida');
          },
          child: const Text('Ir a Bienvenida'),
        ),
      ),
    );
  }
}