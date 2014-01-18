library main_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../../utils/client_connection_manager.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  @observable ClientConnectionManager ccm;    // instantiated by login_view

  MainView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");
  }

  void sample(Event event, var detail, Element target) {

  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

