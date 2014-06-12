library video_player;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:videomed/playlist.dart';
import 'package:videomed/media.dart';

@CustomTag('video-player')
class VideoPlayer extends PolymerElement {

  static const CLASS_NAME = "VideoPlayer";

  @published Playlist playlist;
  @published bool autoplay = false;
  @published bool controls = false;

  VideoElement videoPlayer;

  VideoPlayer.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

    // get UI element references
    Timer.run(() {
      videoPlayer = $['video-player'];
    });
  }

  void playlistChanged(oldValue) {
    print("$CLASS_NAME::playlistChanged()");

    if (playlist == null || videoPlayer == null) {
      return;
    }

    if (autoplay) {
      playNextVideo();
    }
  }

  void togglePlayback(Event event, var detail, Element target) {
    print("$CLASS_NAME::togglePlayback()");

    if (videoPlayer.paused) {
      videoPlayer.play();
    }
    else {
      videoPlayer.pause();
    }
  }

  void playNextVideo([Event event, var detail, Element target]) {
    print("$CLASS_NAME::playNextVideo()");

    // get next video from playlist
    Media nextVid = playlist.next();

    if (nextVid != null) {
      videoPlayer.src = "${nextVid.url}";
      videoPlayer.play();
    }
  }

  void play() {
    if (videoPlayer.paused) {
      videoPlayer.play();
    }
  }

  void pause() {
    if (!videoPlayer.paused) {
      videoPlayer.pause();
    }
  }
}

