import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // https://$ip/restaurant/
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // @GET('/')
  // paginate();

  @GET('/{id}')
  Future<RestaurantDetailModel> getPaginateRestaurantDetail({
    @Path() required String id,
  });
}
