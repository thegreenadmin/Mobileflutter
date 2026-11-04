import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/more/model/help_video_model.dart';
import 'package:thegreenmall/provider/user_provider.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Fetches the help videos published on the server so the app can render them
/// in a simple viewer. Read-only: publishing happens on the admin/server side.
class HelpVideosController extends GetxController with GlobalVarMixin {
  RxBool isLoading = false.obs;
  RxList<HelpVideo> helpVideos = <HelpVideo>[].obs;

  SharedPreferenceStorage storage = SharedPreferenceStorage();

  @override
  void onInit() {
    super.onInit();
    apiGetHelpVideos();
  }

  /// Get Help Videos List Api
  Future apiGetHelpVideos() async {
    isLoading.value = true;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      StringConstants.authorizationText:
          "${StringConstants.bearerText} ${authToken.value}",
    };

    UserProvider()
        .getWithHeadersApi(
            "${ServerCommunicator.baseUrl}${ServerCommunicator.helpVideoList}",
            headers,
            showLoading: false)
        .then((value) async {
      isLoading.value = false;
      if (value?.body["status"] == ApiConstants.statusCode200 ||
          value?.body["status"] == ApiConstants.statusCode201) {
        final model = HelpVideoListModel.fromJson(value?.body);
        helpVideos.value = model.data?.helpVideos ?? [];
        update();
      } else if (value?.body["status"] == ApiConstants.statusCode401) {
        Utility.showAlertMessage(value?.body['message']);
        storage.clearData();
        Get.parameters.clear();
        Utility.handle401Error();
      } else {
        if (value?.body['message'] != null) {
          Utility.showAlertMessage(value?.body['message']);
        }
      }
    });
  }
}
