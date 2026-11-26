import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../routes.dart';
import '../services/api_service.dart';
import '../state/app_state.dart';
import '../widgets/recipe_card.dart';
import '../widgets/status_message.dart';

enum _LoadStatus { loading, success, error }

/// Tela principal: identidade, listagem e pesquisa remota
/// (RF01, RF02, RF03, RF06, RF07, RF08, RF09).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  _LoadStatus _status = _LoadStatus.loading;
  List<Recipe> _recipes = const [];
  List<Recipe>? _allRecipesCache;
  String? _inputError;
  String? _loadError;
  String? _searchedTerm;

  /// Identifica a requisição mais recente. Respostas antigas são
  /// descartadas, evitando estado confuso com consultas concorrentes.
  int _requestId = 0;

  bool get _isLoading => _status == _LoadStatus.loading;

  @override
  void initState() {
    super.initState();
    // Carrega uma única vez, na abertura da tela (RF01),
    // e não a cada reconstrução.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  Future<void> _runRequest(
      Future<List<Recipe>> Function() request, {
        required String? term,
        bool cacheAsAll = false,
      }) async {
    final requestId = ++_requestId;

    setState(() {
      _status = _LoadStatus.loading;
      _loadError = null;
      _inputError = null;
      _searchedTerm = term;
    });

    try {
      final result = await request();
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _recipes = result;
        if (cacheAsAll) _allRecipesCache = result;
        _status = _LoadStatus.success;
      });
    } on ApiException catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _loadError = error.message;
        _status = _LoadStatus.error;
      });
    }
  }

  Future<void> _loadAll({bool forceRefresh = false}) async {
    final cache = _allRecipesCache;
    if (!forceRefresh && cache != null) {
      _requestId++; // cancela qualquer resposta pendente
      setState(() {
        _recipes = cache;
        _searchedTerm = null;
        _loadError = null;
        _status = _LoadStatus.success;
      });
      return;
    }
    await _runRequest(_api.fetchRecipes, term: null, cacheAsAll: true);
  }

  void _executeSearch() {
    if (_isLoading) return; // bloqueia cliques repetidos (RF06)

    final term = _searchController.text.trim();
    FocusScope.of(context).unfocus();

    if (term.isEmpty) {
      setState(() {
        _inputError =
        'Digite o nome de uma receita. Espaços em branco não são aceitos.';
      });
      return;
    }

    _searchController.text = term; // mostra o termo já sem espaços externos
    _runRequest(() => _api.searchRecipes(term), term: term);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _inputError = null);
    _loadAll();
  }

  void _retry() {
    final term = _searchedTerm;
    if (term != null) {
      _runRequest(() => _api.searchRecipes(term), term: term);
    } else {
      _loadAll(forceRefresh: true);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

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
              onChanged: (_) => setState(() => _inputError = null),
              decoration: InputDecoration(
                labelText: 'Nome da receita',
                hintText: 'Ex.: pizza, cookies, chicken...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                (_searchController.text.isNotEmpty || _searchedTerm != null)
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Limpar pesquisa',
                  onPressed: _clearSearch,
                )
                    : null,
                errorText: _inputError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                // Desabilitado durante o carregamento (RF06).
                onPressed: _isLoading ? null : _executeSearch,
                icon: _isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.search),
                label: Text(_isLoading ? 'Carregando...' : 'Buscar receita'),
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
            ..._buildContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    switch (_status) {
      case _LoadStatus.loading:
        return const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando receitas...'),
              ],
            ),
          ),
        ];

      case _LoadStatus.error:
        return [
          StatusMessage(
            icon: Icons.wifi_off,
            title: 'Não foi possível carregar',
            message: _loadError ?? 'Ocorreu um erro inesperado.',
            actionLabel: 'Tentar novamente',
            onAction: _retry,
          ),
        ];

      case _LoadStatus.success:
        if (_recipes.isEmpty) {
          return [
            _searchedTerm != null
                ? StatusMessage(
              icon: Icons.search_off,
              title: 'Nenhuma receita encontrada',
              message:
              'Não há receitas com "$_searchedTerm". Tente outro nome.',
              actionLabel: 'Ver todas as receitas',
              onAction: _clearSearch,
            )
                : StatusMessage(
              icon: Icons.no_food,
              title: 'Nenhuma receita disponível',
              message: 'A API não retornou receitas no momento.',
              actionLabel: 'Recarregar',
              onAction: _retry,
            ),
          ];
        }
        return [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${_recipes.length} receita(s)',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ..._recipes.map(
                (recipe) => RecipeCard(
              recipe: recipe,
              onTap: () => AppRoutes.openDetail(context, recipe),
            ),
          ),
        ];
    }
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