import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:luna/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/providers/notification_provider.dart';
import 'package:luna/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IconColorProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: Navbar(),
          navigatorKey: navigatorKey,
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
