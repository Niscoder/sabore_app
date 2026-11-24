import 'package:flutter/material.dart';
import 'models/recipe_model.dart';
import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';

/// Rotas nomeadas do aplicativo.
///
///   /            → HomeScreen       (listagem + pesquisa)
///   /detalhes    → DetailScreen     (recebe um Recipe como argumento)
///   /favoritos   → FavoritesScreen  (favoritos da sessão)
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detalhes';
  static const String favorites = '/favoritos';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case detail:
        final recipe = settings.arguments;
        if (recipe is Recipe) {
          return MaterialPageRoute(
            builder: (_) => DetailScreen(recipe: recipe),
            settings: settings,
          );
        }
        return _notFound();
      case favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
          settings: settings,
        );
      default:
        return _notFound();
    }
  }

  static Route<dynamic> _notFound() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Saborê')),
        body: const Center(child: Text('Página não encontrada.')),
      ),
    );
  }

  /// Atalhos para manter as chamadas de navegação legíveis nas telas.
  static Future<void> openDetail(BuildContext context, Recipe recipe) =>
      Navigator.pushNamed(context, detail, arguments: recipe);

  static Future<void> openFavorites(BuildContext context) =>
      Navigator.pushNamed(context, favorites);
}