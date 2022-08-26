import 'package:contactapp/homepage.dart';
import 'package:contactapp/model/contact_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'cardviewer.dart';
import 'create_account_view.dart';
import 'firebase_options.dart';
import 'providers/loginView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Contact App',
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          ContactInfo? contact =
              state.extra != null ? state.extra as ContactInfo : null;
          return Scaffold(body: LoginView(contactToEdit: contact));
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          ContactInfo? contact =
              state.extra != null ? state.extra as ContactInfo : null;
          return Scaffold(body: LandingPage(contact: contact));
        },
      ),
      GoRoute(
        path: '/card/:cardId',
        builder: (BuildContext context, GoRouterState state) {
          var cardId = state.params['cardId']!;
          return Scaffold(body: CardView(cardId: cardId));
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return Scaffold(body: CreateAccount());
        },
      ),
    ],
  );
}
