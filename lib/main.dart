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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saborê',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de Boas-vindas / Identidade do App
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepOrange.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant_menu, color: Colors.deepOrange, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Descubra Novas Receitas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Encontre sugestões de pratos, ingredientes detalhados e instruções passo a passo.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Barra de Pesquisa (Estrutura Visual)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar receita por nome...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Título da Seção de Listagem
              const Text(
                'Receitas em Destaque',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Item de Exemplo 1
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_pizza, color: Colors.deepOrange),
                  ),
                  title: const Text(
                    'Pizza Margherita',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Preparo: 30 min | Servimentos: 4'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ),

              // Item de Exemplo 2
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bakery_dining, color: Colors.deepOrange),
                  ),
                  title: const Text(
                    'Bolo de Chocolate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Preparo: 45 min | Servimentos: 8'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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