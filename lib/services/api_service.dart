import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe_model.dart';

/// Erro com mensagem já pronta para ser exibida ao usuário (RF07).
class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Acesso à API DummyJSON Recipes.
///
/// Listagem: GET /recipes?limit=0  (todas as receitas)
/// Pesquisa: GET /recipes/search?q=termo
///
/// Detalhes: o objeto retornado pela listagem/pesquisa já contém
/// ingredientes, instruções e metadados, por isso a tela de detalhes
/// reaproveita esse objeto em vez de chamar /recipes/{id}.
class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/recipes';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Recipe>> fetchRecipes() {
    return _getRecipes(Uri.parse('$_baseUrl?limit=0'));
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      throw const ApiException('Digite o nome de uma receita para pesquisar.');
    }
    final uri = Uri.parse('$_baseUrl/search')
        .replace(queryParameters: {'q': cleanQuery});
    return _getRecipes(uri);
  }

  Future<List<Recipe>> _getRecipes(Uri uri) async {
    // 1. Requisição: trata falta de rede e tempo esgotado.
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } on TimeoutException {
      throw const ApiException(
          'O servidor demorou para responder. Verifique sua conexão e tente novamente.');
    } on http.ClientException {
      throw const ApiException(
          'Sem conexão com a internet. Verifique sua rede e tente novamente.');
    } catch (_) {
      throw const ApiException(
          'Não foi possível conectar ao servidor. Tente novamente.');
    }

    // 2. Status HTTP.
    if (response.statusCode != 200) {
      throw ApiException(
          'O servidor respondeu com erro (código ${response.statusCode}). Tente novamente em instantes.');
    }

    // 3. Corpo: JSON válido e no formato esperado.
    final dynamic data;
    try {
      data = json.decode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ApiException('Os dados recebidos estão em um formato inválido.');
    }

    if (data is! Map<String, dynamic> || data['recipes'] is! List) {
      throw const ApiException('Os dados recebidos não têm o formato esperado.');
    }

    return (data['recipes'] as List)
        .whereType<Map<String, dynamic>>()
        .map(Recipe.fromJson)
        .toList();
  }
}