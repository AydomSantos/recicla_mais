import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/pages/collector_home_page.dart';
import 'package:recicla_mais/features/auth/presentation/pages/register_collector_page.dart';

// pagina de login do usuario coletor
class LoginCollectorPage extends StatefulWidget {
  const LoginCollectorPage({super.key});

  @override
  State<LoginCollectorPage> createState() => _LoginCollectorPageState();
}

class _LoginCollectorPageState extends State<LoginCollectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,  
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        
        // Padding lateral para dar espaço
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          // Column organiza os widgets verticalmente
          child: Column(
            // Estica os elementos para preencher a largura
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Espaçamento no topo
              const SizedBox(height: 80.0), 
              
              // --- ♻️ 1. Logo/Imagem ---
              ClipOval(
                child:
                 
                 Image.asset(
                  'assets/imagens/logo.png',
                  height: 350, 
                  width: 350,// Controla a altura da imagem
                  fit: BoxFit.cover,
                ),
              ),
              
              const SizedBox(height: 16.0),
              
              // --- 📧 2. Campo de Email ---
              const Text('Email', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8.0),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Digite seu Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              
              const SizedBox(height: 24.0),
              
              // --- 🔒 3. Campo de Senha ---
              const Text('Senha', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8.0),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Digite a sua senha',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
              
              const SizedBox(height: 8.0),
              
              // Link "Esqueceu a senha?" (alinhado à direita)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Lógica para recuperar a senha
                  },
                  child: const Text(
                    'Esqueceu a senha ?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              
              const SizedBox(height: 16.0),
              
              // --- ➡️ 4. Botão "Entrar" ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega para a nova home page do coletor, que gerencia as abas
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CollectorHomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3493F2), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // O elemento da linha divisória na sua imagem parece ser apenas um Divider solto:
              const SizedBox(height: 24.0),
              const Divider(color: Colors.grey),
              const SizedBox(height: 80.0), // Espaçamento para empurrar o "Criar conta" para baixo
              
              // --- 📝 5. Link "Criar conta" ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Ainda não tem conta?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterCollectorPage()),
                      );
                    },
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              
              // Espaçamento no rodapé
              const SizedBox(height: 20.0),
              
            ],
          ),
        ),
      ),
    );
  }
}