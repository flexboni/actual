import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final repo = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return repo.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: paginateRestaurant(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) return Container();

            return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];
                  // parsed
                  final pItem = RestaurantModel.fromJson(json: item);

                  return RestaurantCard(
                    image: Image.network(
                      'http://$ip${pItem.thumbUrl}',
                      fit: BoxFit.cover,
                    ),
                    name: pItem.name,
                    tags: pItem.tags,
                    ratingsCount: pItem.ratingsCount,
                    deliveryTime: pItem.deliveryTime,
                    deliveryFee: pItem.deliveryFee,
                    ratings: pItem.ratings,
                  );
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 16.0,
                  );
                });
          },
        ),
      ),
    );
  }
}
