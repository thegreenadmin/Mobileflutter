import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thegreenmall/dashboard/more/controller/help_videos_controller.dart';
import 'package:thegreenmall/dashboard/more/model/help_video_model.dart';
import 'package:thegreenmall/dashboard/more/view/webview_page_screen.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Viewer for the server-published "how to use the app" help videos.
/// Tapping a video opens it in the in-app web view (works for hosted /
/// YouTube / Vimeo links), so no extra video-player dependency is needed.
class HelpVideosScreen extends StatefulWidget {
  const HelpVideosScreen({super.key});

  @override
  State<HelpVideosScreen> createState() => _HelpVideosScreenState();
}

class _HelpVideosScreenState extends State<HelpVideosScreen>
    with GlobalVarMixin {
  final HelpVideosController controller = Get.put(HelpVideosController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.helpVideos.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (controller.helpVideos.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      StringConstants.noHelpVideosText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, color: AppColors.blackLight),
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: controller.helpVideos.length,
                separatorBuilder: (_, __) => height20SizedBox,
                itemBuilder: (_, index) =>
                    _buildVideoCard(controller.helpVideos[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
          .copyWith(top: 50),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(id: pageIdApp.value),
            icon: Icon(Icons.arrow_back,
                color: AppColors.black, size: 24.0),
          ),
          width10SizedBox,
          Text(
            StringConstants.helpVideosText,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(HelpVideo video) {
    return InkWell(
      onTap: () {
        final url = video.videoUrl ?? "";
        if (url.isEmpty) {
          Utility.showAlertMessage(StringConstants.videoUnavailableText);
          return;
        }
        Get.to(
          WebviewPageScreen(isFrom: "helpvideo", url: url),
          id: pageIdApp.value,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(video.thumbnailUrl),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                  if ((video.description ?? "").isNotEmpty) ...[
                    height5SizedBox,
                    Text(
                      video.description ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13, color: AppColors.blackLight),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? thumbnailUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if ((thumbnailUrl ?? "").isNotEmpty)
            Image.network(
              thumbnailUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _thumbnailFallback(),
            )
          else
            _thumbnailFallback(),
          // Play affordance overlaid on the thumbnail.
          Container(
            color: Colors.black.withOpacity(0.12),
            alignment: Alignment.center,
            child: const Icon(
              Icons.play_circle_fill,
              color: AppColors.white,
              size: 54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbnailFallback() {
    return Container(
      color: AppColors.primaryLight,
      alignment: Alignment.center,
      child: Icon(Icons.ondemand_video_outlined,
          color: AppColors.primary, size: 40),
    );
  }
}
