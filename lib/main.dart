import 'package:actual/common/view/root_tab.dart';
import 'package:actual/common/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  GoRouter get _router => GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (_, state) => const SplashScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (_, state) => const RootTab(),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Route 정보 전달
      routeInformationProvider: _router.routeInformationProvider,
      // URI String 을 상태 및 Go Router 에서 사용할 수 있는 형태로
      // 변환 해주는 함수
      routeInformationParser: _router.routeInformationParser,
      // 위에서 변경된 값으로 실제 어떤 라우트를 보여줄지 정하는 함수
      routerDelegate: _router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      // home: const SplashScreen(),
    );
  }
}
