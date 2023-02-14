import 'package:flutter/material.dart';

import '../models/models.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'Login';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'login',
        name: 'Login Screen',
        screen: const LoginScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'register',
        name: 'Register Screen',
        screen: const RegisterScreen(),
        icon: Icons.account_balance_outlined),
    MenuOption(
        route: 'load',
        name: 'Loading Screen',
        screen: const LoadingScreen(),
        icon: Icons.account_balance_outlined),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final options in menuOptions) {
      appRoutes
          .addAll({options.route: (BuildContext context) => options.screen});
    }

    return appRoutes;
  }

  //static Map<String, Widget Function(BuildContext)> routes = {
  // 'home': (BuildContext context) => const HomeScreen(),
  //'listview1': (BuildContext context) => const Listview1Screen(),
  //'listview2': (BuildContext context) => const Listview2Screen(),
  //'alert': (BuildContext context) => const AlertScreen(),
  //'card': (BuildContext context) => const CardScreen(),
  // };

  static Route<dynamic> onGenerateRoute(settings) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}