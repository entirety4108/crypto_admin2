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
import '../../features/transactions/presentation/screens/transfers_screen.dart';
import '../../features/transactions/presentation/screens/transfer_form_screen.dart';
import '../../features/transactions/presentation/screens/airdrops_screen.dart';
import '../../features/transactions/presentation/screens/airdrop_form_screen.dart';
import '../../features/transactions/presentation/screens/swaps_screen.dart';
import '../../features/transactions/presentation/screens/swap_form_screen.dart';
import '../../features/transactions/domain/purchase.dart';
import '../../features/transactions/domain/sell.dart';
import '../../features/transactions/domain/transfer.dart';
import '../../features/transactions/domain/swap.dart';
import '../../features/analysis/presentation/screens/analysis_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/categories_screen.dart';
import '../../features/settings/presentation/screens/category_form_screen.dart';
import '../../features/settings/presentation/screens/category_detail_screen.dart';
import '../../features/settings/domain/crypt_category.dart';
import '../../features/analysis/presentation/screens/profit_loss_screen.dart';
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
              GoRoute(
                path: 'transfers',
                builder: (context, state) => const TransfersScreen(),
              ),
              GoRoute(
                path: 'transfers/new',
                builder: (context, state) => const TransferFormScreen(),
              ),
              GoRoute(
                path: 'transfers/edit',
                builder: (context, state) {
                  final transfer = state.extra as Transfer;
                  return TransferFormScreen(transfer: transfer);
                },
              ),
              GoRoute(
                path: 'airdrops',
                builder: (context, state) => const AirdropsScreen(),
              ),
              GoRoute(
                path: 'airdrops/new',
                builder: (context, state) => const AirdropFormScreen(),
              ),
              GoRoute(
                path: 'airdrops/edit',
                builder: (context, state) {
                  final purchase = state.extra as Purchase;
                  return AirdropFormScreen(purchase: purchase);
                },
              ),
              GoRoute(
                path: 'swaps',
                builder: (context, state) => const SwapsScreen(),
              ),
              GoRoute(
                path: 'swaps/new',
                builder: (context, state) => const SwapFormScreen(),
              ),
              GoRoute(
                path: 'swaps/edit',
                builder: (context, state) {
                  final swap = state.extra as SwapWithDetails;
                  return SwapFormScreen(swap: swap);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/analysis',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalysisScreen(),
            ),
            routes: [
              GoRoute(
                path: 'profit-loss',
                builder: (context, state) => const ProfitLossScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'categories',
                builder: (context, state) => const CategoriesScreen(),
              ),
              GoRoute(
                path: 'categories/new',
                builder: (context, state) => const CategoryFormScreen(),
              ),
              GoRoute(
                path: 'categories/:id/edit',
                builder: (context, state) {
                  final categoryId = state.pathParameters['id']!;
                  return CategoryFormScreen(
                    categoryId: categoryId,
                    category: state.extra as CryptCategory?,
                  );
                },
              ),
              GoRoute(
                path: 'categories/:id',
                builder: (context, state) {
                  final categoryId = state.pathParameters['id']!;
                  return CategoryDetailScreen(categoryId: categoryId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
