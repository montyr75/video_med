library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/polymer_elements.dart';
import 'package:VideoMed/playlist.dart';
import 'package:VideoMed/media.dart';
import '../../../utils/client_connection_manager.dart';
import '../../model/model.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  @observable ClientConnectionManager ccm = new ClientConnectionManager(disableAdminID: false);
  @observable Model model;
  @observable List<Media> filteredMedia;

  @observable bool showConnectionProblemDialog = false;
  @observable String connectionErrorMessage;    // shows up in connectionProblemDialog

  @observable Playlist selectedPlaylist;

  @observable bool showVideoPreviewDialog = false;
  @observable Media previewMedia;

  MainView.created() : super.created() {
    // listen for events
    ccm.onConnect.listen((_) => connectionErrorMessage = null,
        onError: (StateError e) => connectionErrorMessage = e.message);
    ccm.onDisconnect.listen(connectionProblem);
    ccm.onModel.listen(newModelReceived);
  }

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");
  }

  void newModelReceived(Model newModel) {
    print("MainView::newModelReceived()");

    model = newModel;

    // select "All" media categories by default
    ($["category-selector"] as PolymerSelector).selected = 0;
  }

  void playlistSelected(Event event, var detail, PolymerSelector target) {
    // only change the playlist when one is selected (as opposed to deselected)
    if (detail != null && !detail["isSelected"]) {
      return;
    }

    // gotta check the selectedIndex async-style to allow the bindings to update (target.selectedIndex)
    Timer.run(() {
      selectedPlaylist = model.playlists[target.selectedIndex];
      print("MainView::playlistSelected() -- ${target.selectedIndex}: ${selectedPlaylist.title}");
    });
  }

  void mediaCategorySelected(Event event, var detail, PolymerSelector target) {
    // only change the category when one is selected (as opposed to deselected)
    if (detail != null && !detail["isSelected"]) {
      return;
    }

    // gotta check the selectedIndex async-style to allow the bindings to update (target.selectedIndex)
    Timer.run(() {
      String selectedCategory = model.mediaCategories[target.selectedIndex];
      filteredMedia = selectedCategory == "All" ? model.media : model.media.where((Media item) => item.category == selectedCategory).toList();
      print("MainView::mediaCategorySelected() -- ${target.selectedIndex}: $selectedCategory");
    });
  }

  void addMedia(Event event, Media detail, Element target) {
    print("MainView::addMedia() -- ${detail.title}");
  }

  void playMedia(Event event, Media detail, Element target) {
    print("MainView::playMedia() -- ${detail.title}");

    showVideoPreviewDialog = true;
    previewMedia = detail;
    ($['video-player'] as VideoElement).src = "${previewMedia.url}";
  }

  void removeMedia(Event event, Media detail, Element target) {
    print("MainView::removeMedia() -- ${detail.title}");
  }

  void moveUpMedia(Event event, Media detail, Element target) {
    print("MainView::moveUpMedia() -- ${detail.title}");
  }

  void moveDownMedia(Event event, Media detail, Element target) {
    print("MainView::moveDownMedia() -- ${detail.title}");
  }

  void connectionProblem(_) {
    print("MainView::connectionProblem()");

    showConnectionProblemDialog = true;
  }

  void hideConnectionProblemDialog([Event event, var detail, Element target]) {
    print("MainView::hideConnectionProblemDialog()");

    showConnectionProblemDialog = false;
  }

  void hideVideoPreviewDialog([Event event, var detail, Element target]) {
    print("MainView::hideVideoPreviewDialog()");

    showVideoPreviewDialog = false;
    ($['video-player'] as VideoElement).pause();
  }
}

