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
      builder: (context, state) => const LoginScreen(),
    ),
    // Registration Screen
    GoRoute(
      path: '/RegisterScreen',
      builder: (context, state) => const Registerscreen(),
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
          bodyWidget: const HomeScreen(),
          actionsWidget: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: _primaryColor),
              onPressed: () {
                // Notification action
                debugPrint('Notification icon pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode_outlined, color: _primaryColor),
              onPressed: () {
                // Dark mode action
                debugPrint('Dark mode icon pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.translate_outlined, color: _primaryColor),
              onPressed: () {
                // Translation action
                debugPrint('Translation icon pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: _primaryColor),
              onPressed: () {
                // Settings action
                debugPrint('Settings icon pressed');
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
              bodyWidget: const JournalScreen(),
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
              bodyWidget: const EventsScreen(),
            );
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            final userId = state.pathParameters['userID']!;
            return ProfileScreen(userid: userId);
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
          bodyWidget: HealthInstitutionScreen(userid: userId),
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
          bodyWidget: const BlogsScreen(),
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
          bodyWidget: const FinancialSupportScreen(),
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
              FinancialDetails(id: state.pathParameters['fid']!),
        ),
      ],
    ),
    // Doctors Screen
    GoRoute(
      path: '/Oncologist',
      builder: (context, state) {
        final userId = state.pathParameters['userID'] ?? 'default';
        return ScaffoldLayoutWidget(
          userid: userId,
          bodyWidget: const OncologistsScreens(),
          leadingWidget: BackButton(
            color: _primaryColor,
            onPressed: () => GoRouter.of(context).go('/HomeScreen/$userId'),
          ),
        );
      },
    ),
  ],
);
