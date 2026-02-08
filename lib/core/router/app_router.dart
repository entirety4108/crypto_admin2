import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../../features/portfolio/presentation/screens/accounts_list_screen.dart';
import '../../features/portfolio/presentation/screens/account_form_screen.dart';
import '../../features/portfolio/presentation/screens/account_detail_screen.dart';
import '../../features/portfolio/domain/account.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/transactions/presentation/screens/deposits_list_screen.dart';
import '../../features/transactions/presentation/screens/deposit_form_screen.dart';
import '../../features/transactions/presentation/screens/sells_list_screen.dart';
import '../../features/transactions/presentation/screens/sell_form_screen.dart';
import '../../features/transactions/domain/purchase.dart';
import '../../features/transactions/domain/sell.dart';
import '../../features/analysis/presentation/screens/analysis_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/widgets/main_shell.dart';

/// Navigation key for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/portfolio',
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.uri.path == '/login' ||
          state.uri.path == '/sign-up' ||
          state.uri.path == '/reset-password';

      // If not authenticated and not on auth route, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and on auth route, redirect to portfolio
      if (isAuthenticated && isAuthRoute) {
        return '/portfolio';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),

      // Main shell routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/portfolio',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PortfolioScreen(),
            ),
            routes: [
              GoRoute(
                path: 'accounts',
                builder: (context, state) => const AccountsListScreen(),
              ),
              GoRoute(
                path: 'accounts/new',
                builder: (context, state) => const AccountFormScreen(),
              ),
              GoRoute(
                path: 'accounts/edit',
                builder: (context, state) {
                  final account = state.extra as Account;
                  return AccountFormScreen(account: account);
                },
              ),
              GoRoute(
                path: 'accounts/detail',
                builder: (context, state) {
                  final account = state.extra as Account;
                  return AccountDetailScreen(account: account);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/transactions',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TransactionsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'deposits',
                builder: (context, state) => const DepositsListScreen(),
              ),
              GoRoute(
                path: 'deposits/new',
                builder: (context, state) => const DepositFormScreen(),
              ),
              GoRoute(
                path: 'deposits/edit',
                builder: (context, state) {
                  final purchase = state.extra as Purchase;
                  return DepositFormScreen(purchase: purchase);
                },
              ),
              GoRoute(
                path: 'sells',
                builder: (context, state) => const SellsListScreen(),
              ),
              GoRoute(
                path: 'sells/new',
                builder: (context, state) => const SellFormScreen(),
              ),
              GoRoute(
                path: 'sells/edit',
                builder: (context, state) {
                  final sell = state.extra as Sell;
                  return SellFormScreen(sell: sell);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/analysis',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalysisScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
