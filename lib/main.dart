import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/theme.dart';
import 'screens/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Connects to your exact Supabase project
  await Supabase.initialize(
    url: 'https://ixwohlmkbzbnxplrdajk.supabase.co',
    anonKey: 'sb_publishable_4tlLpCUsecwT3yy3Z6kmeg_uuomRVZp',
  );

  runApp(const LumixApp());
}

class LumixApp extends StatelessWidget {
  const LumixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: LumixColors.bg900,
        colorScheme: ColorScheme.fromSeed(seedColor: LumixColors.student, brightness: Brightness.dark),
        cardColor: LumixColors.bg800,
        fontFamily: 'sans-serif',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: LumixColors.bg800,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: LumixColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: LumixColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: LumixColors.student, width: 1.5)),
          labelStyle: LumixText.caption,
          hintStyle: LumixText.caption,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: LumixColors.student,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            elevation: 0,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: LumixColors.bg800,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: LumixColors.textPrimary),
          iconTheme: IconThemeData(color: LumixColors.textPrimary),
        ),
      ),
      home: const AuthGate(),
    );
  }
}