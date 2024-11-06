import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Presentation/screen/BarrelFileScreen.dart';
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
          builder: (context, state) => ScaffoldLayoutWidget(
            leadingWidget: TextButton(
              onPressed: () {
                context.go('/Health-Insititution');
              },
              child: Icon(Icons.arrow_back),
            ),
            bodyWidget:
                MoreInfoInstitutionScreen(id: state.pathParameters['id']!),
          ),
        ),
        // ! Health Institution Facilities Route
        GoRoute(
          path: '/Health-Insititution/facilities',
          builder: (context, state) {
            final type = state.extra as String? ?? '';
            return ScaffoldLayoutWidget(
              leadingWidget: TextButton(
                onPressed: () {
                  context.go('/Health-Insititution');
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF5B50A0),
                ),
              ),
              titleWidget: const Text(
                'Available Services',
                style: TextStyle(
                  color: Color(0xFF5B50A0),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              bodyWidget: HealthInstitutionFacilities(type: type),
            );
          },
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
          name: 'bid',
          path: ':bid',
          builder: (context, state) => MoreinfoBlogsscreen(
            id: state.pathParameters['bid']!,
          ),
        ),
      ],
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
    // ! Clinics Route
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
              name: 'cid',
              path: ':cid',
              builder: (context, state) => MoreinfoClinicsscreen(
                    id: state.pathParameters['cid']!,
                  )),
        ]),
  ],
);
