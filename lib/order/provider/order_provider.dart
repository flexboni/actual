// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/order/model/order_model.dart';
import 'package:actual/order/model/post_order_body.dart';
import 'package:actual/order/repository/order_repository.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  return OrderStateNotifier(
    ref: ref,
    repository: ref.watch(orderRepositoryProvider),
  );
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    try {
      final id = const Uuid().v4();

      final state = ref.read(basketProvider);

      final body = PostOrderBody(
        id: id,
        products: state
            .map((e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ))
            .toList(),
        totalPrice: state.fold<int>(
          0,
          (previousValue, element) =>
              previousValue + (element.count * element.product.price),
        ),
        createdAt: DateTime.now().toString(),
      );

      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map((e) => PostOrderBodyProduct(
                    productId: e.product.id,
                    count: e.count,
                  ))
              .toList(),
          totalPrice: state.fold<int>(
            0,
            (previousValue, element) =>
                previousValue + (element.count * element.product.price),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } on Exception catch (e) {
      return false;
    }
  }
}
