/// Modelo de receita alinhado aos campos da API DummyJSON Recipes.
///
/// Campos numéricos opcionais (tempos, porções) são `int?` para que a
/// interface possa indicar ausência em vez de assumir zero.
class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final double? rating;
  final String? difficulty;
  final String? cuisine;
  final List<String> mealType;

  const Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.rating,
    this.difficulty,
    this.cuisine,
    this.mealType = const [],
  });

  /// Soma preparo + cozimento apenas quando os dois valores existem.
  int? get totalTimeMinutes {
    if (prepTimeMinutes == null || cookTimeMinutes == null) return null;
    return prepTimeMinutes! + cookTimeMinutes!;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] is int ? json['id'] as int : 0,
      name: (json['name'] is String && (json['name'] as String).trim().isNotEmpty)
          ? json['name'] as String
          : 'Receita sem nome',
      ingredients: _stringList(json['ingredients']),
      instructions: _stringList(json['instructions']),
      imageUrl: json['image'] is String ? json['image'] as String : '',
      prepTimeMinutes: json['prepTimeMinutes'] is int ? json['prepTimeMinutes'] as int : null,
      cookTimeMinutes: json['cookTimeMinutes'] is int ? json['cookTimeMinutes'] as int : null,
      servings: (json['servings'] is int && (json['servings'] as int) > 0)
          ? json['servings'] as int
          : null,
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
      difficulty: json['difficulty'] is String ? json['difficulty'] as String : null,
      cuisine: json['cuisine'] is String ? json['cuisine'] as String : null,
      mealType: _stringList(json['mealType']),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList();
  }
}