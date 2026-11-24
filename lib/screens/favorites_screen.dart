import 'package:flutter/material.dart';
import '../routes.dart';
import '../state/app_state.dart';
import '../widgets/recipe_card.dart';
import '../widgets/status_message.dart';

/// Favoritos da sessão atual (RF05, RF08).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = AppStateScope.of(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus favoritos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: favorites.isEmpty
            ? Center(
          child: StatusMessage(
            icon: Icons.favorite_border,
            title: 'Nenhum favorito ainda',
            message:
            'Toque no coração de uma receita para guardá-la aqui durante esta sessão.',
            actionLabel: 'Explorar receitas',
            onAction: () => Navigator.pop(context),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final recipe = favorites[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () => AppRoutes.openDetail(context, recipe),
            );
          },
        ),
      ),
    );
  }
}