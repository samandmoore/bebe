import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'kids/new_kid_screen.dart';
import 'settings/settings_screen.dart';
import 'settings/units_screen.dart';
import 'track/track_screen.dart';

class App extends StatelessWidget {
  App({super.key});

  late final _router = GoRouter(
    initialLocation: TrackScreen.route,
    routes: [
      GoRoute(
        path: TrackScreen.route,
        builder: (_, __) => const TrackScreen(),
      ),
      GoRoute(
        path: NewKidScreen.route,
        builder: (_, __) => const NewKidScreen(),
      ),
      GoRoute(
        path: SettingsScreen.route,
        builder: (_, __) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: UnitsScreen.route.split('/').last,
            builder: (_, __) => const UnitsScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        restorationScopeId: 'app',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
