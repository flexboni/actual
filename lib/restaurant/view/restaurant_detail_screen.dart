// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String title;
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: title,
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref
            .read(restaurantRepositoryProvider)
            .getPaginateRestaurantDetail(id: id),
        builder: (context, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final item = snapshot.data!;

          return CustomScrollView(
            slivers: [
              renderTop(item),
              renderLabel(),
              renderProducts(item.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop(RestaurantDetailModel item) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        item,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts(
    List<RestaurantProductModel> products,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
