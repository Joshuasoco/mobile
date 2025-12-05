import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/splash/splash_view.dart';
import 'presentation/splash/splash_viewmodel.dart';
import 'presentation/onboarding/onboarding_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashView(),
          '/onboarding': (_) => const OnboardingView(),
          '/home': (_) => const HomeView(),
        },
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("MSME Pathways Home")),
    );
  }
}
