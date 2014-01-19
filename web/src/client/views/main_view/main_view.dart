library main_view;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  VideoElement videoPlayer;

  MainView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    videoPlayer = $['video-player'];
  }

  void videoClicked(Event event, var detail, Element target) {
    print("MainView::videoClicked()");

//    videoPlayer
//      ..requestFullscreen()
//      ..play();
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

