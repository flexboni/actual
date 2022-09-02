import 'package:actual/common/provider/pagination_provider.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    // 현재 위치가
    // 최대 길이보다 조금 덜 되는 위치까지 왔다면
    // 새로운 데이터를 추가요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true);
    }
  }
}
