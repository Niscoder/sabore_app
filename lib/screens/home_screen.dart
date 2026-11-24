import 'package:flutter/material.dart';
import '../data/mock_recipes.dart';
import '../models/recipe_model.dart';
import '../routes.dart';
import '../state/app_state.dart';
import '../widgets/recipe_card.dart';
import '../widgets/status_message.dart';

/// Tela principal: identidade, pesquisa e listagem (RF01, RF02, RF03, RF08).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? _errorMessage;
  String? _searchedTerm;

  /// Provisório: filtra os dados de exemplo localmente.
  /// Na próxima etapa será substituído pela busca na API.
  List<Recipe> get _visibleRecipes {
    final term = _searchedTerm;
    if (term == null) return mockRecipes;
    final lower = term.toLowerCase();
    return mockRecipes
        .where((recipe) => recipe.name.toLowerCase().contains(lower))
        .toList();
  }

  void _executeSearch() {
    final sanitizedText = _searchController.text.trim();
    FocusScope.of(context).unfocus();

    if (sanitizedText.isEmpty) {
      setState(() {
        _errorMessage =
        'Digite o nome de uma receita. Espaços em branco não são aceitos.';
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
    final appState = AppStateScope.of(context);
    final recipes = _visibleRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saborê',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Meus favoritos',
            onPressed: () => AppRoutes.openFavorites(context),
            icon: Badge(
              isLabelVisible: appState.favoritesCount > 0,
              label: Text('${appState.favoritesCount}'),
              child: const Icon(Icons.favorite_border),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _WelcomeBanner(),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _executeSearch(),
              onChanged: (_) {
                // Atualiza a visibilidade do botão limpar e remove o erro
                // assim que a pessoa volta a digitar.
                setState(() => _errorMessage = null);
              },
              decoration: InputDecoration(
                labelText: 'Nome da receita',
                hintText: 'Ex.: pizza, cookies, bolo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                (_searchController.text.isNotEmpty || _searchedTerm != null)
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Limpar pesquisa',
                  onPressed: _clearSearch,
                )
                    : null,
                errorText: _errorMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _executeSearch,
                icon: const Icon(Icons.search),
                label: const Text('Buscar receita'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _searchedTerm != null
                        ? 'Resultados para "$_searchedTerm"'
                        : 'Todas as receitas',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_searchedTerm != null)
                  TextButton.icon(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Ver todas'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (recipes.isEmpty)
              StatusMessage(
                icon: Icons.search_off,
                title: 'Nenhuma receita encontrada',
                message:
                'Não há receitas com "$_searchedTerm". Tente outro nome.',
                actionLabel: 'Ver todas as receitas',
                onAction: _clearSearch,
              )
            else
              ...recipes.map(
                    (recipe) => RecipeCard(
                  recipe: recipe,
                  onTap: () => AppRoutes.openDetail(context, recipe),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Expanded(
                child: Text(
                  'Descubra novas receitas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Pesquise pratos, veja os ingredientes e siga o preparo passo a passo.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}