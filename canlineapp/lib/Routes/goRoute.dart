import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screen/BarrelFileScreen.dart';
import '../Layouts/BarrelFileLayouts.dart';
// import '../widgets/BarrelFileWidget..dart';

final GoRouter linkrouter = GoRouter(
  //! Home Route
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ScaffoldLayoutWidget(
        bodyWidget: HomeScreen(),
      ),
    ),
    // ! Health Institution Route
    GoRoute(
      path: '/Health-Insititution',
      builder: (context, state) => ScaffoldLayoutWidget(
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
        bodyWidget: HealthInstitutionScreen(),
      ),
      routes: [
        // ! More Info Intended for Health Institution Route
        GoRoute(
          path: 'More-Info',
          builder: (context, state) => MoreInfoInstitutionScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/Blog',
      builder: (context, state) => ScaffoldLayoutWidget(
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
        bodyWidget: BlogsScreen(),
      ),
    )
  ],
);
