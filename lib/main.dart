import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cubits/theme_cubit.dart';
import 'screens/home_page.dart';
import 'screens/form_page.dart';
import 'cubits/form_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null); // ✅ For date picker Spanish labels
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'JustDigital',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,

          // ✅ Light Theme: Green + Beige
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D32), // deep green
              primary: const Color(0xFF2E7D32),
              secondary: const Color(0xFFD7CCC8), // beige-ish
              surface: const Color(0xFFF5F5DC), // light beige
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          // ✅ Dark Theme: clean + fixed dark surface
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.greenAccent,
              surface: const Color(0xFF1E1E1E), // fixed surface
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          // ✅ Localization support for Spanish date picker etc.
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'ES'),
          ],

          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/form') {
              final flowType = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => FormCubit()),
                  ],
                  child: FormPage(flowType: flowType),
                ),
              );
            }
            return MaterialPageRoute(builder: (_) => const HomePage());
          },
        );
      },
    );
  }
}