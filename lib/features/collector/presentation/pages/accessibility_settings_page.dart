import 'package:flutter/material.dart';

class AccessibilitySettingsPage extends StatefulWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  State<AccessibilitySettingsPage> createState() =>
      _AccessibilitySettingsPageState();
}

class _AccessibilitySettingsPageState extends State<AccessibilitySettingsPage> {
  double _fontSize = 16.0;
  bool _highContrast = false;
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
