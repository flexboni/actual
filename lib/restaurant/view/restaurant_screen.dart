import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) => GestureDetector(
        onTap: () {
          context.goNamed(
            RestaurantDetailScreen.routeName,
            params: {
              'title': model.name,
              'rid': model.id,
            },
            // mobile 에서는 거의 사용하지 않는다.
            // queryParams: {}
          );
        },
        child: RestaurantCard.fromModel(model),
      ),
    );
  }
}
