library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/polymer_collapse/polymer_collapse.dart';
import 'package:VideoMed/global.dart';
import 'package:VideoMed/playlist.dart';
import '../../../utils/client_connection_manager.dart';
import 'package:html_components/html_components.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  @observable ClientConnectionManager ccm = new ClientConnectionManager();

  VideoElement videoPlayer;
  PolymerCollapse headerCollapse;
  Element connectionProblemDialog;  // DialogComponent

  Playlist currentPlaylist;

  MainView.created() : super.created() {
    // listen for events
    ccm.onDisconnect.listen(connectionProblem);
    ccm.onPlaylist.listen(newPlaylistReceived);
  }

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    // get UI element references
    Timer.run(() {
      videoPlayer = $['video-player'];
      headerCollapse = $['header-collapse'];
      connectionProblemDialog = $['connection-problem-dialog'];
    });
  }

  void videoClicked(Event event, var detail, Element target) {
    print("MainView::videoClicked()");

    if (videoPlayer.paused) {
      videoPlayer.play();
    }
    else {
      videoPlayer.pause();
    }

    headerCollapse.toggle();

//    videoPlayer
//      ..requestFullscreen()
//      ..play();
  }

  void connectionProblem(_) {
    print("MainView::connectionProblem()");

    connectionProblemDialog.show();
  }

  void hideConnectionProblemDialog([Event event, var detail, Element target]) {
    print("MainView::hideConnectionProblemDialog()");

    connectionProblemDialog.hide();
  }

  void newPlaylistReceived(Playlist pl) {
    print("MainView::newPlaylistReceived() -- $pl");

    currentPlaylist = pl;
    playNextVideo();

    if (!headerCollapse.closed) {
      headerCollapse.toggle();
    }
  }

  void playNextVideo([Event event, var detail, Element target]) {
    print("MainView::playNextVideo()");

    // TODO: Dart bug prevents nextVid from being strongly typed as Media
    var nextVid = currentPlaylist.next();

    // TODO: VIDEO_PATH is the base, but there may need to be subfolders (maybe the category name?)
    if (nextVid != null) {
      videoPlayer.src = "$VIDEO_PATH${nextVid.filename}";
      videoPlayer.play();
    }
  }
}

