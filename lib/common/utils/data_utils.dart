import 'package:actual/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => 'http://$ip$value';

  static List<String> listPathsToUrls(List<String> paths) =>
      paths.map((e) => pathToUrl(e)).toList();
}
