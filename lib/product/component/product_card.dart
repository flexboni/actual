// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/const/colors.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final String id;
  final int price;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.id,
    required this.price,
    this.onSubtract,
    this.onAdd,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) =>
      ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        id: model.id,
        price: model.price,
        onSubtract: onSubtract,
        onAdd: onAdd,
      );

  factory ProductCard.fromRestaurantModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) =>
      ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        id: model.id,
        price: model.price,
        onSubtract: onSubtract,
        onAdd: onAdd,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    // Row 안의 children은 각각 자신들이 차지해야 하는 높이 만큼만 차지하고 있다.
    // IntrinsicHeight 을 사용하면 child 중 높이가 가장 높은 것 기준으로 모두 통일된다.
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: BODY_TEXT_COLOR,
                      ),
                    ),
                    Text(
                      '₩$price',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          _Footer(
            total: (basket
                        .firstWhere((element) => element.product.id == id)
                        .count *
                    basket
                        .firstWhere((element) => element.product.id == id)
                        .product
                        .price)
                .toString(),
            count:
                basket.firstWhere((element) => element.product.id == id).count,
            onSubtract: onSubtract!,
            onAdd: onAdd!,
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    Key? key,
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 ₩$total',
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(
              icon: Icons.remove,
              onTap: onSubtract,
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            renderButton(
              icon: Icons.add,
              onTap: onAdd,
            ),
          ],
        )
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: PRIMARY_COLOR),
      ),
    );
  }
}
