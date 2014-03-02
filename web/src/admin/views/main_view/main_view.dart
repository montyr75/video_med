library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/polymer_elements.dart';
import 'package:polymer_elements/polymer_collapse/polymer_collapse.dart';
import 'package:VideoMed/global.dart';
import 'package:VideoMed/playlist.dart';
//import 'package:VideoMed/media.dart';
import '../../../utils/client_connection_manager.dart';
import '../../model/model.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  @observable ClientConnectionManager ccm = new ClientConnectionManager();
  @observable Model model;

  MainView.created() : super.created() {
    // listen for events
    ccm.onModel.listen(newModelReceived);
  }

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");
  }

  void categorySelected(Event event, var detail, Element target) {
    print("MainView::categorySelected()");
  }

  void newModelReceived(Model newModel) {
    print("MainView::newModelReceived()");

    model = newModel;

    // select "All" categories
    ($["category-selector"] as PolymerSelector).selected = 0;
  }
}

