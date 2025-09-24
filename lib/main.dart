import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'common/theme_provider.dart';
import 'common/router.dart';
import 'core/supabase_client.dart';
import 'features/animation/explicit/views/explicit_animation_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cache Manager 초기화 (cached_network_image를 위해 필요)
  try {
    await DefaultCacheManager().emptyCache();
    print('✅ [Main] Cache Manager 초기화 완료');
  } catch (e) {
    print('⚠️ [Main] Cache Manager 초기화 실패: $e');
  }

  // Supabase 초기화
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoSlabTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoSlabTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      routerConfig: router,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExplicitAnimationView();
  }
}
