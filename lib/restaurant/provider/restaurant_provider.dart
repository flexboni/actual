// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

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

  void getDetail({required String id}) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination 이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state 가 CursorPagination 이 아닐 때 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getPaginateRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
    // id: 2인 친구의 Detail 모델을 가져와라
    // getDetail(id: 2)
    // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>((e) => e.id == id ? resp : e)
          .toList(),
    );
  }
}
