import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Presentation/screen/BarrelFileScreen.dart';
import '../Layouts/BarrelFileLayouts.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _primaryColor = Color(0xFF5B50A0);
final GoRouter linkrouter = GoRouter(
  routes: [
    // Login Screen
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    // Registration Screen
    GoRoute(
      path: '/RegisterScreen',
      builder: (context, state) => Registerscreen(),
    ),
    // Home Screen with AppBar Icons
    GoRoute(
      name: 'userID',
      path: '/HomeScreen/:userID',
      builder: (context, state) {
        final userId = state.pathParameters['userID']!;

        // Scaffold Layout Widget for Home Screen
        //  with bell Icon, Dark mode Icon, Translation Icon, Settings Icon
        return ScaffoldLayoutWidget(
          userid: userId,
          bodyWidget: HomeScreen(),
          actionsWidget: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: _primaryColor),
              onPressed: () {
                // Notification action
                print('Notification icon pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode_outlined, color: _primaryColor),
              onPressed: () {
                // Dark mode action
                print('Dark mode icon pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.translate_outlined, color: _primaryColor),
              onPressed: () {
                // Translation action
                print('Translation icon pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: _primaryColor),
              onPressed: () {
                // Settings action
                print('Settings icon pressed');
              },
            ),
          ],
          leadingWidget: null, // No back button for Home
        );
      },
      routes: [
        GoRoute(
          path: 'journal',
          builder: (context, state) {
            return ScaffoldLayoutWidget(
              leadingWidget: null,
              bodyWidget: JournalScreen(),
              titleWidget: Text(
                "My Journal",
                style: GoogleFonts.poppins(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                  color: _primaryColor,
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: 'events',
          builder: (context, state) {
            final userId = state.pathParameters['userID']!;
            return ScaffoldLayoutWidget(
              userid: userId,
              bodyWidget: EventsScreen(),
              titleWidget: Text(
                "Events",
                style: GoogleFonts.poppins(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                  color: _primaryColor,
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            final userId = state.pathParameters['userID']!;
            return ScaffoldLayoutWidget(
              userid: userId,
              bodyWidget: ProfileScreen(userid: userId),
              titleWidget: Text(
                "Profile",
                style: GoogleFonts.poppins(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                  color: _primaryColor,
                ),
              ),
            );
          },
        ),
      ],
    ),

    // Health Institution Screens
    GoRoute(
      path: '/Health-Institution',
      builder: (context, state) {
        final userId = state.pathParameters['userID'] ?? 'default';
        return ScaffoldLayoutWidget(
          userid: userId,
          bodyWidget: HealthInstitutionScreen(),
          titleWidget: Text(
            "Health Institution",
            style: GoogleFonts.poppins(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              color: _primaryColor,
            ),
          ),
          leadingWidget: BackButton(
            color: _primaryColor,
            onPressed: () => GoRouter.of(context).go('/HomeScreen/$userId'),
          ),
        );
      },
      routes: [
        GoRoute(
          name: 'hid',
          path: ':hid',
          builder: (context, state) =>
              MoreInfoInstitutionScreen(id: state.pathParameters['hid']!),
          routes: [
            // ! Health Institution Facilities Route
            GoRoute(
              path: 'Facilities',
              builder: (context, state) {
                return ScaffoldLayoutWidget(
                  leadingWidget: TextButton(
                    onPressed: () {
                      context.go(
                          '/Health-Institution/${state.pathParameters['hid']}');
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
              //
            ),
            GoRoute(
              path: 'Accredited-Insurance',
              builder: (context, state) {
                return ScaffoldLayoutWidget(
                  leadingWidget: TextButton(
                    onPressed: () {
                      context.go(
                          '/Health-Institution/${state.pathParameters['hid']}');
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
                          '/Health-Institution/${state.pathParameters['hid']}');
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
        GoRoute(
          name: "id",
          path: '/clinic/:id',
          builder: (context, state) =>
              MoreinfoClinicsscreen(id: state.pathParameters['id']!),
        ),
      ],
    ),

    // Blogs Screen
    GoRoute(
      path: '/Blog',
      builder: (context, state) {
        final userId = state.pathParameters['userID'] ?? 'default';
        return ScaffoldLayoutWidget(
          userid: userId,
          bodyWidget: BlogsScreen(),
          titleWidget: Text(
            "Blogs & News",
            style: GoogleFonts.poppins(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              color: _primaryColor,
            ),
          ),
          leadingWidget: BackButton(
            color: _primaryColor,
            onPressed: () => GoRouter.of(context).go('/HomeScreen/$userId'),
          ),
        );
      },
      routes: [
        GoRoute(
          name: 'blogid',
          path: ':blogid',
          builder: (context, state) =>
              MoreinfoBlogsscreen(id: state.pathParameters['blogid']!),
        )
      ],
    ),
    // Financial Support Screen
    GoRoute(
      path: '/Financial-Institution',
      builder: (context, state) {
        final userId = state.pathParameters['userID'] ?? 'default';
        return ScaffoldLayoutWidget(
          userid: userId,
          bodyWidget: FinancialSupportScreen(),
          titleWidget: Text(
            "Financial Support",
            style: GoogleFonts.poppins(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              color: _primaryColor,
            ),
          ),
          leadingWidget: BackButton(
            color: _primaryColor,
            onPressed: () => GoRouter.of(context).go('/HomeScreen/$userId'),
          ),
        );
      },
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
    // Doctors Screen
    GoRoute(
      path: '/Oncologists',
      builder: (context, state) {
        final userId = state.pathParameters['userID'] ?? 'default';
        return ScaffoldLayoutWidget(
          userid: userId,
          bodyWidget: OncologistsScreens(),
          titleWidget: Text(
            "Oncologists",
            style: GoogleFonts.poppins(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
          leadingWidget: BackButton(
            color: _primaryColor,
            onPressed: () => GoRouter.of(context).go('/HomeScreen/$userId'),
          ),
        );
      },
    ),
  ],
);
