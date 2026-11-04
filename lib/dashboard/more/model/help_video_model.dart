/// Response model for the backend-hosted help videos list.
///
/// Videos are published/curated on the server (admin side); the app only
/// fetches and renders them. Expected shape:
/// {
///   "status": 200,
///   "message": "...",
///   "data": {
///     "total_count": 2,
///     "help_videos": [
///       {
///         "help_video_id": "...",
///         "title": "How to place an order",
///         "description": "...",
///         "video_url": "https://...",
///         "thumbnail_url": "https://..."
///       }
///     ]
///   }
/// }
class HelpVideoListModel {
  int? status;
  String? message;
  HelpVideoListData? data;

  HelpVideoListModel({this.status, this.message, this.data});

  HelpVideoListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? HelpVideoListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HelpVideoListData {
  int? totalCount;
  List<HelpVideo>? helpVideos;

  HelpVideoListData({this.totalCount, this.helpVideos});

  HelpVideoListData.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    // Accept either a wrapped list ("help_videos") or a bare list under "data".
    final dynamic list = json['help_videos'] ?? json['videos'];
    if (list != null) {
      helpVideos = <HelpVideo>[];
      list.forEach((v) {
        helpVideos!.add(HelpVideo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    if (helpVideos != null) {
      data['help_videos'] = helpVideos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HelpVideo {
  String? helpVideoId;
  String? title;
  String? description;
  String? videoUrl;
  String? thumbnailUrl;

  HelpVideo({
    this.helpVideoId,
    this.title,
    this.description,
    this.videoUrl,
    this.thumbnailUrl,
  });

  HelpVideo.fromJson(Map<String, dynamic> json) {
    helpVideoId = json['help_video_id'] ?? json['id'];
    title = json['title'];
    description = json['description'];
    videoUrl = json['video_url'] ?? json['url'];
    thumbnailUrl = json['thumbnail_url'] ?? json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['help_video_id'] = helpVideoId;
    data['title'] = title;
    data['description'] = description;
    data['video_url'] = videoUrl;
    data['thumbnail_url'] = thumbnailUrl;
    return data;
  }
}
