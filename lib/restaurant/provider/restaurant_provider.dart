// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
        (ref) {
  return RestaurantStateNotifier(ref.watch(restaurantRepositoryProvider));
});

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier(
    this.repository,
  ) : super([]) {
    paginate();
  }

  Future<void> paginate() async {
    final resp = await repository.paginate();

    state = resp.data;
  }
}
