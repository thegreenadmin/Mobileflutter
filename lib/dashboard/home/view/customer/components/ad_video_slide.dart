import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:thegreenmall/utils/utils.dart';

/// Inline video creative for an advertisement carousel slide. Plays muted and
/// looping, autoplays only while it is visible on screen (pauses otherwise to
/// save battery/bandwidth), and shows the thumbnail until the first frame is
/// ready.
class AdVideoSlide extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final double width;
  final double height;

  const AdVideoSlide({
    super.key,
    required this.videoUrl,
    required this.width,
    required this.height,
    this.thumbnailUrl,
  });

  @override
  State<AdVideoSlide> createState() => _AdVideoSlideState();
}

class _AdVideoSlideState extends State<AdVideoSlide> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
      }).catchError((_) {
        // leave _initialized false -> thumbnail/fallback keeps showing
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final c = _controller;
    if (c == null || !_initialized) return;
    if (info.visibleFraction > 0.6) {
      if (!c.value.isPlaying) c.play();
    } else {
      if (c.value.isPlaying) c.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final poster = CommonWidgets.cachedNetworkImage(
      widget.thumbnailUrl ?? "",
      assetImg: ImageConstants.nopicfound,
      height: widget.height,
      width: widget.width,
    );

    return VisibilityDetector(
      key: Key('ad-video-${widget.videoUrl}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: _initialized && _controller != null
            ? FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            : poster,
      ),
    );
  }
}
