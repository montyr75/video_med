library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/polymer_elements.dart';
import 'package:VideoMed/global.dart';
import 'package:VideoMed/playlist.dart';
import 'package:VideoMed/media.dart';
import '../../../utils/client_connection_manager.dart';
import '../../model/model.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  @observable ClientConnectionManager ccm = new ClientConnectionManager();
  @observable Model model;

  @observable List<Media> filteredMedia;

  MainView.created() : super.created() {
    // listen for events
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
    Timer.run(mediaCategorySelected);
  }

  void mediaCategorySelected([Event event, var detail, var target]) {
    target = target != null ? target : $["category-selector"];
    String selectedCategory = model.mediaCategories[target.selectedIndex];

    print("MainView::mediaCategorySelected() -- $selectedCategory");

    filteredMedia = selectedCategory == "All" ? model.media : model.media.where((Media item) => item.category == model.mediaCategories[target.selectedIndex]).toList();
  }

  void addMedia(Event event, Media detail, Element target) {
    print("MainView::addMedia() -- ${detail.title}");
  }

  void playMedia(Event event, Media detail, Element target) {
    print("MainView::playMedia() -- ${detail.title}");
  }

  void removeMedia(Event event, Media detail, Element target) {
    print("MainView::removeMedia() -- ${detail.title}");
  }
}

