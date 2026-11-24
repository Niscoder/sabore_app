import 'package:flutter/material.dart';
import 'routes.dart';
import 'state/app_state.dart';

void main() {
  runApp(SaboreApp(appState: AppState()));
}

class SaboreApp extends StatelessWidget {
  final AppState appState;

  const SaboreApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: appState,
      child: MaterialApp(
        title: 'Saborê',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            primary: Colors.deepOrange,
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}