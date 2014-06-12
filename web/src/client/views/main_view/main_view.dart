library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../../../shared/components/polymer_collapse/polymer_collapse.dart';
import 'package:videomed/playlist.dart';
import '../../../utils/client_connection_manager.dart';
import '../../../shared/components/video_player.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  static const CLASS_NAME = "MainView";

  @observable ClientConnectionManager ccm = new ClientConnectionManager();

  VideoPlayer videoPlayer;
  PolymerCollapse headerCollapse;

  @observable bool showConnectionProblemDialog = false;
  @observable String connectionErrorMessage;    // shows up in connectionProblemDialog

  @observable Playlist currentPlaylist;

  MainView.created() : super.created() {
    // listen for events
    ccm.onConnect.listen((_) => connectionErrorMessage = null, onError: connectionProblem);
    ccm.onDisconnect.listen(connectionProblem);
    ccm.onPlaylist.listen(newPlaylistReceived);
  }

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

    // get UI element references
    Timer.run(() {
      videoPlayer = $['video-player'];
      headerCollapse = $['header-collapse'];
    });
  }

  void videoClicked(Event event, var detail, Element target) {
    print("$CLASS_NAME::videoClicked()");

    headerCollapse.toggle();
  }

  void connectionProblem(_) {
    print("$CLASS_NAME::connectionProblem()");

    // if true, function was run by onConnect error--otherwise, it came from onDisconnect
    if (_ is Error) {
      connectionErrorMessage = _.message;
    }

    showConnectionProblemDialog = true;

    // make sure header is showing
    if (headerCollapse.closed) {
      headerCollapse.toggle();
    }

    // make sure video is stopped
    videoPlayer.pause();
  }

  void hideConnectionProblemDialog([Event event, var detail, Element target]) {
    print("$CLASS_NAME::hideConnectionProblemDialog()");

    showConnectionProblemDialog = false;
  }

  void newPlaylistReceived(Playlist pl) {
    print("$CLASS_NAME::newPlaylistReceived() -- $pl");

    currentPlaylist = pl;

    // make sure header is not showing
    if (!headerCollapse.closed) {
      headerCollapse.toggle();
    }
  }
}

