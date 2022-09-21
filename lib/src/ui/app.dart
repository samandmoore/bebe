import 'package:bebe/src/data/auth/auth_repository.dart';
import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/auth/auth_screen.dart';
import 'package:bebe/src/ui/diapers/diaper_event_screen.dart';
import 'package:bebe/src/ui/diapers/providers.dart';
import 'package:bebe/src/ui/history/history_screen.dart';
import 'package:bebe/src/ui/kids/edit_kid_screen.dart';
import 'package:bebe/src/ui/kids/new_kid_screen.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/settings/kids_screen.dart';
import 'package:bebe/src/ui/settings/settings_screen.dart';
import 'package:bebe/src/ui/settings/units_screen.dart';
import 'package:bebe/src/ui/shared/forms/validators.dart';
import 'package:bebe/src/ui/track/track_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;

  App({super.key, required this.authRepository});

  late final _router = GoRouter(
    routes: [
      GoRoute(path: '/', redirect: (_) => TrackScreen.route),
      GoRoute(
        path: AuthScreen.route,
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: TrackScreen.route,
        builder: (_, __) => const TrackScreen(),
      ),
      GoRoute(
        path: DiaperEventScreen.route,
        builder: (_, state) => ProviderScope(
          overrides: [
            editingDiaperEventProvider
                .overrideWithValue(state.extra as DiaperEvent?)
          ],
          child: const DiaperEventScreen(),
        ),
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
    redirect: (state) {
      // if the user is not logged in, they need to login
      final bool loggedIn = authRepository.isLoggedIn;
      final bool loggingIn = state.subloc == AuthScreen.route;
      if (!loggedIn) {
        return loggingIn ? null : AuthScreen.route;
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        return '/';
      }

      // no need to redirect at all
      return null;
    },
    refreshListenable: authRepository,
  );

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.required: (_) => 'required',
        FormValidationMessage.dateLessThanNow: (_) =>
            FormValidationMessageDefaults.dateLessThanNow,
      },
      child: Portal(
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
      ),
    );
  }
}
