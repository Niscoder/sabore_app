import 'package:flutter/widgets.dart';
import '../models/recipe_model.dart';

/// Fonte única de verdade para os favoritos da sessão (RF05).
class AppState extends ChangeNotifier {
  final List<Recipe> _favorites = [];

  List<Recipe> get favorites => List.unmodifiable(_favorites);

  int get favoritesCount => _favorites.length;

  bool isFavorite(Recipe recipe) =>
      _favorites.any((item) => item.id == recipe.id);

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)) {
      _favorites.removeWhere((item) => item.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
  }
}

/// Disponibiliza o [AppState] para toda a árvore de widgets e reconstrói
/// automaticamente quem o consulta sempre que os favoritos mudam.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope não encontrado na árvore de widgets.');
    return scope!.notifier!;
  }
}