import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:luna/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';  

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => IconColorProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true).copyWith(
        textTheme: ThemeData.light(useMaterial3: true).textTheme.apply(
          fontFamily: 'Nunito',
        ),
      ),
      dark: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: ThemeData.dark(useMaterial3: true).textTheme.apply(
          fontFamily: 'Nunito'
        ),
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: Navbar(),
          supportedLocales: const [
            Locale('en', ''), // Inglés
            Locale('es', ''), // Español
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('es', ''), 
        );
      }
    );
  }
}
