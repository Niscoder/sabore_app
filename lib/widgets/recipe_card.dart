import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../state/app_state.dart';
import 'recipe_image.dart';

/// Cartão usado na listagem e nos favoritos.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isFavorite = appState.isFavorite(recipe);
    final total = recipe.totalTimeMinutes;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              RecipeImage(
                url: recipe.imageUrl,
                width: 80,
                height: 80,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _InfoLabel(
                          icon: Icons.schedule,
                          text: total != null ? '$total min' : 'Tempo —',
                        ),
                        if (recipe.rating != null)
                          _InfoLabel(
                            icon: Icons.star,
                            text: recipe.rating!.toStringAsFixed(1),
                          ),
                        if (recipe.cuisine != null)
                          _InfoLabel(icon: Icons.public, text: recipe.cuisine!),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.deepOrange,
                ),
                tooltip: isFavorite
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                onPressed: () => appState.toggleFavorite(recipe),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade700),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
      ],
    );
  }
}