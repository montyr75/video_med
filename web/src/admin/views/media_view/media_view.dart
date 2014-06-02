library media_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:videomed/media.dart';

@CustomTag('media-view')
class MediaView extends PolymerElement {

  static const CLASS_NAME = "MediaView";

  @published Media media;
  @published bool playlistMode = false;   // playlist media has different UI requirements

  MediaView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
//    print("$CLASS_NAME::enteredView()");
  }

  void addClicked(Event event, var detail, Element target) {
//    print("$CLASS_NAME::addClicked()");

    fire("add-media", detail: media);
  }

  void playClicked(Event event, var detail, Element target) {
//    print("$CLASS_NAME::playClicked()");

    fire("play-media", detail: media);
  }

  void removeClicked(Event event, var detail, Element target) {
//    print("$CLASS_NAME::removeClicked()");

    fire("remove-media", detail: media);
  }

  void moveUpClicked(Event event, var detail, Element target) {
//    print("$CLASS_NAME::moveUpClicked()");

    fire("move-up-media", detail: media);
  }

  void moveDownClicked(Event event, var detail, Element target) {
//    print("$CLASS_NAME::moveDownClicked()");

    fire("move-down-media", detail: media);
  }
}

