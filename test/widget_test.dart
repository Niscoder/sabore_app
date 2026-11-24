import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sabore_app/main.dart';
import 'package:sabore_app/state/app_state.dart';

void main() {
  testWidgets('Tela principal abre com título e campo de pesquisa',
          (WidgetTester tester) async {
        await tester.pumpWidget(SaboreApp(appState: AppState()));

        expect(find.text('Saborê'), findsOneWidget);
        expect(find.text('Nome da receita'), findsOneWidget);
      });

  testWidgets('Pesquisa vazia exibe mensagem de erro',
          (WidgetTester tester) async {
        await tester.pumpWidget(SaboreApp(appState: AppState()));

        await tester.enterText(find.byType(TextField), '   ');
        await tester.tap(find.text('Buscar receita'));
        await tester.pump();

        expect(find.textContaining('Espaços em branco'), findsOneWidget);
      });

  testWidgets('Ícone de favoritos abre a tela de favoritos vazia',
          (WidgetTester tester) async {
        await tester.pumpWidget(SaboreApp(appState: AppState()));

        await tester.tap(find.byTooltip('Meus favoritos'));
        await tester.pumpAndSettle();

        expect(find.text('Nenhum favorito ainda'), findsOneWidget);
      });
}