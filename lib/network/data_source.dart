import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadCategory() {
    return BaseNetwork.get("categories.php");
  }


  Future<Map<String, dynamic>> loadMeal(String category) {
    return BaseNetwork.get("filter.php?c=" + category);
  }

  Future<Map<String, dynamic>> loadDetail(String id) {
    return BaseNetwork.get("lookup.php?i=" + id);
  }

}
