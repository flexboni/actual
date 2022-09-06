// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/common/view/splash_screen.dart';
import 'package:actual/order/view/order_done_screen.dart';
import 'package:actual/restaurant/view/basket_screen.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(ref: ref),
);

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:title/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                title: state.params['title']!,
                id: state.params['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (_, __) => const BasketScreen(),
        ),
        GoRoute(
          path: '/order_done',
          name: OrderDoneScreen.routeName,
          builder: (_, __) => const OrderDoneScreen(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen 이 필요한데,
  // 앱을 처음 시작했을 때 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보낼지, 홈 스크린으로 보낼지 확인하는 과정이 필요하다.
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final loginIn = state.location == '/login';

    // 유저 정보가 없는데 로그인 중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return loginIn ? null : '/login';
    }

    // user 가 null 이 아님(UserModel 상태)
    // 사용자 정보가 있는 상태면 로그인 중이거나 현재 위치가 SplashScreen 이면
    // 홈으로 이동
    if (user is UserModel) {
      return loginIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError 상태
    if (user is UserModelError) {
      return loginIn ? null : '/login';
    }

    return null;
  }
}
