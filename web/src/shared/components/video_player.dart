library video_player;

import 'dart:html';
import 'dart:async';
import 'package:VideoMed/global.dart';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/playlist.dart';
import 'package:VideoMed/media.dart';

@CustomTag('video-player')
class VideoPlayer extends PolymerElement {

  @published Playlist playlist;
  @published bool autoplay = false;
  @published bool controls = false;

  VideoElement videoPlayer;

  VideoPlayer.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("VideoPlayer::enteredView()");

    // get UI element references
    Timer.run(() {
      videoPlayer = $['video-player'];
    });
  }

  void playlistChanged(oldValue) {
    print("VideoPlayer::playlistChanged()");

    if (playlist == null || videoPlayer == null) {
      return;
    }

    if (autoplay) {
      playNextVideo();
    }
  }

  void togglePlayback(Event event, var detail, Element target) {
    print("VideoPlayer::togglePlayback()");

    if (videoPlayer.paused) {
      videoPlayer.play();
    }
    else {
      videoPlayer.pause();
    }
  }

  void playNextVideo([Event event, var detail, Element target]) {
    print("VideoPlayer::playNextVideo()");

    // get next video from playlist
    Media nextVid = playlist.next();

    // TODO: VIDEO_PATH is the base and comes from global.dart, but there may need to be subfolders (maybe the category name?)
    if (nextVid != null) {
      videoPlayer.src = "$VIDEO_PATH${nextVid.filename}";
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

