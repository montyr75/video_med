library media_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/media.dart';

@CustomTag('media-view')
class MediaView extends PolymerElement {

  @published Media media;
  @published bool showRemoveButton = false;

  MediaView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
//    print("MediaView::enteredView()");
  }

  void addClicked(Event event, var detail, Element target) {
//    print("MediaView::addClicked()");

    fire("add-media", detail: media);
  }

  void playClicked(Event event, var detail, Element target) {
//    print("MediaView::playClicked()");

    fire("play-media", detail: media);
  }

  void removeClicked(Event event, var detail, Element target) {
//    print("MediaView::removeClicked()");

    fire("remove-media", detail: media);
  }
}

