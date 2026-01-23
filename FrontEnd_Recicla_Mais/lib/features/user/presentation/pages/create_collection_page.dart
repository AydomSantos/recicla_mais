import 'package:flutter/material.dart';
import 'package:recicla_mais/features/user/data/repositories/collection_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List;

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({super.key});

  @override
  State<CreateCollectionPage> createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cepController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeFromController = TextEditingController();
  final _timeToController = TextEditingController();

  // Image picker
  XFile? _selectedXFile;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  String? _generatedCode;

  @override
  void initState() {
    super.initState();
    // Gerar código único ao iniciar a página
    _generatedCode = DateTime.now().millisecondsSinceEpoch.toString().substring(
      7,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _cepController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _descriptionController.dispose();
    _timeFromController.dispose();
    _timeToController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedXFile = image;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  Future<void> _createCollection() async {
    if (_formKey.currentState!.validate()) {
      try {
        final collectionData = {
          'collectionCode': _generatedCode,
          'tempoColeta':
              '${_timeFromController.text} - ${_timeToController.text}',
          'distanciaKm': '0 km',
          'nomeSolicitante': _nameController.text,
          'endereco': '${_addressController.text}, ${_numberController.text}',
          'referencia': _neighborhoodController.text,
          'tipoMaterial': 'Resíduo',
          'pesoEstimado': 'N/A',
          'detalhesAdicionais': _descriptionController.text,
          'observacoes': _descriptionController.text,
          'bairro': _neighborhoodController.text,
          'status': 'pending', // Aguardando aprovação do admin
          'imageUrl': null, // TODO: Upload de imagem para servidor
        };

        await UserCollectionRepository.createCollection(collectionData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Solicitação criada! Aguardando aprovação do administrador.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao criar solicitação: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3493F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Solicitação de coleta',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Collection Code Header
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: 'Código de coleta: '),
                      TextSpan(
                        text: _generatedCode ?? '00000',
                        style: const TextStyle(color: Color(0xFF00C2FF)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Name
              _buildLabel('Nome:'),
              _buildTextField(
                controller: _nameController,
                hintText: 'Digite seu nome',
              ),
              SizedBox(height: screenHeight * 0.02),

              // Address and Number
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Endereço:'),
                        _buildTextField(
                          controller: _addressController,
                          hintText: 'Ex: Rua Marinete Francisca',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Nº:'),
                        _buildTextField(controller: _numberController),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Neighborhood and CEP
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Bairro:'),
                        _buildTextField(controller: _neighborhoodController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Cep:'),
                        _buildTextField(controller: _cepController),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // City and State
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Cidade:'),
                        _buildTextField(controller: _cityController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Estado:'),
                        _buildTextField(controller: _stateController),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Description
              _buildLabel('Descrição:'),
              _buildTextField(
                controller: _descriptionController,
                hintText: 'Opcional*',
              ),
              SizedBox(height: screenHeight * 0.02),

              // Time
              _buildLabel('Horário:'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _timeFromController,
                      hintText: 'De:',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _timeToController,
                      hintText: 'ás:',
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),

              // Add Photo Button
              const Text(
                'Adicione uma foto do resíduo a ser coletado:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: screenHeight * 0.015),
              OutlinedButton(
                onPressed: _pickImage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00C2FF), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                ),
                child: Text(
                  _selectedXFile != null
                      ? 'Foto selecionada ✓'
                      : 'Adicionar foto do material',
                  style: const TextStyle(
                    color: Color(0xFF00C2FF),
                    fontSize: 16,
                  ),
                ),
              ),
              if (_imageBytes != null)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _imageBytes!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedXFile = null;
                            _imageBytes = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: screenHeight * 0.03),

              // Create Request Button
              ElevatedButton(
                onPressed: _createCollection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3493F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                ),
                child: const Text(
                  'Criar solicitação',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF3493F2)),
        ),
        filled: true,
        fillColor: Colors.grey[50], // Very light grey background
      ),
    );
  }
}
