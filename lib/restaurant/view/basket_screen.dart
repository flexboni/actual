import 'package:actual/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({Key? key}) : super(key: key);

  static String get routeName => 'basket';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '장바구니',
      child: Column(),
    );
  }
}
