import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/diapers/new_diaper_event_screen.dart';
import 'package:bebe/src/ui/history/history_screen.dart';
import 'package:bebe/src/ui/kids/edit_kid_screen.dart';
import 'package:bebe/src/ui/kids/new_kid_screen.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/settings/kids_screen.dart';
import 'package:bebe/src/ui/settings/settings_screen.dart';
import 'package:bebe/src/ui/settings/units_screen.dart';
import 'package:bebe/src/ui/track/track_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        path: NewDiaperEventScreen.route,
        builder: (_, __) => const NewDiaperEventScreen(),
      ),
      GoRoute(
        path: NewKidScreen.route,
        builder: (_, __) => const NewKidScreen(),
      ),
      GoRoute(
        path: EditKidScreen.route,
        builder: (_, state) => ProviderScope(
          overrides: [
            editingKidProvider.overrideWithValue(state.extra! as Kid)
          ],
          child: const EditKidScreen(),
        ),
      ),
      GoRoute(
        path: HistoryScreen.route,
        builder: (_, __) => const HistoryScreen(),
      ),
      GoRoute(
        path: SettingsScreen.route,
        builder: (_, __) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: UnitsScreen.route.split('/').last,
            builder: (_, __) => const UnitsScreen(),
          ),
          GoRoute(
            path: KidsScreen.route.split('/').last,
            builder: (_, __) => const KidsScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Portal(
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
