import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screen/BarrelFileScreen.dart';
import '../Layouts/BarrelFileLayouts.dart';
// import '../widgets/BarrelFileWidget..dart';

final GoRouter linkrouter = GoRouter(
  routes: [
    //! Intro Login Route
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => IntroLogin(),
    // ),
    // //! Login Route
    // GoRoute(
    //   path: '/Login-Screen',
    //   builder: (context, state) => LoginScreen(),
    // ),
    //! Home Route
    GoRoute(
      path: '/',
      builder: (context, state) => ScaffoldLayoutWidget(
        bodyWidget: HomeScreen(),
      ),
    ),

    //? Information Hub Routes
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
          name: 'id',
          path: ':id',
          builder: (context, state) =>
              MoreInfoInstitutionScreen(id: state.pathParameters['id']!),
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
        bodyWidget: ClinicScreen(),
      ),
    ),
    // ! Financial Support Route
    GoRoute(
      path: '/Financial-Institution',
      builder: (context, state) => ScaffoldLayoutWidget(
        bodyWidget: FinancialSupportScreen(),
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      routes: [
        // ! More Info Intended for Health Institution Route
        GoRoute(
          name: 'fid',
          path: ':fid',
          builder: (context, state) =>
              Financialdetails(id: state.pathParameters['fid']!),
        ),
      ],
    ),
    GoRoute(
        path: '/clinic',
        builder: (context, state) => ScaffoldLayoutWidget(
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
