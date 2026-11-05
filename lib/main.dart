import 'package:flutter/material.dart';

void main() {
  runApp(const SaboreApp());
}

class SaboreApp extends StatelessWidget {
  const SaboreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saborê',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String? _errorMessage;
  String? _searchedTerm;

  void _executeSearch() {
    final rawText = _searchController.text;
    final sanitizedText = rawText.trim();

    if (sanitizedText.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, digite o nome de uma receita. Espaços em branco não são aceitos.';
        _searchedTerm = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _searchedTerm = sanitizedText;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _errorMessage = null;
      _searchedTerm = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saborê',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Identidade do App
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepOrange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: Colors.deepOrange, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Busca de Receitas Saborê',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Campo de Pesquisa Rotulado
              TextField(
                controller: _searchController,
                onSubmitted: (_) => _executeSearch(),
                decoration: InputDecoration(
                  labelText: 'Nome da Receita',
                  hintText: 'Ex: Pizza, Bolo de Cenoura...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty || _searchedTerm != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                          tooltip: 'Limpar consulta',
                        ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _executeSearch,
                        tooltip: 'Pesquisar',
                      ),
                    ],
                  ),
                  errorText: _errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botão explícito de pesquisa adicional
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _executeSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar Receita'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Feedback do Termo Válido Recebido
              if (_searchedTerm != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Resultado para: "$_searchedTerm"',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Listagem de Resultados Provisórios
              Text(
                _searchedTerm != null
                    ? 'Resultados Encontrados (Provisório)'
                    : 'Todas as Receitas',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_pizza, color: Colors.deepOrange),
                  title: const Text('Pizza Margherita'),
                  subtitle: const Text('Massa tradicional com queijo e manjericão'),
                  onTap: () {},
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.bakery_dining, color: Colors.deepOrange),
                  title: const Text('Bolo de Chocolate'),
                  subtitle: const Text('Bolo fofinho com cobertura de brigadeiro'),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}