import 'package:flutter_test/flutter_test.dart';
import 'package:sabore_app/models/recipe_model.dart';

void main() {
  test('Converte JSON completo da API', () {
    final recipe = Recipe.fromJson({
      'id': 1,
      'name': 'Classic Margherita Pizza',
      'ingredients': ['Pizza dough', 'Tomato sauce'],
      'instructions': ['Preheat the oven', 'Bake'],
      'image': 'https://cdn.dummyjson.com/recipe-images/1.webp',
      'prepTimeMinutes': 20,
      'cookTimeMinutes': 15,
      'servings': 4,
      'rating': 5, // int: deve virar double
      'mealType': ['Dinner'],
    });

    expect(recipe.rating, 5.0);
    expect(recipe.totalTimeMinutes, 35);
    expect(recipe.mealType, ['Dinner']);
  });

  test('Campos ausentes não viram zero', () {
    final recipe = Recipe.fromJson({'id': 2});

    expect(recipe.name, 'Receita sem nome');
    expect(recipe.ingredients, isEmpty);
    expect(recipe.cookTimeMinutes, isNull);
    expect(recipe.totalTimeMinutes, isNull);
    expect(recipe.servings, isNull);
  });

  test('Tipos inesperados são ignorados com segurança', () {
    final recipe = Recipe.fromJson({
      'id': 3,
      'name': 'Teste',
      'mealType': 'Dinner', // String em vez de lista
      'servings': 0, // não utilizável
      'rating': '4.5', // texto em vez de número
    });

    expect(recipe.mealType, isEmpty);
    expect(recipe.servings, isNull);
    expect(recipe.rating, isNull);
  });
}