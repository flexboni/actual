// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  return RestaurantStateNotifier(ref.watch(restaurantRepositoryProvider));
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier(
    this.repository,
  ) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate() async {
    final resp = await repository.paginate();

    state = resp;
  }
}
