import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../state/app_state.dart';
import '../widgets/recipe_image.dart';

/// Detalhes da receita: imagem, metadados, ingredientes e preparo (RF04, RF05).
class DetailScreen extends StatelessWidget {
  final Recipe recipe;

  const DetailScreen({super.key, required this.recipe});

  String _minutes(int? value) => value != null ? '$value min' : '—';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isFavorite = appState.isFavorite(recipe);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            actions: [
              IconButton(
                tooltip: isFavorite
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                onPressed: () => appState.toggleFavorite(recipe),
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: RecipeImage(url: recipe.imageUrl),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (recipe.mealType.isNotEmpty || recipe.cuisine != null)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (recipe.cuisine != null)
                        Chip(label: Text(recipe.cuisine!)),
                      ...recipe.mealType.map((type) => Chip(label: Text(type))),
                    ],
                  ),
                const SizedBox(height: 16),
                _MetadataPanel(
                  items: [
                    _Meta(Icons.timer_outlined, 'Preparo',
                        _minutes(recipe.prepTimeMinutes)),
                    _Meta(Icons.local_fire_department_outlined, 'Cozimento',
                        _minutes(recipe.cookTimeMinutes)),
                    _Meta(Icons.people_outline, 'Porções',
                        recipe.servings?.toString() ?? '—'),
                    _Meta(Icons.star_outline, 'Nota',
                        recipe.rating?.toStringAsFixed(1) ?? '—'),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  icon: Icons.shopping_basket_outlined,
                  title: 'Ingredientes (${recipe.ingredients.length})',
                ),
                const SizedBox(height: 8),
                if (recipe.ingredients.isEmpty)
                  const Text('Ingredientes não informados.')
                else
                  ...recipe.ingredients.map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle,
                                size: 8, color: Colors.deepOrange),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(item,
                                style: const TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                const _SectionTitle(
                  icon: Icons.format_list_numbered,
                  title: 'Modo de preparo',
                ),
                const SizedBox(height: 8),
                if (recipe.instructions.isEmpty)
                  const Text('Instruções não informadas.')
                else
                  ...List.generate(recipe.instructions.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.deepOrange,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                recipe.instructions[index],
                                style: const TextStyle(
                                    fontSize: 15, height: 1.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta {
  final IconData icon;
  final String label;
  final String value;

  const _Meta(this.icon, this.label, this.value);
}

class _MetadataPanel extends StatelessWidget {
  final List<_Meta> items;

  const _MetadataPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: items
            .map(
              (meta) => Expanded(
            child: Column(
              children: [
                Icon(meta.icon, color: Colors.deepOrange),
                const SizedBox(height: 4),
                Text(
                  meta.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  meta.label,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}