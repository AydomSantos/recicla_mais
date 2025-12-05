import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // Mantive o nome da sua classe State, mas o nome ideal seria _RegisterPageState
  State<RegisterPage> createState() => _CadastroScreenState(); 
}

// Sua classe State com o novo código de layout
class _CadastroScreenState extends State<RegisterPage> {
  // Variáveis para os estados dos campos
  String? _selectedGender;
  bool _agreedToTerms = false;
  final List<String> _genders = ['Masculino', 'Feminino', 'Não Binário', 'Prefiro não informar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remove a sombra e a cor de fundo para ficar mais clean, como na imagem
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // O título original não é mais necessário, mas você pode adicioná-lo
        // se preferir.
        // title: const Text('Cadastro de Usuário'), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Título
            const Text(
              'Criar Conta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre-se para começar a usar o app',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Campos do Formulário
            _buildTextField(label: 'Nome completo', hintText: 'Seu Nome Completo'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email', hintText: 'Digite o seu Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),

            // Data de Nascimento
            _buildDateField(label: 'Data de nascimento', hintText: 'dd/mm/aaaa'),
            const SizedBox(height: 16),

            // Gênero (Dropdown)
            _buildDropdownField(label: 'Gênero'),
            const SizedBox(height: 16),

            // Cidade - Estado
            _buildTextField(label: 'Cidade - Estado', hintText: 'Cidade - UF'),
            const SizedBox(height: 16),

            // Endereço
            _buildTextField(label: 'Endereço, Nº', hintText: 'Rua, Número, Complemento'),
            const SizedBox(height: 16),

            // Senha
            _buildTextField(label: 'Senha', hintText: 'Crie uma senha', obscureText: true),
            const SizedBox(height: 16),
            _buildTextField(label: 'Confirmar senha', hintText: 'Digite a senha novamente', obscureText: true),
            const SizedBox(height: 24),

            // Botão Adicionar uma foto
            OutlinedButton(
              onPressed: () {
                // Lógica para adicionar foto
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                side: const BorderSide(color: Colors.grey, width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Adicionar uma foto', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),

            // Checkbox e Termos de Uso
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: Checkbox(
                    value: _agreedToTerms,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _agreedToTerms = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreedToTerms = !_agreedToTerms;
                      });
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Concordo com os ',
                        style: TextStyle(fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Termos de Uso',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' e '),
                          TextSpan(
                            text: 'Política de Privacidade',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ', estou ciente de que meus dados serão utilizados conforme a legislação aplicável.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botão Criar Conta
            ElevatedButton(
              onPressed: _agreedToTerms ? () {
                // Lógica para criar conta
                print('Conta Criada!');
              } : null, // Desabilita o botão se não concordar com os termos
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFF3493F2),
                minimumSize: const Size.fromHeight(50),
               
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Criar Conta', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 24),

            // Link Já tem uma conta?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já tem uma conta?', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),

            // Botão Entrar
            OutlinedButton(
              onPressed: () {
                // Volta para a tela de login anterior
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Color(0xFF3493F2), width: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              // O texto deve ser 'Entrar', não 'Criar Conta'
              child: const Text('Entrar', style: TextStyle(fontSize: 18, color: Color(0xFF3493F2))), 
            ),
          ],
        ),
      ),
    );
  }

  // --- Funções Auxiliares (Métodos) para Construção dos Widgets ---

  Widget _buildTextField({required String label, required String hintText, TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({required String label, required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: true, // Para simular que abre um seletor de data
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                // Lógica para mostrar o DatePicker
                print('Abrir DatePicker');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          // A decoração aqui herda o estilo global do MaterialApp
          decoration: const InputDecoration(
            hintText: 'Selecione',
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: _genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ],
    );
  }
}