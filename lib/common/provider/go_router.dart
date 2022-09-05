import 'package:actual/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    // watch - 값이 변경될 때마다 다시 빌드
    // read - 한 번만 읽고 값이 변경돼도 다시 빌드하지 않음
    // 항상 같은 GoRouter 인스턴스를 반환 받아야 하므로 read를 사용함
    final provider = ref.read(authProvider);

    return GoRouter(
      routes: provider.routes,
      initialLocation: '/splash',
      refreshListenable: provider,
      redirect: provider.redirectLogic,
    );
  },
);
