import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:actual/order/view/order_done_screen.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerStatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);

  static String get routeName => 'basket';

  @override
  ConsumerState<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends ConsumerState<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text('장바구니가 비어있습니다!!'),
        ),
      );
    }

    final priceTotal = basket.fold<int>(
      0,
      (previousValue, element) =>
          previousValue + element.product.price * element.count,
    );

    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(height: 32.0),
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onSubtract: () => ref
                          .read(basketProvider.notifier)
                          .removeFromBasket(product: model.product),
                      onAdd: () => ref
                          .read(basketProvider.notifier)
                          .addToBasket(product: model.product),
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '장바구니 금액',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        '₩ $priceTotal',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '배달비',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      // 다른 가게 상품을 동시에 담을 수 없어서
                      // 첫 번째 상품 가게의 배달비를 바인딩 하면 된다.
                      if (basket.isNotEmpty)
                        Text(
                          '₩ $deliveryFee',
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '총액',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₩ ${priceTotal + deliveryFee}',
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp =
                            await ref.read(orderProvider.notifier).postOrder();

                        if (!mounted) return;

                        if (resp) {
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('결제 실패!'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                      child: const Text('결제하기'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
