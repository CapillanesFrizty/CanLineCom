import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screen/BarrelFileScreen.dart';
import '../Layouts/BarrelFileLayouts.dart';
// import '../widgets/BarrelFileWidget..dart';

final GoRouter linkrouter = GoRouter(
  routes: [
    //! Home Route  
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
      routes: [
        // ! More Info Intended for Blogs Route
        GoRoute(
          path: 'More-Info-Blogs',
          builder: (context, state) => MoreinfoBlogsscreen(),
        ),
      ],
    ),
    // ! Clinics Route
    GoRoute(
      path: '/Clinics',
      builder: (context, state) => ScaffoldLayoutWidget(
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
        bodyWidget: Clinicsscreen(),
      ),
    ),
    // ! Financial Support Route
    GoRoute(
      path: '/Financial-Support',
      builder: (context, state) => ScaffoldLayoutWidget(
        bodyWidget: FinancialSupportScreen(),
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
    ),
      GoRoute(
        path: '/clinic',
        builder: (context, state) =>   ScaffoldLayoutWidget(
        bodyWidget: ClinicScreen(),
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
        routes: [
          GoRoute(
              path: './clinicInfo',
              builder: (context, state) => MoreinfoClinicsscreen()),
        ]),
  ],
);
