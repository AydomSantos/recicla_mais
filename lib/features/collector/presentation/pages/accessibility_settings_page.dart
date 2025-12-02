import 'package:flutter/material.dart';

/// Uma página que permite ao usuário configurar as opções de acessibilidade do aplicativo.
///
/// Atualmente, permite ajustar o tamanho da fonte, ativar o modo de alto contraste
/// e reduzir animações.
class AccessibilitySettingsPage extends StatefulWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  State<AccessibilitySettingsPage> createState() =>
      _AccessibilitySettingsPageState();
}

/// Gerencia o estado das configurações de acessibilidade.
class _AccessibilitySettingsPageState extends State<AccessibilitySettingsPage> {
  /// O tamanho da fonte preferido pelo usuário, em pixels lógicos.
  double _fontSize = 16.0;
  /// Controla se o modo de alto contraste está ativado.
  bool _highContrast = false;
  /// Controla se as animações devem ser reduzidas para minimizar efeitos visuais.
  bool _reduceAnimations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acessibilidade'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Tamanho da Fonte'),
            subtitle: Text('${_fontSize.toInt()}px'),
          ),
          Slider(
            value: _fontSize,
            min: 12.0,
            max: 24.0,
            divisions: 12,
            label: '${_fontSize.toInt()}px',
            onChanged: (value) {
              setState(() => _fontSize = value);
            },
          ),
          SwitchListTile(
            title: const Text('Alto Contraste'),
            subtitle: const Text('Aumentar contraste das cores'),
            value: _highContrast,
            onChanged: (value) {
              setState(() => _highContrast = value);
            },
          ),
          SwitchListTile(
            title: const Text('Reduzir Animações'),
            subtitle: const Text('Minimizar efeitos visuais'),
            value: _reduceAnimations,
            onChanged: (value) {
              setState(() => _reduceAnimations = value);
            },
          ),
        ],
      ),
    );
  }
}
