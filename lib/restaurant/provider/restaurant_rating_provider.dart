// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantRatingProvider extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository repository;

  RestaurantRatingProvider({
    required this.repository,
  }) : super(CursorPaginationLoading());
}
