import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Presentation/screen/BarrelFileScreen.dart';
import '../Layouts/BarrelFileLayouts.dart';

final GoRouter linkrouter = GoRouter(
  routes: [
    //! Intro Login Route
    GoRoute(path: '/', builder: (context, state) => IntroLogin(), routes: [
      // //! Login Route
      GoRoute(
        path: 'Login',
        builder: (context, state) => LoginScreen(),
      ),
      // //! Sign Up Route
      GoRoute(path: 'Sign-Up', builder: (context, state) => SignUpScreen()),
    ]),

    //! Home Route
    GoRoute(
      name: 'userID',
      path: '/homescreen/:userID',
      builder: (context, state) => ScaffoldLayoutHomeScreen(
        userid: state.pathParameters['userID'],
        bodyWidget: HomeScreen(),
      ),
      routes: [
        // ! Profile Route
        GoRoute(
          path: '/profile',
          builder: (context, state) => ScaffoldLayoutHomeScreen(
            bodyWidget: ProfileScreen(userid: state.pathParameters['userID']),
          ),
        ),

        // ! Journal Route
        GoRoute(
          path: '/journal',
          builder: (context, state) => ScaffoldLayoutHomeScreen(
            bodyWidget: JournalScreen(),
          ),
        ),
        // ! Events Route
        GoRoute(
          path: '/events',
          builder: (context, state) => EventsScreen(),
        ),
      ],
    ),

    //? Information Hub Routes
    // ! Health Institution Route
    GoRoute(
      path: '/Health-Insititution',
      builder: (context, state) => ScaffoldLayoutWidget(
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/homescreen/:userID');
          },
          child: Icon(Icons.arrow_back),
        ),
        bodyWidget: HealthInstitutionScreen(),
      ),
      routes: [
        // ! More Info Intended for Health Institution Route
        GoRoute(
          name: 'hid',
          path: ':hid',
          builder: (context, state) =>
              MoreInfoInstitutionScreen(id: state.pathParameters['hid']!),
          routes: [
            // ! Health Institution Facilities Route
            GoRoute(
              path: 'facilities',
              builder: (context, state) {
                return ScaffoldLayoutWidget(
                  leadingWidget: TextButton(
                    onPressed: () {
                      context.go(
                          '/Health-Insititution/${state.pathParameters['hid']}');
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF5B50A0),
                    ),
                  ),
                  bodyWidget: HealthInstitutionFacilities(
                      id: state.pathParameters['hid']!),
                );
              },
            ),
            GoRoute(
              path: 'Accredited-Insurance',
              builder: (context, state) {
                return ScaffoldLayoutWidget(
                  leadingWidget: TextButton(
                    onPressed: () {
                      context.go(
                          '/Health-Insititution/${state.pathParameters['hid']}');
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF5B50A0),
                    ),
                  ),
                  bodyWidget: HealthInstitutionAccreditedInsurances(
                      id: state.pathParameters['hid']!),
                );
              },
            ),
            GoRoute(
              path: 'Doctors',
              builder: (context, state) {
                return ScaffoldLayoutWidget(
                  leadingWidget: TextButton(
                    onPressed: () {
                      context.go(
                          '/Health-Insititution/${state.pathParameters['hid']}');
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF5B50A0),
                    ),
                  ),
                  bodyWidget: HealthInstitutionOncologists(
                      id: state.pathParameters['hid']!),
                );
              },
            ),
          ],
        ),
      ],
    ),

    // ! Blogs Route
    GoRoute(
      path: '/Blog',
      builder: (context, state) => ScaffoldLayoutWidget(
        leadingWidget: TextButton(
          onPressed: () {
            context.go('/homescreen/:userID');
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
            context.go('/homescreen/:userID');
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
            context.go('/homescreen/:userID');
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
          ),
        ),
      ],
    ),
  ],
);
