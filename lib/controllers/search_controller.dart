import 'package:get/get.dart';
import 'package:mobilejobportal/utils/http_client.dart';

class SearchController extends GetxController {
  var searchText = ''.obs;
  var selectedLocation = ''.obs;
  var services = [].obs;
  var isLoading = false.obs;

  Future<void> performSearch() async {
    isLoading.value = true;
    final response = await HttpClient.testRoute({
      'service': searchText.value,
      'location': selectedLocation.value,
    });

    if (response.statusCode == 200) {
      services.value = response.data;
    } else {
      Get.snackbar('Error', 'Failed to fetch services');
    }
    isLoading.value = false;
  }
}
